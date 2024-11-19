-- insert into : 테이블에 데이터 삽입
insert into 테이블명(컬럼명1, 컬럼명2, 컬럼명3) values(데이터1, 데이터2, 데이터3);
-- 문자열은 일반적으로 작은 따옴표 ''를 사용
insert into author(id, name, email) values(3, 'kim', 'kim@naver.com');

-- select : 데이터조회, * : 모든 컬럼을 의미
select * from author;
select name, email, from author; ; //원하는 컬럼만 뽑아서 확인하기, csv로 저장하면 excel에서 확인 가능

-- post 데이터 1줄 추가
insert into post(id, title, contents) values(1,'hello', 'hello...');
insert into post(id, title, contents, author_id) values(1,'hello', 'hello...', 3);

-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name = 'post';

-- insert 문을 통해 author 데이터 2개 정도 추가, post 데이터 2개 정도 추가(1개는 익명)

-- update : 데이터 수정 -- update 테이블명 컬럼명 where 로우(행)값
-- where문을 빠뜨리게 될 경우, 모든 데이터에 update문이 실행됨에 유의.
update author set name='홍길동' where id=1;
update author set name='홍길동2', email='hongildong@naver.com' where id=2;

-- delete : 데이터 삭지
-- where 조건을 생략한 경우 모든 데이터가 삭제됨에 유의
delete from author where id = 5;

-- select : 조회
select * from author; -- 어떠한 조회 조건 없이 모든 컬럼 조회
select * from author where id=1; --where 뒤에 조회 조건을 통해 조회 id 값은 pk라서 1명만 조회됨
select * from author where name='hongildong'; --name이 홍길동인 사람만 조회 -> 1명만 조회된다는 보장 없음
select * from author where id>=3; --3이상 확인
select * from author where id>2 and name='kim'; --또는 일 경우에는 or를 사용하면 됨.

-- distinct : 중복제거 조회
select name from author;
select distinct name from author;

-- 정렬 : order by + 컬럼명
-- 아무런 정렬조건 없이 조회할 경우에는 pk 기준으로 오름차순 정렬
-- asc : 오름차순, desc : 내림차순
select* from author order by name desc; --asc 안적으면 자동으로 오름차순

-- 멀티컬럼 order by : 여러 컬럼으로 정렬, 먼저 쓴 컬럼 우선 정렬. 중복 시, 그 다음 정렬 옵션 적용.
select* from author order by name desc, email asc;
 --name으로 먼저 정렬 후, name이 중복되면 email로 정렬 / 대소문자 구분이 없는 듯 함

--  결과값 갯수 제한
select * from author order by id desc limit 2;

-- 별칭(alias)을 이용한 select
select name as '이름', email as '이메일';
select a.name, a.email from author as a; -- table도 별칭을 붙일 수 있음
select a.name, a.email from author a; -- as를 생략할 수도 있음

-- null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null;

-- 프로그래머스 sql 문제풀이
-- 여러 기준을 정렬하기
-- 상위 n개 레코드