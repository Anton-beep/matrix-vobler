See https://element-hq.github.io/synapse/latest/welcome_and_overview.html

# Scripts

## General Guidance
To run scripts use
```shell
bash scripts/<script_name>.sh
```

They will not properly if you try to use them from script directory.

Consider running `ssh-copy-id` to copy your ssh key to the server for passwordless login.

## Ansible Vault Management
Secrets are stored in an Ansible Vault at `ansible/group_vars/main_server/vault.yml`. The vault password is stored in `ansible/.vault_pass`.

To edit the vault:
```shell
ANSIBLE_CONFIG=ansible.cfg ansible-vault edit group_vars/all/vault.yml
```

## Deploy
Run the playbook:
```shell
ANSIBLE_CONFIG=ansible.cfg ansible-playbook deploy_main_server.yml
```

(The old script `scripts/deploy/deployToMainServer.sh` has been deprecated).

## Start First Time or Update Public IP Server
```shell
bash scripts/deploy/deployToPublicIPServer.sh
```

