data "aws_subnet_ids" "subnets" {
  vpc_id = data.terraform_remote_state.infra_remote_state.outputs.vpc_id
}

resource "aws_security_group" "wp_sg" {
  name   = "wp_security_group"
  vpc_id = data.terraform_remote_state.infra_remote_state.outputs.vpc_id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #need to specify the IP adress but right now this is up to the deployer where is the script executed. 
  }

  ingress {
    from_port = var.nfs_port
    to_port   = var.nfs_port
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "elastic_FS" {
  creation_token = "Filesystem for WP"
}

resource "aws_efs_mount_target" "elastic_MT" {
  //count= "4" 
  //count had to be hardcoded because of dependency faliure. later this can be calculated
  count           = length(data.aws_subnet_ids.subnets.ids)
  file_system_id  = aws_efs_file_system.elastic_FS.id
  subnet_id       = element(tolist(data.aws_subnet_ids.subnets.ids), count.index)
  security_groups = [aws_security_group.wp_sg.id]
}

resource "aws_key_pair" "deployer" {
  key_name   = "my_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAinGft7WD0sBrmOBOD5ecqNIansujlktQVlgXUV57HRIGJWtYuwOMlRxHP/NsZ0y0BuKpTbs5lFkMdBa/fLvocF0FoiHNTw8wQSIj6y2NHZ2MCiMXuNMG5dZzz980PCWGz43P3Fha8o6UD6f2jEcwMEe45gnSgPBBjqlCBuvcKjvE5rDc"
}

resource "aws_instance" "WP_site" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wp_sg.id]
  key_name               = aws_key_pair.deployer.id
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = var.volume_size
    delete_on_termination = "true"
  }

  user_data = <<EOF
        #!/bin/bash
        echo "${aws_efs_file_system.elastic_FS.dns_name}:/ /var/www/html nfs defaults,vers=4.1 0 0" >> /etc/fstab
        yum install -y php php-dom php-gd php-mysql
        for z in {0..120}; do
            echo -n .
            host "${aws_efs_file_system.elastic_FS.dns_name}" && break
            sleep 1
        done
        cd /tmp
        wget https://www.wordpress.org/latest.tar.gz
        mount -a
        tar xzvf /tmp/latest.tar.gz --strip 1 -C /var/www/html
        rm /tmp/latest.tar.gz
        chown -R apache:apache /var/www/html
        systemctl enable httpd
        sed -i 's/#ServerName www.example.com:80/ServerName www.myblog.com:80/' /etc/httpd/conf/httpd.conf
        sed -i 's/ServerAdmin root@localhost/ServerAdmin admin@myblog.com/' /etc/httpd/conf/httpd.conf
        #setsebool -P httpd_can_network_connect 1
        #setsebool -P httpd_can_network_connect_db 1
        systemctl start httpd
        #firewall-cmd --zone=public --permanent --add-service=http
        #firewall-cmd --reload
        #iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        #iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
    
EOF

}

resource "aws_security_group" "alb_wp" {
  name   = "public-secgroup"
  vpc_id = data.terraform_remote_state.infra_remote_state.outputs.vpc_id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

