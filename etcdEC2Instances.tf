/* Create bastion host that resides in a public subnet. This is used to proxy ssh connections to our
etcd instances that reside in private networks */

resource "aws_instance" "bastion" {
  ami                         = "ami-0d8e27447ec2c8410"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name = "terraform"
  subnet_id = "${aws_subnet.bastion.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  source_dest_check = false
  tags = {
    Name = "bastion"
  }
}

/* Create three etcd instances, one for each availability zone in the London region
Then use the bastion host to SSH into the instances and execute the bootstrap script */


resource "aws_instance" "etcd1" {
  ami           = "ami-077a5b1762a2dde35" 
  instance_type = "t2.micro"
  key_name = "terraform"

  depends_on        = ["aws_nat_gateway.etcd-nat-gw"]

  network_interface {
    network_interface_id = "${aws_network_interface.etcd1-eth0.id}"
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "etcd1"
  }

    connection {
    host = "${aws_instance.etcd1.private_ip}"
    port = "22"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("./terraformec2.pem")}"
    timeout = "2m"
    agent = false

    bastion_host = "${aws_instance.bastion.public_ip}"
    bastion_port = "22"
    bastion_user = "ec2-user"
    bastion_private_key = "${file("./terraformec2.pem")}"
}

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
}

resource "aws_instance" "etcd2" {
  ami           = "ami-077a5b1762a2dde35" 
  instance_type = "t2.micro"
  key_name = "terraform"

  depends_on        = ["aws_nat_gateway.etcd-nat-gw"]

  network_interface {
    network_interface_id = "${aws_network_interface.etcd2-eth0.id}"
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "etcd2"
  }

      connection {
    host = "${aws_instance.etcd2.private_ip}"
    port = "22"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("./terraformec2.pem")}"
    timeout = "2m"
    agent = false

    bastion_host = "${aws_instance.bastion.public_ip}"
    bastion_port = "22"
    bastion_user = "ec2-user"
    bastion_private_key = "${file("./terraformec2.pem")}"
}

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

}

resource "aws_instance" "etcd3" {
  ami           = "ami-077a5b1762a2dde35" 
  instance_type = "t2.micro"
  key_name = "terraform"
  depends_on        = ["aws_nat_gateway.etcd-nat-gw"]

  network_interface {
    network_interface_id = "${aws_network_interface.etcd3-eth0.id}"
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "etcd3"
  }

      connection {
    host = "${aws_instance.etcd3.private_ip}"
    port = "22"
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("./terraformec2.pem")}"
    timeout = "2m"
    agent = false

    bastion_host = "${aws_instance.bastion.public_ip}"
    bastion_port = "22"
    bastion_user = "ec2-user"
    bastion_private_key = "${file("./terraformec2.pem")}"
}

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

}