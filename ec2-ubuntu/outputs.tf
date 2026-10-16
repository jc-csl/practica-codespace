# IP para el navegador y para SSH
output "ip_publica" {
  value = aws_instance.servidor.public_ip
}

# ID que AWS da a la instancia (i-0…)
output "id_instancia" {
  value = aws_instance.servidor.id
}
