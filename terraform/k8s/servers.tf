resource "aws_instance" "K8master" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.medium"
  security_groups = ["${aws_security_group.K8master.id}"]
  key_name        = "master"
  subnet_id       = "${element(data.aws_subnet_ids.all.ids, count.index)}"

  tags = {
    Name = "K8master"
  }
}

resource "aws_instance" "K8node" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  count           = 1
  security_groups = ["${aws_security_group.K8node.id}"]
  key_name        = "master"
  subnet_id       = "${element(data.aws_subnet_ids.all.ids, count.index)}"
  
  tags = {
    Name = "K8node-${count.index+1}"
  }
}

