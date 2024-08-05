variable "network_domains" {
  type    = map(any)
  default = null
}

variable "strict_mode" {
  type        = bool
  default     = false
  description = "if set to true - requires policy definition both directions. if false it is enough to allow on just 1 net domain"
}

variable "associations" {
  description = "A map with network domain associations"
  type        = map(string)
  default     = {}
  nullable    = false
}
