# 베이스 이미지
FROM ubuntu:22.04

# 작성자 정보
LABEL maintainer="이동혁"

# 패키지 업데이트 & 설치
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# 컨테이너 시작 시 실행할 명령
CMD ["/bin/bash"]