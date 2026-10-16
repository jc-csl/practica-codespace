# El grupo: un cortafuegos vacío
resource "aws_security_group" "web" {
  name        = "sg-ubuntu-asir"
  description = "SSH, HTTP y HTTPS"
}

# Regla de SALIDA: la EC2 puede salir a Internet
resource "aws_vpc_security_group_egress_rule" "salida" {
  security_group_id = aws_security_group.web.id # el de arriba
  cidr_ipv4         = "0.0.0.0/0"               # hacia cualquier IP
  ip_protocol       = "-1"                      # -1 = todo el tráfico
}

# Regla de ENTRADA: SSH (puerto 22)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web.id # ¿grupo?
  cidr_ipv4         = "0.0.0.0/0"               # ¿origen?
  ip_protocol       = "tcp"                     # ¿protocolo?
  from_port         = 22                        # ¿puerto?
  to_port           = 22
}

# Regla de ENTRADA: HTTP (puerto 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Regla de ENTRADA: HTTPS (puerto 443)
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}
