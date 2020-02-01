# vim: syntax=yaml
#
# Add yum repository configuration to the system

bootcmd:
 - yum update -y
 - mkdir configuration
 
packages:
 - yum
 - wget
 - unzip

yum_repos:
    elasticsearch:
        baseurl: https://artifacts.elastic.co/packages/7.x/yum
        enabled: false
        failovermethod: priority
        gpgcheck: true
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
        name: elasticsearch repository for 7.x packages
        autorefresh: 1
        type: rpm-md  

write_files:
 - path: "configuration/elasticsearch.yml"
   permissions: "0774"
   owner: root
   content: |
      node.name: ${node_name}
      node.master: false
      node.data: false
      node.ingest: false
      http.port: 9200
      discovery.zen.hosts_provider: ec2
      discovery.ec2.groups: ${securitygroup_id}
      discovery.ec2.endpoint: ec2.${region}.amazonaws.com
      discovery.ec2.tag.Env: {env}
      discovery.ec2.host_type: private_ip
      cloud.node.auto_attributes: true
      cluster.routing.allocation.awareness.attributes: aws_availability_zone
      xpack.security.enabled: true
      xpack.security.transport.ssl.enabled: true
      xpack.security.transport.ssl.verification_mode: certificate
      xpack.security.transport.ssl.keystore.path: certs/${node_name}.p12
      xpack.security.transport.ssl.truststore.path: certs/${node_name}.p12
      xpack.security.http.ssl.enabled: true
      xpack.security.http.ssl.keystore.path: certs/${node_name}.p12 
      xpack.security.http.ssl.truststore.path: certs/${node_name}.p12  
 
runcmd:
 - yum install --enablerepo=elasticsearch elasticsearch -y
 - echo y | /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2
 - aws s3 cp s3://${certs_bucket_name}/certificate-bundle.zip .
 - unzip certificate-bundle.zip
 - mkdir /etc/elasticsearch/certs
 - cp ${node_name}/${node_name}.p12 /etc/elasticsearch/certs/
 - rm -rf /etc/elasticsearch/elasticsearch.yml
 - cp configuration/elasticsearch.yml /etc/elasticsearch/
 - chkconfig --add elasticsearch
 - systemctl daemon-reload
 - systemctl enable elasticsearch.service
 - systemctl start elasticsearch.service
 


