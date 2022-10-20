###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Variables - Provider
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
variable "aws_akey" {
  type        = string
  description = "Set as environmental variable: export TF_VAR_aws_akey="
  sensitive   = true
}
variable "aws_skey" {
  type        = string
  description = "Set as environmental variable: export TF_VAR_aws_skey="
  sensitive   = true
}
variable "aws_region" {
  type        = string
  description = "AWS region."
  default     = "us-east-2"
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Variables - Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
variable "prefix" {
  type        = string
  description = "Resource name prefix."
  default     = "cjh-"
}
variable "inst_size" {
  type        = list(string)
  description = "EC2 instance sizes."
  default     = ["t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large"]
}
variable "resource_count" {
  type        = number
  description = "Quantity of resource groupings created."
  default     = 2
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Variables - Networking
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
variable "network" {
  type        = string
  description = "Default address space for VPS."
  default     = "10.0.0.0/16"
}

variable "subnets_count" {
  type        = number
  description = "Number of subnets in this deployment."
  default     = 2
}
variable "dnshostname" {
  type        = bool
  description = "Enable DNS hostnames for the VPC?"
  default     = true
}
variable "mapip" {
  type        = bool
  description = "Map the subnet IPs on launch."
  default     = true
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Variables - Tag Primatives
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
variable "owner" {
  type        = string
  description = "User who owns these resources."
  default     = "Coleman J. Heard"
}
variable "project" {
  type        = string
  description = "Project name."
  default     = "AWS Terraform Test"
}
variable "department" {
  type        = string
  description = "Department that this resource belongs to."
  default     = "IT_Infra"
}
