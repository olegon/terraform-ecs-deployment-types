{
  "version": 0.0,
  "Resources": [
    {
      "TargetService": {
        "Type": "AWS::ECS::Service",
        "Properties": {
          "TaskDefinition": "ARN_WILL_BE_FILLED_ON_CICD_PIPELINE",
          "LoadBalancerInfo": {
            "ContainerName": "$CONTAINER_NAME",
            "ContainerPort": "$CONTAINER_PORT"
          }
        }
      }
    }
  ],
  "Hooks": [
    {
      "BeforeAllowTraffic": [
        {
          "Name": "synthetic-test",
          "Type": "Lambda",
          "FunctionName": "$SYNTHETIC_TEST_LAMBDA_ARN"
        }
      ]
    }
  ]
}
