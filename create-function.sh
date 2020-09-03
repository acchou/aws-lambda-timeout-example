#!/bin/zsh

aws iam create-role --role-name lambda-example-role --assume-role-policy-document file://trust-policy.json
aws iam attach-role-policy --role-name lambda-example-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
zip function.zip index.js
ArnQuoted=$(aws iam get-role --role-name faast-cached-lambda-role --query Role.Arn)
Arn=$(echo $ArnQuoted | sed s/\"//g)
echo $Arn
aws lambda create-function --function-name example --timeout 300 --runtime nodejs12.x --role $Arn --handler index.handler --zip-file fileb://function.zip
