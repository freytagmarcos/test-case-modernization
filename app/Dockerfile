FROM python:3.11-alpine

EXPOSE 5000

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN pip install opentelemetry-distro opentelemetry-exporter-otlp

COPY . .

# Define variáveis do OpenTelemetry
ENV OTEL_TRACES_EXPORTER=otlp
ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
ENV OTEL_SERVICE_NAME=user-app
ENV OTEL_EXPORTER_OTLP_PROTOCOL=grpc

# Roda com auto-instrumentação
ENTRYPOINT ["opentelemetry-instrument"]

CMD [ "python", "app.py" ]