# 덤프파일 생성 : dumpfile.sql 이라는 이름의 덤프파일 생성
mysqldump -u root -p board > dumpfile.sql
# 한글 깨질때
mysqldump -u root -p board -r dumpfile.sql
# 덤프파일 적용(복원)
# < 가 특수문자로 인식되어, window에서는 적용이 안될 경우, git bash 터미널 창을 이용
mysql -u root -p board < dumpfile.sql

# dump 파일을 github에 업로드
# 리눅스에서 mariadb 설치
sudo apt-get install mariadb-server=
# mariadb 서버 실행
sudo systemctl start mariadb
# mariadb 접속 : 1234
sudo mariadb -u root -p
create database board;
# git 설치
sudo apt install git
# git에서 repository clone -> cd에서 진행
git clone https://github.com/gayeon99/Database_syntax

# 복원 -> database_syntax 폴더 안에서 해야함
mysql -u root -p board < dumpfile.sql