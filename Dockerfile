FROM debian:12.2

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_ID=1000
ENV USER_NAME=devuser

# Perform an update.
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get clean all

# Install common utilities and tools.
RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests \
	bash curl wget tar zip bzip2 xz-utils \
	unzip make ca-certificates gnupg \
	git git-core openssh-client vim && \
	apt-get autoremove -y && apt-get clean all

# Install GO.
ENV GO_LANG_VERSION=1.21.3
ENV PATH=/usr/local/go/bin:${PATH}
ENV GOPATH=/home/${USER_NAME}/go
RUN wget https://go.dev/dl/go${GO_LANG_VERSION}.linux-amd64.tar.gz && \
	tar -zxf go${GO_LANG_VERSION}.linux-amd64.tar.gz -C /usr/local/ && \
	rm -f go${GO_LANG_VERSION}.linux-amd64.tar.gz

# Install Python.
RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests \
	python3 python3-pip python3-full python3-all-dev python3-gevent \
	libnss3 libnspr4 libglib2.0-0 libdbus-1-dev xdg-utils libgbm1 \
	libasound2 fonts-liberation xvfb fonts-liberation && \
	apt-get autoremove -y && apt-get clean all && \
	cd /usr/bin && \
	ln -sf python3 python && \
	ln -sf python3-config python-config

# Install Python libraries.
ADD requirements.txt /tmp/
RUN pip install --break-system-packages -r /tmp/requirements.txt && \
	rm -f /tmp/requirements.txt

# Install nodejs LTS version.
RUN mkdir -p /etc/apt/keyrings && \
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
	    gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | \
	    tee /etc/apt/sources.list.d/nodesource.list && \
	apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests nodejs && \
	apt-get autoremove -y && apt-get clean all && \
	corepack enable

# Install angular framework.
RUN npm install -g @angular/cli && \
	yarn global add @angular/cli

# Install Java.
RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests \
	openjdk-17-jdk && \
	apt-get clean all

# Install Maven.
ENV MVN_VERSION="3.9.5"
RUN mkdir -p /opt/maven  && \
	wget https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz && \
	tar -xf apache-maven-${MVN_VERSION}-bin.tar.gz -C /opt/maven && \
	ln -sf /opt/maven/apache-maven-${MVN_VERSION}/bin/mvn /usr/bin/mvn && \
	rm -f apache-maven-${MVN_VERSION}-bin.tar.gz

# Install gradle.
ENV GRADLE_VERSION="8.4"
RUN mkdir -p /opt/gradle && \
	wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
	unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt/gradle && \
	ln -sf /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle && \
	rm -f gradle-${GRADLE_VERSION}-bin.zip

# Install Sonar Scanner CLI.
ENV SONAR_SCANNER_CLI_VERSION="5.0.1.3006"
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_CLI_VERSION}-linux.zip && \
	unzip sonar-scanner-cli-${SONAR_SCANNER_CLI_VERSION}-linux.zip -d /opt/sonar-scanner-cli && \
	ln -sf /opt/sonar-scanner-cli/sonar-scanner-${SONAR_SCANNER_CLI_VERSION}-linux/bin/sonar-scanner /usr/bin/sonar-scanner && \
	rm -f sonar-scanner-cli-${SONAR_SCANNER_CLI_VERSION}-linux.zip

# Install Crane CLI.
ENV CRANE_CLI_VERSION="0.16.1"
RUN wget https://github.com/google/go-containerregistry/releases/download/v${CRANE_CLI_VERSION}/go-containerregistry_Linux_x86_64.tar.gz && \
	mkdir -p /tmp/crane && tar -xf go-containerregistry_Linux_x86_64.tar.gz -C /tmp/crane && \
	mv /tmp/crane/crane /usr/bin/crane && \
	rm -rf /tmp/crane

# Install various Browsers and its Drivers for perfroming headless tests.
# Install Chrome Browser..
ENV CHROME_VERSION="119.0.6045.105"
RUN apt-get update && \
	wget http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb && \
	apt-get install -y --no-install-recommends --no-install-suggests -f ./google-chrome-stable_${CHROME_VERSION}-1_amd64.deb && \
	rm -f google-chrome-stable_${CHROME_VERSION}-1_amd64.deb && apt-get autoremove -y && apt-get clean all

# Install chromedriver.
RUN wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_VERSION}/linux64/chromedriver-linux64.zip && \
	unzip chromedriver-linux64.zip && \
	mv chromedriver-linux64/chromedriver /usr/bin && \
	rm -rf chromedriver-linux64*

# Install firefox.
RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests firefox-esr && \
	apt-get autoremove -y && apt-get clean all

# Install geckodriver.
ENV GECHO_DRIVER_VERSION="0.33.0"
RUN wget https://github.com/mozilla/geckodriver/releases/download/v${GECHO_DRIVER_VERSION}/geckodriver-v${GECHO_DRIVER_VERSION}-linux64.tar.gz && \
	tar -xf geckodriver-v${GECHO_DRIVER_VERSION}-linux64.tar.gz -C /usr/bin/ && \
	rm -f geckodriver-v${GECHO_DRIVER_VERSION}-linux64.tar.gz

# Install MS Edge.
ENV EDGE_VERSION="118.0.2088.76"
RUN wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_${EDGE_VERSION}-1_amd64.deb && \
	apt-get install -y --no-install-recommends --no-install-suggests -f ./microsoft-edge-stable_${EDGE_VERSION}-1_amd64.deb  && \
	rm -f microsoft-edge-stable_${EDGE_VERSION}-1_amd64.deb && \
	apt-get autoremove -y && apt-get clean all

# Install MS Edge Driver.
RUN wget https://msedgedriver.azureedge.net/${EDGE_VERSION}/edgedriver_linux64.zip && \
	unzip edgedriver_linux64.zip -d /usr/bin/ && \
	rm -f edgedriver_linux64.zip

# Create default user.
RUN addgroup --gid ${USER_ID} ${USER_NAME} && \
	adduser --disabled-password --gecos "" \
	    --uid ${USER_ID} --gid ${USER_ID} ${USER_NAME}

# Set default user.
ENV HOME /home/devuser
WORKDIR /home/devuser
USER devuser

# Update PATH.
ENV PATH=${PATH}:~/.local/bin/

# Print components versions.
RUN echo "\n-------- All Components Version --------\n" && \
	echo "`dpkg-query --showformat='${Package} - ${Version}\n' --show \
	python3 \
	nodejs \
	openjdk-17-jdk \
	google-chrome-stable \
	firefox-esr \
	microsoft-edge-stable`\n" && \
	echo "GO Version - `go version`\n" && \
	echo "NPM Version - `npm --version`\n" && \
	echo "Yarn Version - `yarn --version`\n" && \
	echo "Maven Version - `mvn --version`\n" && \
	echo "Gradle Version - `gradle --version`\n" && \
	echo "Sonar Scanner CLI Version - `sonar-scanner --version`\n" && \
	echo "Crane CLI Version - `crane version`\n" && \
	echo "-------- All Components Version --------\n"

CMD /bin/bash
