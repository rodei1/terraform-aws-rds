#!/usr/bin/env python
# pylint: disable=W1203,R0902
"""
QA test cases. Refactor to use https://docs.python.org/3/library/unittest.html
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
        self.endpoint: dict = None
        self.secret: dict = None
        self.instance: dict = None
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
        instance: dict = self.instance
        if instance is None:
            dbs: dict = self.__get_databases()
            for db in dbs["DBInstances"]:
                if db["DBInstanceIdentifier"] == "qa":
                    self.__set_instance(db)
                    return db
        else:
            return instance
        return None

    def __set_instance(self, instance: dict) -> None:
        """
        Set the instance value for the instance of the class.
        """
        self.instance = instance

    def instance_exist(self) -> bool:
        """
        Check if the QA instance exist.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            return True
        return False

    def is_instance_available(self) -> bool:
        """
        Check if the instance is available

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            instance_status: str = instance.get("DBInstanceStatus", None)
            if instance_status is not None:
                return True
        return False

    def is_username(self, username: str) -> bool:
        """
        Check that the username has the expected value

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            instance_username: str = instance.get("MasterUsername", None)
            if instance_username == username:
                return True
        return False

    def is_storage_size(self, size: int) -> bool:
        """
        Check that the storage has the expected size.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            storage_size: int = instance.get("AllocatedStorage", -1)
            if storage_size == size:
                return True
        return False

    def is_backup_retention_period(self, period: int) -> bool:
        """
        Check that the backup retention period is as expected.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            retention_period: int = instance.get("BackupRetentionPeriod", -1)
            if retention_period == period:
                return True
        return False

    def is_multi_az(self) -> bool:
        """
        Check if the instance is configured with multi AZ.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            multi_az: bool = instance.get("MultiAZ", False)
            if multi_az:
                return True
        return False

    def is_storage_type(self, storage_type: str) -> bool:
        """
        Check that the storage is of the expected size.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            storage: str = instance.get("StorageType", None)
            if storage == storage_type:
                return True
        return False

    def is_storage_encrypted(self) -> bool:
        """
        Check that the storage is encrypted.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            storage_encrypted: bool = instance.get("StorageEncrypted", False)
            if storage_encrypted:
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
            secret = self.__get_secret()
            if secret is None:
                secret = self.__get_secret()
                self.__set_secret(secret)
        if secret is not None:
            return True
        return False

    def __get_secret(self) -> dict:
        """
        Get the username and password to RDS from a Secrets Manager

        :return: dict
        """
        secret: dict = self.secret
        if secret is None:
            client = self.session.client(
                service_name="secretsmanager", region_name=self.region
            )

            secret_name: str = self.__get_secretsmanager()

            try:
                logging.info("Connected to Secrets Manager")
                get_secret_value_response = client.get_secret_value(
                    SecretId=secret_name
                )
            except ClientError:
                return None

            secret = json.loads(get_secret_value_response["SecretString"])
            if secret is None:
                return None
            self.__set_secret(secret)
        return secret

    def __set_secret(self, secret: dict) -> None:
        """
        Set the secret value for the instance of the class.
        """
        self.secret = secret

    def __get_endpoint(self) -> dict:
        """
        Get the RDS instance endpoint.

        :return: dict
        """
        endpoint: dict = self.endpoint
        if endpoint is None:
            instance: dict = self.__get_instance()
            if instance is not None:
                endpoint = instance.get("Endpoint", None)
                if endpoint is not None:
                    self.__set_endpoint(endpoint)
                    return endpoint
                return None
        return endpoint

    def __set_endpoint(self, endpoint: dict) -> None:
        """
        Set the endpoint value
        """
        self.endpoint = endpoint

    def connect_to_database(self) -> None:
        """
        Connect to the database and execute a simple query
        """
        endpoint: dict = self.__get_endpoint()
        if endpoint is None:
            endpoint: dict = self.__get_endpoint()
            self.__set_endpoint(endpoint)

        address = endpoint.get("Address", None)
        port = endpoint.get("Port", 0)

        secret: dict = self.__get_secret()
        if secret is None:
            secret: dict = self.__get_secret()
            self.__set_secret(secret)

        username = secret.get("username", None)
        password = secret.get("password", None)

        logging.info(f"Connecting to {address}:{port} as {username}")

        conn = psycopg2.connect(
            dbname=self.database,
            user=username,
            password=password,
            host=address,
            port=port,
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
    assert qa.instance_exist()
    assert qa.is_instance_available()
    assert qa.secretsmanager_exist()
    assert qa.is_username("qa_user")
    assert qa.is_storage_size(5)
    assert qa.is_backup_retention_period(0)
    assert qa.is_multi_az()
    assert qa.is_storage_type("gp2")
    assert qa.is_storage_encrypted()
    qa.connect_to_database()
    # This line will of course only be reached if all assert statement succeeds.
    print("All test cases succeeded")
