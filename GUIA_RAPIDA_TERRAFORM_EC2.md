# Guía Rápida: EC2 Ubuntu 22.04 con Terraform

Crea una EC2 Ubuntu 22.04 con nginx en AWS en un solo comando.

## Qué se crea

- **Grupo de seguridad** con puertos 22 (SSH), 80 (HTTP) y 443 (HTTPS) abiertos
- **EC2 Ubuntu 22.04** con nginx instalado automáticamente

## Requisitos

- Learner Lab iniciado (círculo verde)
- AWS CLI configurado con credenciales
- Terraform instalado

---

## 1. Preparar el entorno

Si usas **GitHub Codespaces con `.devcontainer/`**, todo ya está instalado. Salta al paso 2.

### Sin Codespaces:

```bash
# Añadir repositorio de Terraform
wget -O - https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Instalar herramientas
sudo apt update && sudo apt install -y terraform unzip curl

# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o aws.zip
unzip -q aws.zip && sudo ./aws/install

# Verificar
terraform -version && aws --version
```

---

## 2. Configurar credenciales de AWS

### Obtener credenciales:
1. Abre **Learner Lab → AWS Details → AWS CLI: Show**
2. Copia el bloque `[default]` completo (3 líneas)

### Guardarlas:

```bash
# Crear carpeta y pegar credenciales
mkdir -p ~/.aws
nano ~/.aws/credentials
# Pega el bloque [default] y guarda (Ctrl+O, Intro, Ctrl+X)

# Configurar región
printf "[default]\nregion = us-east-1\n" > ~/.aws/config

# Verificar que funcionan
aws sts get-caller-identity
```

**Nota:** Las credenciales caducan al terminar el lab. Nunca van dentro de los archivos `.tf`.

---

## 3. Estructura del proyecto

```
ec2-ubuntu/
├── providers.tf       # Qué provider usar (AWS)
├── variables.tf       # Valores configurables (región, tipo, etc.)
├── security.tf        # Grupo de seguridad y reglas de puertos
├── main.tf           # Instancia EC2
├── outputs.tf        # IP pública e ID de instancia
├── nginx.sh          # Script que se ejecuta al arrancar
└── .gitignore        # Qué no subir a GitHub
```

### Archivos importantes:

| Archivo | Qué hace |
|---------|----------|
| **providers.tf** | Define AWS como provider |
| **variables.tf** | AMI, tipo de instancia, región |
| **security.tf** | Cortafuegos (puertos 22, 80, 443) |
| **main.tf** | Crea la EC2 usando las piezas anteriores |
| **outputs.tf** | Muestra la IP pública y ID |
| **nginx.sh** | Instala nginx al arrancar |

---

## 4. Desplegar

```bash
cd ec2-ubuntu

# 1. Descargar plugin de AWS
terraform init

# 2. Validar que la sintaxis sea correcta
terraform validate

# 3. Ver qué va a crear (sin tocar nada)
terraform plan
# Debe decir: Plan: 6 to add (grupo de seguridad, 4 reglas, EC2)

# 4. Crear los recursos
terraform apply
# Escribe "yes" para confirmar

# 5. Ver IP pública e ID
terraform output
```

**Los 6 recursos:** 1 grupo de seguridad + 1 regla de salida + 3 reglas de entrada + 1 EC2

---

## 5. Probar

Espera **1-2 minutos** a que nginx.sh termine su ejecución.

### Desde terminal:

```bash
# HTTP
curl http://$(terraform output -raw ip_publica)
# Debe aparecer: "Welcome to nginx!"

# HTTPS (acepta certificado autofirmado)
curl -k https://$(terraform output -raw ip_publica)
```

### Desde navegador:
- HTTP: `http://IP_PUBLICA`
- HTTPS: `https://IP_PUBLICA` (Avanzado → Continuar)

---

## 6. Acceder por SSH

### Descargar clave:
1. **Learner Lab → AWS Details → Download PEM**
2. Guarda `labsuser.pem` en `~/.ssh/`

### Conectar:

```bash
mkdir -p ~/.ssh
chmod 400 ~/.ssh/labsuser.pem

ssh -i ~/.ssh/labsuser.pem ubuntu@$(terraform output -raw ip_publica)

# Dentro de la EC2, verificar que nginx corre
systemctl status nginx

# Salir
exit
```

---

## 7. Modificar y borrar

```bash
# Recrear la EC2 (necesario si cambias nginx.sh)
terraform apply -replace="aws_instance.servidor"

# Borrar todo (IMPORTANTE al terminar)
terraform destroy
# Escribe "yes"
```

**Nota:** En Codespaces, ejecuta `terraform destroy` antes de eliminar el codespace.

---

## 8. Solucionar problemas

### ❌ Error de AMI (InvalidAMIID)

El ID de Ubuntu puede haber cambiado. Obtén el nuevo:

```bash
aws ssm get-parameters --output text --query "Parameters[0].Value" --names \
  /aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id
```

Actualiza en `variables.tf`:

```bash
grep ami variables.tf
# Sustituye el ID
nano variables.tf
```

Alternativa sin AWS CLI: https://cloud-images.ubuntu.com/locator/ec2 → Busca us-east-1, 22.04, amd64

### ❌ Credenciales vencidas

Pega las nuevas credenciales:

```bash
nano ~/.aws/credentials
# Reemplaza el bloque [default]
```

### ❌ nginx tarda en instalar

Espera 2-3 minutos más. Verifica con SSH:

```bash
ssh -i ~/.ssh/labsuser.pem ubuntu@IP
systemctl status nginx
```

---

## Comandos útiles

| Comando | Qué hace |
|---------|----------|
| `terraform init` | Descargar plugin de AWS |
| `terraform validate` | Revisar sintaxis |
| `terraform plan` | Ver cambios (sin aplicar) |
| `terraform apply` | Crear/actualizar recursos |
| `terraform output` | Mostrar IP y ID |
| `terraform destroy` | Borrar todo |
| `terraform output -raw ip_publica` | Solo la IP (para scripts) |

---

## Notas finales

- ✅ Sube a GitHub: `*.tf`, `*.sh`, `.gitignore`, `.devcontainer/`, `README.md`
- ❌ NO subas: `*.pem`, credenciales, `.terraform/`, `*.tfstate`
- 🔒 Las credenciales se leen de `~/.aws/credentials`, nunca van en el código
- ⏱️ El estado se guarda en `terraform.tfstate` (mantén seguro)

---

**Profesor:** Juan Carlos San Román  
**Ciclo:** ASIR · Cloud, IoT and Quantum Computing
