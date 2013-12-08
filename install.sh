#! /bin/bash -e

apt-get update
apt-get install -y openssh-server sshd supervisor vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat software-properties-common
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer oracle-java7-set-default

wget http://static.druid.io/artifacts/releases/druid-services-0.6.25-bin.tar.gz && \
  tar -zxf druid-services-*.gz && \
  mv druid-services-0.6.25 druid-services

wget http://mirrors.cnnic.cn/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz && \
  tar xzf zookeeper-*.tar.gz && \
  mv zookeeper-3.4.5 zookeeper && \
  cp zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg

# druid 0.6.25 currently only support kafka 0.7.2
wget http://archive.apache.org/dist/kafka/old_releases/kafka-0.7.2-incubating/kafka-0.7.2-incubating-src.tgz && \
  tar -xvzf kafka-*.tgz && \
  mv kafka-0.7.2-incubating-src kafka && \
  cd kafka && \
  ./sbt update && ./sbt package && cd ..


DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

DB_PASSWORD=password

if mysqladmin -u root password $DB_PASSWORD 2>&1; then
  echo "Intial db root password is set now."
else
  echo "Existing db. root password is not changed."
fi

cat <<EOF | mysql -u root --password=$DB_PASSWORD
create database if not exists druid default charset utf8 COLLATE utf8_general_ci;
CREATE USER 'druid'@'localhost' IDENTIFIED BY 'druid';
GRANT ALL PRIVILEGES ON druid.* TO 'druid'@'localhost';
FLUSH PRIVILEGES;
EOF
