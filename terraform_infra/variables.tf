variable "region" {
  description = "Region"
  default     = "us-west-2"
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

variable "vpc_cidr" {
  description = "VPC cidr"
  default     = "10.10.0.0/21"
}

variable "public_cidr" {
  description = "Public Subnet"
  default     = "10.10.0.0/24"
}

variable "public_cidr2" {
  description = "Public Subnet"
  default     = "10.10.1.0/24"
}

variable "private_cidr" {
  description = "Private Subnet"
  default     = "10.10.2.0/24"
}

variable "private_cidr2" {
  description = "Private Subnet"
  default     = "10.10.3.0/24"
}

