## Intracting with GitLab CI Pipeline.
This repository also contains a `.gitlab-ci.yml` file for building the image using GitLab CI Pipeline.  
[.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/yaml/)

### Prerequisite.
Following variables in the CI environment must be available to build the Image and Push it to the specified repository.

#### Predefined environment variables.
These can be found at [GitLab Predefined Variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

- CI_REGISTRY
- CI_REGISTRY_IMAGE
- CI_COMMIT_BRANCH
- CI_COMMIT_SHORT_SHA
- CI_REGISTRY_USER
- CI_REGISTRY_PASSWORD
- CI_PROJECT_DIR

##### Additional variables.
This required to create a tag using GitLab CI.

- PROJECT_ACCESS_TOKEN

#### Custom environment varaibles.
These are specific to the needs, only required to push the image to some private container registry.

- PRIVATE_CONTAINER_REGISTRY  - `registry.mydomain.com`
- PRIVATE_CONTAINER_REGISTRY_IMAGE - `myproject/dev-tools-container-image`
- PRIVATE_CONTAINER_REGISTRY_USER - `YOUR_USERNAME`
- PRIVATE_CONTAINER_REGISTRY_PASSWORD - `YOUR_PASSWORD`
- RELEASE_VERSION_ID - `version_number`

The image that will be pushed to the private registry server will be like this - `registry.mydomain.com/myproject/dev-tools-container-image:version_number`
