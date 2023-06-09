#!/bin/bash

cat <<EOF > config.yaml
## This is a example configuration file for mongosqld.

## The full documentation is available at:
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#configuration-file

## Network options - configure how mongosqld should accept connections.
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#network-options
net:
  bindIp: "0.0.0.0" # To bind to multiple IP addresses, enter a list of comma separated values.
  port: 3307
  # unixDomainSocket:
  #   enabled: false
  #   pathPrefix: "/var"
  #   filePermissions: "0600"
  # ssl:
  #   mode: "disabled"
  #   allowInvalidCertificates: false
  #   PEMKeyFile: <string>
  #   PEMKeyPassword: <string>
  #   CAFile: <string>
  #   minimumTLSVersion: TLS1_1

## MongoDB options - configure how mongosqld should connect to your MongoDB cluster.
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#mongodb-host-options
mongodb:
  # versionCompatibility: <string>
  net:
    # https://docs.mongodb.com/manual/reference/connection-string/#mongodb-uri
    uri: "${MONGODB_URL:-mongodb://192.168.1.5:27017}"
    #uri: "mongodb://192.168.1.5:27017"
    # ssl:
    #   enabled: false
    ## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#mongodb-tls-ssl-options
    #   allowInvalidCertificates: false
    #   allowInvalidHostnames: false
    #   PEMKeyFile: <string>
    #   PEMKeyPassword: <string>
    #   CAFile: <string>
    #   CRLFile: <string>
    #   FIPSMode: false
    #   minimumTLSVersion: TLSv1_1
    auth:
      username: "${USERNAME:-root}"
      password: "${PASSWORD:-example}"
      #username: root
      #password: example
    #   source: <string> # This is the name of the database to authenticate against.
    #   mechanism: SCRAM-SHA-1
    #   gssapiServiceName: mongodb

# Security options - configure mongosqld's authentication (disabled by default).
## Enable security options if your MongoDB cluster requires authentication.
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#security-options
security:
  enabled: true
  # defaultMechanism: "SCRAM-SHA-1"
  # defaultSource: "admin"
  # gssapi:
  #   hostname: <string>
  #   serviceName: "mongosql"

## Logging options
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#logging-options
systemLog:
  ## The path to the file where log output will be written to.
  ## Defaults to stderr.
  # path: <string>
  quiet: ${MONGODB_SYSTEMLOG_QUIET:-false}
  ## 0|1|2 - Verbosity of the log output, this is overridden if 'quiet' is true.
  verbosity: ${MONGODB_SYSTEMLOG_VERBOSITY:-1}
  # logAppend: false
  # logRotate: "rename"|"reopen"
  #logRotate: "${MONGODB_SYSTEMLOG_LOGROTATE:-rename}"

## Schema options
## These configuration options define how the mongosqld should sample your MongoDB
## data so that it can be used by the relational application.
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#data-sampling-options
schema:
  ## If you've generated a DRDL schema file using mongodrdl, you can supply the
  ## path for mongosqld to use that schema DRDL file.
  # path: <string>
  # maxVarcharLength: <integer>
  ## Use the 'refreshIntervalSecs' option to specify an interval in seconds for
  ## mongosqld to update its schema, either by resampling or by re-reading from
  ## the schema source. The default value for this option is 0, which means that
  ## mongosqld does not automatically refresh the schema after it is
  ## initialized.
  refreshIntervalSecs: 0
  stored:
    mode: "auto" # "auto"|"custom"
    source: "mongosqld_data" # the database where schemas are stored in stored-schema modes
    name: "dpmSchema" # the named schema to read/write to in stored-schema modes
  sample:
    size: 1000 # The amount of random documents we sample from each collection.
    namespaces: ["*.*"]
    # prejoin: false
    # uuidSubtype3Encoding: "old" # <[old|csharp|java]>

## Process management options
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#process-management-options
processManagement:
  service:
    name: "mongosql"
    displayName: "MongoSQL Service"
    description: "MongoSQL accesses MongoDB data with SQL"

## Runtime options
## https://docs.mongodb.com/bi-connector/master/reference/mongosqld/#runtime-options
# runtime:
#   memory:
#     ## A value of '0' indicates there is no enforced maximum.
#     maxPerStage: 0
#     maxPerServer: 0
#     maxPerConnection: 0
EOF

#/usr/local/bin/mongosqld --config config.yaml
source /.env

if [ -z "$USERNAME" ]; then
  # USERNAME NULL
  /usr/local/bin/mongosqld --auth --mongo-uri "${MONGODB_URL:-mongodb://192.168.1.5:27017}" --addr --addr "${CLIENT:-0.0.0.0:3307}"
  
else
#USERNAME Not Null
 /usr/local/bin/mongosqld --auth --mongo-uri "${MONGODB_URL:-mongodb://192.168.1.5:27017}" -u "${USERNAME:-root}" -p "${PASSWORD:-example}" --addr "${CLIENT:-0.0.0.0:3307}"
fi

