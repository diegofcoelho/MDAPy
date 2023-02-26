FROM rocker/r-ver:4.1.2
RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN apt-get install -y python3.8
RUN apt-get install -y python3-pip
RUN apt-get install -y libxt6
ENV RENV_VERSION 0.14.0
COPY ./src /app
WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
RUN R -e 'install.packages(c("remotes", "IsoplotR", "dplyr", "rjson", "openxlsx", "readxl", "renv"))'
RUN R -e 'renv::restore()'

# ENV PORT 8080
CMD exec gunicorn --bind :$PORT --log-level info --workers 1 --threads 8 --timeout 900 app:server
