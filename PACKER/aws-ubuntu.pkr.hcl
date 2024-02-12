packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  aws_access_key           = var.AWS_ACCESS_KEY_ID
  aws_secret_key           = var.AWS_SECRET_ACCESS_KEY
  region                   = var.AWS_DEFAULT_REGION
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
      "set -eu", # Stop on error and treat unset variables as an error
      "sudo apt-get update",
      "sudo useradd -m s4tankoua || true", 
      "sudo -u s4tankoua mkdir -p /home/s4tankoua/.ssh || true", 
      "sudo cp /home/ubuntu/.ssh/authorized_keys /home/s4tankoua/.ssh/",
      "sudo chown -R s4tankoua:s4tankoua /home/s4tankoua/.ssh",
      "sudo chmod 700 /home/s4tankoua/.ssh",
      "sudo chmod 600 /home/s4tankoua/.ssh/authorized_keys",
      "echo 's4tankoua ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/s4tankoua",
      "sudo chmod 0440 /etc/sudoers.d/s4tankoua",
      "sudo usermod -aG docker ${SSH_USERNAME}",
       # Grouping package installations
      "sudo apt-get install -y apt-utils postgresql-client python3 python3-pip git wget htop vim watch openssh-server unzip build-essential   openjdk-13-jdk openjdk-13-jre mysql-client-8.0 mysql-client software-properties-common ansible apt-transport-https ca-certificates  curl docker-ce docker-ce-cli containerd.io",
      # Docker Compose installation
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt update",
      # Maven Installation (Choose either direct download or package installation, not both)
      "sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose || { echo 'Failed to download Docker Compose'; exit 1; }",
      "sudo tar xzvf apache-maven-3.9.6-bin.tar.gz -C /opt || { echo 'Failed to extract Maven'; exit 1; }",
      ##"echo 'export PATH=/opt/apache-maven-3.9.6/bin:\$PATH' >> ~/.bashrc",
      "echo 'export PATH=/opt/apache-maven-3.9.6/bin:$PATH' >> ~/.bashrc",
      # Node.js installation
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - || { echo 'Failed to setup Node.js repository'; exit 1; }",
      "sudo apt-get install -y nodejs",
      # AWS CLI v2 installation
      "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" || { echo 'Failed to download AWS CLI v2';   exit 1; }",
      "unzip awscliv2.zip",
      "sudo ./aws/install || { echo 'AWS CLI v2 installation failed'; exit 1; }",
      # Additional setup commands here...
      "echo 'Provisioning complete!'"

    ]
  }
}

