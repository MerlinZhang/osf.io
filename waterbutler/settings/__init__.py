import logging

from .defaults import *


logger = logging.getLogger()


try:
    from .local import *
except ImportError:
    logger.warning('No local.py found; using defaults.')