#!/bin/bash
set -e

# This function creates a user and a database
# Usage: create_user_and_db <user> <password> <database>
create_user_and_db() {
    local user=$1
    local password=$2
    local database=$3

    echo "  Creating user '$user' and database '$database'..."
    
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE USER $user WITH PASSWORD '$password';

        CREATE DATABASE $database OWNER $user;
EOSQL
}


create_user_and_db $MAS_POSTGRES_USER $MAS_POSTGRES_PASSWORD "mas"

create_user_and_db $SYNAPSE_POSTGRES_USER $SYNAPSE_POSTGRES_PASSWORD "synapse"
