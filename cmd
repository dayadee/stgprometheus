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

