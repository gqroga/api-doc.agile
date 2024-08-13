FROM ubuntu:22.04 AS build

# Instalação de dependências
RUN apt-get update && apt-get install -y curl zip unzip

# Instalação do SDKMAN!
RUN curl -s "https://get.sdkman.io" | bash

# Definindo o shell para bash
SHELL ["/bin/bash", "-c"]

# Configuração do SDKMAN! e instalação do Java 21 e Maven
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install java 21.0.2-tem && \
    sdk install maven && \
    sdk use maven"

# Configurando o JAVA_HOME
ENV JAVA_HOME=/root/.sdkman/candidates/java/current
ENV PATH=$PATH:/root/.sdkman/candidates/maven/current/bin

# Copiando o código fonte e construindo o projeto com Maven
COPY . .
RUN mvn clean install

# Preparando o ambiente de produção
FROM openjdk:21-jdk-slim
EXPOSE 8080
ARG JAR_FILE=target/*.jar
COPY --from=build ${JAR_FILE} /app/app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
