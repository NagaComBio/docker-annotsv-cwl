# docker-annotsv
Docker container with requirements to run [AnnotSV](https://lbgi.fr/AnnotSV/).

Forked from genome/docker-annotsv-cwl

## version 3.1

## docker2singularity build:

sudo docker build -t yussab:annotsv .

sudo singularity build annotsv_3.1.sif docker-daemon://yussab:annotsv
