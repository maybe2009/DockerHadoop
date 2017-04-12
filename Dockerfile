FROM openjdk:8

MAINTAINER littleArtist

ENV HADOOP_VERSION 2.8.0
ENV HADOOP_HOME /usr/local/hadoop
WORKDIR /tmp

RUN set -x

#get hadoop
RUN curl --connect-timeout 10 \ 
    http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
    -o hadoop-$HADOOP_VERSION.tar.gz 
    
#verify signature
RUN curl --connect-timeout 20 \
    https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz.asc \
    -o hadoop-$HADOOP_VERSION.tar.gz.asc

RUN curl --connect-timeout 10  https://dist.apache.org/repos/dist/release/hadoop/common/KEYS -o KEYS

RUN gpg --import KEYS && gpg --verify hadoop-$HADOOP_VERSION.tar.gz.asc 

#extract
RUN set -x && tar -zxf hadoop-$HADOOP_VERSION.tar.gz -C /usr/local  && rm  hadoop-$HADOOP_VERSION.tar.gz

RUN cd /usr/local && ln -s /usr/local/hadoop-$HADOOP_VERSION hadoop

ENV DOCKER_HADOOP_SCRIPTS /data/container/hadoop-$HADOOP_VERSION/scripts

#ssh
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys 

#load scripts
RUN mkdir -p $DOCKER_HADOOP_SCRIPTS
ADD scripts $DOCKER_HADOOP_SCRIPTS
ENV PATH "${PATH}:$DOCKER_HADOOP_SCRIPTS"

WORKDIR $HADOOP_HOME

ENTRYPOINT ["start.sh"]




