# Private EC2 AZ-1

module "ec2-instance_private_az1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "${var.environment}-EC2-Private-AZ1"


  ami                    = data.aws_ami.amz-2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security-group_private.security_group_id]
  create_security_group = false

  

  user_data           = file("${path.module}/APP-1.sh")
  user_data_replace_on_change = true

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }
  enable_volume_tags = false
  root_block_device = {
    encrypted  = true
    type       = "gp3"
    throughput = 200
    size       = 50
    tags = {
      Name = "my-root-block"
    }
  }

  ebs_volumes = {
    "/dev/sdf" = {
      size       = 5
      throughput = 200
      encrypted  = true
     # kms_key_id = aws_kms_key.this.arn
      tags = {
        MountPoint = "/mnt/data"
      }
    }
  }
  
  

  tags = local.common_tags
}


module "ec2-instance_private_az2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "${var.environment}-EC2-Private-AZ2"


  ami                    = data.aws_ami.amz-2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  availability_zone      = element(module.vpc.azs, 1)
  subnet_id              = element(module.vpc.private_subnets, 1)
  vpc_security_group_ids = [module.security-group_private.security_group_id]
  create_security_group = false

  

  user_data           = file("${path.module}/APP-1.sh")
  user_data_replace_on_change = true

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }
  enable_volume_tags = false
  root_block_device = {
    encrypted  = true
    type       = "gp3"
    throughput = 200
    size       = 50
    tags = {
      Name = "my-root-block"
    }
  }

  ebs_volumes = {
    "/dev/sdf" = {
      size       = 5
      throughput = 200
      encrypted  = true
     # kms_key_id = aws_kms_key.this.arn
      tags = {
        MountPoint = "/mnt/data"
      }
    }
  }
  
  

  tags = local.common_tags
}