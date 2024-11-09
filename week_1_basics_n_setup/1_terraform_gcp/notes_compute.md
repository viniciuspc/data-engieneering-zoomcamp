## Generate new ssh key
cd ~/.ssh
ssh-keygen -t rsa -f gcp -C [USERNAME] -b 2048

## Connect to the instance
ssh -i .ssh/gcp wsl@34.38.233.80