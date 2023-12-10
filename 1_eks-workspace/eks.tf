data "aws_kms_key" "existing_kms_key" {
  key_id = "arn:aws:kms:ap-northeast-2:970698899539:key/48ffc2e8-696a-485b-838f-03100c4f88e1"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                          = var.eks_cluster_name
  cluster_version                       = var.eks_cluster_version
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = true
  cluster_additional_security_group_ids = [aws_security_group.security_group_eks_cluster.id]
  # kms_key_aliases = "kms_alias_test"
  # kms_key_aliases = ["alias/yuran_key_examples"]
  kms_key_aliases = data.aws_kms_key.existing_kms_key.arn
  
  lifecycle {
    ignore_changes = [
      kms_key_aliases,
    ]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    "${var.eks_cluster_node_group_name}" = {
      desired_size   = var.worker_node_desired_size
      max_size       = var.worker_node_max_size
      min_size       = var.worker_node_min_size
      instance_types = var.worker_node_instance_type
    }
  }

}
