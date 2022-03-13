variable"aws_access_key"{

     description="Entera access key"
 }
 variable "aws_secret_key" {
     description = "Enter secret key"
   
 }

variable "ec2_ami_id" {
  description = "AMI ID"
  type = string
  default = "ami-0e1d30f2c40c4c701"
  
}

variable "aws_instance_type" {
  description = "instance type"
  type=string
  default="t3.small"
    
  
}
variable "aws_key_pair" {
    description = "enter key pair for ssh"
    default = "AWS-Market-place"
  
}
 




variable "subnet_id" {
    description = "Enter subnet id for vpc id"
}
