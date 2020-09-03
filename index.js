exports.handler = async function (event, context, callback) {
    console.log("Received event: ", event);
    var data = { greetings: "Hello." };
    const timeout = 300 * 1000;
    await new Promise(resolve => setTimeout(resolve, timeout));
    data.greetings += ` Waited ${timeout}ms.`;
    return data;
};
