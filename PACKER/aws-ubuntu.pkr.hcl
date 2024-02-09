packer {
  required_plugins {
    amazon =  {
      version = >=1.2.8
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  access_key           = var.AWS_ACCESS_KEY_ID
  secret_key           = var.AWS_SECRET_ACCESS_KEY
  region               = var.AWS_DEFAULT_REGION
  source_ami_filter {
    filters = {
      "virtualization-type" = "hvm"
      "name"                = "*ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      "root-device-type"    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  instance_type       = "t2.micro"
  ssh_username        = "ubuntu"
  ami_name            = "ubuntu-20.04-s4tankoua-${formatdate("YYYYMMDDHHmmss", timestamp())}"
  ami_users           = []
  tags = {
    Name        = "ubuntu-20.04-s4tankoua"
    Environment = "Production"
  }
}

build {
  name = "s6-student"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo useradd -m s4tankoua || true", // Prevents error if user already exists
      "sudo -u s4tankoua mkdir -p /home/s4tankoua/.ssh || true", 
      "sudo cp /home/ubuntu/.ssh/authorized_keys /home/s4tankoua/.ssh/",
      "sudo chown -R s4tankoua:s4tankoua /home/s4tankoua/.ssh",
      "sudo chmod 700 /home/s4tankoua/.ssh",
      "sudo chmod 600 /home/s4tankoua/.ssh/authorized_keys",
      "echo 's4tankoua ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/s4tankoua",
      "sudo chmod 0440 /etc/sudoers.d/s4tankoua"
      "sudo usermod -aG docker ${SSH_USERNAME}",
      "sudo apt install apt-utils kubectl mysql-client postgresql-client docker-compose default-jdk default-jre python3 python3-pip git nodejs npm maven wget ansible htop vim watch build-essential openssh-server -y",
      "sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx",
      "sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx",
      "sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens",
      curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -,
      echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list,
      "sudo apt update",
      "sudo apt install helm",
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo apt update",
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common",
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -,
      "sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable",
      "sudo apt update",
      "sudo apt install docker-ce",
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -,
      "sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main",
      "sudo apt update",
      "sudo apt install terraform",

    ]
  }
}

