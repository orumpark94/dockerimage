# Amazon ECS를 이용한 Docker 이미지 배포 및 업데이트(update), 롤백(rollback) 테스트


#  프로젝트 개요
GitHub Actions와 Terraform을 활용하여, ECS Fargate 기반 Node.js 웹 애플리케이션을 자동 배포하고,

Docker 이미지 태그 기반으로 업데이트 및 롤백을 수행하는 구조를 테스트한 프로젝트입니다.



#핵심 구성

CI/CD 자동화 (GitHub Actions)

workflow_dispatch로 수동 트리거 (update / rollback 선택)

image_tag 입력 → ECS 서비스 자동 갱신


#ECS + ALB 인프라 구성 (Terraform)

퍼블릭 서브넷(ALB), 프라이빗 서브넷(ECS) 분리

ALB를 통해 외부에서 ECS 접근

보안 그룹으로 ALB → ECS 3000 포트 허용


#CloudWatch Logs 연동

ECS Task 정의에 awslogs 드라이버 설정

컨테이너 로그를 /ecs/my-app 로그 그룹으로 출력


#사용 기술

AWS: ECS Fargate, ALB, CloudWatch, IAM

CI/CD: GitHub Actions

Infra: Terraform (모듈화: vpc, alb, ecs, security)

이미지 관리: Docker Hub 


															
	Amazon ECS를 이용한 Docker 이미지 배포 및 업데이트(update), 롤백(rollback) 테스트														
															
	전체 아키텍처 개요														
	Docker Image 빌드: node.js를 기반으로 도커 이미지 생성														
	ECR에 푸시: 빌드된 이미지를 docker hub에 저장														
	ECS에 배포: 이미지를 ECS (Fargate)에 배포														
	업데이트 테스트: 코드 변경 → 이미지 재빌드 → ECS 서비스 업데이트														
	롤백 테스트: 이전 이미지로 서비스 되돌리기														
															
	Terraform → [VPC + ECS Cluster + ALB + IAM]														
	                     ↑														
	            terraform → Docker build & push														
	                             → ECS Task Definition & Service 업데이트 (별도 deploy 진행)														
															
	1. docker 이미지 빌드용 서버 구성														
	가상화서버를 이용하여 ECR에 이미지를 업로드 할 수 있는 구성 진행														
→	→ linux - docker 설치 및 docker Hub 연결														
	→ docker 이미지 생성을 위한 config 파일 구성 (copy 명령어를 통하여 이미지 생성 시 복사)														
	(node.js를 이용하여 구성중)														
															
	2. 생성된 docker image docker hub에 업로드														
	*docker hub에 로그인 #docker login 명령어 실행														
	*docker hub에 올릴 이미지 이름 및 테그 설정 후 push														
	docker hub에 push시에는 Docker Hub용으로 재이름(tag) 붙이는 작업이 필요함														
	push 후 docker hub에 올라간 docker image 확인 가능														
															
	#docker tag dockerimage:1.0 baram940/devops-test:1.0														
	→ 생성된 image(dockerimage:1.0)을 tag를 붙혀서 docker hub에 업로드 할 수 있도록 세팅														
	#docker push baram940/devops-test:1.0														
	→ docker hub 레포지토리에 업로드 (tag를 기준으로 이미지를 업로드함)														
															
	3. terraform을 이용한 ecs 구성 							1. VPC 모듈에서 퍼블릭 + 프라이빗 서브넷을 함께 구성							
								2. ALB는 퍼블릭 서브넷에 생성							
	[클라이언트 브라우저] → HTTP(80)							3. ECS Fargate는 프라이빗 서브넷에 배치							
	          ↓							4. ECS에 퍼블릭 IP는 할당하지 않음 (assign_public_ip = false)							
	      [퍼블릭 ALB]  ← 퍼블릭 서브넷							5. ALB 보안 그룹에서 ECS로 포트 3000 허용							
	          ↓							6. NAT GW는 없어도 무방 (단, 외부 통신이 필요 없는 앱이라면)							
	     [Target Group → ECS Fargate Task] ← 프라이빗 서브넷														
	          ↓														
	    [컨테이너: Node.js (3000 포트)]														
															
															
	*terraform 모듈화 코드 구성														
							루트 모듈 (Root Module)								
		infra/					Terraform이 실행될 때 가장 먼저 읽는 진입점 디렉토리로, 여러 서브 모듈을 호출하고 전체 인프라를 조합하는 역할을 합니다.								
		├── main.tf 					여러 서브 모듈의 값을 연결해주는 중심부								
		├── variables.tf    													
		├── terraform.tfvars  					서브 모듈 (Child Module / Submodule)								
		├── modules/					루트 모듈에서 module 블록을 통해 불러오는 기능 단위 구성 모듈로, VPC, ECS, ALB 등 특정 인프라 자원을 담당합니다.								
		│   ├── vpc/					재사용성과 역할 분리를 위한 핵심 구조								
		│   │   ├── main.tf													
		│   │   └── variables.tf													
		│   ├── ecs/					aws 계정 정보								
		│   │   ├── main.tf					ecs-test								
		│   │   └── variables.tf					-							
		│   └── alb/													
		│       ├── main.tf					-								
		│       └── variables.tf													
							TAitQmOkiwzAr8khA8qKRudoz3+Ql2HklC06gsCs								
															
															
	*ALB를 구성하기 위해서는 2개의 subnet이 필요하다.														
	*public sub이 외부와 연결되기 위해서는 라우팅 테이블 및 IGW 연결이 필요하다														
	*main.tf에서 실행되는 값에 각 리소스에 해당하는 변수 값이 들어가야한다.														
	*각 리소스에는 각 리소스가 사용되어야 하는 별도의 sg를 만들어서 적용하는게 좋다														
															
															
	4. 배포된 docker 서비스 (node.js로 구성된 웹 호스팅)														
															
															
															
															
															
															
															
															
															
	5. docker 이미지 업데이트 진행														
															
	[root@localhost nodejs]# docker build -t -											
	[root@localhost nodejs]# docker login														
	[root@localhost nodejs]# docker push -													
	*git hub에 이미지 업데이트														
															
	6. workflow 생성 - docker image update or rollback														
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
															
	*update 실행 시 기존 1.0v 에서 2.0v으로 업데이트 완료 (기존 컨테이너 off 진행)														
															
															
															
															
															
															
															
	업데이트 완료														
	*추가로 알게된 사항 ecs는 기본적으로 서비스 무중단 배포를 지원한다. (zero downtime deployment)														
	기존 서비스를 바로 지우지 않고, 새로운 task가 running 상태가 되면 기존 task를 순차적으로 종료함														
	ECS Fargate (또는 EC2) 서비스는 내부적으로 Rolling Update 방식을 사용합니다.														
	즉 기존 docker image를 업데이트하는 것이 아닌 새로운 docker 컨테이너를 띄우는 것이다.														
	*rollback도 정상 적용 가능														
															
	*추가 고려사항														
															
	항목	실무 환경 (권장)													
	VPC	Multi-AZ 구성으로 고가용성													
	서브넷	퍼블릭: ALB만 배치, 프라이빗: ECS/Fargate 배치 (AZ 2개 이상 구성)													
	NAT Gateway	프라이빗 서브넷에서 외부 통신 가능하도록 NAT Gateway 구성													
	보안 그룹	IP 제한, SG-to-SG 통신 허용만 사용 (ALB SG → ECS SG 인바운드 허용)													
	NACL	가능하면 보안 그룹 외에 NACL로 한 번 더 방어													
															
	Docker 이미지 관리														
															
	항목	실습 환경	실무 환경 (권장)												
	이미지 저장소	DockerHub	ECR Private + 이미지 서명(Signing) 적용												
	태그 방식	수동 태그 (1.0, 2.0)	Git Commit SHA 또는 Semver 기반 버전 태그링 자동화												
	취약점 검사	없음	Amazon Inspector, ECR 이미지 Scan, Trivy 도구 등 활용												
															
	IAM 및 인증 보안														
															
	항목	실습 환경	실무 환경 (권장)												
	IAM 권한	액세스 키 직접 입력	OIDC 기반 GitHub Actions IAM Role 구성 (OIDC Trust + AssumeRole)							OIDC(OpenID Connect)				*OIDC의 보안 강화 방안	
	ECS Task Role	설정 안 함	ECS Task Execution Role 및 Task Role 분리, 최소 권한 원칙 적용											보안 전략	설명
	DockerHub 사용	공개 이미지 사용	ECR (Private) 사용 + Image Scan + Lifecycle Policy 적용											브랜치 조건 제한	ref:refs/heads/main만 허용
														GitHub 환경 승인 사용	관리자 승인 후에만 배포 가능하게 설정
	ALB 및 HTTPS 구성													최소 권한 IAM Role	OIDC Role에 꼭 필요한 권한만 부여
														PR 자동 배포 제한	PR에선 실행되지 않도록 워크플로우 조건 설정
	항목	실습 환경	실무 환경 (권장)											리포지토리 권한 관리	Push 권한 있는 사람을 최소화
	ALB 프로토콜	HTTP (80)	HTTPS (443), ACM을 통한 TLS 적용												
	도메인 연결	없음	Route53 + ACM 인증서를 통해 도메인 연결											* ECR = Elastic Container Registry	
	Web Firewall	없음	AWS WAF 연결 (IP/Geo/Cookie 기반 룰 적용)											Docker 이미지를 저장하는 저장소입니다.	
	로그	없음	ALB Access Logs를 S3에 저장하여 분석 가능하게 구성											GitHub Actions, ECS, EKS 등에서 사용할 수 있어요.	
														docker push / docker pull로 사용합니다.	
	Docker 이미지 관리													이미지 보안 스캔 기능	
															
	항목	실습 환경	실무 환경 (권장)											Lifecycle Policy란?	
	이미지 저장소	DockerHub	ECR Private + 이미지 서명(Signing) 적용											오래된 이미지를 자동으로 정리해주는 기능	
	태그 방식	수동 태그 (1.0, 2.0)	Git Commit SHA 또는 Semver 기반 버전 태그링 자동화											예: 10개 이상 쌓이면 오래된 이미지부터 자동 삭제	
	취약점 검사	없음	Amazon Inspector, ECR 이미지 Scan, Trivy 도구 등 활용											ECR 저장 공간을 절약할 수 있어요.	
														비용 절감에도 도움이 됩니다.	
	GitHub Actions 보안														
														어떤 상황에서 워크플로우를 실행할지를 정하는 설정	
	항목	실습 환경	실무 환경 (권장)											Push 단위 트리거	git push 할 때 워크플로우 실행
	Secret 저장소	GitHub Secrets	Secrets Manager 또는 OIDC 기반 Role 사용 권장											PR 단위 트리거	Pull Request 열거나 수정할 때 실행
	워크플로우 실행 조건	수동 workflow_dispatch	Push, PR 단위 + path-filter로 제한된 디렉토리만 트리거											path-filter	특정 파일/디렉토리 변경 시에만 워크플로우 실행
	빌드 검증	없음	PR시 Lint, Test, Security Scan 등의 CI 필수 통과 조건 설정												
															
	모니터링 및 로깅														
															
	항목	실습 환경	실무 환경 (권장)												
	로그	없음	ECS → CloudWatch Logs 연동 (stdout/stderr)												
	모니터링	없음	CloudWatch Metrics, Container Insights, Alarm 설정												
	트레이싱	없음	X-Ray, OpenTelemetry 도입 검토 가능												
															
	배포 전략														
															
	항목	실습 환경	실무 환경 (권장)												
	배포 방식	단순 이미지 태그 교체	Blue/Green 또는 Canary 배포 (ECS + CodeDeploy 통합)												
	롤백 방식	수동 태그 변경	배포 실패 시 자동 롤백 + 알림 (SNS, Slack 등)												
	배포 도구	GitHub Actions	GitHub Actions + Terraform + ArgoCD/GitOps 기반 운영도 고려												

