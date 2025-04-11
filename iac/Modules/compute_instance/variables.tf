variable "instance_name" {
  description = "value of instance name"
  type = string
}

variable "instance_type" {
  description = "instance type"
  type = string
}

variable "zone" {
    description = "instance zone"
    type = string
}
variable "instance_image" {
    description = "value of instance image"
    type = string
}

variable "instance_disk_size" {
    description = "value of instance disk size"
    type = number
}
