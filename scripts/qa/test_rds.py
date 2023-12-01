#!/usr/bin/env python
# pylint: disable=W1203,R0902
"""
QA test cases.
"""
import unittest
import rds


class TestQA(unittest.TestCase):
    """
    Test cases for the QA class.
    """

    def setUp(self):
        self.qa = rds.QA()

    def test_instance_exist(self):
        self.assertTrue(self.qa.instance_exist, "Instance doesn't exist.")

    def test_is_instance_available(self):
        self.assertTrue(self.qa.is_instance_available, "Instance isn't available.")

    def test_secretsmanager_exist(self):
        self.assertTrue(
            self.qa.secretsmanager_exist, "SecretsManager secret doesn't exist."
        )

    def test_is_multi_az(self):
        self.assertTrue(
            self.qa.is_multi_az, "The instance is not configured with multi AZ."
        )

    def test_certificate_ca(self):
        self.assertEqual(self.qa.get_certificate_ca(), "rds-ca-ecc384-g1")

    def test_username(self):
        self.assertEqual(self.qa.get_username_from_instance(), "qa_user")

    def test_storage_size(self):
        self.assertEqual(self.qa.get_storage_size_from_instance(), 5)

    def test_storage_type(self):
        self.assertEqual(self.qa.get_storage_type_from_instance(), "gp2")

    def test_is_storage_encrypted(self):
        self.assertTrue(self.qa.is_storage_encrypted(), "Storage isn't encrypted.")

    def test_backup_retention_period(self):
        self.assertEqual(self.qa.get_backup_retention_period(), 0)


if __name__ == "__main__":
    unittest.main()
