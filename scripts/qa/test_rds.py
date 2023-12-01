#!/usr/bin/env python
# pylint: disable=W0212,C0116
"""
QA test cases.
"""
import unittest
import rds


class TestQA(unittest.TestCase):
    """
    Test cases for the QA class.
    """

    @classmethod
    def setUpClass(cls):
        cls._qa = rds.QA()

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
        self.assertEqual(self.__class__._qa.get_storage_size_from_instance(), 5)

    def test_storage_type(self):
        self.assertEqual(self.__class__._qa.get_storage_type_from_instance(), "gp2")

    def test_is_storage_encrypted(self):
        self.assertTrue(
            self.__class__._qa.is_storage_encrypted(), "Storage isn't encrypted."
        )

    def test_backup_retention_period(self):
        self.assertEqual(self.__class__._qa.get_backup_retention_period(), 0)


if __name__ == "__main__":
    unittest.main()
