FROM s390x/openjdk:11-jre

ADD *.jar /app/app.jar
ADD app.sh /
RUN chmod 0755 /app.sh

CMD /app.sh
