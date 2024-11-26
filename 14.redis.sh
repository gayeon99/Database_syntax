# redis 설치
sudo apt-get install redis-server

# redis 접속
redis-cli

# redis는 0-15번까지의 database로 구성(default는 0번 db)
# 데이터베이스 선택
select db번호

# 데이터베이스 내 모든 키 조회
keys *

# 일반적인 string 자료 구조
sey key명 value 값
# set을 통해 key:value 세팅. 맵에서 set은 이미 존재할 때 덮어쓰기
set user:email:1 hong1@naver.com
set user:email:1 hong

# nx: 이미 존재하면 pass, 없으면 set
set user:email:1 hong1@naver.com nx
# ex : 만료시간(초단위) -ttl(time to live) ->캐싱
set user:email:1 hong1@naver.com ex 10

# get을 통해 value 값 얻기
get user:email:1 

# 특정 key 삭제
del user:email:1
# 현재 DB 내 모든 key 삭제
flushdb

# redis 활용 예시 : 동시성 이슈
# 1. 좋아요 기능 구현
set likes:posting:1 0
    # 좋아요 눌렀을 경우
    incr likes:posting:1 #특정 key값의 value를 1만큼 증가
    decr likes:posting:1 #특정 key값의 value를 1만큼 감소
get likes:posting:1
# 2. 재고관리
set stocks:product:1 100
    decr stocks:product:1
get stocks:product:1]

# bash 쉘을 활용하여 재고감소 프로그램 작성

# redis 활용 예시 : 캐싱 긴으 구현
# 1번 author 회원 정보 조회
# select name, email, age from author whrer id-1;
# 위 데이터의 결과값을 redis로 캐싱 -> json 형식으로 저장 {"naem":"hong", "email":"hong@daum.net"}
set author:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 20

# list자료구조
# redis의 list는 java의 deque와 같은 자료구조, 즉 double-ended queue 구조

# lpush : 데이터를 왼쪽에 삽입
# rpush : 데이터를 오른쪽에 삽입
# lpop : 데이터를 왼쪽에서 꺼내기
# rpop : 데이터를 오른쪽에서 꺼내기
lpush hongildongs hong1
lpush hongildongs hong2
lpush hongildongs hong3
rpop hongildongs

# list조회
# -1은 list의 끝 자리를 의미. -2는 끝에서 2번째를 의미
lrange hongildongs 0 0 #-> =lpop 첫번째 값
lrange hongildongs -1 -1 #->rpop 마지막 값
lrange hongildongs 0 -1 #-> 처음부터 마지막
lrange hongildongs -3 -1 #-> 마지막 3개
lrange hongildongs 0 3 #-> 앞에서부터 3개

# 데이터 개수 조회
llen hongildongs
# ttl 적용
expire hongildongs 20
# ttl 조회
ttl hongildongs

# pop과 push를 동시에
# A리스트에서 pop 하여 B리스트로 push
rpoplpush A리스트 B리스트

# 최근 방문한 페이지
# 5개 정도 데이터 push
# 최근 방문한 페이지 3개만 보여주는
rpush mypages www.naver.com
rpush mypages www.google.com
rpush mypages www.daum.net
rpush mypages www.chatgpt.com
rpush mypages www.playdata.io
lrange mypages -3 -1

# set 자료구조 : 중복없음, 순서없음
sadd members member1
sadd members member2
sadd members member3

# set 조회
smembers memberlist
# set 멤버 개수 조회
scard memberlist
# set에서 멤버 삭제
srem memberlist member2
# 특정 멤버가 set 안에 있는지 존재여부 확인
sismember memberlist member1


# 좋아요 구현
sadd likes:posting:1 member1
sadd likes:posting:1 member2
sadd likes:posting:1 member3
sadd likes:posting:1 member4
scard likes:posting:1
sismember likes:posting:1 member1

# zset : sorted set
# 사이에 숫자는 score라고 불리고, score를 기준으로 정렬이 가능
zadd memberlist 3 member1
zadd memberlist 4 member2
zadd memberlist 1 member3
zadd memberlist 2 member4

# 조회방법
# score 기준 오름차순 정렬
zrange memberlist 0 -1
# score 기준 내림차순 정렬
zrevrange memberlist 0 -1

# zset 삭제
zrem memberlist member4

# zrank : 특정 멤버가 몇번째(index 기준) 순서인지 풀력
zrank memberlist member4

# 최근 본 상품목록 => zset을 활용해서 최근 시간 순으로 정렬
# zset도 set 이므로 같은 상품을 add 할 경우에 시간만 업데이트되고 중복이 제거
# 같은 상품을 더할 경우 시간만 마지막에 넣은 값으로 업데이트 (중복제거)
zadd recent:products 151930 apple
zadd recent:products 152030 banana
zadd recent:products 152130 orange
zadd recent:products 152930 apple
zadd recent:products 153030 apple
# 최근 본 상품목록 3개 조회
zrevrange recent:products 0 2 withscores

# hashes : map 형태의 자료구조(key:value key:value ... 형태의 자료구조)
hset author:info:1 name "hong" email "hong@naver.com" age 30
# 특정 값 조회
hget author:info:1 name
# 모든 객체값 조회
hgetall author:info:1

# 특정 요소값 수정
hset author:info:1 name kim