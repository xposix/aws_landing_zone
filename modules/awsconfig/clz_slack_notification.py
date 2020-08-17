'''
Follow these steps to configure the webhook in Slack:

  1. Navigate to https://<your-team-domain>.slack.com/services/new

  2. Search for and select "Incoming WebHooks".

  3. Choose the default channel where messages will be sent and click "Add Incoming WebHooks Integration".

  4. Copy the webhook URL from the setup instructions and use it in the next section.

To encrypt your secrets use the following steps:

  1. Create or use an existing KMS Key - http://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html

  2. Click the "Enable Encryption Helpers" checkbox

  3. Paste <SLACK_CHANNEL> into the slackChannel environment variable

  Note: The Slack channel does not contain private info, so do NOT click encrypt

  4. Paste <SLACK_HOOK_URL> into the kmsEncryptedHookUrl environment variable and click encrypt

  Note: You must exclude the protocol from the URL (e.g. "hooks.slack.com/services/abc123").

  5. Give your function's role permission for the kms:Decrypt action.

     Example:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1443036478000",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "<your KMS key ARN>"
            ]
        }
    ]
}
'''

import boto3
import json
import logging
import os
import traceback

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError


# The base-64 encoded, encrypted key (CiphertextBlob) stored in the kmsEncryptedHookUrl environment variable
ENCRYPTED_HOOK_URL = os.environ['kmsEncryptedHookUrl']
# The Slack channel to send a message to stored in the slackChannel environment variable
SLACK_CHANNEL = os.environ['slackChannel']

HOOK_URL = boto3.client('kms').decrypt(CiphertextBlob=b64decode(ENCRYPTED_HOOK_URL))['Plaintext'].decode('utf-8')

ACCOUNT_ALIAS = boto3.client('iam').list_account_aliases(MaxItems=1)["AccountAliases"][0]

accountName = ACCOUNT_ALIAS.replace("mycompany-", "")

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    logger.info("Event: " + str(event))

    records = event["Records"]
    logger.info("Records: " + str(records))

    sendRequest = True

    for record in records:
        subject = str(record["Sns"]["Subject"])
        message = record["Sns"]["Message"]
        alertType = "unknown alert"
        accountID = "N/A"
        alertName = "N/A"
        awsRegion = "N/A"
        timestamp = "N/A"
        reason = "N/A"
        color = "#c71313" # Default RED

        try:
            if "AWS Config" in subject \
            and ("Configuration Snapshot Delivery" in subject \
            or "Configuration History Delivery" in subject):
                sendRequest = False

            elif "AWS Config" in subject and "AWS::Config::ResourceCompliance" in subject:
                message = json.loads(message)
                alertType = "AWS Config"
                accountID = str(message["configurationItem"]["awsAccountId"])

                alertName = ""
                for rule in message["configurationItem"]["configuration"]["configRuleList"]:
                    alertName = alertName + str(rule["configRuleName"])+"\n"

                awsRegion = str(message["configurationItem"]["awsRegion"])
                timestamp = str(message["configurationItem"]["configurationItemCaptureTime"])
                complianceType = str(message["configurationItem"]["configuration"]["complianceType"])
                reason = str(message["configurationItem"]["configuration"]["targetResourceId"]) + " is " + complianceType
                if complianceType == "COMPLIANT":
                    color = "#36a64f" # GREEN

            elif "AWS Config" in subject:
                alertType = "AWS Config"
                accountID = str(message["awsAccountId"])
                alertName = str(message["configRuleName"])
                awsRegion = str(message["awsRegion"])
                timestamp = str(message["newEvaluationResult"]["resultRecordedTime"])
                reason = str(message["newEvaluationResult"]["complianceType"])
                if reason == "COMPLIANT":
                    color = "#36a64f" # GREEN

            elif "ALARM" in subject:
                message = json.loads(message)
                alertType = "Cloudwatch ALARM"
                accountID = str(message["AWSAccountId"])
                alertName = str(message["AlarmName"])
                awsRegion = str(message["Region"])
                timestamp = str(message["StateChangeTime"])
                reason = str(message["NewStateReason"])

            elif "aws.ec2" in message:
                message = json.loads(message)
                alertType = "Cloudwatch EC2 Event"
                accountID = str(message["account"])
                alertName = str(message["detail-type"])
                awsRegion = str(message["region"])
                timestamp = str(message["time"])
                reason = "Instance "+str(message["detail"]["instance-id"])+" is in state " + str(message["detail"]["state"])
                color = "#c76913" # AMBER
                reason = str(message["NewStateReason"])

            elif "aws.autoscaling" in message:
                message = json.loads(message)
                alertType = "Cloudwatch Auto-scaling Event"
                accountID = str(message["account"])
                alertName = str(message["detail-type"])
                awsRegion = str(message["region"])
                timestamp = str(message["time"])
                reason = "AutoScalingGroup: "+str(message["detail"]["AutoScalingGroupName"])+" because " + str(message["detail"]["StatusMessage"])
                color = "#c76913" # AMBER

            else:
                subject = "Unknown event type, here is the JSON recieved: ```" + str(json.dumps(record, indent="\t")) + "```"

        except Exception:
            subject = "An exception occurred\n```"+traceback.format_exc()+"```\nhere is the JSON recieved: ```" + str(json.dumps(record, indent="\t")) + "```"
            logger.error("An exception occurred: \n" + traceback.format_exc())


        slack_message = {
            "channel": SLACK_CHANNEL,
            "text": "*AWS Alert - "+ accountName +" account - " + alertType + "*",
            "attachments": [
                {
                    "color": color,
                    "blocks": [
                		{
                			"type": "section",
                			"text": {
                				"type": "mrkdwn",
                				"text": subject
                			}
                		},
                		{
                			"type": "section",
                			"fields": [
                				{
                					"type": "mrkdwn",
                					"text": "*Alert Type:*\n" + alertType
                				},
                				{
                					"type": "mrkdwn",
                					"text": "*Account:*\n" + accountName + " (" + accountID + ")"
                				},
                				{
                					"type": "mrkdwn",
                					"text": "*Region:*\n" + awsRegion
                				},
                				{
                					"type": "mrkdwn",
                					"text": "*Triggered:*\n" + timestamp
                				},
                				{
                					"type": "mrkdwn",
                					"text": "*Rules:*\n" + alertName
                				},
                				{
                					"type": "mrkdwn",
                					"text": "*Reason:*\n" + reason
                				}
                			]
                		}
                    ]
                }
        	]
        }

        if sendRequest:
            req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
            try:
                response = urlopen(req)
                response.read()
                logger.info("Message posted to %s", slack_message['channel'])
            except HTTPError as e:
                logger.error("Request failed: %d %s", e.code, e.reason)
            except URLError as e:
                logger.error("Server connection failed: %s", e.reason)
