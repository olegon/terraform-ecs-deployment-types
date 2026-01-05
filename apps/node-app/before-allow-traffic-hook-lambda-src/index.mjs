import { CodeDeployClient, PutLifecycleEventHookExecutionStatusCommand } from '@aws-sdk/client-codedeploy';

const { AWS_REGION, APPLICATION_URL } = process.env;

const codedeploy = new CodeDeployClient({ region: AWS_REGION });

console.log('APPLICATION_URL = %s', APPLICATION_URL);

export const handler = async (event, context) => {
    console.log('event = %o', event);
    console.log('context = %o', context);

    const putLifecycleEventHookExecutionStatusCommand = new PutLifecycleEventHookExecutionStatusCommand({
        deploymentId: event.DeploymentId,
        lifecycleEventHookExecutionId: event.LifecycleEventHookExecutionId,
        // "Pending" || "InProgress" || "Succeeded" || "Failed" || "Skipped" || "Unknown"
        status: await isTestSuccessful() ? 'Succeeded' : 'Failed'
    });

    console.log('putLifecycleEventHookExecutionStatusCommand = %o', putLifecycleEventHookExecutionStatusCommand);

    const putLifecycleEventHookExecutionStatusResponse = await codedeploy.send(putLifecycleEventHookExecutionStatusCommand);

    console.log('putLifecycleEventHookExecutionStatusResponse = %o', putLifecycleEventHookExecutionStatusResponse);
};

async function isTestSuccessful() {
    try {
        const testResponse = await fetch(APPLICATION_URL);
        console.log('testResponse = %o', testResponse);

        return testResponse.status === 200;
    } catch (error) {
        console.error('error = %o', error);

        return false;
    }
}