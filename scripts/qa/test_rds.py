#!/usr/bin/env python
# pylint: disable=W0212,C0116,R0904
"""
QA test cases.
"""
import logging
import unittest
import rds


class TestQA(unittest.TestCase):
    """
    Test cases for the QA class.
    """

    @classmethod
    def setUpClass(cls):
        cls._qa = rds.QA(database="qa", log_level=logging.ERROR)

    def test_instance_exist(self):
        self.assertTrue(self.__class__._qa.instance_exist, "Instance doesn't exist.")

    def test_is_instance_available(self):
        self.assertTrue(
            self.__class__._qa.is_instance_available, "Instance isn't available."
        )

    def test_secretsmanager_exist(self):
        self.assertTrue(
            self.__class__._qa.secretsmanager_exist,
            "SecretsManager secret doesn't exist.",
        )

    def test_is_multi_az(self):
        self.assertTrue(
            self.__class__._qa.is_multi_az,
            "The instance is not configured with multi AZ.",
        )

    def test_certificate_ca(self):
        self.assertEqual(self.__class__._qa.get_certificate_ca(), "rds-ca-ecc384-g1")

    def test_username(self):
        self.assertEqual(self.__class__._qa.get_username_from_instance(), "qa_user")

    def test_storage_size(self):
        self.assertEqual(self.__class__._qa.get_storage_size_from_instance(), 20)

    def test_storage_type(self):
        self.assertEqual(self.__class__._qa.get_storage_type_from_instance(), "gp3")

    def test_is_storage_encrypted(self):
        self.assertTrue(
            self.__class__._qa.is_storage_encrypted(), "Storage isn't encrypted."
        )

    def test_backup_retention_period(self):
        self.assertEqual(self.__class__._qa.get_backup_retention_period(), 0)

    def test_engine(self):
        self.assertEqual(self.__class__._qa.get_engine_from_instance(), "postgres")

    def test_database_name(self):
        self.assertEqual(self.__class__._qa.get_database_name_from_instance(), "qadb")

    def test_instance_class(self):
        self.assertEqual(
            self.__class__._qa.get_instance_class_from_instance(), "db.t3.micro"
        )

    def test_preferred_maintenance_window(self):
        self.assertEqual(
            self.__class__._qa.get_preferred_maintenance_window_instance(),
            "sat:18:00-sat:20:00",
        )

    def test_is_auto_minor_version_upgrade(self):
        self.assertTrue(self.__class__._qa.is_auto_minor_version_upgrade())

    def test_is_publicly_available(self):
        self.assertTrue(self.__class__._qa.is_publicly_available())

    def test_is_iam_db_auth_enabled(self):
        self.assertTrue(self.__class__._qa.is_iam_db_auth_enabled())

    def test_is_performance_insights_enabled(self):
        self.assertTrue(self.__class__._qa.is_performance_insights_enabled())

    def test_performance_insights_retention_period(self):
        self.assertEqual(
            self.__class__._qa.get_performance_insights_retention_period_from_instance(),
            7,
        )

    def test_is_delete_protection_enabled(self):
        self.assertFalse(self.__class__._qa.is_delete_protection_enabled())

    def test_is_customer_owned_ip_enabled(self):
        self.assertFalse(self.__class__._qa.is_customer_owned_ip_enabled())

    def test_dedicated_log_volume(self):
        self.assertFalse(self.__class__._qa.has_dedicated_log_volume())

    def test_storage_config_upgrade_available(self):
        self.assertFalse(self.__class__._qa.has_storage_config_upgrade_available())

    def test_get_cloudwatch_logs_exports(self):
        self.assertListEqual(
            self.__class__._qa.get_cloudwatch_logs_exports(), ["postgresql", "upgrade"]
        )

    def test_active_subnets(self):
        self.assertTrue(self.__class__._qa.has_active_subnets())


if __name__ == "__main__":
    unittest.main()
