# VPC 모듈 호출
module "vpc" {
  source                = "./modules/vpc"
  name                  = var.name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
}

# ALB SG 생성 (Security 모듈)
module "security_alb" {
  source   = "./modules/security"
  name     = "${var.name}-alb-sg"
  vpc_id   = module.vpc.vpc_id
  type     = "alb"
}

# ECS SG 생성 (Security 모듈)
module "security_ecs" {
  source     = "./modules/security"
  name       = "${var.name}-ecs-sg"
  vpc_id     = module.vpc.vpc_id
  type       = "ecs"
  alb_sg_id  = module.security_alb.sg_id   # ECS SG는 ALB SG에서의 인바운드 허용
}

# ALB 모듈 호출
module "alb" {
  source          = "./modules/alb"
  name            = var.name
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  sg_id           = module.security_alb.sg_id       # ✅ ALB SG 주입
  target_port     = 3000                            # ✅ ECS 컨테이너 포트
}

# ECS 모듈 호출
module "ecs" {
  source           = "./modules/ecs"
  name             = var.name
  image            = "baram940/devops-test:1.0"
  container_port   = 3000
  private_subnets  = module.vpc.private_subnets
  tg_arn           = module.alb.target_group_arn
  sg_id            = module.security_ecs.sg_id      # ✅ ECS SG 주입
}
