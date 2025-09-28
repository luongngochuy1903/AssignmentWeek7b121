# 1️⃣ Dùng JDK để compile source
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy source code
COPY src/main/java ./src
COPY src/main/webapp ./webapp

# Tạo thư mục chứa class và lib
RUN mkdir -p webapp/WEB-INF/classes
RUN mkdir -p webapp/WEB-INF/lib

# ✅ Thêm MySQL driver
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar webapp/WEB-INF/lib/

# ✅ Thêm servlet-api.jar (Tomcat 9 dùng javax)
ADD https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar webapp/WEB-INF/lib/

# ✅ Compile Java (với classpath gồm 2 JAR)
RUN javac -d webapp/WEB-INF/classes \
    -cp "webapp/WEB-INF/lib/mysql-connector-j-8.4.0.jar:webapp/WEB-INF/lib/javax.servlet-api-4.0.1.jar" \
    $(find src -name "*.java")

# 2️⃣ Image chạy Tomcat 9
FROM tomcat:9.0-jdk17-temurin

# Xóa webapp mặc định
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy webapp đã build vào ROOT
COPY --from=builder /app/webapp /usr/local/tomcat/webapps/ROOT

EXPOSE 8080
CMD ["catalina.sh", "run"]
