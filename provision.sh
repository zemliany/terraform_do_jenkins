#!/bin/bash -e

jenkins_infra_provision() {
echo "===== Start Init Terraform ====="
terraform init
echo "===== End Init Terraform ====="
echo "===== Start Apply Infrastructure ====="
TF_VAR_instance_count=$DROPLET_COUNT terraform apply -auto-approve
echo "===== End Apply Infrastructure ====="
echo "===== Start Provisioning ====="
TF_STATE=./terraform.tfstate $(which terraform-inventory) -inventory > do_env; ansible-playbook -u root '--inventory-file=do_env' -vvv -f5  ansible/playbooks/provision.yml; [ -e do_env ] && rm do_env;
echo "===== End Provisioning ====="
}

jenkins_infra_destroy() {
echo "===== Start Destroy Infrastructure ====="
TF_VAR_instance_count=$DROPLET_COUNT terraform destroy -auto-approve
echo "===== End Destroy Infrastructure ====="
}

jenkins_infra_state() {
if [ "$ADDITIONAL_PARAM" == "detail" ]; then
    terraform state show digitalocean_droplet.jenkins_droplets[$DROPLET_NUMBER]
else
    echo "Total: `terraform state list | awk 'END{print NR}'`"
    echo "List: 
`terraform state list`" 
fi
}

# The command line help #
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -p, --provision           Create and provision Jenkins infrastructure"
    echo "   -s, --update              State Jenkins Infrastructure|State Detail Mode"
    echo "   -s, --state[detail] [instance_number] State Infrastructure | Detail Mode + provide droplet number"
    echo "   -d, --destroy             Destroy All Jenkins Infrastructure"
    echo
    exit 1
}

while :; do
    case "$1" in
      -h | --help)
          display_help 
          exit 0
          ;;
      -p | --provision)
          DROPLET_COUNT=$2
          jenkins_infra_provision
           shift 2
           ;;
      -u | --update)
         STATE_COUNT=`terraform state list | awk 'END{print NR}'`
         if [ -z "$2" ] || ([[ $STATE_COUNT -eq "0" ]] && [[ $2 -gt 0  ]])  ;then
            echo "There are nothing to update"
          elif [ ! -z "$2" ] && [[ $2 -eq $STATE_COUNT ]]; then
                DROPLET_COUNT=$2
                jenkins_infra_provision
          elif [ ! -z "$2" ] && [[ "$2" -lt "$STATE_COUNT" ]]; then
            echo "You provide the value than less current instance count. This action will be destroyed a some droplets. Do you want to proceed?"
                read -p "Continue (y/n)?" choice
                case "$choice" in 
                y|Y ) DROPLET_COUNT=$2; jenkins_infra_provision;;
                n|N ) echo "Aborted!"; exit 1;;
                * ) echo "invalid";;
            esac
         else
            DROPLET_COUNT=$2
            jenkins_infra_provision
         fi 
           shift 2
           ;;
      -d | --destroy)
          DROPLET_COUNT=`terraform state list | awk 'END{print NR}'`
          jenkins_infra_destroy
           shift 2
           ;;
      -s | --state)
          ADDITIONAL_PARAM=$2
          DROPLET_NUMBER=$3
          jenkins_infra_state
           shift 2
           ;;
      --) echo "type --help for display reference"
          shift
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          exit 1 
          ;;
      *) 
          break  
          ;;
    esac
done

