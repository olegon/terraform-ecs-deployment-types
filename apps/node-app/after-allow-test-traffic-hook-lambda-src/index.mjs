import { CodeDeployClient, PutLifecycleEventHookExecutionStatusCommand } from '@aws-sdk/client-codedeploy';

const { AWS_REGION, TEST_APPLICATION_URL, PRODUCTION_APPLICATION_URL } = process.env;

const codedeploy = new CodeDeployClient({ region: AWS_REGION });

console.log('TEST_APPLICATION_URL = %s', TEST_APPLICATION_URL);
console.log('PRODUCTION_APPLICATION_URL = %s', PRODUCTION_APPLICATION_URL);

export const handler = async (event, context) => {
    console.log('event = %o', event);
    console.log('context = %o', context);

    await debugApplicationVersion(TEST_APPLICATION_URL);
    const isTestUrlOk = await isTestSuccessful(TEST_APPLICATION_URL);
    console.log('isTestUrlOk = %o', isTestUrlOk);

    await debugApplicationVersion(PRODUCTION_APPLICATION_URL);
    const isProductionUrlOk = await isTestSuccessful(PRODUCTION_APPLICATION_URL);
    console.log('isProductionUrlOk = %o', isProductionUrlOk);

    const putLifecycleEventHookExecutionStatusCommand = new PutLifecycleEventHookExecutionStatusCommand({
        deploymentId: event.DeploymentId,
        lifecycleEventHookExecutionId: event.LifecycleEventHookExecutionId,
        // "Pending" || "InProgress" || "Succeeded" || "Failed" || "Skipped" || "Unknown"
        status: isTestUrlOk ? 'Succeeded' : 'Failed'
    });

    console.log('putLifecycleEventHookExecutionStatusCommand = %o', putLifecycleEventHookExecutionStatusCommand);

    const putLifecycleEventHookExecutionStatusResponse = await codedeploy.send(putLifecycleEventHookExecutionStatusCommand);

    console.log('putLifecycleEventHookExecutionStatusResponse = %o', putLifecycleEventHookExecutionStatusResponse);
};

async function isTestSuccessful(applicationUrl) {
    try {
        console.log('applicationUrl = %s', applicationUrl);

        const testResponse = await fetch(applicationUrl);
        console.log('testResponse = %o', testResponse);

        if (testResponse.headers.get('content-length') != '0') {
            const testResponseBody = await testResponse.text();
            console.log('testResponseBody = %s', testResponseBody);
        }

        return testResponse.status === 200;
    } catch (error) {
        console.error('error = %o', error);

        return false;
    }
}

async function debugApplicationVersion(applicationUrl) {
    try {
        console.log('applicationUrl = %s', applicationUrl);

        const applicationVersionResponse = await fetch(`${applicationUrl}/v1/version`);
        console.log('applicationVersionResponse = %o', applicationVersionResponse);

        if (applicationVersionResponse.headers.get('content-length') != '0') {
            const applicationVersionResponseBody = await applicationVersionResponse.text();
            console.log('applicationVersionResponseBody = %s', applicationVersionResponseBody);
        }
    } catch (error) {
        console.error('error = %o', error);
    }
}