resource "aws_instance" "servidor" {
  ami                    = var.ami
  instance_type          = var.tipo
  key_name               = var.clave
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = file("${path.module}/nginx.sh")

  tags = {
    Name = "ubuntu-asir"
  }
}
