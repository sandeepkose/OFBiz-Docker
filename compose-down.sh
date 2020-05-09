#! /bin/bash

if [[ ! $1 ]]; then
  echo "Usage: ./compose-down.sh <mysql/postgres>"
  exit 1
fi

docker-compose -f docker-$1-compose.yml down
