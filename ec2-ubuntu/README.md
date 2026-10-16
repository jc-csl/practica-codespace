# EC2 Ubuntu 22.04 con Terraform · Cloud, IoT and Quantum Computing (ASIR)

Profesor: Juan Carlos San Roman · Centro San Luis

## Opción B: GitHub Codespaces (sin instalar nada)
Sube esta carpeta a un repositorio de GitHub (incluida `.devcontainer/`) y abre
**Code → Codespaces → Create codespace on main**. Terraform y AWS CLI ya vienen instalados.
Credenciales en `~/.aws/credentials` y `labsuser.pem` en `~/.ssh/` igual que en Linux.
El `.gitignore` evita subir `*.pem` y el estado de Terraform. Para el codespace al acabar.

## Antes de empezar
1. Learner Lab → Start Lab → AWS Details → copia el bloque [default] en ~/.aws/credentials
2. Comprueba: `aws sts get-caller-identity`
3. Comprueba el ID de la AMI en variables.tf (Ubuntu 22.04, us-east-1). Si falla, busca uno nuevo con el comando del propio fichero

## Clave SSH (solo para entrar por SSH)
Learner Lab → AWS Details → Download PEM. Desde WSL:

    mkdir -p ~/.ssh
    cp /mnt/c/Users/TU_USUARIO/Downloads/labsuser.pem ~/.ssh/
    chmod 400 ~/.ssh/labsuser.pem

(En /mnt/c el chmod no funciona: por eso se copia a Linux. Si la dejas en esta carpeta, *.pem ya está en .gitignore.)

## Desplegar
    terraform init
    terraform plan      # Plan: 6 to add
    terraform apply     # escribe yes
    terraform output

## Probar
    http://IP   y   https://IP  (aviso del certificado → Avanzado → Continuar)
    ssh -i ~/.ssh/labsuser.pem ubuntu@$(terraform output -raw ip_publica)

## Al terminar
    terraform destroy

nginx.sh = versión final (HTTP + HTTPS). nginx-http.sh = versión del paso 3, solo HTTP.
