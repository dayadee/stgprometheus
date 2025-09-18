aws route53 list-hosted-zones-by-name --dns-name prd-prometheu.na.internal.samsungacr.com

{
    "HostedZones": [
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
    "DNSName": "prd-prometheu.na.internal.samsungacr.com",
    "IsTruncated": false,
    "MaxItems": "100"
}
