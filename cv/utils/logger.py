import logging

def custom_logger() -> logging.getLogger:
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    return logger