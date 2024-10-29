# Start from a base image with Java and Spark dependencies
FROM openjdk:8-jdk

# Set environment variables
ENV SPARK_VERSION=3.2.4 \
    HADOOP_VERSION=3.2 \
    SPARK_HOME=/spark

# Download and extract Spark
RUN apt-get update && \
    apt-get install -y wget python3-pip && \
    wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    mkdir -p /usr/share/java && \
    curl -o /usr/share/java/mssql-jdbc.jar https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/9.4.0.jre8/mssql-jdbc-9.4.0.jre8.jar

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt && rm requirements.txt

# Set Spark as the working directory
WORKDIR ${SPARK_HOME}

# Expose necessary Spark ports
EXPOSE 7077 8080

# Start Spark master
CMD ["./sbin/start-master.sh", "-h", "0.0.0.0"]
