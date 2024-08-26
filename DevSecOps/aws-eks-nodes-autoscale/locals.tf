locals {
  cluster_id = data.aws_eks_cluster.eks.id
  state = var.state == "Habilitar" || var.state == "" ? "ENABLED" : "DISABLED"

  cron_down_split  = split(" ", var.cron_down)
  cron_up_split    = split(" ", var.cron_up)
  timestamp_custom = timeadd(format("%sT%s:%s:00Z", formatdate("YYYY-MM-DD", timestamp()), local.cron_down_split[1], format("%02d", local.cron_down_split[0])), "30m")

  cron_up             = format("%s %s ? * %s *", local.cron_up_split[0], local.cron_up_split[1], local.cron_up_split[2])
  cron_down           = format("%s %s ? * %s *", local.cron_down_split[0], local.cron_down_split[1], local.cron_down_split[2])
  cron_karpenter_down = format("%s ? * %s *", formatdate("mm hh", local.timestamp_custom), local.cron_down_split[2])

  eec_tags = ({
    "CostString"  = lookup(data.aws_eks_cluster.eks.tags, "CostString", "0000.BR.000.000000")
    "AppID"       = lookup(data.aws_eks_cluster.eks.tags, "AppID", "12345")
    "Environment" = lookup(data.aws_eks_cluster.eks.tags, "Environment", var.env_map[var.env])
    "BU"          = var.bu_name
  })

  tags = "${merge(
    tomap(local.eec_tags), "${var.tags}"
  )}"
}
