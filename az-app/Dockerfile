FROM python:alpine3.9
COPY . /az_task
WORKDIR /az_task
RUN pip install -r requirements.txt
EXPOSE 8888
ENTRYPOINT [ "python" ]
CMD [ "az.py" ]
