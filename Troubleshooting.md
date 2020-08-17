# Troubleshooting Test

* Check if resources are sufficient (disk, memory, inodes)

* Check if any Java process is launched

* Check if java is installed. Install if required:
```bash
sudo apt update
sudo apt install openjdk-8-jre
```

* Try to launch ZK manually:
```bash
sudo su - kafka
/usr/lib/kafka/bin/zookeeper-server-start.sh /etc/kafka_1001/config/zookeeper.properties
```

* Check if ZK accepts connections:
```bash
netstat -tulpn | grep 2181
echo ruok | nc 127.0.0.1 2181
```

* Check if there any issues with firewall or iptables:
```bash
sudo ufw status
sudo iptables-save


Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       tcp  --  anywhere             anywhere             tcp dpt:9092
DROP       tcp  --  anywhere             anywhere             tcp dpt:9096
DROP       tcp  --  anywhere             anywhere             tcp dpt:2181
```

* Make sure ZK port is allowed as well as all ports for Kafka brokers:
```bash
# default zk port
sudo iptables -D INPUT -p tcp -m tcp --dport 2181 -j DROP

# default kafka broker port
sudo iptables -D INPUT -p tcp -m tcp --dport 9092 -j DROP

# broker3 listener port
sudo iptables -D INPUT -p tcp -m tcp --dport 9096 -j DROP
```

* Double check ZK:
```bash
/usr/lib/kafka/bin/zookeeper-shell.sh 127.0.0.1:2181
```

* Launch Kafka brokers:
```bash
/usr/lib/kafka/bin/kafka-server-start.sh /etc/kafka_1001/config/server.properties
/usr/lib/kafka/bin/kafka-server-start.sh /etc/kafka_1002/config/server.properties
/usr/lib/kafka/bin/kafka-server-start.sh /etc/kafka_1003/config/server.properties
```

* Create Kafka topic:
```bash
/usr/lib/kafka/bin/kafka-topics.sh --list --bootstrap-server 127.0.0.1:9092

/usr/lib/kafka/bin/kafka-topics.sh --create --topic validate-kafka --replication-factor 3 --partitions 3 --bootstrap-server 127.0.0.1:9092

/usr/lib/kafka/bin/kafka-topics.sh --describe --topic validate-kafka --bootstrap-server 127.0.0.1:9092

Topic: validate-kafka	PartitionCount: 3	ReplicationFactor: 3	Configs: flush.ms=120000,segment.bytes=1073741824,flush.messages=20000,message.format.version=2.3-IV1,retention.bytes=10737418240
	Topic: validate-kafka	Partition: 0	Leader: 1002	Replicas: 1002,1003,1001	Isr: 1002,1003,1001
	Topic: validate-kafka	Partition: 1	Leader: 1003	Replicas: 1003,1001,1002	Isr: 1003,1001,1002
	Topic: validate-kafka	Partition: 2	Leader: 1001	Replicas: 1001,1002,1003	Isr: 1001,1002,1003
```

* Make sure all replicas are in-synch and that partition leaders are spread across the cluster.

* Try to write/read messages from the newly created topic:
```bash
/usr/lib/kafka/bin/kafka-console-producer.sh --topic validate-kafka --bootstrap-server 127.0.0.1:9092
>message01
>message02
>message03
>message04

/usr/lib/kafka/bin/kafka-console-consumer.sh --topic validate-kafka --from-beginning --bootstrap-server 127.0.0.1:9092
message02
message04
message01
message03
```
