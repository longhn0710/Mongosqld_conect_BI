# Mongosqld_conect_BI
from https://github.com/ianblenke/docker-mongosqld

edit .env file.

Then run cmd "make"

docker-mongosqld

This container encapsulates the MongoDB BI SQL daemon for the PowerBI connector.

The mongosqld simulates a MySQL server on 3307, and connects to a MongoDB on the backend.

It is possible to use a .drdl file to define a schema, or the schema will be auto-discovered at runtime by sampling the collections in the database to create a schema automatically.
