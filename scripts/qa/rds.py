#!/usr/bin/env python
"""
QA test cases
"""

import argparse
import json
import logging
import sys

import boto3
import psycopg2
from botocore.exceptions import ClientError


class QA:
    def __init__(self, region: str = "eu-central-1", log_level: int = logging.INFO) -> None:
        """Class constructor.

        :param region: The AWS region with the QA resources. Default: eu-central-1
        :param log_level: A valid log level from the logging module. Default: logging.INFO
        :type region: str
        :type log_level: int
        """
        logging.basicConfig(
            format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=log_level
        )
        self.region: str = region
        self.log_level: int = log_level


if __name__ == "__main__":
    qa = QA()
    print("TODO in later PR")
