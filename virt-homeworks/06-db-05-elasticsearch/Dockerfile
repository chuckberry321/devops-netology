FROM centos:latest 

ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-darwin-x86_64.tar.gz /
ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-darwin-x86_64.tar.gz.sha512 /

RUN yum update -y && \ 
    yum install -y perl-Digest-SHA && \
    yum install -y java-11-openjdk-devel && \
    shasum -a 512 -c elasticsearch-7.16.2-darwin-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.16.2-darwin-x86_64.tar.gz && \
    rm -rf elasticsearch-7.16.2-darwin-x86_64.tar.gz elasticsearch-7.16.2-darwin-x86_64.tar.gz.sha512 && \
    cd elasticsearch-7.16.2 && \ 
    groupadd elastic && \ 
    useradd -g elastic -p elastic elastic && \
    chown -R elastic:elastic /elasticsearch-7.16.2 && \ 
    chmod o+x /elasticsearch-7.16.2 && \
    mkdir -p /var/lib/elasticsearch/{data,logs} && \
    chown -R elastic:elastic /var/lib/elasticsearch && \
    mkdir -p /elasticsearch-7.16.2/snapshots && \
    chown -R elastic:elastic /elasticsearch-7.16.2/snapshots

USER elastic

ENV ES_JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH="$ES_JAVA_HOME/bin:${PATH}"  

RUN echo "node.name: netology_test" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \ 
    echo "path.data: /var/lib/elasticsearch/" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "network.host: 0.0.0.0" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "discovery.type: single-node" >> /elasticsearch-7.16.2/config/elasticsearch.yml && \
    echo "path.repo: /elasticsearch-7.16.2/snapshots" >> /elasticsearch-7.16.2/config/elasticsearch.yml  && \
    echo "xpack.ml.enabled: false" >> /elasticsearch-7.16.2/config/elasticsearch.yml

VOLUME /var/lib/elasticsearch/data
VOLUME /var/lib//elasticsearch/logs

EXPOSE 9200

CMD ["/elasticsearch-7.16.2/bin/elasticsearch"]
