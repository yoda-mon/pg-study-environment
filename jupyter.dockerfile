FROM jupyter/datascience-notebook

USER root

RUN apt-get update && apt-get install -y \
  libpq-dev \
  vim

RUN pip install \
  altair \
  ipython-sql \
  psycopg2 \
  git+https://github.com/altair-viz/altair_pandas


USER jovyan