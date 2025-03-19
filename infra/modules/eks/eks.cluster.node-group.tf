resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_cluster_node_group.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types
  capacity_type   = var.node_capacity_type

  # Boa prática tfsec: habilitar tags-to-labels para recursos Kubernetes
  tags = merge(
    var.tags,
    {
      "k8s.io/cluster-autoscaler/enabled"             = "true"
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    }
  )

  scaling_config {
    desired_size = var.node_scaling_config.desired_size
    max_size     = var.node_scaling_config.max_size
    min_size     = var.node_scaling_config.min_size
  }

  # Boa prática: definir configuração de atualização para evitar interrupções
  update_config {
    max_unavailable = 1
  }

  # Boa prática: configurar disco raiz para ter criptografia
  launch_template {
    id      = aws_launch_template.node_group.id
    version = aws_launch_template.node_group.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_cluster_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_cluster_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Boa prática tfsec: launch template com criptografia de volume e IMDSv2
resource "aws_launch_template" "node_group" {
  name_prefix = "${var.cluster_name}-node-"
  description = "Launch template para nós do EKS ${var.cluster_name}"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true # Boa prática tfsec: habilitar criptografia de volume
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Boa prática tfsec: requer IMDSv2
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tags = var.tags
}
