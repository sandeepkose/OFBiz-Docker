#! /bin/bash
if [ ! -d ofbiz ]; then
  echo "OFBiz code directory name must be ofbiz in the current directory"
  exit 1
fi
if [[ ! $1 ]]; then
  echo "Usage: ./compose-up.sh <mysql/postgres>"
  exit 1
fi
sed -i -r 's/DB_TYPE=(mysql|postgres)/DB_TYPE='$1'/g' config.env 
docker-compose -f docker-$1-compose.yml up --build -d

