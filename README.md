## dev-tools-container-image

Container Image that includes Development Tools for various environment.

### Container Image
This project uses a Container Image that is based on following components.
- Debian Bookworm
- Python3
- Robot Framework
- Various Python Test Framework and Libraries
- NodeJS
    - npm
    - yarn
    - ng
- Java
    - Maven
    - Gradle
- Sonar Scanner CLI
- Crane CLI
- Browsers
    - Firefox
    - Chrome
    - MS Edge

### Building the docker image.
```bash
docker build -t dev-tools-container-image:latest .
```

[Intracting with GitLab CI Pipeline](./gitlab-ci/README.md)
