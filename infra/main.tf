# VPC 모듈 호출
module "vpc" {
  source               = "./modules/vpc"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr   # ✅ 단수로 수정
  private_subnet_cidr  = var.private_subnet_cidr  # ✅ 단수로 수정
  availability_zone    = var.availability_zone    # ✅ 단수로 수정
}

# ALB 모듈 호출
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id  # ✅ 정확한 output 사용
  name              = var.name
}

# ECS 모듈 호출
module "ecs" {
  source             = "./modules/ecs"
  vpc_id             = module.vpc.vpc_id
  private_subnet_id  = module.vpc.private_subnet_id  # ✅ 정확한 output 사용
  alb_sg_id          = module.alb.alb_sg_id
  tg_arn             = module.alb.target_group_arn
  name               = var.name
}
