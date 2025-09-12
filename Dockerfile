# Stage 1: Build with Maven
FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app

# Copy source code and pom.xml
COPY pom.xml .  
COPY src ./src  

# Build the application (creates target/app.jar)
RUN mvn clean package -DskipTests

# Stage 2: Lightweight runtime image
FROM openjdk:17  

WORKDIR /app  

# Copy built jar from the build stage
COPY --from=build /app/target/*.jar app.jar  

# Download OpenTelemetry agent during build
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar opentelemetry-javaagent.jar  

# Set environment variables (can also override at runtime)
ENV OTEL_SERVICE_NAME=api-tutorial  
ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://tempo:4317
ENV OTEL_METRICS_EXPORTER=none  

# Run the app with OpenTelemetry agent
ENTRYPOINT ["java", "-javaagent:opentelemetry-javaagent.jar", \
    "-Dotel.service.name=${OTEL_SERVICE_NAME}", \
    "-Dotel.exporter.otlp.endpoint=${OTEL_EXPORTER_OTLP_ENDPOINT}", \
    "-Dotel.metrics.exporter=${OTEL_METRICS_EXPORTER}", \
    "-jar", "app.jar"]
