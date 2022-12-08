#!/bin/bash

openssl genrsa -out server.key 2048;
openssl req -new -key server.key -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=PrimeStyle/CN=localhost" -out server.csr;
openssl x509 -req -in server.csr -days 1800 -signkey server.key -out server.crt;