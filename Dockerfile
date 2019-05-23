FROM openjdk:8-jdk-alpine

RUN apk add --no-cache bash openssl

ENV wd /workdir
ENV output ${wd}/output

WORKDIR ${wd}
RUN mkdir ${output}

COPY bin ${wd}
COPY etc ${wd}/etc

CMD ["./generate.sh"]
