# raspi-spark-docker
Docker files to build a standalone spark cluster running on raspberries with docker
Just change the env SPARK_MASTER_URL value on worker's dockerfiles to the host_ip:port spark master is being served and be happy.

Example config to run pyspark driver outside the cluster:

```
conf = SparkConf().setMaster("spark://192.168.0.101:7077") #spark_master_ip:port
conf.set("spark.executor.memory", "6g")
conf.set("spark.driver.memory", "12g")
conf.set("spark.executor.cores", "3")
conf.set("spark.driver.cores", "6")
conf.set("spark.driver.bindAddress", "0.0.0.0") #spark driver internal ip(0.0.0.0 if running driver on docker)
conf.set('spark.driver.host',"192.168.0.209") #spark_driver_host_ip
conf.set("spark.driver.port", "33139") # default driver port, better explicit
conf.set("spark.driver.blockManager.port", "45029") # default block manager port, better explicit
```
