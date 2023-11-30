#!/usr/bin/env python
# pylint: disable=W1203,R0902
"""
QA test cases
"""

import json
import logging

import boto3
import psycopg2
from botocore.exceptions import ClientError


class QA:
    """
    Class for QA test cases
    """

    def __init__(
        self,
        database: str = "postgres",
        region: str = "eu-central-1",
        log_level: int = logging.INFO,
    ) -> None:
        """Class constructor.

        :param database: The name of the QA database. Default: postgres
        :param region: The AWS region with the QA resources. Default: eu-central-1
        :param log_level: A valid log level from the logging module. Default: logging.INFO
        :type region: str
        :type log_level: int
        """
        logging.basicConfig(
            format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
            level=log_level,
        )
        self.region: str = region
        self.log_level: int = log_level
        self.database: str = database
        self.address: str = None
        self.port: int = None
        self.username: str = None
        self.password: str = None
        self.session = boto3.session.Session()
        logging.info("Class initialized")

    def __get_databases(self) -> dict:
        """
        Get a list of RDS Instances and return them stored inside a dictionary.

        :return: dict
        """
        client = self.session.client(service_name="rds", region_name=self.region)
        databases: dict = client.describe_db_instances()
        return databases

    def __get_instance(self) -> dict:
        """
        Check if there is a QA instance among the RDS Instances and return
        its configuration as a dictionary.

        :return: dict
        """
        dbs: dict = self.__get_databases()
        for db in dbs["DBInstances"]:
            if db["DBInstanceIdentifier"] == "qa":
                return db
        return None

    def qa_instance_exist(self) -> bool:
        """
        Check if the QA instance exist.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            return True
        return False

    def __get_secretsmanager(self) -> str:
        """
        Get the secret name from Secrets Manager.
        The Secret ARN contains a value that consists of the
        Secret Name and -abcdef, where 'abcdef' seems like random characters.
        In order to retrieve the Secret Name, we need to do some black magic
        with split and join to remove 'abcdef' from the results.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            mus: dict = instance.get("MasterUserSecret", None)
            if mus is not None:
                arn: str = mus.get("SecretArn", None)
            if arn is not None:
                try:
                    arn_part = arn.split(":")[6]
                    return "-".join(arn_part.split("-")[0:-1])
                except IndexError:
                    return None
        return None

    def secretsmanager_exist(self) -> bool:
        """
        Check if SecretsManager is used by the QA RDS instance.

        :return: bool
        """
        secretsmanager: str = self.__get_secretsmanager()
        if secretsmanager is not None:
            return True
        return False

    def __get_secret(self) -> (str, str):
        """
        Get the username and password to RDS from a Secrets Manager

        :return: (str, str)
        """
        client = self.session.client(
            service_name="secretsmanager", region_name=self.region
        )

        secret_name: str = self.__get_secretsmanager()

        try:
            logging.info("Connected to Secrets Manager")
            get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        except ClientError as e:
            raise e

        secret: dict = json.loads(get_secret_value_response["SecretString"])
        return secret.get("username", None), secret.get("password", None)

    def username_exist(self) -> bool:
        """
        Check if a username exist in the SecretsManager secret used by RDS.

        :return: bool
        """
        if self.username is None:
            username, password = self.__get_secret()
            self.username = username
            self.password = password
        if self.username is not None:
            return True
        return False

    def password_exist(self) -> bool:
        """
        Check if a password exist in the SecretsManager secret used by RDS.

        :return: bool
        """
        if self.password is None:
            username, password = self.__get_secret()
            self.username = username
            self.password = password
        if self.password is not None:
            return True
        return False

    def __get_endpoint(self) -> (str, int):
        """
        Get the address and port number from the RDS instance endpoint.

        :return: (str, int)
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            endpoint: dict = instance.get("Endpoint", None)
            if endpoint is not None:
                address: str = endpoint.get("Address", None)
                port: int = endpoint.get("Port", None)
            if address is not None or port is not None:
                return address, port
        return None, None

    def connect_to_database(self) -> None:
        """
        Connect to the database and execute a simple query

        """
        if self.address is None or self.port is None:
            address, port = self.__get_endpoint()
            self.address = address
            self.port = port

        if self.username is None or self.password is None:
            username, password = self.__get_secret()
            self.username = username
            self.password = password

        logging.info(f"Connecting to {address}:{port}")

        conn = psycopg2.connect(
            dbname=self.database,
            user=self.username,
            password=self.password,
            host=self.address,
            port=self.port,
            sslmode="verify-full",
        )

        logging.info("Connected to RDS")

        conn.autocommit = False

        with conn.cursor() as sql:
            try:
                sql.execute(
                    "SELECT current_user, current_database(), current_timestamp"
                )
                data: tuple = sql.fetchone()
                logging.info(f"User is {data[0]} on database {data[1]} at {data[2]}")
            except psycopg2.DatabaseError as db_error:
                logging.error(db_error)
        conn.close()


if __name__ == "__main__":
    qa = QA()
    assert qa.qa_instance_exist()
    assert qa.secretsmanager_exist()
    assert qa.username_exist()
    assert qa.password_exist()
    qa.connect_to_database()
    # This line will of course only be reached if all assert statement succeeds.
    print("All test cases succeeded")
