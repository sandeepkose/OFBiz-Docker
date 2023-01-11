# OFBiz-Docker
Deploy Apache OFBiz Using Docker on Ubuntu Machine.

Required softwares.
1. Docker-ce installed.
2. Docker-compose installed.
3. Git Installed.

Steps to  Created Docker of OFBiz.

Step 1. Clone This repo
# git clone https://github.com/sandeepkose/OFBiz-Docker.git

Step 2. Go to cloned directory.
# cd OFBiz-Docker

Step 3. Clone Apache OFBiz repo either by git repo or svn on any branch with named ofbiz in the same cloned (OFBiz-Docker) directory.
# git clone -b release18.12 https://github.com/apache/ofbiz-framework.git ofbiz

Step 4. Run compose-up.sh to build OFBiz docker images and deploy it either with Mysql or PostgreSql.

a) Deploy OFBiz with Mysql Database.
# ./compose-up.sh mysql
 
b) Deploy OFBiz with PostgreSQL Database.
# ./compose-up.sh postgres
Once compose-up.sh is executed secessfully it will take some time to build and deploy images.

Step 5. Access Apache OFBiz at https://localhost:8443/ and https://localhost:8443/webtools/control/main

Step 6. To stop and remove containers run
# ./compose-down.sh msyql/postgres
 

