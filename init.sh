#!bin/bash

echo MAIN_HOST_IP=$(hostname -i | awk '{print $1}') >> .env
