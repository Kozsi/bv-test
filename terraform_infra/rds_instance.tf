resource "aws_db_subnet_group" "wp_subnet_g" {
  name       = "wp_subnet"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_db_instance" "wp_db" {
  allocated_storage    = 20
  db_subnet_group_name = aws_db_subnet_group.wp_subnet_g.id
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "WP_test_DB"
  username             = "wp_test"
  password             = "wp_test123"
  parameter_group_name = "mysql5.7"
}



