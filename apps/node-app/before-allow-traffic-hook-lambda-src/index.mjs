import { CodeDeployClient, PutLifecycleEventHookExecutionStatusCommand } from '@aws-sdk/client-codedeploy';

const { AWS_REGION } = process.env;

const codedeploy = new CodeDeployClient({ region: AWS_REGION });

export const handler = async (event, context) => {
    console.log('event = %s', JSON.stringify(event, null, 2));
    console.log('context = %s', JSON.stringify(context, null, 2));

    const putLifecycleEventHookExecutionStatusCommand = new PutLifecycleEventHookExecutionStatusCommand({
        deploymentId: event.DeploymentId,
        lifecycleEventHookExecutionId: event.LifecycleEventHookExecutionId,
        status: await isTestSuccessful() ? 'Succeeded' : 'Failed'
    });

    console.log('putLifecycleEventHookExecutionStatusCommand = %s', JSON.stringify(putLifecycleEventHookExecutionStatusCommand, null, 2));

    await codedeploy.send(putLifecycleEventHookExecutionStatusCommand)
};

async function isTestSuccessful() {
    try {
        const testResponse = await fetch('http://my-lb-ingress-1855827051.us-east-1.elb.amazonaws.com:8080/node-app');
        console.log('testResponse = %o', testResponse);

        return testResponse.status === 200;
    } catch (error) {
        console.error('error = %o', error);

        return false;
    }
}