# codyssey_E1-1
# Docker 개발자 워크스테이션 구축

## 1) 프로젝트 개요
- 리눅스 CLI, Docker, Git/GitHub를 활용해 개발자 워크스테이션을 구축한다.
- 터미널로 파일/권한을 관리하고, Docker로 웹 서버를 컨테이너화하여
  포트 매핑 접속, 바인드 마운트 반영, 볼륨 영속성을 검증한다.

## 2) 실행 환경
- OS: Windows (Git Bash 사용)
- Shell: bash (Git Bash)
- Docker: Docker version 29.9.2, build a82e528
- Git: git version 2.56.0.windows.4

## 3) 수행 체크리스트
- [x] 1. 터미널 기본 조작
- [ ] 2. 권한 변경 실습
- [x] 3. Docker 설치/점검
- [ ] 4. Docker 기본 운영 (hello-world, ubuntu)
- [ ] 5. Dockerfile 빌드/실행
- [ ] 6. 포트 매핑 접속 (2회)
- [ ] 7. 바인드 마운트 반영
- [ ] 8. 볼륨 영속성
- [ ] 9. Git 설정 + GitHub 연동

## 4) 수행 로그

### 1. 터미널 기본 조작
```bash
$ pwd                # 현재 내 위치(폴더) 확인
C:/codyE1-1/codyssey_E1-1

$ ls                 # 현재 폴더의 파일/폴더 목록 보기
app/  images/  README.md

$ cd app             # app 폴더로 이동
$ pwd                # 잘 들어왔는지 확인
C:/codyE1-1/codyssey_E1-1/app

$ touch test.txt     # 빈 파일 생성
$ ls                 # 생성 확인
test.txt

$ cat test.txt       # 파일 내용 확인 (빈 파일이라 출력 없음)

$ rm test.txt        # 파일 삭제
$ ls                 # 삭제 확인 (아무것도 안 나옴)

$ cd ..              # 상위 폴더로 이동
$ pwd                # 루트로 돌아왔는지 확인
C:/codyE1-1/codyssey_E1-1
```

### 2. 권한 변경 실습

### 3. Docker 설치/점검

$ docker --version
Docker version 29.9.2, build a82e528

$ git --version
git version 2.56.0.windows.4

$ docker info   # 데몬 정상 확인 (Server 섹션 출력됨)
Server Version: 29.9.2
Containers: 0 / Images: 0
OSType: linux (WSL2)
→ Docker 엔진 정상 작동 확인

### 4. Docker 기본 운영

### 5. Dockerfile 빌드/실행

### 6. 포트 매핑 접속

### 7. 바인드 마운트

### 8. 볼륨 영속성

### 9. Git 설정 + GitHub 연동

## 5) 트러블슈팅 (문제 → 원인 → 확인 → 해결)
1.  문제 : 파일의 권한 변경 불가
```bash
$ touch test.txt
$ ls -l test.txt              # 권한 확인 (rw-r--r-- = 644)
-rw-r--r-- 1 ... test.txt

$ chmod 755 test.txt          # 권한을 755(rwxr-xr-x)로 변경 시도
$ ls -l test.txt
-rw-r--r-- 1 ... test.txt     # 권한 변경이 되지 않음
    원인 : Windows의 Git Bash에서는 chmod가 실제 권한에 반영되지 않을 수 있음

    확인 : (Docker 컨테이너 안에서 다시 확인해볼 예정)
2. 