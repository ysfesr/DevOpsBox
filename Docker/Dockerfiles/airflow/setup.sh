pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-no-providers-${PYTHON_VERSION}.txt"

pip install apache-airflow-providers-apache-spark

# initialize the database
airflow db init

airflow users create \
    --username admin \
    --firstname Ysf \
    --lastname ESR \
    --role Admin \
    --email esrysf@admin.com

# start the web server, default port is 8080
airflow webserver --port 8080 -D

# start scheduler
airflow scheduler