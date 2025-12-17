variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "Expense"
        Environment = "Dev"
        Terraform = "True"
        Component = "acm"
    }
}

variable "zone_name" {
    default = "aviexpense.online"
}

variable "zone_id" {
    default = "Z074597133KN1IHDWRZO"
}