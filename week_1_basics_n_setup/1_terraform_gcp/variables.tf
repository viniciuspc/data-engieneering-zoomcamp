variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-creds.json"
}

variable "project" {
  description = "Project from GCP"
  default     = "de-zoomcamp-viniciuspc"
}

variable "region" {
  description = "Project Region"
  default     = "europe-west10"

}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQueryDataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Bucket stroage name"
  default     = "terraform-demo-440914-terra-bucket"

}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}