
variable "cider-vpc" {
    description="variable cider"
    type= list
    default=["10.0.0.0/16"] 
    }



variable "cider-sub" {
    description="variable cider sub"
    type= map
    }


variable "ingress" {
  type        = object({
    description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
  })
  description = "Security group rules" 
  default     = {
      description = "For HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    
  } 
}


variable "ingress1" {
  type        = object({
    description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
  })
  description = "Security group rules" 
  default     = {
      description = "For ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    
  } 
}



variable "egress" {
  type        = object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = string
  })
  description = "Security group rules" 
  default = {  
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"

    
  } 
}

