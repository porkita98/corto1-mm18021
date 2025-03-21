# Usamos una imagen base de JDK 17 con Maven
FROM eclipse-temurin:17-jdk AS build

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /corto

# Copiar los archivos del proyecto al contenedor
COPY . .

# Compilar el proyecto usando Maven Wrapper dentro del contenedor
RUN ./mvnw clean package -DskipTests

# Usamos una imagen más ligera de JDK para ejecutar la aplicación
FROM eclipse-temurin:17-jdk-jammy

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /corto

# Copiar el archivo .jar generado desde la fase de compilación
COPY --from=build /corto/target/*.jar app.jar

# Exponer el puerto en el que corre la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
