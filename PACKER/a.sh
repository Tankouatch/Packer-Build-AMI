# curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
# apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# apt-get update && apt-get install packer
apt-get update
apt-get install -y wget unzip
wget https://releases.hashicorp.com/packer/1.10.1/packer_1.10.1_linux_amd64.zip

unzip packer_1.10.1_linux_amd64.zip

packer --version
rm packer_1.10.1_linux_amd64.zip
mv packer /usr/local/bin



#  AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
#  AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
#  AWS_DEFAULT_REGION="us-east-1"
#  export AWS_ACCESS_KEY_ID="AKIAZI2LE2Z6CLDSGQZ7"
#  export AWS_SECRET_ACCESS_KEY="j4lfVWjpnLvWMLdJQ4YiQZ35EGMnoMxQE/XGW6dI"
#  export AWS_DEFAULT_REGION="us-esat-1"