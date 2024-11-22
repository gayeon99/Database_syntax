-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만 반환. on 조건을 통해 교집합찾기
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
-- 출력순서만 달라질 뿐 조회결과는 동일.
-- post의 글쓴이가 없는 데이터는 포함되지 않으며 글쓴이 중에 글을 한번도 안쓴 사람도 포함되지 않는다.
select * from post p inner join author a on a.id=p.author_id;
-- 글쓴이가 있는 글 목록과 글쓴이의 이메일을 출력하시오.
select p.*, a.email from post p inner join author a on a.id=p.author_id order by a.id;
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이메일을 출력하시오.
select p.title, p.contents, a.email from post p inner join author a on a.id=p.author_id order by a.id;

-- 모든 글 목록을 출력하고, 만약에 글쓴이가 있다면 이메일 정보를 출력.
-- left outer join -> left join 으로 생략 가능
-- 글을 한번도 안 쓴 글쓴이 정보는 포함되지 않음
select p.*, if(p.author_id!=null,a.email,null) from post p left join author a on a.id=p.author_id;

-- 글쓴이를 기준으로 left join 할 경우, 글쓴이가 n개의 글을 쓸 수 있으므로 같은 글쓴이가 여러번 출력될 수 있음
-- author와 post가 1:N 관계이므로,
-- 글쓴이가 없는 글은 포함되지 않는다.
select * from author a left join post p on a.id=p.author_id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 email 만을 출력하되,
-- 저자의 나이가 30세 이상인 글만 출력.
select p.title, a.email, a.age from author a inner join post p on a.id=p.author_id
	where a.age>=30;    

-- 실습) 글의 내용과 글의 저자의 이름이 있는(NOT NULL), 글 목록(P.*)을 출력하되 24년 6월 이후에 만들어진 글만 출력.
select p.* from post p left join author a on a.id=p.author_id
    not null and p.contents is not null and date_format(p.created_time,'%Y-%m-%d')>='2024-06-01';

-- 조건에 맞는 도서와 저자 리스트 출력하기
SELECT b.BOOK_ID as BOOK_ID, a.AUTHOR_NAME as AUTHOR_NAME, date_format(b.PUBLISHED_DATE,'%Y-%m-%d') as PUBLISHED_DATE
    from BOOK b inner join AUTHOR a on b.AUTHOR_ID=a.AUTHOR_ID
    where b.CATEGORY = '경제' order by PUBLISHED_DATE;

-- union : 두 테이블의 select 결과를 횡으로 결합(기본적으로 distinct 적용)
-- 컬럼의 개수와 컬럼의 타입이 같아야함에 유의
-- union all : 중복까지 포함
select name, email from author union select title, contents from post;

-- 서브쿼리 : select 문 안에 또 다른 select 문을 서브쿼리라고 한다.
-- where 절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 목록 조회
select distinct * from author a inner post p on a_id=p.author_id;
select * from author where id =(select author_id from post);

-- select 절 안에 서브쿼리
-- author의 email과 author 별로 본인이 쓴 글의 개수를 출력
select a.id, a.email, (select count(*) from post p where p.author_id=a.id) as post_count from author a order by a.id;

-- from 절 안에 서브쿼리    
select a.name from ( select * from author) as a;

-- 없어진 기록 찾기
-- 서브쿼리
-- 코드를 입력하세요
SELECT OUTS.ANIMAL_ID, OUTS.NAME FROM ANIMAL_OUTS AS OUTS
    WHERE OUTS.ANIMAL_ID NOT IN (SELECT INS.ANIMAL_ID FROM ANIMAL_INS AS INS);

-- 집계함수 (null은 count에서 제외된다)
select coutn(*) from author;
select sum(price) from post;
select avg(price) from post;
-- 소수점 첫 번째 자리에서 반올림해서 소수점을 없앰
select round(avg(price), 0) from post;

-- group by : 그룹화된 데이터를 하나의 행(row)처럼 취급
-- author_id로 그룹핑 하였으면, 그외의 컬럼을 조회하는 것은 적절치 않음
select author_id from post group by author_id;

-- group by와 집계함수
-- 아래 쿼리에서 *은 그룹화된 데이터 내에서의 개수
select author_id, count(*) from post group by author_id;
select author_id, count(id), sum(price) from post group by author_id;

-- author의 email과 author 별로 본인이 쓴 글의 개수를 출력
select a.id, a.email, (select count(*) from post p where p.author_id=a.id) as post_count from author a order by a.id;
-- join과 group by, 집계함수를 활용한 글의 개수 출력
select author.id, author.name, author.email, count(post.id) as post_count from author
	left join post on author.id=post.author_id
	group by author.name order by author.id;

-- where와 group by
-- 연도별 post 글의 개수 출력, 연도가 null인 값은 제외
select date_format(created_time, '%Y') as year, count(id) as post_count from post
	where created_time is not null group by year
    order by year desc;

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- 입양 시각 구하기(1)

-- having : group by를 통해 나온 집계값에 대한 조건
-- 글을 2개 이상 쓴 사람에 대한 정보 조회
select author_id from post group by author_id having count(*)>=2;
select author_id, count(*) as count from post group by author_id having count>=2;

--동명 동물 수 찾기
select NAME, count(*) as COUNT from ANIMAL_INS 
where NAME is not null group by NAME having  count>=2 order by name;

-- 다중열 group by
-- post에서 작성자가 만든 제목의 개수를 출력하시오.
select author_id, title, count(*) from post group by author_id, title;

-- 재구매가 일어난 상품과 회원 리스트 구하기
select user_id, product_id from ONLINE_SALE 
group by user_id, product_id having count(*)>= 2 
order by user_id asc, product_id desc;
