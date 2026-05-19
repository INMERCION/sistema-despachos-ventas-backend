# Etapa 1: compilación del proyecto con Maven y JDK 17
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

COPY . .

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests

# Etapa 2: imagen final de ejecución
FROM eclipse-temurin:17-jre-alpine AS runner

# Se crea un usuario sin privilegios root por seguridad
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Se copia solamente el JAR generado desde la etapa de compilación
COPY --from=builder /app/target/*.jar app.jar

RUN chown appuser:appgroup app.jar

USER appuser

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]