module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  alb_sg_id         = module.alb.alb_sg_id
  tg_arn            = module.alb.target_group_arn
}
