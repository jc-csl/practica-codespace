# Región: la del Learner Lab (AWS Details)
variable "region" { default = "us-east-1" }

# Imagen Ubuntu 22.04 · us-east-1 · amd64 (publicada el 01/10/2026)
# Si falla (InvalidAMIID), busca un ID nuevo y sustitúyelo:
#   aws ssm get-parameters --output text --query "Parameters[0].Value" --names \
#   /aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id
# Buscar: https://cloud-images.ubuntu.com/locator/ec2/  (us-east-1 22.04, amd64)
variable "ami" { default = "ami-062944a84867f2386" }

# Tamaño de la máquina (pequeña y barata)
variable "tipo" { default = "t3.micro" }

# Par de claves del Learner Lab (EC2 → Pares de claves)
variable "clave" { default = "vockey" }
