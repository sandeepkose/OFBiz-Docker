#!/bin/bash
ConfFile=framework/entity/config/entityengine.xml
cd /ofbiz
ls  .git
if [ $? = 0 ] ; then
        echo "Git Repo"
       git checkout $ConfFile
       git checkout build.gradle
else
       svn revert $ConfFile
       svn revert build.gradle
fi
source /root/config.env
DB_TYPE=`echo "$DB_TYPE"`
DB_HOST=db-server

if [ $DB_TYPE = mysql ]; then
	DB_USER=`echo "$MYSQL_USER"`
	DB_PASSWORD=`echo "$MYSQL_PASSWORD"`
	DB_NAME=`echo "$MYSQL_DATABASE"`      
	sed -i "181i runtime 'mysql:mysql-connector-java:5.1.47'" build.gradle
	sed -i -e '355,365s/ofbiz/'$DB_NAME'/' $ConfFile
	sed -i -e '350,668s/jdbc-username="'$DB_NAME'"/jdbc-username="'$DB_USER'"/' $ConfFile
        sed -i -e '350,370s/jdbc-password="'$DB_NAME'"/jdbc-password="'$DB_PASSWORD'"/' $ConfFile
	mysql -h db-server -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS ofbizolap; CREATE DATABASE IF NOT EXISTS ofbiztenant; grant all privileges on *.* to $DB_USER@'%' identified by '$DB_PASSWORD';"
fi
if [ $DB_TYPE = postgres ]; then
	DB_USER=`echo "$POSTGRES_USER"`
        DB_PASSWORD=`echo "$POSTGRES_PASSWORD"`
	DB_NAME=`echo "$POSTGRES_DB"`
	sed -i "181i runtime 'org.postgresql:postgresql:42.2.5.jre7'" build.gradle
        sed -i -e '482,491s/ofbiz/'$DB_NAME'/' $ConfFile
	sed -i -e '480,495s/jdbc-username="'$DB_NAME'"/jdbc-username="'$DB_USER'"/' $ConfFile
        sed -i -e '480,495s/jdbc-password="'$DB_NAME'"/jdbc-password="'$DB_PASSWORD'"/' $ConfFile
	PGPASSWORD=$DB_PASSWORD psql -h DB_HOST -U DB_USER ofbizolap
        PGPASSWORD=$DB_PASSWORD psql -h DB_HOST -U DB_USER ofbiztenant
fi	
        sed -i -e '40,80s/localderby/'local$DB_TYPE'/g' $ConfFile
        sed -i -e '350,572s/127.0.0.1/'$DB_HOST'/g' $ConfFile
	sed -i -e '480,495s/jdbc-username="'$DB_NAME'"/jdbc-username="'$DB_USER'"/' $ConfFile
        sed -i -e '480,495s/jdbc-password="'$DB_NAME'"/jdbc-password="'$DB_PASSWORD'"/' $ConfFile
	sed -i -e '355,572s/jdbc-username="ofbiz"/jdbc-username="'$DB_USER'"/' $ConfFile
        sed -i -e '355,572s/jdbc-password="ofbiz"/jdbc-password="'$DB_PASSWORD'"/' $ConfFile

#DataLoad command
$DB_LOAD 2>&1
#To start OFBiz
$StartOFBiz 2>&1
