-- DB와 table 생성
create database order_db;
use order_db;

create table user
(
	id bigint not null primary key auto_increment,
    name varchar(255),
    email varchar(255),
    credit varchar(255),
    role enum('user', 'shop') not null default 'user',
    created_time datetime default current_timestamp
);

create table product
(
	id bigint not null primary key auto_increment,
    shop_id bigint not null,
    name varchar(255),
    stock int not null,
    price int not null,
    contents varchar(3000),
    created_time datetime default current_timestamp,
    foreign key(shop_id) references user(id)
);
create table order_list
(
	id bigint not null primary key auto_increment,
    product_id bigint not null,
    num int not null,
    created_time datetime default current_timestamp,
    foreign key(product_id) references product(id)
);
create table user_order
(
	id bigint not null primary key auto_increment,
    user_id bigint not null,
    list_id bigint not null,
    foreign key(user_id) references user(id),
    foreign key(list_id) references product(id)
);
create table address
(
	address_id bigint not null primary key auto_increment,
    user_id bigint not null,
    country varchar(255),
    city varchar(255),
    street varchar(255),
    foreign key(user_id) references user(id)
);

-- insert
-- user 입력
insert into user(name,email,credit,role) values ('진영','jinyoung@gmail.com','110-212-12312','shop');
insert into user(name,email,credit,role) values ('가연','gayeon@gmail.com','110-215-12212','shop');
insert into user(name,email,credit,role) values ('shopper1','shopper1@gmail.com','110-101-12312','shop');
insert into user(name,email,credit) values ('user1','user1@gmail.com','110-111-11111');
insert into user(name,email,credit) values ('user2','user2@gmail.com','110-112-11111');
insert into user(name,email,credit) values ('user3','user3@gmail.com','110-113-11111');
insert into user(name,email,credit) values ('user4','user4@gmail.com','110-114-11111');
insert into user(name,email,credit) values ('user5','user5@gmail.com','110-115-11111');
-- address 입력
insert into address(user_id,country,city,street) values (1,'한국','제주','제주아일랜드');
insert into address(user_id,country,city,street) values (2,'한국','성남','분당구');
insert into address(user_id,country,city,street) values (3,'한국','서울','동작구');
insert into address(user_id,country,city,street) values (4,'한국','서울','강남구');
insert into address(user_id,country,city,street) values (5,'한국','인천','송도');
insert into address(user_id,country,city,street) values (6,'한국','여수','여수밤바다');
insert into address(user_id,country,city,street) values (7,'한국','부산','해운대');
insert into address(user_id,country,city,street) values (8,'미국','켈리포니아','LA');
-- product 입력
insert into product(shop_id,name,stock,price,contents) values (1,'제주도 감귤',110,10000,'제주도에서 올라온 따끈따끈한 감귤');
insert into product(shop_id,name,stock,price,contents) values (1,'나주 배',10,5000,'마감임박 떨이');
insert into product(shop_id,name,stock,price,contents) values (2,'커피캔10병한묶음',30,6000,'잠 깨는데에 탁월하지 않은 커피');
insert into product(shop_id,name,stock,price,contents) values (3,'모스카츠',3000,15000,'현재 1000원 할인중');
insert into product(shop_id,name,stock,price,contents) values (2,'아이셔',4000,500,'나는 잠이 오지 않는다');
insert into product(shop_id,name,stock,price,contents) values (1,'청송사과',70,20000,'새빨간 사과애용');
insert into product(shop_id,name,stock,price,contents) values (2,'따뜻한정수기물',23,100,'정수기에서 떠온 물');
insert into product(shop_id,name,stock,price,contents) values (3,'가츠디나인',5,16500,'모스카츠보다 맛있더라');
insert into product(shop_id,name,stock,price,contents) values (2,'이어폰',5,5500,'음악은 나라가 허락한...');
-- order_list 입력
insert order_list(product_id, num) values (1,12);
insert order_list(product_id, num) values (2,4);
insert order_list(product_id, num) values (3,5);
insert order_list(product_id, num) values (4,39);
insert order_list(product_id, num) values (5,10);
insert order_list(product_id, num) values (6,40);
insert order_list(product_id, num) values (8,1);
-- user_order 입력
insert user_order(user_id, list_id) values (4,1);
insert user_order(user_id, list_id) values (4,2);
insert user_order(user_id, list_id) values (6,3);
insert user_order(user_id, list_id) values (7,4);
insert user_order(user_id, list_id) values (5,5);
insert user_order(user_id, list_id) values (5,6);
insert user_order(user_id, list_id) values (5,7);

-- 상품 한번에 주문하기 위한 검색
-- 2개 이상의 상품을 주문한 사람 id + 주문 개수 검색
select uo.user_id as user_id, count(*) as count from user_order uo
	left join order_list ol on uo.list_id=ol.id
	group by uo.user_id having count(uo.user_id)>=2 order by uo.user_id;
-- 사람 id를 통해 주문 리스트 내역 출력
select uo.user_id as user_id, uo.list_id as list_id, ol.product_id, p.name, ol.num from user_order uo
	left join order_list ol on uo.list_id=ol.id
	left join product p on ol.product_id=p.id
	where uo.user_id=4;


-- 현재 문제점
-- 사용자가 address 여러개 만들 수 있다
-- 주문 내역에 address를 넣자
-- 주문번호 pk와 order detail 과 같은 pk 이용 가능 -> 이거 활용하면 논리 선이 반대로 되는게 이해가 감
