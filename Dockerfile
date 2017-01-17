#
# Container to build private version of mesos-consul
# 
# Typical usage: 
#       docker run -it mesos-consul --zk=zk://leader.mesos:2181/mesos --consul --log-level=DEBUG --fw-whitelist=cassandra --fw-port-names=cassandra
#
# This can be much simpler if we could use the onbuild facility in the offical "golang" image.  It gets complicated because
# we're using a fork from the mnp repo, which I'm not sure they've accounted for. So this will brute force the src tree 
# structure and the build
#

FROM golang:alpine

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN set -x \
  && apk --no-cache add --repository https://dl-3.alpinelinux.org/alpine/edge/community git make \
  && mkdir -p /go/src/github.com/CiscoCloud \
  && cd /go/src/github.com/CiscoCloud \
  && git clone https://github.com/mnp/mesos-consul \
  && cd mesos-consul \ 
  && git checkout framework-names \
  && make \
  && mv bin/mesos-consul /go/bin 

ENTRYPOINT ["mesos-consul"]

