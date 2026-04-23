create database project_mini;
use project_mini;


CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    gender VARCHAR(10),
    birth_date DATE
);

CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE order_detail(
	order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT ,
    quantity_total INT,
    total_price INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    UNIQUE(order_id, product_id)

);


INSERT INTO customer (full_name, email, gender, birth_date)
VALUES
    ('Nguyễn Văn A', 'nguyenvana@gmail.com', '1', '1995-05-12'),
    ('Trần Thị B', 'tranthib@gmail.com', '0', '1998-10-25'),
    ('Lê Hoàng C', 'lehoangc@gmail.com', '1', '1990-02-28'),
    ('Phạm Mỹ D', 'phammyd@gmail.com', '0', '2001-08-15'),
    ('Đặng Đình E', 'dangdinhe@gmail.com', '1', '1985-11-03');


INSERT INTO category (category_name)
VALUES
    ('Điện thoại di động'),
    ('Máy tính xách tay'),
    ('Máy tính bảng'),
    ('Phụ kiện điện tử'),
    ('Thiết bị thông minh');


INSERT INTO product (product_name, price, category_id)
VALUES
    ('iPhone 15 Pro Max', 29990000.00, 1),
    ('MacBook Pro M3', 39990000.00, 2),
    ('iPad Air 5', 15490000.00, 3),
    ('Tai nghe AirPods Pro', 5500000.00, 4),
    ('Đồng hồ Apple Watch', 9500000.00, 5);


INSERT INTO orders (customer_id, order_date)
VALUES
    (1, '2026-01-10'),
    (2, '2026-02-14'),
    (1, '2026-03-05'), 
    (3, '2026-03-20'),
    (4, '2026-04-01');


INSERT INTO order_detail (order_id, product_id, quantity_total, total_price)
VALUES
    (1, 1, 1, 29990000),
    (1, 4, 2, 11000000), 
    (2, 2, 1, 39990000), 
    (3, 3, 1, 15490000), 
    (4, 5, 1, 9500000);  


-- Cập nhật giá bán cho một sản phẩm.
UPDATE product
SET price = 250000
where product_id = 1;


update customer 
set email = 'thienduc@gmail.com '
where customer_id = 6;

delete from 
order_detail where order_detail_id = 1;


select customer_id, full_name,
case 
when gender = 1 then 'Nam'
when gender = 0 then 'Nữ'
else 'khog xac dinh' 
end as gioi_tinh
from customer;

select customer_id, full_name , birth_date, (YEAR(NOW()) - YEAR(birth_date)) AS age
from customer
order by birth_date DESC
limit 3;

select  
	O.order_id,
    O.order_date,
    c.full_name,
    c.email
from Orders O
inner join customer C on o.customer_id = c.customer_id;










select 
	c.category_name as 'danh mục sản phẩm',
    count(p.product_id) as'số lượng sản phẩm'
from category c
inner join product p on c.category_id = p.category_id
group by  c.category_name
having COUNT(p.product_id) >=2;

select product_id , product_name
from product
where price > (select avg(price) from product);

select product_id , product_name
from product
where product_id not in (
	select customer_id
    from orders
);

SELECT 
    c.category_name, 
    SUM(od.total_price) AS doanh_thu_danh_muc
FROM category c
JOIN product p ON c.category_id = p.category_id
JOIN order_detail od ON p.product_id = od.product_id
GROUP BY c.category_id, c.category_name
HAVING doanh_thu_danh_muc > (
    -- Subquery: Tính doanh thu trung bình của mỗi danh mục rồi nhân 1.2 (tức là 120%)
    SELECT AVG(tong_thu_tung_danh_muc) * 1.2
    FROM (
        SELECT SUM(total_price) AS tong_thu_tung_danh_muc
        FROM order_detail od2
        JOIN product p2 ON od2.product_id = p2.product_id
        GROUP BY p2.category_id
    ) AS temp_table
);


SELECT 
    SP_Goc.product_name, 
    SP_Goc.price, 
    danhmuc.category_name
FROM product AS SP_Goc
JOIN category AS danhmuc ON SP_Goc.category_id = danhmuc.category_id
WHERE SP_Goc.price = (
    SELECT MAX(SP_SoSanh.price) 
    FROM product AS SP_SoSanh 
    WHERE SP_SoSanh.category_id = SP_Goc.category_id
);


SELECT DISTINCT 
    khachhang.full_name, 
    khachhang.email
FROM customer AS khachhang
WHERE khachhang.customer_id IN (
    SELECT donhang.customer_id 
    FROM orders AS donhang
    WHERE donhang.order_id IN (
        SELECT chitiet.order_id 
        FROM order_detail AS chitiet
        WHERE chitiet.product_id IN (
            SELECT sanpham.product_id 
            FROM product AS sanpham
            JOIN category AS loai ON sanpham.category_id = loai.category_id
            WHERE loai.category_name = 'Điện thoại di động'
        )
    )
);





