#!/bin/bash

set -ex
trap "echo FAILURE" ERR

name=docs-revamp-22
if ! docker inspect $name >/dev/null 2>&1; then
  docker build -t $name documentation/generator/build
fi

# Current path must have the following repos cloned:
# * core (used for changelog, examples)
# * nova (used for changelog)
# * enterprise (used for changelog)
# * masterfiles (used to document masterfies)
# * documentation (this repo)

# These env vars must be defined:
#true "${BRANCH?undefined}"
#true "${PACKAGE_JOB?undefined}"
#true "${PACKAGE_UPLOAD_DIRECTORY?undefined}"
#true "${PACKAGE_BUILD?undefined}"

#c=$(buildah from -v $PWD:/nt docs-revamp-22)
docker run -d -v $PWD:/nt --name $name $name
#trap "buildah run $c bash -c 'sudo chown -R root:root /nt; sudo chmod -R a+rwX /nt'; buildah rm $c >/dev/null" EXIT
docker exec -i $name bash -x documentation/generator/build/main.sh
#docker exec -i $name bash -x documentation/generator/build/main.sh $BRANCH $PACKAGE_JOB $PACKAGE_UPLOAD_DIRECTORY $PACKAGE_BUILD
docker exec -i $name bash -x documentation/generator/_scripts/_publish.sh
#docker exec -i $name bash -x documentation/generator/_scripts/_publish.sh $BRANCH
