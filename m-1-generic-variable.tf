variable "aws_region" {
    description = "AWS Region where we need to create these resources"
    default = "us-east-1"
    type = string
}


variable "aws_credential_profile" {
    description = "AWS Credential profile"
    default = "default"
    type = string
}

variable "business_division" {
    description = "Business Division in the large organization this Infrastructure belongs"
    default = "SAP"
    type = string
}

variable "environment" {
    description = "Environment Variable used as a prefix"
    default = "dev"
    type = string
}
