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

    $ ./update-and-run-function.sh 5

## Example output

An example with timeout 300s, which hangs:

```
~/Code/aws-lambda-timeout-example$ ./update-and-run-function.sh 300
updating: index.js (deflated 33%)
{
    "FunctionName": "example",
    "FunctionArn": "arn:aws:lambda:us-west-2:343675226624:function:example",
    "Runtime": "nodejs12.x",
    "Role": "arn:aws:iam::343675226624:role/faast-cached-lambda-role",
    "Handler": "index.handler",
    "CodeSize": 374,
    "Description": "",
    "Timeout": 30,
    "MemorySize": 128,
    "LastModified": "2020-09-03T19:09:10.864+0000",
    "CodeSha256": "q79EX1eyCCITdZzlJf5Tj+39vO4lDHCNlkJdnYvK1h8=",
    "Version": "$LATEST",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "RevisionId": "ebedae11-cc63-40dd-9fa0-eb90fae738e5",
    "State": "Active",
    "LastUpdateStatus": "Successful"
}
{
    "FunctionName": "example",
    "FunctionArn": "arn:aws:lambda:us-west-2:343675226624:function:example",
    "Runtime": "nodejs12.x",
    "Role": "arn:aws:iam::343675226624:role/faast-cached-lambda-role",
    "Handler": "index.handler",
    "CodeSize": 374,
    "Description": "",
    "Timeout": 300,
    "MemorySize": 128,
    "LastModified": "2020-09-03T19:09:11.657+0000",
    "CodeSha256": "q79EX1eyCCITdZzlJf5Tj+39vO4lDHCNlkJdnYvK1h8=",
    "Version": "$LATEST",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "RevisionId": "40d57c3c-8dbc-4f64-9568-64e8f21a95f9",
    "State": "Active",
    "LastUpdateStatus": "Successful"
}
```


Corresponding cloudwatch logs for the above:

```
2020-09-03T12:09:12.906-07:00	START RequestId: 68705fd7-fe3e-484f-a7e5-6b11f02470c1 Version: $LATEST
2020-09-03T12:09:12.927-07:00	2020-09-03T19:09:12.908Z 68705fd7-fe3e-484f-a7e5-6b11f02470c1 INFO Received event: {}
2020-09-03T12:14:12.941-07:00	END RequestId: 68705fd7-fe3e-484f-a7e5-6b11f02470c1
2020-09-03T12:14:12.941-07:00	REPORT RequestId: 68705fd7-fe3e-484f-a7e5-6b11f02470c1 Duration: 300029.52 ms Billed Duration: 300000 ms Memory Size: 128 MB Max Memory Used: 66 MB Init Duration: 134.58 ms
2020-09-03T12:14:12.941-07:00	2020-09-03T19:14:12.940Z 68705fd7-fe3e-484f-a7e5-6b11f02470c1 Task timed out after 300.03 seconds
```

