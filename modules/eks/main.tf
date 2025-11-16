module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  
  enable_cluster_creator_admin_permissions = true
  authentication_mode = "API_AND_CONFIG_MAP"

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    for ng_name, ng_config in var.node_groups : ng_name => {
      name = "${var.cluster_name}-${ng_name}-ng"

      instance_types = ng_config.instance_types
      capacity_type  = ng_config.capacity_type

      min_size     = ng_config.min_size
      max_size     = ng_config.max_size
      desired_size = ng_config.desired_size

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = ng_config.disk_size
            volume_type           = ng_config.disk_type
            iops                  = ng_config.disk_type == "gp3" ? ng_config.disk_iops : null
            throughput            = ng_config.disk_type == "gp3" ? ng_config.disk_throughput : null
            delete_on_termination = true
          }
        }
      }

      labels = merge(
        {
          Environment = var.environment
          NodeGroup   = ng_name
        },
        ng_config.labels
      )

      taints = ng_config.taints

      tags = merge(
        var.tags,
        ng_config.tags,
        {
          Name   = "${var.cluster_name}-${ng_name}-node"
          Module = "kubernetes"
        }
      )
    }
  }

  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Nodes on ephemeral ports"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = merge(
    {
      ingress_self_all = {
        description = "Node to node all ports/protocols"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "ingress"
        self        = true
      }
      egress_all = {
        description      = "Node all egress"
        protocol         = "-1"
        from_port        = 0
        to_port          = 0
        type             = "egress"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    },
    var.additional_security_group_rules
  )

  tags = merge(
    var.tags,
    {
      Module = "kubernetes"
    }
  )
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  statement {
    sid    = "ClusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ClusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  name_prefix = "${var.cluster_name}-cluster-autoscaler-"
  description = "Cluster autoscaler policy for EKS cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler[0].json

  tags = merge(
    var.tags,
    {
      Name   = "${var.cluster_name}-cluster-autoscaler-policy"
      Module = "kubernetes"
    }
  )
}