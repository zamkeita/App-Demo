FROM maven as build
WORKDIR /app
COPY . .

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/target/Uber
EXPOSE 9090
CMD [ "java","-jar","Uber.jar"]
