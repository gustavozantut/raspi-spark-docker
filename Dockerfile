# Start from a base image with Java and Spark dependencies
FROM openjdk:17-jdk-bullseye

# Set environment variables
ENV SPARK_VERSION=3.5.3 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/spark

# Download and extract Spark
RUN apt-get update && \
    apt-get install -y wget python3-pip && \
    wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    mkdir -p /usr/share/java && \
    curl -o /usr/share/java/mssql-jdbc.jar https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/11.2.3.jre17/mssql-jdbc-11.2.3.jre17.jar

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt && rm requirements.txt

# Set Spark as the working directory
WORKDIR ${SPARK_HOME}

# Expose necessary Spark ports
EXPOSE 7077 8080

# Start the Spark master
CMD ["/bin/bash", "-c", "./sbin/start-master.sh && tail -f /dev/null"]