FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/
EXPOSE 8888
CMD [ "java","-jar","Uber.jar" ]
