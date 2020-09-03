# aws-lambda-timeout-example
An example demonstrating that timeouts longer than 300s are not delivered to the node aws-sdk invoke api

## Create the lambda function

    $ ./create-function.sh

A new role with name "lambda-example-role" is created. A new Lambda function with name "example" is created. The code for the function is in `index.js`. The code waits for 500s and then returns a message. It is intended that the code never returns and instead the lambda timeout occurs.

## Invoke the function

This script updates the code and timeout (provided in the argument) and invokes the function:

    $ ./update-and-run-function.sh 300

## Expected result

After 300s, the lambda function's timeout should expire and a invoke will stop, with an error message in the file "output".

## Actual result

The function never returns. The cloudwatch logs show the function appears to timeout at 300s as expected, but the timeout is never delivered to the caller, and the client hangs waiting.

## Correct timeout for shorter periods

Updating the function timeout to 5s results in the invoke terminating with an error, as expected:

    $ ./update-ad-run-function.sh 5
