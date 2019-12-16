variable "region" {
  description = "Region"
  default     = "us-west-2"
}

variable "ami_id" {
  description = "Latest linux ami ID"
  default     = "ami-00068cd7555f543d5"
}

variable "instance_type" {
  description = "free tier instance type"
  default     = "t2.small"
}

variable "volume_size" {
  description = "volume size for EBS"
  default     = 8
}

variable "ssh_port" {
  default = 22
}

variable "nfs_port" {
  default = 2049
}

variable "http_port" {
  default = 80
}

