FROM openjdk:11.0.7-jdk

ARG TZ="Europe/Moscow"

ARG JMETER_VERSION=5.3

RUN apt-get update && \
    apt-get -qy install \
                wget \
                telnet \
                iputils-ping \
                unzip && \
    apt-get clean
    
RUN   mkdir /jmeter \
      && cd /jmeter/ \
      && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
      && tar -xzf apache-jmeter-$JMETER_VERSION.tgz \
      && rm apache-jmeter-$JMETER_VERSION.tgz

ENV JMETER_HOME /jmeter/apache-jmeter-$JMETER_VERSION/
ENV PATH $JMETER_HOME/bin:$PATH

EXPOSE 1099 50000

ENTRYPOINT $JMETER_HOME/bin/jmeter-server \
                        -Dserver.rmi.localport=50000 \
                        -Dserver_port=1099
