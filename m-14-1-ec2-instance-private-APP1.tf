# Private EC2s for APP1

module "ec2-instance_private-app1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"
  depends_on = [ module.vpc ]
  name = "${var.environment}-EC2-APP1"


  ami                    = data.aws_ami.amz-2023.id
  instance_type          = var.instance_type
  key_name               = var.private-ec2-keypair
 #   availability_zone      = element(module.vpc.azs, 0)
 #   subnet_id              = element(module.vpc.private_subnets, 0)
 #   vpc_security_group_ids = [module.security-group_private.security_group_id]
  
  for_each = toset(["0", "1"])
  subnet_id =  element(module.vpc.private_subnets, tonumber(each.key))
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


