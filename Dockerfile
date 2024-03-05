# Start from a base image with Java and Spark dependencies
FROM openjdk:8-jdk

# Set environment variables
ENV SPARK_VERSION=3.2.4
ENV HADOOP_VERSION=3.2

# Download and extract Spark
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark

RUN apt-get update && \
    apt-get install -y python3-pip

RUN pip install py4j

# Copy requirements.txt file
COPY requirements.txt requirements.txt

# Install Python dependencies including PySpark
RUN pip install -r requirements.txt

# Remove requirements.txt file
RUN rm requirements.txt

# Set the working directory
WORKDIR /spark

# Expose the necessary Spark ports
EXPOSE 7077 8080

# Start the Spark master
CMD ["/bin/bash", "-c", "./sbin/start-master.sh && tail -f /dev/null"]
