# Etapa de build usando Maven
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Argumentos de build para configurar as dependências do Maven
ARG MAVEN_CLI_OPTS="-B -DskipTests"

# Copiar o arquivo de configuração do Maven e instalar as dependências
COPY pom.xml .
RUN mvn dependency:go-offline ${MAVEN_CLI_OPTS}

# Copiar o código-fonte e compilar a aplicação
COPY src ./src
RUN mvn clean package ${MAVEN_CLI_OPTS}

# Etapa final usando uma imagem mais leve do OpenJDK
FROM openjdk:17-jdk-slim
WORKDIR /app
ENV HOST=database

# Copiar o artefato da etapa de build para a imagem final
COPY --from=build /app/target/oceantech-0.0.1-SNAPSHOT.jar ./app.jar

# Comando de entrada para rodar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]

