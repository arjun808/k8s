resource "aws_instance" "K8master" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.k8-master-size}"
  security_groups = ["${aws_security_group.K8master.id}"]
  key_name        = "${var.keyname}"
  subnet_id       = "${element(data.aws_subnet_ids.all.ids, count.index)}"

  tags = {
    Name = "K8master"
  }
  
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/master.pem")}"
  }
  
  provisioner "file" {
    source      = "./install-kubernetes.sh"
    destination = "/home/ubuntu/install-kubernetes.sh"
  }
  
 provisioner "remote-exec" {
       inline = [
         "sudo mv /home/ubuntu/install-kubernetes.sh /root/install-kubernetes.sh",
         "sudo chmod +x /root/install-kubernetes.sh",
         "sudo /root/install-kubernetes.sh"
        ]
  }
}

resource "aws_instance" "K8node" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.k8-master-size}"
  count           = "${var.node-count}"
  security_groups = ["${aws_security_group.K8node.id}"]
  key_name        = "${var.keyname}"
  subnet_id       = "${element(data.aws_subnet_ids.all.ids, count.index)}"

  tags = {
    Name = "K8node-${count.index+1}"
  }
  
   connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/master.pem")}"
  }

  provisioner "file" {
    source      = "./install-node.sh"
    destination = "/home/ubuntu/install-node.sh"
  }

  provisioner "remote-exec" {
        inline = [
          "sudo mv /home/ubuntu/install-node.sh /root/install-node.sh",
          "sudo chmod +x /root/install-node.sh",
          "sudo /root/install-node.sh"
        ]
  }

}

output "master_ip" {
  value = "${aws_instance.K8master.public_ip}"
}

output "node_ips" {
    value = "${join(",", aws_instance.K8node.*.public_ip)}"
}
