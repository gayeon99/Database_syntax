# 덤프파일 생성 : dumpfile.sql 이라는 이름의 덤프파일 생성
mysqldump -u root -p board > dumpfile.sql
# 한글 깨질때
mysqldump -u root -p board -r dumpfile.sql
# 덤프파일 적용(복원)
mysqldump -u root -p board < dumpfile.sql