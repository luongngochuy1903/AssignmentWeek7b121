# 1️⃣ Dùng JDK để compile source
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy source code
COPY src/main/java ./src
COPY src/main/webapp ./webapp

RUN mkdir -p webapp/WEB-INF/classes
RUN mkdir -p webapp/WEB-INF/lib

# ✅ PostgreSQL driver
ADD https://repo1.maven.org/maven2/org/postgresql/postgresql/42.6.0/postgresql-42.6.0.jar webapp/WEB-INF/lib/

# ✅ Servlet API
ADD https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar webapp/WEB-INF/lib/

# Compile Java
RUN javac -d webapp/WEB-INF/classes \
    -cp "webapp/WEB-INF/lib/postgresql-42.6.0.jar:webapp/WEB-INF/lib/javax.servlet-api-4.0.1.jar" \
    $(find src -name "*.java")

# 2️⃣ Tomcat 9 image
FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=builder /app/webapp /usr/local/tomcat/webapps/ROOT

EXPOSE 8080
CMD ["catalina.sh", "run"]