create database MechKeyStore;
use MechKeyStore;

create table product (
	product_id int primary key auto_increment,
    product_name varchar(100) not null,
    manufacturer varchar(100) not null,
    price decimal(10, 2) not null,
    stock int default 0
);

create table customer (
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    email varchar(50) not null unique,
    phone varchar(15) unique,
    address varchar(100)
);

create table orders (
	orders_id int primary key auto_increment,
    orders_date date default(current_date),
    orders_total decimal(10, 2),
    customer_id int,
    foreign key (customer_id) references customer(customer_id)
);

create table order_detail (
	orders_id int,
    foreign key (orders_id) references orders(orders_id),
    product_id int,
    foreign key (product_id) references product(product_id),
	primary key (orders_id, product_id),
    quantity int not null,
    price_at_time decimal(10, 2)
);
-- Thêm cột category (kiểu chuỗi - ví dụ: 'Keyboard', 'Switch', 'Keycap') vào bảng Product
alter table product
add category varchar(100);

-- Đổi tên cột Hãng sản xuất trong bảng Product thành tên khác cùng nghĩa.
alter table product
rename column manufacturer to factory;

-- Viết câu lệnh SQL để xóa bảng Order_Detail và bảng Orders
delete from order_detail;
delete from orders;

-- Thêm ít nhất 5 bản ghi hợp lệ cho mỗi bảng. Dữ liệu cần có sự liên kết logic thông qua các khóa ngoại
insert into customer (customer_name, email, phone, address)
values
('Nguyễn A', 'a@gmail.com', '01478523690', 'HCM'),
('Lê B', 'b@gmail.com', '0147258369', 'HN'),
('Trần C', 'c@gmail.com', '0123654789', 'DN'),
('Hoàng D', 'd@gmail.com', '0987456321', 'HCM'),
('Vũ H', 'h@gmail.com', '0963258741', 'HN');

insert into orders (orders_total, customer_id)
values
(3250000, 4),
(800000, 1),
(800000, 2),
(1800000, 3),
(1900000, 5),
(9000000, 5);

insert into product (product_name, factory, price, stock, category)
values
('Aula L99', 'Aula', 1900000, 12, 'Bàn phím'),
('Aula F75', 'Aula', 800000, 9, 'Bàn phím'),
('Akko Mode 007B', 'Akko', 3250000, 14, 'Bàn phím'),
('Tay cầm chơi game', 'Apex', 1800000, 5, 'Phụ kiện'),
('Tai nghe Logitech G73', 'Logitech', 2400000, 18, 'Tai nghe');

insert into order_detail
values
(1, 3, 1, 3250000),
(5, 1, 1, 1900000),
(4, 4, 2, 1800000),
(2, 2, 1, 800000),
(3, 2, 1, 800000);

-- Tăng giá bán thêm 10% cho tất cả các sản phẩm thuộc thương hiệu 'Aula'.
set sql_safe_updates = 0;
update product
set price = price * 1.1
where factory = 'Aula';

-- Xóa thông tin những khách hàng chưa cung cấp địa chỉ.
delete  from customer
where address is not null;

--  Tìm tất cả các sản phẩm có đơn giá nằm trong khoảng từ 1.000.000 VNĐ đến 3.000.000 VNĐ.
select * from product
where price between 1000000 and 3000000;

-- Liệt kê danh sách các đơn hàng được thực hiện trong tháng 04 năm 2026.

-- Hiển thị danh sách các sản phẩm có tên chứa từ khóa 'Aula'.
select * from product
where product_name = 'Aula';

-- Lấy ra mã khách hàng và tổng tiền của những đơn hàng có tổng giá trị lớn hơn 5.000.000 VNĐ.
select customer_id, orders_total from orders
where orders_total > 5000000 ;

-- Hiển thị thông tin các sản phẩm có số lượng tồn kho dưới 10 sản phẩm để cửa hàng có kế hoạch nhập thêm.
select * from product
where stock < 10;