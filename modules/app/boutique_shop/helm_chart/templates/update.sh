#!/bin/bash

NEW_VERSION=$1

if [ -z "${NEW_VERSION}" ]; then
    echo "Provide a version of the microservices-demo to deploy."
    exit 1
fi

rm -rf ./microservices-demo
rm -f ./*.yaml
git clone git@github.com:GoogleCloudPlatform/microservices-demo.git
cp microservices-demo/kubernetes-manifests/*.yaml .

while read line; do
    sed -e 's@image: \(.*\)$@image: gcr.io/google-samples/microservices-demo/\1:'${NEW_VERSION}'@' ${line} > ${line}.new
    mv ${line}.new ${line}
done < <(ls ./*.yaml | grep -v redis.yaml)

rm -rf ./microservices-demo
