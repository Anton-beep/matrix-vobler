See https://element-hq.github.io/synapse/latest/welcome_and_overview.html

```
scp -r docker-compose.yml .env nginx.conf files ant@192.168.1.120:/home/ant/1progr/vobler-matrix-deploy
```

# Scripts
To run scripts use
```shell
bash scripts/<script_name>.sh
```

They will not properly if you try to use them from script directory.

Consider running `ssh-copy-id` to copy your ssh key to the server for passwordless login.
