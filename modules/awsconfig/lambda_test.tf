# data "aws_lambda_invocation" "lambda_slack_test" {
#   function_name = aws_lambda_function.lambda_slack.function_name
#
#   input = <<JSON
# {
#   "Records": [
#     {
#       "Sns": {
#         "Type": "Notification",
#         "MessageId": "11fd05dd-47e1-5523-bc01-55b988bb9478",
#         "TopicArn": "arn:aws:sns:us-east-2:123456789012:config-topic-ohio",
#         "Subject": "[AWS Config:us-east-2] AWS::::Account 123456789012 is COMPLIANT with cloudtrail-enabled in Accoun...",
#         "Message": {
#           "awsAccountId": "123456789012",
#           "configRuleName": "cloudtrail-enabled",
#           "configRuleARN": "arn:aws:config:us-east-2:123456789012:config-rule/config-rule-9rpvxc",
#           "resourceType": "AWS::::Account",
#           "resourceId": "123456789012",
#           "awsRegion": "us-east-2",
#           "newEvaluationResult": {
#             "evaluationResultIdentifier": {
#               "evaluationResultQualifier": {
#                 "configRuleName": "cloudtrail-enabled",
#                 "resourceType": "AWS::::Account",
#                 "resourceId": "123456789012"
#               },
#               "orderingTimestamp": "2016-09-27T19:48:40.619Z"
#             },
#             "complianceType": "COMPLIANT",
#             "resultRecordedTime": "2016-09-27T19:48:41.405Z",
#             "configRuleInvokedTime": "2016-09-27T19:48:40.914Z",
#             "annotation": "",
#             "resultToken": ""
#           },
#           "oldEvaluationResult": {
#             "evaluationResultIdentifier": {
#               "evaluationResultQualifier": {
#                 "configRuleName": "cloudtrail-enabled",
#                 "resourceType": "AWS::::Account",
#                 "resourceId": "123456789012"
#               },
#               "orderingTimestamp": "2016-09-27T16:30:49.531Z"
#             },
#             "complianceType": "NON_COMPLIANT",
#             "resultRecordedTime": "2016-09-27T16:30:50.717Z",
#             "configRuleInvokedTime": "2016-09-27T16:30:50.105Z",
#             "annotation": "",
#             "resultToken": ""
#           },
#           "notificationCreationTime": "2016-09-27T19:48:42.620Z",
#           "messageType": "ComplianceChangeNotification",
#           "recordVersion": "1.0"
#         },
#         "Timestamp": "2016-09-27T19:48:42.749Z",
#         "SignatureVersion": "1",
#         "Signature": "XZ9FfLb2ywkW9yj0yBkNtIP5q7Cry6JtCEyUiHmG9gpOZi3seQ41udhtAqCZoiNiizAEi+6gcttHCRV1hNemzp/YmBmTfO6azYXt0FJDaEvd86k68VCS9aqRlBBjYlNo7Iik4Pqd5rE4BX2YBQSzcQyERGkUfTZ2BIFyAmb1Q/y4/6ez8rDyi545FDSlgcGEb4LKLNR6eDi4FbKtMGZHA7Nz8obqs1dHbgWYnp3c80mVLl7ohP4hilcxdywAgXrbsN32ekYr15gdHozx8YzyjfRSo3SjH0c5PGSXEAGNuC3mZrKJip+BIZ21ZtkcUtY5B3ImgRlUO7Yhn3L3c6rZxQ==",
#         "SigningCertURL": "https://sns.us-east-2.amazonaws.com/SimpleNotificationService-b95095beb82e8f6a046b3aafc7f4149a.pem",
#         "UnsubscribeURL": "https://sns.us-east-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-2:123456789012:config-topic-ohio:956fe658-0ce3-4fb3-b409-a45f22a3c3d4"
#       }
#     },
#     {
#       "Sns": {
#         "Type": "Notification",
#         "MessageId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
#         "TopicArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms",
#         "Subject": "ALARM: \"Example alarm name\" in EU - Ireland",
#         "Message": "{\"AlarmName\":\"Example alarm name\",\"AlarmDescription\":\"Example alarm description.\",\"AWSAccountId\":\"000000000000\",\"NewStateValue\":\"ALARM\",\"NewStateReason\":\"Threshold Crossed: 1 datapoint (10.0) was greater than or equal to the threshold (1.0).\",\"StateChangeTime\":\"2017-01-12T16:30:42.236+0000\",\"Region\":\"EU - Ireland\",\"OldStateValue\":\"OK\",\"Trigger\":{\"MetricName\":\"DeliveryErrors\",\"Namespace\":\"ExampleNamespace\",\"Statistic\":\"SUM\",\"Unit\":null,\"Dimensions\":[],\"Period\":300,\"EvaluationPeriods\":1,\"ComparisonOperator\":\"GreaterThanOrEqualToThreshold\",\"Threshold\":1.0}}",
#         "Timestamp": "2017-01-12T16:30:42.318Z",
#         "SignatureVersion": "1",
#         "Signature": "Cg==",
#         "SigningCertUrl": "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.pem",
#         "UnsubscribeUrl": "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
#         "MessageAttributes": {}
#       }
#     },
#     {
#       "Sns": {
#         "Type": "Notification",
#         "MessageId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
#         "TopicArn": "arn:aws:sns:eu-west-1:000000000000:cloudwatch-alarms",
#         "Subject": "",
#         "Message": "Test text message"
#       }
#     },
#     {
#       "EventSource": "aws:sns",
#       "EventVersion": "1.0",
#       "EventSubscriptionArn": "arn:aws:sns:eu-west-1:0123456789010:default_slack_notifications_topic:c53fc42e-233f-46b0-a28a-9092c01d9c90",
#       "Sns": {
#         "Type": "Notification",
#         "MessageId": "d3cb91c1-5739-52ed-bda4-c72fa15fffd6",
#         "TopicArn": "arn:aws:sns:eu-west-1:0123456789010:default_slack_notifications_topic",
#         "Subject": null,
#         "Message": "{\"version\":\"0\",\"id\":\"8e27c373-fbeb-7d71-69f9-250156f8e864\",\"detail-type\":\"EC2 Instance State-change Notification\",\"source\":\"aws.ec2\",\"account\":\"0123456789010\",\"time\":\"2020-03-20T16:49:42Z\",\"region\":\"eu-west-1\",\"resources\":[\"arn:aws:ec2:eu-west-1:0123456789010:instance/i-0b86d1f17d7e17163\"],\"detail\":{\"instance-id\":\"i-0b86d1f17d7e17163\",\"state\":\"pending\"}}",
#         "Timestamp": "2020-03-20T16:49:42.455Z",
#         "SignatureVersion": "1",
#         "Signature": "hJ/5kShbMFU+Ky2PlVoCwvhDDd4XRNb6oUI+Tizc1qKKYpXZfBYfIxLNHahwHUFwsnCBntM/5QRDfYzYPfYHiJ9QbDxr69gC1iXdCtpvW9chVX1TmFLtcazbtV+BkctlfDejsLxxGjS9zBNoVmIoIbM2E/WOOPo8qSxOWutoTcxvu9sqvaSlfLoeq4miz/vfOJ/hsRxygKbRHYrAealHXcJSQ1xSNgcSs/4070fzySMJt0DveEn4gc5qnecocXe81oQHTYEVnHE6qfwsabGkFm6fNSjZJoUK4av9DIGitBVPI0zUrgVZ8HSI2mFkXsCz9prE0doXDMocjQ1/WLa7PDKg==",
#         "SigningCertUrl": "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-a86cb10b4e1f29c941702d737128f7b8.pem",
#         "UnsubscribeUrl": "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:0123456789010:default_slack_notifications_topic:c53fc42e-233f-46b0-a28a-9092c01d9c90",
#         "MessageAttributes": {}
#       }
#     },
#     {
#       "EventSource": "aws:sns",
#       "EventVersion": "1.0",
#       "EventSubscriptionArn": "arn:aws:sns:eu-west-1:0123456789010:default_slack_notifications_topic:b534048c-24c6-43ca-8bdb-982895677715",
#       "Sns": {
#           "Type": "Notification",
#           "MessageId": "c72a3e32-42c8-5533-8933-68c0d84afa19",
#           "TopicArn": "arn:aws:sns:eu-west-1:0123456789010:default_slack_notifications_topic",
#           "Subject": null,
#           "Message": "{\"version\":\"0\",\"id\":\"500ae0ac-ca2b-7e58-8e6c-eba503456fd1\",\"detail-type\":\"Config Configuration Snapshot Delivery Status\",\"source\":\"aws.config\",\"account\":\"0123456789010\",\"time\":\"2020-03-23T11:06:35Z\",\"region\":\"eu-west-1\",\"resources\":[],\"detail\":{\"recordVersion\":\"1.1\",\"messageType\":\"ConfigurationSnapshotDeliveryCompleted\",\"s3ObjectKey\":\"v1/AWSLogs/0123456789010/Config/eu-west-1/2020/3/23/ConfigSnapshot/0123456789010_Config_eu-west-1_ConfigSnapshot_20200323T110635Z_13bcca7b-3ce1-41dc-adb4-044938286611.json.gz\",\"configSnapshotId\":\"13bcca7b-3ce1-41dc-adb4-044938286611\",\"s3Bucket\":\"awsconfig-master-global-org\",\"notificationCreationTime\":\"2020-03-23T11:06:35.491Z\"}}",
#           "Timestamp": "2020-03-23T11:06:42.531Z",
#           "SignatureVersion": "1",
#           "Signature": "OGAwvvsUtWmu893YnN1Uyho7GFYBlaOhe4yluFE5BjrHpieK4uVBtTcWyWdt2WYmIK+oA5/4CbXqsapohOYHhOlz1NMl6IGNTshJMD1pOv8J++QTZSxASAVexwxvG0tiCYM+rvCHllac7+5YiOibCvkmFue5/T/4q+L7F2EZsnk1H3NQEepgBt73FXNaI92+f6t056neX6lmp25PZDSGh2LgGWTUiBjj7GGhCvQVeCkjIpzpHP02YgPe2CQ+iCm+HwAOKUULGAC20JZvtJ+2ujad64Ael4GrmTWcgxA5aYQLwrkGQp7Esv6d5MXYhIO6qlHMMmYZuVOsZTlXcllrVQ==",
#           "SigningCertUrl": "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-a86cb10b4e1f29c941702d737128f7b8.pem",
#           "UnsubscribeUrl": "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:0123456789010:default_slack_notifications_topic:b534048c-24c6-43ca-8bdb-982895677715",
#           "MessageAttributes": {}
#       }
#     }
#   ]
# }
# JSON
#
#   depends_on = [
#     aws_lambda_function.lambda_slack
#   ]
# }
