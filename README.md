# Amazon ECS를 이용한 Docker 이미지 배포 및 업데이트(update), 롤백(rollback) 테스트


#  프로젝트 개요
GitHub Actions와 Terraform을 활용하여, ECS Fargate 기반 Node.js 웹 애플리케이션을 자동 배포하고,

Docker 이미지 태그 기반으로 업데이트 및 롤백을 수행하는 구조를 테스트한 프로젝트입니다.


핵심 구성

CI/CD 자동화 (GitHub Actions)

workflow_dispatch로 수동 트리거 (update / rollback 선택)

image_tag 입력 → ECS 서비스 자동 갱신

ECS + ALB 인프라 구성 (Terraform)

퍼블릭 서브넷(ALB), 프라이빗 서브넷(ECS) 분리

ALB를 통해 외부에서 ECS 접근

보안 그룹으로 ALB → ECS 3000 포트 허용

CloudWatch Logs 연동

ECS Task 정의에 awslogs 드라이버 설정

컨테이너 로그를 /ecs/my-app 로그 그룹으로 출력

✅ 사용 기술

AWS: ECS Fargate, ALB, CloudWatch, IAM

CI/CD: GitHub Actions

Infra: Terraform (모듈화: vpc, alb, ecs, security)

이미지 관리: Docker Hub (baram940/devops-test)

