# Why I should enable node group multi AZ

The reason you need an ASG per AZ is in cases where you do not have enough compute capacity in a specific AZ. For example, if your ASG in sa-east-1a is at maximum capacity and a pod needs to run with access to an EBS volume in that AZ. The cluster autoscaler needs to be able to add resources to that AZ in order for the pod to be scheduled.

If you run one ASG that spans multiple AZs, then the cluster autoscaler has no control over which AZ new instances will be created. The cluster autoscaler can add capacity to the ASG, but it may take multiple tries before an instance is created in the correct AZ.
