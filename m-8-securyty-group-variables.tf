# Bastion Security group Name 

variable "sg-bastion" {
  description = "bastion sg"
  default     = "SG-Bastion"
  type        = string

}

variable "sg-private" {
  description = "private sg"
  default     = "SG-private"
  type        = string

}

variable "sg-database" {
  description = "private sg"
  default     = "SG-database"
  type        = string

}
