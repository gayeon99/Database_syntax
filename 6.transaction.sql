-- author 테이블에 post_count 컬럼 추가
alter table author add column post_count int default 0;

-- post에 글쓴 후에, author 테이블에 post_count 값에 +1을 시키는 트랜잭션 테스트
-- auto_increment 안해둔 id 는 실패한다.
start transaction;
update author set post_count = post_count + 1 where id = 3;
insert into post(title, contents, author_id) values('hello java', 'hello java is ...', 3);

commit; -- 또는 rollback;

-- 위 transaction은 실패 시 자동으로 rollback 어려움
-- stored 프로시저를 활용하여 자동화된 rollback 프로그래밍
DELIMITER //  <- 시작점
CREATE PROCEDURE Transaction_Test()
BEGIN
    DECLARE exit handler for SQLEXCEPTION <- 에러가 나는 경우에만
    BEGIN
        ROLLBACK;
    END;
    start transaction;
    update author set post_count = post_count + 1 where id = 3;
    insert into post(title, contents, author_id) values('hello java', 'hello java is ...', 3);
    commit; -- 또는 rollback
END //
DELIMITER ;

-- 프로시저 호출
CALL Transaction_Test();

-- 사용자에게 입력받을 수 있는 프로시저 생성
DELIMITER //
CREATE PROCEDURE Transaction_Test2(in titleInput varchar(255), in contentsInput varchar(255), int idInput bigint)
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    start transaction;
    update author set post_count = post_count+1 where id = 3;
    insert into post(title, contents, author_id) values(titleInput, contentsInput, idInput);
    commit;
END //
DELIMITER ;