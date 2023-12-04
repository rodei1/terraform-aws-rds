#!/usr/bin/env python
# pylint: disable=W1203,R0902,R0904
"""
RDS
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
        logging.debug("Class initialized")

    def __get_all_instances(self) -> dict:
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
            dbs: dict = self.__get_all_instances()
            for db in dbs["DBInstances"]:
                if db["DBInstanceIdentifier"] == "qa":
                    self.__set_instance(db)
                    logging.debug(db)
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
            logging.debug(instance)
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
            if instance_status == "available":
                return True
        return False

    def get_username_from_instance(self) -> str:
        """
        Return the username from the instance.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            username: str = instance.get("MasterUsername", None)
            if username is not None:
                return username
        return None

    def get_storage_size_from_instance(self) -> int:
        """
        Return the storage size from the instance.

        :return: int
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            storage_size: int = instance.get("AllocatedStorage", -1)
            return storage_size
        return None

    def get_backup_retention_period(self) -> int:
        """
        Return the backup retention period from the instance.

        :return: int
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            retention_period: int = instance.get("BackupRetentionPeriod", -1)
            return retention_period
        return None

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

    def get_storage_type_from_instance(self) -> str:
        """
        Return the storage type from the instance.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            storage: str = instance.get("StorageType", None)
            if storage is not None:
                return storage
        return None

    def get_engine_from_instance(self) -> str:
        """
        Return the instance engine.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            engine: str = instance.get("Engine", None)
            if engine is not None:
                return engine
        return None

    def get_database_name_from_instance(self) -> str:
        """
        Return the instance database name.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            db_name: str = instance.get("DBName", None)
            if db_name is not None:
                return db_name
        return None

    def get_instance_class_from_instance(self) -> str:
        """
        Return the instance class from the instance.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            instance_class: str = instance.get("DBInstanceClass", None)
            if instance_class is not None:
                return instance_class
        return None

    def get_preferred_maintenance_window_instance(self) -> str:
        """
        Return the preferred maintenance window from the instance.

        :return: str
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            preferred_maintenance_window: str = instance.get(
                "PreferredMaintenanceWindow", None
            )
            if preferred_maintenance_window is not None:
                return preferred_maintenance_window
        return None

    def is_auto_minor_version_upgrade(self) -> bool:
        """
        Check if auto minor version upgrade is enabled.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            auto_minor_version_upgrade: bool = instance.get(
                "AutoMinorVersionUpgrade", False
            )
            if auto_minor_version_upgrade:
                return True
        return False

    def is_publicly_available(self) -> bool:
        """
        Check if the instance is public available.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            publicly_available: bool = instance.get("PubliclyAccessible", False)
            if publicly_available:
                return True
        return False

    def is_iam_db_auth_enabled(self) -> bool:
        """
        Check if the instance has IAM database authentication enabled.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            iam_db_auth_enabled: bool = instance.get(
                "IAMDatabaseAuthenticationEnabled", False
            )
            if iam_db_auth_enabled:
                return True
        return False

    def is_performance_insights_enabled(self) -> bool:
        """
        Check if the instance has performance insights enabled.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            performance_insights_enabled: bool = instance.get(
                "PerformanceInsightsEnabled", False
            )
            if performance_insights_enabled:
                return True
        return False

    def get_performance_insights_retention_period_from_instance(self) -> int:
        """
        Return the performance insights retention period from the instance.

        :return: int
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            performance_insights_retention_period: int = instance.get(
                "PerformanceInsightsRetentionPeriod", -1
            )
            return performance_insights_retention_period
        return None

    def is_delete_protection_enabled(self) -> bool:
        """
        Check if the instance has delete protection enabled.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            delete_protection_enabled: bool = instance.get("DeletionProtection", False)
            if delete_protection_enabled:
                return True
        return False

    def has_dedicated_log_volume(self) -> bool:
        """
        Check if the instance has a dedicated log volume

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            dedicated_log_volume: bool = instance.get("DedicatedLogVolume", False)
            if dedicated_log_volume:
                return True
        return False

    def is_customer_owned_ip_enabled(self) -> bool:
        """
        Check if the instance has a customer owner IP address.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            customer_owned_ip_enabled: bool = instance.get(
                "CustomerOwnedIpEnabled", False
            )
            if customer_owned_ip_enabled:
                return True
        return False

    def get_cloudwatch_logs_exports(self) -> list:
        """
        Return a list if the CloudWatch Logs exports

        :return: list
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            cloudwatch_logs_exports: list = instance.get(
                "EnabledCloudwatchLogsExports", []
            )
        return cloudwatch_logs_exports

    def has_storage_config_upgrade_available(self) -> bool:
        """
        Check if the instance has storage config upgrade available.

        :return: bool
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            customer_owned_ip_enabled: bool = instance.get(
                "IsStorageConfigUpgradeAvailable", False
            )
            if customer_owned_ip_enabled:
                return True
        return False

    def has_active_subnets(self) -> bool:
        """
        Check if the instance has a database subnet group with active subnets.

        :return: bool
        """
        instance: dict = self.__get_instance()
        ret_val: bool = False
        if instance is not None:
            subnet_group: dict = instance.get("DBSubnetGroup", None)
            if subnet_group is not None:
                subnets: list = subnet_group.get("Subnets", [])
                ret_val = True
                for subnet_i in subnets:
                    subnet: dict = subnet_i
                    subnet_status: str = subnet.get("SubnetStatus", None)
                    if subnet_status != "Active":
                        return False
        return ret_val

    def get_certificate_ca(self) -> str:
        """
        Return the Certificate CA Identifier from the instance.
        """
        instance: dict = self.__get_instance()
        if instance is not None:
            cert_details: str = instance.get("CertificateDetails", None)
            if cert_details is not None:
                ca: str = cert_details.get("CAIdentifier", None)
                if ca is not None:
                    return ca
        return None

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
