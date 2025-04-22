# 🧱 Inception - Docker 기반 시스템 인프라 구축 프로젝트

> **프로젝트 개요**  
> `Inception`은 Docker와 Docker Compose를 활용하여 웹 서비스를 위한 **경량 인프라 환경**을 직접 설계하고 구축한 프로젝트입니다. 실제 서비스 환경과 유사한 조건에서 컨테이너 기반 시스템을 운영하는 능력을 키우기 위해 진행되었습니다.

## 🗂️ 프로젝트 구조
```Bash
Inception/
├── Makefile
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── conf/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools/
        ├── nginx/
        │   ├── conf/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools/
        └── wordpress/
            ├── Dockerfile
            └── tools/
```
## 🎯 주요 목표
- **Dockerfile 작성 및 이미지 빌드 자동화**
- **TLS 적용된 웹 서비스 구성 (HTTPS 443 포트)**
- **멀티 컨테이너 환경에서의 서비스 분리 및 연동**
- **보안 정책 준수 (환경변수 관리, 비밀번호 노출 금지 등)**

## ⚙️ 기술 스택 및 구성 요소
| 구성 요소 | 설명 |
|-----------|------|
| **Docker** | 각 서비스를 컨테이너화하고 격리된 환경 제공 |
| **Docker Compose** | 전체 인프라 환경을 코드로 구성 및 자동화 |
| **NGINX** | HTTPS(SSL/TLS 1.2 or 1.3) 기반 Reverse Proxy |
| **WordPress + PHP-FPM** | 블로그/웹사이트 엔진 |
| **MariaDB** | WordPress와 연동된 데이터베이스 |
| **Volumes** | 웹 데이터 및 DB 데이터의 영속성 보장 |
| **Custom Network** | 서비스 간의 내부 통신을 위한 가상 네트워크 구성 |
| **.env 파일** | 민감정보 외부 유출 방지를 위한 환경변수 관리 |

## 🛠️ 주요 기능
- NGINX는 HTTPS 443 포트만 허용하며, 유일한 진입점입니다.
- WordPress는 php-fpm 기반으로 동작하며, nginx 없이 별도 컨테이너에서 구동됩니다.
- MariaDB는 DB 전용 컨테이너에서 구동되며, WordPress DB를 관리합니다.
- 웹서비스 빌드시 즉시 사용자 및 관리자 계정이 생성됩니다.
- 모든 서비스는 **Debian 기반의 이미지**를 바탕으로 커스텀되었습니다.
- 컨테이너는 crash 시 자동 재시작되도록 설정되어 있습니다.
- `.env` 파일을 통해 비밀번호, 도메인 등 민감 정보는 Git에서 제외됩니다.

## 📚 배운 점 (What I Learned)
이 프로젝트는 단순한 Docker 실습을 넘어서, 실제 서비스 환경과 유사한 인프라를 직접 구성해보며 시스템 관리의 핵심 개념과 Docker의 실전 활용법을 깊이 이해할 수 있었던 경험이었습니다. 다음과 같은 내용을 새롭게 배우고 체득했습니다:

🔧 1. Docker 및 docker-compose 기반 인프라 구성
docker-compose.yml을 통해 Nginx, WordPress, MariaDB를 각각의 컨테이너로 분리해 구성하고, 서비스 간 연결을 docker network로 구성하여 실제 환경과 유사한 형태의 인프라를 설계했습니다.

Dockerfile을 직접 작성하여 각 서비스의 이미지 커스터마이징을 수행했고, Makefile로 빌드 및 실행을 자동화했습니다.

🔒 2. HTTPS 기반 보안 설정
TLS 1.2/1.3을 적용한 Nginx 서버 구성을 통해 HTTPS로만 접속 가능한 보안 환경을 구축했습니다.

OpenSSL을 이용해 자체 인증서 생성 및 Nginx에 적용하는 과정에서 TLS와 인증서의 원리를 이해했습니다.

💾 3. 데이터 영속화 및 사용자 데이터 보호
WordPress의 웹 파일과 MariaDB의 데이터를 별도의 Docker volume으로 분리하여 영속화 처리함으로써 컨테이너 재시작 시에도 데이터가 보존되도록 구성했습니다.

.env 파일을 통해 민감한 정보(비밀번호, 도메인 등)를 외부로부터 분리하고, git에서 ignore 처리하여 보안 관점의 프로젝트 설계 경험을 쌓았습니다.

🔄 4. 컨테이너 운영 안정성 확보
restart: always 옵션을 적용해 컨테이너가 충돌이나 서버 재부팅 이후에도 자동으로 복구되도록 설정하였고,

PID 1 및 데몬 처리에 대한 개념을 이해하고, tail -f, sleep infinity 같은 비권장 방식 없이 서비스를 안정적으로 실행할 수 있는 구조로 개선했습니다.

🧠 5. 운영 환경 시뮬레이션 경험
mylogin.42.fr 형태의 도메인 연결과 hosts 파일 설정을 통해 가상 운영 환경을 구축하며, 도메인, IP 매핑, 포트포워딩, 서버 보안에 대한 실제 환경과 유사한 실습을 진행했습니다.

경량화 이미지로는 Debian을 선택하여 서비스 안정성과 라이브러리 호환성을 확보하는 방식의 운영 선택 기준을 배웠습니다.

