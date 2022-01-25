variable "instance_options" {

  description = "Instance options"

  type = list(object(
    {
      workspace     = string
      instance_type = string
      instance_count = number
    }
    )
  )

  default = [
    {
      workspace     = "stage"
      instance_type = "t2.micro"
      instance_count = 1
    },
    {
      workspace     = "prod"
      instance_type = "t2.micro"
      instance_count = 2
    }
  ]
}
