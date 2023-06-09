terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "= 0.85.0"
    }
  }
  required_version = "= 1.3.7"
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone                      = "ru-central1-a"
}

data "yandex_iam_service_account" "netology-diplom" {
  service_account_id = "${var.service_account_id}"
}

// Storage Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = "${var.service_account_id}"
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "state" {
  access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
  secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
  bucket = "my-netology-bucket"
  force_destroy = true
}