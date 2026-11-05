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
- [ ] 4. Docker 기본 운영 (hello-world, ubuntu)
- [ ] 5. Dockerfile 빌드/실행
- [ ] 6. 포트 매핑 접속 (2회)
- [ ] 7. 바인드 마운트 반영
- [ ] 8. 볼륨 영속성
- [ ] 9. Git 설정 + GitHub 연동

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

*(진행 예정)*

---

### 6. 포트 매핑 접속

*(진행 예정)*

---

### 7. 바인드 마운트

*(진행 예정)*

---

### 8. 볼륨 영속성

*(진행 예정)*

---

### 9. Git 설정 + GitHub 연동

*(진행 예정)*

---

## 5) 검증 방법 및 결과 위치

| 항목 | 검증 명령 | 결과 위치 |
|---|---|---|
| Docker 설치 | `docker --version` | 3단계 로그 |
| Docker 데몬 | `docker info` | 3단계 로그 |
| hello-world | `docker run hello-world` | 4단계 로그 (예정) |
| 이미지 목록 | `docker images` | 4단계 로그 (예정) |
| 컨테이너 목록 | `docker ps -a` | 4단계 로그 (예정) |
| 포트 매핑 | 브라우저 접속 화면 | 6단계 스크린샷 (예정) |
| 볼륨 영속성 | 컨테이너 삭제 전/후 비교 | 8단계 로그 (예정) |

---

## 6) 트러블슈팅

### TS-1. Windows Git Bash에서 chmod 미반영
| 항목 | 내용 |
|---|---|
| **문제** | `chmod 755 test.txt` 실행 후 `ls -l`로 확인해도 권한이 변경되지 않음 |
| **원인 가설** | Windows NTFS 파일시스템은 리눅스 권한 체계(rwx)를 지원하지 않아 Git Bash의 chmod가 무시됨 |
| **확인** | `ls -l` 반복 실행 → 권한 숫자 변화 없음 |
| **해결/대안** | Docker ubuntu 컨테이너 내부(리눅스 환경)에서 chmod 재실습 → 정상 반영 확인 (2단계 참고) |

---
