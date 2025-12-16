import { CodeDeployClient, PutLifecycleEventHookExecutionStatusCommand } from '@aws-sdk/client-codedeploy';

const { AWS_REGION } = process.env;

const codedeploy = new CodeDeployClient({ region: AWS_REGION });

export const handler = async (event, context) => {
    console.log('event = %s', JSON.stringify(event, null, 2));
    console.log('context = %s', JSON.stringify(context, null, 2));

    /*
     Enter validation tests here.
    */

    const putLifecycleEventHookExecutionStatusCommand = new PutLifecycleEventHookExecutionStatusCommand({
        deploymentId: event.DeploymentId,
        lifecycleEventHookExecutionId: event.LifecycleEventHookExecutionId,
        status: 'Succeeded'
    });

    console.log('putLifecycleEventHookExecutionStatusCommand = %s', JSON.stringify(putLifecycleEventHookExecutionStatusCommand, null, 2));

    await codedeploy.send(putLifecycleEventHookExecutionStatusCommand)
};
