See https://element-hq.github.io/synapse/latest/welcome_and_overview.html

# Scripts

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

