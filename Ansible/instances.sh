aws ec2 describe-instances --profile load \
    --filters "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].{
        Name:Tags[?Key==`Name`].Value|[0],
        InstanceId:InstanceId,
        PrivateIP:PrivateIpAddress,
        PublicIP:PublicIpAddress,
        Service:Tags[?Key==`Service`].Value|[0],
        Type:Tags[?Key==`Type`].Value|[0],
        Environment:Tags[?Key==`Environment`].Value|[0]
    }' \
    --output json | \
jq -r 'flatten | sort_by(.PrivateIP)' > instances.json