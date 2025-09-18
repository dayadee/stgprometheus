aws route53 list-resource-record-sets --hosted-zone-id ZPCVKTJXHQJ8T  --query "ResourceRecordSets[?Name=='prd-prometheus.na.internal.samsungacr.com.']"

				[
				    {
				        "Name": "prd-prometheus.na.internal.samsungacr.com.",
				        "Type": "A",
				        "AliasTarget": {
				            "HostedZoneId": "Z35SXDOTRQ7X7K",
				            "DNSName": "internal-aa419275b815c436f81c4aed4d451d86-376881644.us-east-1.elb.amazonaws.com.",
				            "EvaluateTargetHealth": true
				        }
				    },
				    {
				        "Name": "prd-prometheus.na.internal.samsungacr.com.",
				        "Type": "TXT",
				        "TTL": 300,
				        "ResourceRecords": [
				            {
				                "Value": "\"heritage=external-dns,external-dns/owner=PRD-EKS-NA,external-dns/resource=service/monitoring/prometheus-k8s\""
				            }
				        ]
				    }
				]
