#!/bin/bash
ConfFile=framework/entity/config/entityengine.xml
cd /ofbiz
ls  .git
if [ $? = 0 ] ; then
        echo "Git Repo"
       git checkout $ConfFile
       git checkout build.gradle
       git checkout framework/webapp/config/url.properties
else
       svn revert $ConfFile
       svn revert build.gradle
       svn revert framework/webapp/config/url.properties
fi
source /root/config.env
DB_TYPE=`echo "$DB_TYPE"`
DB_HOST=db-server

checkcontent=`grep -n "  runtimeOnly" build.gradle`
if [ $? = 0 ] ; then
        line=`grep -n "  runtimeOnly" build.gradle | cut -d : -f 1 | head -1`
        sed -i "$line"i" runtimeOnly 'mysql:mysql-connector-java:5.1.49'" build.gradle
        sed -i "$line"i" runtimeOnly 'org.postgresql:postgresql:42.2.5.jre7'" build.gradle
     else
          line=`grep -n "   runtime" build.gradle | cut -d : -f 1 | head -1`
          sed -i "$line"i" runtime 'mysql:mysql-connector-java:5.1.49'" build.gradle
          sed -i "$line"i" runtime 'org.postgresql:postgresql:42.2.5.jre7'" build.gradle
fi

if [ $DB_TYPE = mysql ]; then
#	sed -i "181i runtime 'mysql:mysql-connector-java:5.1.47'" build.gradle
	sed -i -e 's/ofbiz?autoReconnect=true/'$MYSQL_DATABASE'?autoReconnect=true/' $ConfFile
	sed -i -e 's/jdbc-username="ofbiz"/jdbc-username="'$MYSQL_USER'"/' $ConfFile
        sed -i -e 's/jdbc-password="ofbiz"/jdbc-password="'$MYSQL_PASSWORD'"/' $ConfFile
	sleep 10
	mysql -h db-server -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS ofbizolap; CREATE DATABASE IF NOT EXISTS ofbiztenant; grant all privileges on *.* to '$MYSQL_USER'@'%' identified by '$MYSQL_PASSWORD';"
fi
if [ $DB_TYPE = postgres ]; then
#	sed -i "181i runtime 'org.postgresql:postgresql:42.2.5.jre7'" build.gradle
        sed -i -e '482,491s/ofbiz/'$POSTGRES_DB'/' $ConfFile
	sed -i -e 's/jdbc-username="'ofbiz'"/jdbc-username="'$POSTGRES_USER'"/' $ConfFile
        sed -i -e 's/jdbc-password="'ofbiz'"/jdbc-password="'$POSTGRES_PASSWORD'"/' $ConfFile
	PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOST -U $POSTGRES_USER ofbizolap
        PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOST -U $POSTGRES_USER ofbiztenant
fi	
        sed -i -e '40,80s/localderby/'local$DB_TYPE'/g' $ConfFile
        sed -i -e '350,572s/127.0.0.1/'$DB_HOST'/g' $ConfFile

sed -i 's/force.https.host=/force.https.host='localhost'/g' framework/webapp/config/url.properties
sed -i 's/force.http.host=/force.http.host='localhost'/g' framework/webapp/config/url.properties


#DataLoad command
$DB_LOAD 2>&1

#To start OFBiz
$StartOFBiz 2>&1
