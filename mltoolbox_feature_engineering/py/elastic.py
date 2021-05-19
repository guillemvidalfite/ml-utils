#!/usr/bin/env python
# coding: utf-8
"""
Elasticsearch helpers for this evaluation
"""
import logging
import ssl
import urllib3

from elasticsearch import Elasticsearch, JSONSerializer
from elasticsearch.connection import create_ssl_context
from elasticsearch.helpers import parallel_bulk
import numpy as np

urllib3.disable_warnings() # This is insecure
logger = logging.getLogger(__name__)


def get_elastic_client(server="local", write=False):
    if server == "local":
        if write:
            serializer = NpJSONSerializer()
        else:
            serializer = JSONSerializer()
        return Elasticsearch(host="localhost",
                             port=9200,
                             serializer=serializer)
    elif server in {"dev", "horizon", "prod"}:
        # All the other servers are remote hosts with similar configs
        if server == "prod":
            host = "daimler-elastic.vpc.bigml.com"
        elif server == "horizon":
            host = "daimler-elastic.horizon.bigml.com"
        else:
            host = "daimler-elastic.dev.bigml.com"

        if write:
            serializer = NpJSONSerializer()
        else:
            serializer = JSONSerializer()
        # Set up ssl context to disable cert verification
        ssl_context = create_ssl_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        return Elasticsearch(host=host,
                             port=443,
                             http_auth=("dev", "paroafCa"),
                             serializer=serializer,
                             ssl_context=ssl_context,
                             use_ssl=True)
    else:
        logger.warning("unknown server '%s'", server)
        return None


def bulk_generate_actions(hits, index, id_field=None, doc_type="_doc"):
    for hit in hits:
        action = {"_op_type": "index", "_index": index, "_source": hit}
        if id_field is not None:
            action["_id"] = hit[id_field]
        if doc_type is not None:
            action["_type"] = doc_type
        yield action


def bulk_store(ES, welds, index):
    """
    Helper to store the results back into an index
    """
    actions_gen = bulk_generate_actions(welds, index, id_field="fingerprint")
    bulk_gen = parallel_bulk(client=ES,
                             request_timeout=30.0,
                             refresh="wait_for",
                             actions=actions_gen)
    try:
        result = True
        for success, info in bulk_gen:
            if not success:
                logger.warning(f"failed bulk batch with info: {info}")
                result = False
        return result
    except Exception as e:
        logger.error("failed bulk store", exc_info=True)
        return False


class NpJSONSerializer(JSONSerializer):
    """Custom Serializer to add support for basic numpy scalar types."""
    def default(self, obj):
        """Add support for np encoding"""
        if isinstance(obj, np.integer):
            return int(obj)
        if isinstance(obj, np.float):
            return float(obj)
        return JSONSerializer.default(self, obj)