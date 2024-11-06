## Install terraform
https://techcommunity.microsoft.com/blog/azuredevcommunityblog/configuring-terraform-on-windows-10-linux-sub-system/393845

wget https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_386.zip -O terraform.zip;
unzip terraform.zip;
sudo mv terraform /usr/local/bin;
rm terraform.zip;

## Export credetials path and use it in the provider (not necessary after the variables)
export GOOGLE_CREDENTIALS='/home/viniciuspc/git/data-engieneering-zoomcamp/week_1_basics_n_setup/1_terraform_gcp/keys/my-creds.json'

## Terraform commands
terraform fmt - Format .tf file
terraform init - Initiate terraform directory creating a lock.hcl file and install the providers
terrform plan - Show the plan that will be execute
terraform apply - will Show the plan and execute after asking if we want to perform the actions in the plan, will generate a file with extension .tfstate
terraform destroy - will delete the resouces created by the apply after asking for confirmation