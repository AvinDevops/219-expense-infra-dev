variable "project_name" {
    type = string
    default = "expense"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    type = map
    default = {
        Project = "Expense"
        Terraform = "True"
        Environment = "Dev"
    }
}

variable "zone_name" {
    type = string
    default = "aviexpense.online"
}