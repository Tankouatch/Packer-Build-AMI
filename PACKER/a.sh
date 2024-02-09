# curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
# apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# apt-get update && apt-get install packer
# rm /usr/local/bin/packer
#  apt-get update
#  apt-get install -y wget unzip
# wget https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_linux_amd64.zip
# unzip packer_1.7.8_linux_amd64.zip 
# packer --version
# rm packer_1.7.8_linux_amd64.zip
#  mv packer /usr/local/bin



#  AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
#  AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
#  AWS_DEFAULT_REGION="us-east-1"
#   export AWS_ACCESS_KEY_ID="AKIAZI2LE2Z6CLDSGQZ7"
#   export AWS_SECRET_ACCESS_KEY="j4lfVWjpnLvWMLdJQ4YiQZ35EGMnoMxQE/XGW6dI"
#   export AWS_DEFAULT_REGION="us-esat-1"

# Define the version and plugin name for easier reference
VERSION="v1.3.0"
PLUGIN_NAME="packer-plugin-amazon"

# Create the directory structure
mkdir -p ~/.config/packer/plugins/github.com/hashicorp/amazon/

# Navigate to the directory
cd ~/.config/packer/plugins/github.com/hashicorp/amazon/

# Download the plugin
wget https://github.com/hashicorp/packer-plugin-amazon/releases/download/${VERSION}/${PLUGIN_NAME}_${VERSION}_x5.0_linux_amd64.zip

# Unzip the plugin
unzip ${PLUGIN_NAME}_${VERSION}_x5.0_linux_amd64.zip

# Remove the zip file
rm ${PLUGIN_NAME}_${VERSION}_x5.0_linux_amd64.zip

# Rename the plugin binary to match Packer's expected naming convention
mv ${PLUGIN_NAME} ${PLUGIN_NAME}_${VERSION}_x5.0_linux_amd64
