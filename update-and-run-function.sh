#!/bin/zsh

zip function.zip index.js
aws lambda update-function-code --function-name example --zip-file fileb://function.zip
aws lambda update-function-configuration --function-name example --timeout $1
aws lambda invoke --function-name example output --cli-read-timeout 0 --cli-connect-timeout 0
cat output
