echo "Limits addition - Dataiku"
sudo /bin/sh -c 'echo "dssuser soft nproc 90000" >> /etc/security/limits.d/90-nproc.conf'
sudo /bin/sh -c 'echo "dssuser hard nofile 90000" >> /etc/security/limits.d/90-nproc.conf'
sudo /bin/sh -c 'echo "dssuser soft nofile 90000" >> /etc/security/limits.d/90-nproc.conf'
sudo /bin/sh -c 'echo "dssuser soft nproc 90000" >> /etc/security/limits.conf'
sudo /bin/sh -c 'echo "dssuser hard nofile 90000" >> /etc/security/limits.conf'
sudo /bin/sh -c 'echo "dssuser soft nofile 90000" >> /etc/security/limits.conf'

echo "Limits addition - Dremio"
sudo /bin/sh -c 'echo "dremio soft nproc 90000" >> /etc/security/limits.d/90-nproc.conf'
sudo /bin/sh -c 'echo "dremio hard nofile 90000" >> /etc/security/limits.d/90-nproc.conf'
sudo /bin/sh -c 'echo "dremio soft nofile 90000" >> /etc/security/limits.d/90-nproc.conf'
sudo /bin/sh -c 'echo "dremio soft nproc 90000" >> /etc/security/limits.conf'
sudo /bin/sh -c 'echo "dremio hard nofile 90000" >> /etc/security/limits.conf'
sudo /bin/sh -c 'echo "dremio soft nofile 90000" >> /etc/security/limits.conf'

echo "Add repo entry for RHEL8 - ubi8.repo"
wget https://artifactory.global.standardchartered.com/artifactory/vendor-generic-staging-local/dataiku/ubi8.repo -P /etc/yum.repos.d/

echo "Install OS Level packages"
sudo yum install -y git
sudo yum install -y java-1.8.0-openjdk
sudo yum install -y libgfortran
sudo yum install -y ncurses-compat-libs
sudo yum install -y nginx
sudo yum install -y libXdamage
sudo yum install -y libXScrnSaver
sudo yum install -y libatk*
sudo yum install -y libgtk*
sudo yum install -y bzip2-devel.x86_64
sudo yum install -y libcurl-devel.x86_64
sudo yum install -y libcurl.x86_64
sudo yum install -y openssl-libs.x86_64
sudo yum install -y openssl-devel.x86_64
sudo yum install -y pcre2.x86_64
sudo yum install -y xz.x86_64
sudo yum install -y xz-devel.x86_64
sudo yum install -y zlib-devel.x86_64
sudo yum install -y gcc
sudo yum install -y gcc-c++.x86_64
sudo yum install -y gcc-gfortran.x86_64
sudo yum install -y libicu-devel.x86_64
sudo yum install -y libxml2-devel.x86_64
sudo yum install -y libgs.x86_64
sudo yum install -y python39
sudo yum install -y python39-devel
sudo yum install -y python311
sudo yum install -y python3.11-devel.x86_64
sudo yum install -y libffi-devel
sudo yum install -y libffi
sudo yum install -y pysqlite
sudo yum install -y sqlite2
sudo yum install -y sqlite2-devel.x86_64
sudo yum install -y sqlite3-dbf.x86_64
sudo yum install -y libsqlite3x.x86_64
sudo yum install -y libsqlite3x-devel.x86_64
sudo yum install -y npm
sudo yum install -y ncurses-compat-libs 
sudo yum install -y npm 
sudo yum install -y gtk3 
sudo yum install -y libXScrnSaver 
sudo yum install -y alsa-lib 
sudo yum install -y nss 
sudo yum install -y mesa-libgbm 
sudo yum install -y libX11-xcb
sudo yum install -y podman
sudo yum install -y docker


echo "Add the SE Linux Set enforce command"
sudo setenforce 0

echo "Download and extract Dataiku binary"
sudo -u dssuser mkdir -p /hadoopfs/fs1/dataiku/
sudo -u dssuser chmod -R 755 /hadoopfs/fs1/dataiku/
sudo -u dssuser wget https://artifactory.global.standardchartered.com/artifactory/vendor-generic-staging-local/dataiku/dataiku-dss-12.5.1.tar.gz -P /hadoopfs/fs1/dataiku/
sudo -u dssuser tar xf /hadoopfs/fs1/dataiku/dataiku-dss-12.5.1.tar.gz -C /hadoopfs/fs1/dataiku/

echo "Install Dataiku tool - Design node"
sudo -u dssuser /hadoopfs/fs1/dataiku/dataiku-dss-12.5.1/installer.sh -d /hadoopfs/fs1/dataiku/DATA_DESIGN_NODE -p 1999 -P python3.9 -n

echo "start Instance - Design node"
sudo -u dssuser /hadoopfs/fs1/dataiku/DATA_DESIGN_NODE/bin/dss start

echo "Dremio Installation commands"
sudo mkdir -p /hadoopfs/fs1/dremio/
sudo chmod -R 775 /hadoopfs/fs1/dremio/

sudo chown -R dremio /hadoopfs/fs1/dremio/
sudo chgrp -R dremio /hadoopfs/fs1/dremio/

sudo -u dremio wget https://artifactory.global.standardchartered.com/artifactory/vendor-generic-staging-local/dremio/dremio-enterprise-24.3.4-202403122102100613-8dd6ffd4.tar.gz -P /hadoopfs/fs1/dremio/

sudo -u dremio tar -xvf /hadoopfs/fs1/dremio/dremio-enterprise-24.3.4-202403122102100613-8dd6ffd4.tar.gz -C /hadoopfs/fs1/dremio/
sudo -u dremio mv /hadoopfs/fs1/dremio/dremio-enterprise-24.3.4-202403122102100613-8dd6ffd4 /hadoopfs/fs1/dremio/dremio-enterprise-24.3.4

sudo chmod -R 775 /hadoopfs/fs1/dremio

#Start dremio instance
sudo -u dremio /hadoopfs/fs1/dremio/dremio-enterprise-24.3.4/bin/./dremio start