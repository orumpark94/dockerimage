terraform {
  backend "s3" {
    bucket = "ecs-terraform-test-sj"     # 사용자가 만든 S3 버킷 이름
    key    = "terraform/ecs.tfstate"     # tfstate 파일 저장 경로 (원하는 이름으로 가능)
    region = "ap-northeast-2"            # 서울 리전
  }
}
