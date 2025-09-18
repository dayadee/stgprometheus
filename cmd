aws route53 list-hosted-zones-by-name --dns-name na.internal.samsungacr.com 

{
    "HostedZones": [
        {
            "Id": "/hostedzone/ZPCVKTJXHQJ8T",
            "Name": "na.internal.samsungacr.com.",
            "CallerReference": "4F784B9F-DDA8-B4CF-87AD-E13DB74930F7",
            "Config": {
                "Comment": "Internal ",
                "PrivateZone": true
            },
            "ResourceRecordSetCount": 762
        },
        {
            "Id": "/hostedzone/Z0847277PEVFY425TS9Q",
            "Name": "sa.internal.samsungacr.com.",
            "CallerReference": "ROUTE53-INTERN-DNS-1IWSKVLPTH25E",
            "Config": {
                "Comment": "Internal",
                "PrivateZone": true
            },
            "ResourceRecordSetCount": 101
        }
    ],
    "DNSName": "na.internal.samsungacr.com",
    "IsTruncated": false,
    "MaxItems": "100"
}

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


aws elb describe-load-balancers \
  --region us-east-1 \
  --query "LoadBalancerDescriptions[?DNSName=='internal-aa419275b815c436f81c4aed4d451d86-376881644.us-east-1.elb.amazonaws.com'].{Name:LoadBalancerName,DNSName:DNSName}"

[
    {
        "Name": "aa419275b815c436f81c4aed4d451d86",
        "DNSName": "internal-aa419275b815c436f81c4aed4d451d86-376881644.us-east-1.elb.amazonaws.com"
    }
]
