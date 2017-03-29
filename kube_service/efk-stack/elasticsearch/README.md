# Elasticsearch Cluster on Kubernetes
Elasticsearch Version 5.2.2

* `Master` nodes - intended for clustering management only, no data, no HTTP API
* `Client` nodes - intended for client usage, no data, with HTTP API
* `Data` nodes - intended for storing and indexing your data, no HTTP API

### Deploy 
```
kubectl create -f es-discovery-svc.yaml
kubectl create -f es-svc.yaml
kubectl create -f es-master-rc.yaml
```

Wait until `es-master` deployment is provisioned, and

```
kubectl create -f es-client-rc.yaml
kubectl create -f es-data-rc.yaml
```
```
root@Master1:~/EFK-cluster# kubectl get pods --namespace=efk-logging -o wide                                                                                                                                
NAME              READY     STATUS    RESTARTS   AGE       IP            NODE
es-client-hhm66   1/1       Running   0          3m        172.17.58.3   node2
es-data-tvhj2     1/1       Running   0          3m        172.17.58.4   node2
es-master-6qtj3   1/1       Running   0          4m        172.17.58.2   node2
```
```
root@Master1:~/EFK-cluster# curl 172.17.58.3:9200/_cluster/health?pretty
{
  "cluster_name" : "k8s-es",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```
```
[2017-03-20T05:40:17,942][INFO ][o.e.n.Node               ] [BCE6na1] started
[2017-03-20T05:40:18,039][INFO ][o.e.g.GatewayService     ] [BCE6na1] recovered [0] indices into cluster_state
[2017-03-20T05:41:00,553][INFO ][o.e.c.s.ClusterService   ] [BCE6na1] added {{nAe5lpR}{nAe5lpRiS1WgQhNe2cd8YQ}{3bP9ZP5aRG-Ndo0COLv22Q}{172.17.58.3}{172.17.58.3:9300},}, reason: zen-disco-node-join[{nAe5lpR}{nAe5lpRiS1WgQhNe2cd8YQ}{3bP9ZP5aRG-Ndo0COLv22Q}{172.17.58.3}{172.17.58.3:9300}]
[2017-03-20T05:41:27,223][INFO ][o.e.c.s.ClusterService   ] [BCE6na1] added {{nN-4Bt3}{nN-4Bt3pRxmk0RnIoMoPNA}{GNxZU5c2RQCqUkKemsM0wA}{172.17.58.4}{172.17.58.4:9300},}, reason: zen-disco-node-join[{nN-4Bt3}{nN-4Bt3pRxmk0RnIoMoPNA}{GNxZU5c2RQCqUkKemsM0wA}{172.17.58.4}{172.17.58.4:9300}]
```

### Scale
```
kubectl scale --replicas=2 rc es-master --namespace=efk-logging
kubectl scale --replicas=2 rc es-client --namespace=efk-logging
kubectl scale --replicas=2 rc es-data --namespace=efk-logging
```
```
root@Master1:~/EFK-cluster# kubectl get pods --namespace=efk-logging -o wide
NAME              READY     STATUS    RESTARTS   AGE       IP            NODE
es-client-fgzf9   1/1       Running   0          45s       172.17.11.2   node3
es-client-hhm66   1/1       Running   0          5m        172.17.58.3   node2
es-data-cwt5m     1/1       Running   0          32s       172.17.68.6   node1
es-data-tvhj2     1/1       Running   0          5m        172.17.58.4   node2
es-master-6qtj3   1/1       Running   0          6m        172.17.58.2   node2
es-master-jbhcc   1/1       Running   0          56s       172.17.68.4   node1
```
```
root@Master1:~/EFK-cluster# curl 172.17.58.3:9200/_cluster/health?pretty
{
  "cluster_name" : "k8s-es",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 6,
  "number_of_data_nodes" : 2,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```


