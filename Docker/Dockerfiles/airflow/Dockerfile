FROM python:3

ENV AIRFLOW_VERSION=2.3.0 PYTHON_VERSION=3.9

RUN pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-no-providers-${PYTHON_VERSION}.txt"

EXPOSE 8080

#  docker build -t airflow:2.2.3 .
#  docker run --name airflow -dp 8080:8080 -v ./airflow:/root/airflow/ airflow-min