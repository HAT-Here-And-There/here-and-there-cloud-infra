module "bastion_host" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = format(module.naming.result, "bastion-host-ec2")

  ami                         = "ami-0b23bb3616e3892a6"
  instance_type               = "t2.micro"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.sg_for_bastion_host.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false

  key_name = aws_key_pair.key_pair.key_name
}
