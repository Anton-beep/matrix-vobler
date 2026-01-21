See https://element-hq.github.io/synapse/latest/welcome_and_overview.html

# Scripts
To run scripts use
```shell
bash scripts/<script_name>.sh
```

They will not properly if you try to use them from script directory.

Consider running `ssh-copy-id` to copy your ssh key to the server for passwordless login.

## Start First Time or Update Main Server
```shell
bash scripts/deploy/deployToMainServer.sh
```

## Start First Time or Update Public IP Server
```shell
bash scripts/deploy/deployToPublicIPServer.sh
```

