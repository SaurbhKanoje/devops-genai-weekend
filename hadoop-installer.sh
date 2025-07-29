######Downloading CDH Parcels from Artifactory and extracting it
wget https://artifactory.global.standardchartered.com/artifactory/vendor-generic-staging-local/dataiku/cdh.tar.gz -P /datadir/dataiku/hadoop/

tar -xvf /datadir/dataiku/hadoop/cdh.tar.gz -C /datadir/dataiku/hadoop

echo "CDH Parcel downloaded from Artifactory"

echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
####Create soft link to CDH

ln -s /datadir/dataiku/hadoop/CDH-7.2.17-1.cdh7.2.17.p300.49883770 /datadir/dataiku/hadoop/CDH

echo "Soft link to CDH is created"

echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo ""

##Appending to bashrc file
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.412.b08-2.el8.x86_64/jre" >> /home/dssuser/.bashrc
echo "export ES_JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.412.b08-2.el8.x86_64/jre" >> /home/dssuser/.bashrc

echo "" >> /home/dssuser/.bashrc

echo "unset rc" >> /home/dssuser/.bashrc

echo "" >> /home/dssuser/.bashrc 

echo "export Dataiku_HOME=/datadir/dataiku" >> /home/dssuser/.bashrc
echo "export ES_JAVA_OPTS=\"-Xes4g -Xmg4g\" " >> /home/dssuser/.bashrc 
echo "export HADOOP_HOME=/datadir/dataiku/hadoop/CDH/lib/hadoop" >> /home/dssuser/.bashrc

echo "" >> /home/dssuser/.bashrc

echo "export HADOOP_HDFS_HOME=/datadir/dataiku/hadoop/CDH/lib/hadoop-hdfs" >> /home/dssuser/.bashrc
echo "export HADOOP_COMMON_HOME=/datadir/dataiku/hadoop/CDH/lib/hadoop" >> /home/dssuser/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=/datadir/dataiku/hadoop/CDH/lib/hadoop/lib/native" >> /home/dssuser/.bashrc
 
echo "export HADOOP_OPTS=\"-Djava.library.path=/datadir/dataiku/hadoop/CDH/lib/hadoop/lib/native\"" >> /home/dssuser/.bashrc
echo "export LD LIBRARY PATH=\"/datadir/dataiku/hadoop/CDH/lib/hadoop/lib/native/:LD LIBRARY PATH\"" >> /home/dssuser/.bashrc
echo "export HADOOP_MAPRED_HOME=\"/datadir/dataiku/hadoop/CDH/lib/hadoop-mapreduce\"" >> /home/dssuser/.bashrc
echo "export HADOOP_CLIENT_CONF_DIR=\"/datadir/dataiku/hadoop/CDH/etc/hadoop/conf\"" >> /home/dssuser/.bashrc 
echo "export HADOOP_CONF_DIR=\"/datadir/dataiku/hadoop/CDH/etc/hadoop/conf\"" >> /home/dssuser/.bashrc
echo "export HADOOP_YARN_HOME=\"/datadir/dataiku/hadoop/CDH/lib/hadoop-yarn\"" >> /home/dssuser/.bashrc
echo "export SPARX_HOME=\"/datadir/dataiku/hadoop/CDH/lib/spark/\"" >> /home/dssuser/.bashrc 

echo "" >> /home/dssuser/.bashrc

echo "alias yarn=\"/datadir/dataiku/hadoop/CDH/bin/yarn"\" >> /home/dssuser/.bashrc
echo "alias hdfs=\"/datadir/dataiku/hadoop/CDH/bin/hadoop"\" >> /home/dssuser/.bashrc
echo "alias spark3-submit=\"/datadir/dataiku/hadoop/CDH/bin/spark3-submit\"" >> /home/dssuser/.bashrc
echo "alias hive=\"/datadir/dataiku/hadoop/CDH/bin/hive\"" >> /home/dssuser/.bashrc
echo "alias beeline=\"/datadir/dataiku/hadoop/CDH/bin/beeline\"" >> /home/dssuser/.bashrc

echo "" >> /home/dssuser/.bashrc

#echo "export KRB5CCNAME=/tmp/krb5cc_1000" >> /home/dssuser/.bashrc

#echo "" >> /home/dssuser/.bashrc
 
echo "PATH=$PATH:/datadir/dataiku/hadoop/CDH/lib/oozie/bin" >> /home/dssuser/.bashrc 

echo "export PATH=$PATH:/datadir/dataiku/hadoop/CDH/lib/hadoop/bin/:/datadir/dataiku/hadoop/CDH/lib/hadoop/sbin" >> /home/dssuser/.bashrc


source /home/dssuser/.bashrc

echo "Entries added in bashrc file"
echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo ""

#copy conf file into CDH directories
##############create backup of existing conf files in CDH/etc/hadoop CDH/etc/hive , CDH/etc/spark etc

for file in /datadir/dataiku/hadoop/CDH/etc/hadoop/*
do
  mv $file $file.backup
done

for file in /datadir/dataiku/hadoop/CDH/etc/hive/*
do
  mv $file $file.backup
done

for file in /datadir/dataiku/hadoop/CDH/etc/spark/*
do
  mv $file $file.backup
done

for file in /datadir/dataiku/hadoop/CDH/etc/spark3/*
do
  mv $file $file.backup
done


cp -r /datadir/dataiku/hadoop/conf_file/hadoop/* /datadir/dataiku/hadoop/CDH/etc/hadoop/
cp -r /datadir/dataiku/hadoop/conf_file/hive/* /datadir/dataiku/hadoop/CDH/etc/hive/
cp -r /datadir/dataiku/hadoop/conf_file/spark/* /datadir/dataiku/hadoop/CDH/etc/spark/
cp -r /datadir/dataiku/hadoop/conf_file/spark3/* /datadir/dataiku/hadoop/CDH/etc/spark3/

echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo ""

#copy modified hadooo-env.sh to hadoop conf
mv /datadir/dataiku/hadoop/CDH/etc/hadoop/conf/hadoop-env.sh /datadir/dataiku/hadoop/hadoop-env.sh.backup
cp /datadir/dataiku/hadoop/hadoop-env.sh /datadir/dataiku/hadoop/CDH/etc/hadoop/conf


#copy hive.xml to spark
echo "Performing step 15"

cp /datadir/dataiku/hadoop/CDH/etc/hive/conf/hive-site.xml /datadir/dataiku/hadoop/CDH/etc/spark3/conf
cp /datadir/dataiku/hadoop/CDH/etc/hive/conf/hive-site.xml /datadir/dataiku/hadoop/CDH/lib/spark3/conf

echo "Modified hadoop-env.sh copied and hive.xml copied to spark"

echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo ""

#Creating kerberos ticket for dssuser

kinit -kt /datadir/dataiku/hadoop/tnd-haas1-dssuser.keytab dssuser@TND-HAAS.HK87-PA28.CLOUDERA.SITE

klist

echo "Keberos ticket generated for dssuser"

echo "--------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
