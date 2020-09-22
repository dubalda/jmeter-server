FROM openjdk:14.0.2-jdk-buster

ARG JMETER_VERSION=5.2.1

ENV JMETER_HOME /apache/jmeter/
ENV JMETER_BIN  ${JMETER_HOME}bin
ENV PATH        ${JMETER_HOME}/bin:$PATH

ENV JMETER_PLUGINS_MANAGER_VERSION 1.4
ENV CMDRUNNER_VERSION 2.2
ENV JSON_LIB_VERSION 2.4
ENV JSON_LIB_FULL_VERSION ${JSON_LIB_VERSION}-jdk15

ENV TZ="Europe/Moscow"

RUN mkdir /apache && \
    cd /apache && \
    wget --quiet https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz && \
    tar -xzf apache-jmeter-$JMETER_VERSION.tgz && \
    mv /apache/apache-jmeter-$JMETER_VERSION jmeter && \
    rm apache-jmeter-$JMETER_VERSION.tgz && \
    cd /tmp/ && \
    curl --location --silent --show-error --output ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar && \
    curl --location --silent --show-error --output ${JMETER_HOME}/lib/cmdrunner-${CMDRUNNER_VERSION}.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar && \
    curl --location --silent --show-error --output ${JMETER_HOME}/lib/json-lib-${JSON_LIB_FULL_VERSION}.jar https://search.maven.org/remotecontent?filepath=net/sf/json-lib/json-lib/${JSON_LIB_VERSION}/json-lib-${JSON_LIB_FULL_VERSION}.jar && \
    java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller && \
    PluginsManagerCMD.sh available && \
    PluginsManagerCMD.sh install \
      jpgc-json=2.7, \
      jpgc-graphs-basic=2.0 && \
    chmod +x ${JMETER_HOME}/bin/*.sh && \
    rm -fr /tmp/* && \
    PluginsManagerCMD.sh status && \
    jmeter --version && \
    ls -lh ${JMETER_HOME}lib/ext/

EXPOSE 1099

ENTRYPOINT ["/apache/jmeter/bin/jmeter-server"]
