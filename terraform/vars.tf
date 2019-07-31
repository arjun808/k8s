variable "k8-master-size" {
  default = "t2.medium"
}

variable "k8-node-size" {
  default = "t2.micro"
}

variable "master-count" {
 default = "1"
}

variable "node-count" {
 default = "1"
}

variable "keyname" {
 default = "master"
}

variable "keypath" {
 default = "/root/.ssh/master.pem"
}




