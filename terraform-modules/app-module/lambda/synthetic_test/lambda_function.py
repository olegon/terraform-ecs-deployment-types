import json
import os
import urllib.request

ALB_DNS = os.environ.get("ALB_DNS")
ALB_PORT = os.environ.get("ALB_PORT", "8080")
PATH = os.environ.get("SYNTHETIC_PATH", "/")


def lambda_handler(event, context):
    if not ALB_DNS:
        return {"statusCode": 500, "body": json.dumps({"error": "ALB_DNS not set"})}

    url = f"http://{ALB_DNS}:{ALB_PORT}{PATH}"

    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            status = resp.getcode()
            body = resp.read(512).decode("utf-8", errors="replace")

        if 200 <= status < 300:
            return {"statusCode": 200, "body": json.dumps({"status": status})}

        return {"statusCode": status, "body": json.dumps({"status": status, "body": body})}

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
