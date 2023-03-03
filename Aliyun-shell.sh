
ali_region_AZ_list(){
    echo '---'
for region in $(aliyun ecs DescribeRegions  | jq '.Regions.Region[].RegionId' )
    do
        #echo $region
        reg=$(echo $region | sed s/\"//g )
        #for zone in $(aliyun ecs DescribeZones --RegionId $reg | jq '.Zones.Zone[] | "\(.ZoneId) \(.LocalName)"')
        #for zone in $(aliyun ecs DescribeZones --RegionId $reg)
        #for zone in $(aliyun ecs DescribeZones --RegionId $reg | jq '.Zones.Zone[].ZoneId')
        #do
 	    #    #echo $zone
	    #    printf "%s,%s\n"  $zone
        #done
        aliyun ecs DescribeZones --RegionId $reg --output cols=ZoneId,LocalName rows=Zones.Zone[]
        #echo ''
    done
}
ali_region_list(){
     aliyun ecs DescribeRegions --output cols=RegionId,LocalName rows=Regions.Region[]
}

ali_region_endpoint(){
     aliyun ecs DescribeRegions --output cols=RegionId,RegionEndpoint rows=Regions.Region[]
}

ali_region_set(){
  ENV=$1
  if [[ $ENV == "uat" ]];then
    export ALIYUN_REGION="ap-northeast-1"
    echo "environment is UAT"
    echo "AWS Region is Tokyo"
    echo "ALIYUN_REGION=ap-northeast-1"
  elif [[ $ENV == "dev" ]] || [[ $ENV == "stg" ]];then
    export ALIYUN_REGION="cn-hongkong"
    echo "environment is Dev"
    echo "AALIYUN_REGION is Hong Kong"
    echo "ALIYUN_REGION=cn-hongkong"
  elif [[ $ENV == "prod" ]];then
    export ALIYUN_REGION="ap-southeast-6"
    echo "environment is Master"
    echo "AWS ALIYUN_REGION is Philippines-Manila"
    echo "ALIYUN_REGION=ap-southeast-6"
  fi
}
ali_ecs_list(){
  aliyun ecs DescribeInstances --RegionId $ALIYUN_REGION --output cols=InstanceId,InstanceName,HostName,Status,NetworkInterfaces.NetworkInterface[].PrimaryIpAddress rows=Instances.Instance[] num=true
}
ali_slb_list(){
  aliyun slb DescribeLoadBalancers --RegionId $ALIYUN_REGION --output cols=LoadBalancerId,LoadBalancerName,LoadBalancerStatus rows=LoadBalancers.LoadBalancer[]
}
ali_ecs_instanceType(){
  aliyun ecs DescribeInstanceTypes --RegionId $ALIYUN_REGION --output cols=InstanceTypeId,CpuCoreCount,MemorySize rows=InstanceTypes.InstanceType[] | sort
}
ali_securitygroup_list(){
  aliyun ecs DescribeSecurityGroups --RegionId $ALIYUN_REGION --output cols=SecurityGroupName,SecurityGroupId,VpcId,Description rows=SecurityGroups.SecurityGroup[]
}
ali_vswitch_list(){
 aliyun vpc DescribeVSwitches --RegionId $ALIYUN_REGION --output cols=VSwitchId,VSwitchName,ZoneId,CidrBlock,Description rows=VSwitches.VSwitch[]
}
ali_keyPair_list(){
 aliyun ecs DescribeKeyPairs --RegionId $ALIYUN_REGION  --output cols=KeyPairName,CreationTime rows=KeyPairs.KeyPair[]
}