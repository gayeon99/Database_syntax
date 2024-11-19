-- tunyint는 -127~128까지 표현 (1byte 할당)
-- author 테이블에 age 컬럼 추가
alter table author add column age tinyint;
-- data insert 테스트 : 200살 insert
insert into author(id, name, age) values(7, 'old', 200); -> out of range 라는 오류 문구가 뜸
alter table author modify column age tinyint unsigned; -> unsigned을 활용하면 양수만 사용

-- decimal 실습
-- decimal (정수부자릿수, 소수부자릿수)
-- alter table post add column price decimal(10,3)

-- decimal 소수점 초과 후 값 짤림 현상
insert into post (id, title, price) values(2, 'java programming', 10.34122);'

-- 문자열 실습
alter table author add column self_introduction text;
insert into author(id, self_introduction) values(7, '안녕하세요.추가연입니다.');

-- blob(바이너리데이터) 실습
alter table author add column profile_image longblob; -> longblob 이라는 문자형
insert into author(id, profile_image) values(8, LOAD_FILE('파일경로'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role  컬럼 추가
-- default 'user' -> 아무것도 값을 입력하지 않으면 user 가 된다.
alter table author add column role enum('user', 'admin') not null default 'user';
-- user값 세팅 후 insert
insert into author(id, role) values(10,'user');
-- users값 세팅 후 insert(잘못된값
insert into author(id,role) values(11, 'users');
-- 아무것도 안넣고 insert(default 값)
insert into author(id,name,email) values (12,'kill','1234@naver.com');

-- date : 날짜, datetime : 날짜 및 시분초(microseconds)
-- datetime은 입력, 수정, 조회 시에 문자열 형식을 활용
alter table post add column created_time datetime default current_timestamp();
update post set created_time = '2024-11-18 19:12:16' where id =3;

-- 조회시 비교 연산자
select * from author where id >= 2 and id <=4;
select * from author where id between 2 and 4; --위 구문과 같은 구문
select * from author where id not(id<2 or id>4);
select * from author where id in (2,3,4); --in : 2,3,4에 해당되는 값
select * from author where id not in (1,5); --전체 데이터가 1-5밖에 없을때, 234를 뽑고 싶을때
select author.id, author.name from author where id in(select author_id from post);

-- like : 특정 문자를 포함하는 데이터를 조회하기 위해 사용하는 키워드
select * from where title likg '%h'; --h로 끝나는 title 검색
select * from where title likg 'h%'; --h로 시작하는 title 검색
select * from post where title like '%h%'; --단어 중간에 있는 h title 검색

-- regexp : 정규 표현식을 활용한 조회
-- not regexp 도 활용 가능
select * from post where title regexp '[a-z]'; -- [a-z] 하나라도 알파벳 소문자가 들어있으면
select * from post where title not regexp '[a-z]'; -- [a-z] 하나라도 알파벳 소문자가 들어있지 않으면 
select * from post where title regexp '[가-힣]'; -- [가-힣] 하나라도 한글이 포함돼 있으면

-- 날짜변환 cast, convert : 숫자 -> 날씨 , 문자 -> 날씨
-- 문자 => 숫자 변환
select cast(20241119 as date);
select cast('20241119' as date);
select convert(20241119 as date);
select convert(2;0241119; as date);
-- 문자 => 숫자 변환
select cast ('12', int);
select cast ('12', unsigned);

-- 날짜 조회 방법
-- like 패턴, 부등호 활용
select * from post where created_time like '2024-11%'; --문자열처럼 조회
select * from post where created_time >= '2024-01-01' and created_time < '2025-01-01'; -- 뒤에 시간 안붙이면 0시0분 부터 인식함

-- date format 활용
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H:%i:%s') from post;
select * from post where date_format(created_time, '%Y')='2024';
select * from post where cast(date_format(created_time, '%Y')='2024' as unsigned)=2024;

-- 오늘 현재 시간
select now();