# codyssey_E1-1
# Docker 개발자 워크스테이션 구축

## 1) 프로젝트 개요
- 리눅스 CLI, Docker, Git/GitHub를 활용해 개발자 워크스테이션을 구축한다.
- 터미널로 파일/권한을 관리하고, Docker로 웹 서버를 컨테이너화하여
  포트 매핑 접속, 바인드 마운트 반영, 볼륨 영속성을 검증한다.

## 2) 실행 환경
| 항목 | 내용 |
|---|---|
| OS | Windows 11 |
| Shell / 터미널 | Git Bash (VSCode 내장 터미널) |
| Docker | 29.9.2, build a82e528 |
| Git | 2.56.0.windows.4 |

## 3) 수행 체크리스트
- [x] 1. 터미널 기본 조작
- [x] 2. 권한 변경 실습
- [x] 3. Docker 설치/점검
- [x] 4. Docker 기본 운영 (hello-world, ubuntu)
- [x] 5. Dockerfile 빌드/실행
- [x] 6. 포트 매핑 접속 (2회)
- [x] 7. 바인드 마운트 반영
- [x] 8. 볼륨 영속성
- [x] 9. Git 설정 + GitHub 연동

## 4) 수행 로그

### 1. 터미널 기본 조작

```bash
$ pwd                        # 현재 위치 확인
C:/codyE1-1/codyssey_E1-1

$ ls                         # 파일/폴더 목록
app/  images/  README.md

$ ls -a                      # 숨김 파일 포함 목록
./  ../  .git/  app/  images/  README.md

$ cd app                     # app 폴더로 이동
$ pwd
C:/codyE1-1/codyssey_E1-1/app

$ touch test.txt             # 빈 파일 생성
$ ls
test.txt

$ cp test.txt test_copy.txt  # 파일 복사
$ ls
test.txt  test_copy.txt

$ mv test_copy.txt test_renamed.txt  # 파일 이름 변경
$ ls
test.txt  test_renamed.txt

$ cat test.txt               # 파일 내용 확인 (빈 파일이라 출력 없음)

$ rm test.txt                # 파일 삭제
$ rm test_renamed.txt
$ ls                         # 삭제 확인 (아무것도 안 나옴)

$ cd ..                      # 상위 폴더로 이동
$ pwd
C:/codyE1-1/codyssey_E1-1
```

---

### 2. 권한 변경 실습

> ⚠️ Windows Git Bash 환경에서는 `chmod`가 실제 파일시스템 권한에 반영되지 않는다.
> 아래 실습은 **Docker ubuntu 컨테이너 내부**에서 수행하였다. (→ 4단계 참고)

```bash
# [컨테이너 내부에서 수행]

# 파일 권한 변경 실습
$ touch perm_test.txt
$ ls -l perm_test.txt        # 변경 전 확인
-rw-r--r-- 1 root root 0 ... perm_test.txt   # 644

$ chmod 755 perm_test.txt
$ ls -l perm_test.txt        # 변경 후 확인
-rwxr-xr-x 1 root root 0 ... perm_test.txt   # 755

# 디렉토리 권한 변경 실습
$ mkdir perm_dir
$ ls -ld perm_dir            # 변경 전 확인
drwxr-xr-x 2 root root ... perm_dir          # 755

$ chmod 700 perm_dir
$ ls -ld perm_dir            # 변경 후 확인
drwx------ 2 root root ... perm_dir          # 700
```

> **권한 표기 해석 (예: 755)**
> - `7 (rwx)` → 소유자: 읽기+쓰기+실행
> - `5 (r-x)` → 그룹: 읽기+실행
> - `5 (r-x)` → 기타: 읽기+실행

---

### 3. Docker 설치/점검

```bash
$ docker --version
Docker version 29.9.2, build a82e528

$ git --version
git version 2.56.0.windows.4

$ docker info
Server Version: 29.9.2
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
OSType: linux
Architecture: x86_64
...
# → Docker 엔진 정상 작동 확인 (Server 섹션 출력됨)
```

---

### 4. Docker 기본 운영

4-1. hello-world 실행
```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    74cc54e27dc4   4 months ago   10.1kB

$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
a0f5a3a1d2c1   hello-world   "/hello"   10 seconds ago   Exited (0) 9 seconds ago              vibrant_morse
```
4-2. ubuntu 컨테이너 대화형 실행
```bash
$ docker run -it ubuntu bash

root@e605117cf412:/# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr

root@e605117cf412:/# echo "hello ubuntu"
hello ubuntu

root@e605117cf412:/# cat /etc/os-release
PRETTY_NAME="Ubuntu 26.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="26.04"
VERSION="26.04.1 LTS (Resolute Raccoon)"
VERSION_CODENAME=resolute
ID=ubuntu
ID_LIKE=debian

root@e605117cf412:/# exit
exit
```
> ✅ Ubuntu 26.04 LTS 컨테이너 내부 진입 및 명령 실행 확인

---

### 5. Dockerfile 빌드/실행

```dockerfile
# 5-1. Dockerfile 작성
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
```
# 5-2. 이미지 빌드
```bash
$ docker build -t codyssey-workspace .
[+] Building ...
...
Successfully built 427c0bd977c6
Successfully tagged codyssey-workspace:latest

$ docker images
REPOSITORY             TAG       IMAGE ID       CREATED          SIZE
codyssey-workspace     latest    427c0bd977c6   ...              650MB

# 5-3. 컨테이너 실행 및 도구 검증
$ docker run -it --name my-workspace codyssey-workspace

root@0655daef7d49:/app# python3 --version
Python 3.10.12
root@0655daef7d49:/app# curl --version
curl 7.81.0 (x86_64-pc-linux-gnu) ...
root@0655daef7d49:/app# git --version
git version 2.34.1
root@0655daef7d49:/app# pip3 --version
pip 22.0.2 from /usr/lib/python3/dist-packages/pip (python 3.10)
root@0655daef7d49:/app# exit
exit
```

| 도구 | 버전 | 상태 |
|------|------|------|
| Python3 | 3.10.12 | ✅ |
| curl | 7.81.0 | ✅ |
| git | 2.34.1 | ✅ |
| pip3 | 22.0.2 | ✅ |

> ✅ 커스텀 이미지 빌드 및 도구 설치 정상 확인

---

### 6. 포트 매핑 접속

```bash
# 6-1. nginx 이미지 준비 및 컨테이너 실행
$ docker pull nginx
$ docker run -d -p 8080:80 --name web-8080 nginx   # 호스트 8080 → 컨테이너 80

$ docker ps                                          # Up 상태 확인
CONTAINER ID   IMAGE   COMMAND                  STATUS         PORTS                  NAMES
bd1901d45e0b   nginx   "/docker-entrypoint.…"   Up ...         0.0.0.0:8080->80/tcp   web-8080
```

```bash
# 6-2. 브라우저 접속 → http://localhost:8080
# 결과: "Welcome to nginx!" 페이지 정상 출력
# (스크린샷: ./images/스크린샷.png)
```

```bash
# 6-3. 접속 로그 확인
$ docker logs web-8080
...
2026/11/09 03:02:08 [notice] 1#1: nginx/1.31.8
2026/11/09 03:02:08 [notice] 1#1: start worker processes
172.17.0.1 - - [09/Nov/2026:03:04:37 +0000] "GET / HTTP/1.1" 200 896 ...   # 정상 응답 200
172.17.0.1 - - [09/Nov/2026:03:04:37 +0000] "GET /favicon.ico HTTP/1.1" 404 555 ...  # 아이콘 없음(정상)
```
> ✅ 브라우저 접속 기록 `GET / 200` 확인 → 포트 매핑 정상 동작

```bash
# 6-4. 리소스 상태 확인
$ docker stats --no-stream
CONTAINER ID   NAME       CPU %   MEM USAGE / LIMIT    NET I/O
bd1901d45e0b   web-8080   0.00%   25.25MiB / 15.25GiB  5.36kB / 4.25kB
```

| 항목 | 접속 전 | 접속 후 |
|------|---------|---------|
| NET I/O | 1.7kB / 126B | 5.36kB / 4.25kB |

> ✅ 접속 후 NET I/O 증가 → 실제 통신 발생 확인

### 7. 바인드 마운트


## 1. 호스트 파일 준비 (변경 전)
​```bash
# html 폴더 및 index.html 생성
$ cat html/index.html
<h1>Hello Bind Mount</h1>    # (※ 최초 작성 내용)
​```

### 2. 컨테이너 실행 (바인드 마운트)
​```bash
$ MSYS_NO_PATHCONV=1 docker run -d -p 8081:80 \
    -v "$(pwd)/html:/usr/share/nginx/html" \
    --name web-bind nginx
ecc24a3e4e63...    # 컨테이너 ID 출력
​```

## 3. 초기 상태 확인
​```bash
# 컨테이너 내부 파일 확인
$ MSYS_NO_PATHCONV=1 docker exec web-bind \
    cat /usr/share/nginx/html/index.html
<h1>Hello Bind Mount</h1>
​```
→ 브라우저 http://localhost:8081 : "Hello Bind Mount" 표시

---

## 4. 호스트에서 파일 수정 (변경 발생)
​```bash
# 호스트의 index.html 내용을 변경
$ echo '<h1>Updated!</h1>' > html/index.html

# 호스트 파일 확인
$ cat html/index.html
<h1>Updated!</h1>
​```

## 5. 변경 후 컨테이너 반영 확인
​```bash
# 컨테이너 재시작/재빌드 없이 그대로 확인
$ MSYS_NO_PATHCONV=1 docker exec web-bind \
    cat /usr/share/nginx/html/index.html
<h1>Updated!</h1>
​```
→ 브라우저 새로고침(Ctrl+Shift+R) : "Updated!" 표시


### 변경 전/후 비교

| 구분 | 호스트 (html/index.html) | 컨테이너 내부 | 브라우저 |
|------|--------------------------|----------------|-----------|
| 변경 전 | `<h1>Hello Bind Mount</h1>` | 동일 | Hello Bind Mount |
| 변경 후 | `<h1>Updated!</h1>` | **자동 반영** | Updated! |

### 결론
- 컨테이너를 **재시작하지 않고도** 호스트 파일 수정이 즉시 반영됨
- 바인드 마운트가 호스트↔컨테이너를 실시간으로 연결함을 확인 ✔
---

### 8. 볼륨 영속성

Docker 볼륨을 생성하고 컨테이너에 연결한 뒤, **컨테이너를 삭제해도 데이터가 유지되는지** 검증한다.

#### ① 볼륨 생성 및 확인
```bash
$ docker volume create myvolume
myvolume

$ docker volume ls
DRIVER    VOLUME NAME
local     myvolume
```

#### ② 볼륨 연결 컨테이너 실행 & 데이터 쓰기
```bash
$ docker run -it --name vol-test2 -v myvolume:/data ubuntu bash
root@94b034b01b18:/# echo "persistent data" > /data/test.txt
root@94b034b01b18:/# cat /data/test.txt
persistent data
root@94b034b01b18:/# exit
```
> `-v myvolume:/data` : 볼륨 `myvolume`을 컨테이너 내부 `/data`에 마운트

#### ③ 컨테이너 삭제 (삭제 전/후 비교)
```bash
$ docker rm vol-test2
vol-test2

$ docker ps -a    # 목록에서 vol-test2 사라짐 확인
```

#### ④ 새 컨테이너에 같은 볼륨 연결 → 데이터 생존 검증
```bash
$ docker run -it --name vol-check -v myvolume:/data ubuntu bash
root@aa888e4323f2:/# cat /data/test.txt
persistent data          # ← 데이터 유지됨!
root@aa888e4323f2:/# exit
```

#### ✅ 결과
- 기존 컨테이너(`vol-test2`)를 삭제하고 **완전히 새로운 컨테이너**(`vol-check`)를 생성했음에도
  볼륨에 저장한 `persistent data`가 그대로 유지됨
- **컨테이너는 일회용이지만, 볼륨은 영구 저장소**임을 확인

| 구분 | 바인드 마운트 | 볼륨 |
|------|-------------|------|
| 저장 위치 | 호스트 지정 폴더 | Docker 관리 영역 |
| 용도 | 개발/소스코드 수정 | 데이터 영구 보관 |

### 9. Git 설정 + GitHub 연동

#### 9-1. Git 사용자 정보 설정
```bash
$ git config --global user.name "이**"
$ git config --global user.email "dl******@gmail.com"
```
> 커밋 작성자 정보 등록. `--global`로 전체 저장소에 공통 적용.

#### 9-2. 기본 브랜치 설정
```bash
$ git config --global init.defaultBranch main
```
> 새 저장소 생성 시 기본 브랜치를 `main`으로 지정.

#### 9-3. 설정 확인
```bash
$ git config --list
...
init.defaultbranch=master
user.name=이**
user.email=dl******@gmail.com
init.defaultbranch=main
...
```
> 사용자 정보와 기본 브랜치 설정이 정상 반영됨을 확인.
> (`init.defaultbranch`가 두 번 보이지만, 나중 값인 `main`이 최종 적용됨)

#### 9-4. VSCode 실행 및 GitHub 저장소 연동
```bash
$ code .              # 현재 폴더를 VSCode로 열기
$ git remote -v       # 원격 저장소 연결 확인
origin  https://github.com/jsk-17/codyssey_E1-1.git (fetch)
origin  https://github.com/jsk-17/codyssey_E1-1.git (push)
```
> 로컬 저장소가 원격(origin)에 정상 연결됨을 확인.

## 5) 검증 방법 및 결과 위치

| 항목 | 검증 명령 | 결과 위치 |
|---|---|---|
| Docker 설치 | `docker --version` | 3단계 로그 |
| Docker 데몬 | `docker info` | 3단계 로그 |
| hello-world | `docker run hello-world` | 4단계 로그 |
| 이미지 목록 | `docker images` | 4단계 로그 |
| 컨테이너 목록 | `docker ps -a` | 4단계 로그 |
| 포트 매핑 | 브라우저 접속 화면 | 6단계 로그/스크린샷 |
| 볼륨 영속성 | 컨테이너 삭제 전/후 비교 | 8단계 로그 (예정) |

---

## 6) 트러블슈팅

### TS-1. Windows Git Bash에서 chmod 미반영
| 항목 | 내용 |
|---|---|
| **문제** | `chmod 755 test.txt` 실행 후 `ls -l`로 확인해도 권한이 변경되지 않음 |
| **원인** | Windows NTFS 파일시스템은 리눅스 권한 체계(rwx)를 지원하지 않아 Git Bash의 chmod가 무시됨 |
| **확인** | `ls -l` 반복 실행 → 권한 숫자 변화 없음 |
| **대안** | Docker ubuntu 컨테이너 내부(리눅스 환경)에서 chmod 재실습 → 정상 반영 확인 (2단계 참고) |

### TS-2. 바인드 마운트 후 브라우저에 변경사항이 반영되지 않음

**문제**
- 컨테이너는 정상 생성됨 (ID 출력됨)
- docker exec로 파일을 확인하려 하면 아래 에러 발생
```code
cat: 'C:/Program Files/Git/usr/share/nginx/html/index.html':
No such file or directory
```
**원인**
처음엔 -v 옵션의 공백 누락을 의심했으나,
에러 메시지의 경로가 컨테이너 경로(/usr/share/...)가 아니라
C:/Program Files/Git/usr/share/... 로 바뀐 것을 확인
MSYS(Git Bash) 환경이 유닉스식 절대 경로(/usr/...)를
윈도우 경로로 자동 변환(path conversion)하는 것이 원인

**확인**
에러에 찍힌 경로가 윈도우 경로로 치환되어 있음을 확인
-v 와 exec의 컨테이너 측 경로가 모두 변환되어 엉뚱한 위치를 가리킴

**대안**
경로 변환을 비활성화하는 환경변수 MSYS_NO_PATHCONV=1 를 명령 앞에 붙임

---
