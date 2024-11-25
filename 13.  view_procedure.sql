-- view : 실제 데이터를 참조만 하는 가상의 테이블
-- 사용 목적 : ) 복잡한 퀘리 대신 2)테이블의 컬럼까지 권한 분리

-- view 생성
create view author_for_marketing as select name, email from author where rold != admin;

-- view 조회
select * from author_for_marketing;

-- view 권한 부여
grant select on board.author_for_marketing to '계정명'@'localhost';

-- view 삭제
drop view author_for_marketing;

-- 프로시저 생성 (프로그래밍이 가능하다) / transaction은 commit/rollback 두개의 값 반환을 보장 이건 보장의 개념이 아닌 그냥 함수의 개념
DELIMITER //
create procedure hello_procedure()
BEGIN
    select 'hello world';
END
// DELIMITER ;

-- 프로시저 호출;
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure;

-- 게시글 목록 조회 프로시저 생성
DELIMITER //
create procedure 게시글목록조회()
BEGIN
    select * from post;
END
// DELIMITER ;

call 게시글목록조회();

-- 게시글 id 단건 조회
DELIMITER //
create procedure 게시글id단건조회(in post_id bigint)
BEGIN
    select * from post p where p.post_id = post_id;
END
// DELIMITER ;

call 게시글id단건조회(1);

-- 본인이 쓴 글 목록조회 본인의 이메일을 입력값으로 조회 / 목록조회 결과는 * all
DELIMITER //
create procedure post_secure_by_email(in user_email varchar(255))
BEGIN
    select p.* from post p inner join author_post ap
        on p.post_id=ap.author_post_id
        inner join author a on a.id=ap.author_id
        where a.email = user_email;
END
// DELIMITER ;

call post_secure_by_email(first@naver.com);


-- 글쓰기
DELIMITER //
create procedure write_by_email(in inputTitle varchar(255),in inputContents varchar(255), in inputEmail varchar(255))
BEGIN
    declare authorID bigint;
    declare postID bigint;
    -- post 테이블에 insert
    insert into post(title, contents) values (inputTitle, inputContents);
    select id into postID from post order by id desc limit 1;
    select id into authorID from author where email=inputEmail;
    -- author_post 테이블에 insert : author_id, post_id
    insert into author_post(author_id, post_id) values(authorID, postID);
END
// DELIMITER ;


-- 글삭제 : 입력값으로 글 id, 본인 email 
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_by_email`(in inputPost_ID bigint, in inputEmail varchar(255))
BEGIN
    declare authorPostCount bigint;
    declare authorID bigint;
    select count(*) into authorPostCount from author_post where author_post_id = inputPost_ID;
	select id into authorID from author where email = inputEmail;
    if authorPostCount >= 2 then
        delete from author_post where author_id = authorID && post_id = inputPost_ID;
    else
        delete from author_post where author_id = authorID;
        delete from post where post_id = inputPost_ID;
    end if;
END
// DELIMITER ;


-- 반복문을 통해 post 대량 생성 : title, 글쓴이 email
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE post_cloneemail`(in inputPost_ID bigint, in inputEmail varchar(255))
BEGIN
    declare countValue int default 0;
    declare postID bigint;
    declare authorID bigint;
    while countValue<count
        -- post 테이블에 insert
        insert into post(title) values ('안녕하세요');
        select id into postID from post order by id desc limit 1;
        select id into authorID from author where email=inputEmail;
        insert into author_post(author_id,post_id) values (authorID,postID)
        set countValue=countValue+1
    end while;
END
// DELIMITER ;

-- 반복문을 통해 post대량 생성: title, 글쓴이email
DELIMITER //
create procedure 글도배(in count int, in inputEmail varchar(255))
begin
    declare countValue int default 0;
    declare authorId bigint;
    declare postId bigint;
    while count > countValue do
        insert into post(title) values("안녕하세요 ㅎ2ㅎ2");
        select id into postId from post order by id desc limit 1;
        select id into authorId from author where email = inputEmail;  

        insert into author_post(author_id, post_id) values(authorId,postId);
        set countValue = countValue +1 ;
    end while;
end
// DELIMITER ;