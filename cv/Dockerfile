FROM python:3.10

ENV GCP_SECRET_KEY ""
ENV GCP_PRIVATE_KEY_ID ""
ENV GCP_PROJECT_ID ""
ENV GCP_CLIENT_EMAIL ""
ENV GCP_CLIENT_ID ""
ENV GCP_CLIENT_CERT ""

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "./main.py"]



