-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 08, 2021 lúc 07:12 AM
-- Phiên bản máy phục vụ: 10.4.17-MariaDB
-- Phiên bản PHP: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `computerstore`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `itemProduct` (IN `ngay` DATE, IN `masp` BIGINT(20))  begin
	select product.*, trademark_name, product_type_name, 
	(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id) as promotion_level,
	(select image from product_image where product_image.product_id = product.product_id and image is not null) as image,
	(price*(1-(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id and promotion_date.date is not null)/100)) as price_new
	from product, trademark, product_type
	where product.product_type_id = product_type.product_type_id
	and product.trademark_id = trademark.trademark_id and product.product_id = masp;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listProduct` (IN `ngay` DATE)  begin
	select product.*, trademark_name, product_type_name, 
	(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id) as promotion_level,
	(select image from product_image where product_image.product_id = product.product_id and image is not null) as image,
	(price*(1-(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id and promotion_date.date is not null)/100)) as price_new
	from product, trademark, product_type
	where product.product_type_id = product_type.product_type_id
	and product.trademark_id = trademark.trademark_id;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `account`
--

CREATE TABLE `account` (
  `account_id` int(11) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` int(10) NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_type_id` bigint(20) NOT NULL DEFAULT 3,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `account`
--

INSERT INTO `account` (`account_id`, `email`, `password`, `full_name`, `address`, `phone_number`, `image`, `account_type_id`, `created_at`) VALUES
(1, 'hasgidzo@gmail.com', '$2y$10$9TdTFzyZf6NSsBwYmC5GzeZy.XUkVZPzlZxgLgwUT2fED1B9XgXzy', 'Phạm Nhật Nam', 'Hà Nội', 386123362, NULL, 2, '2021-04-14 00:00:00'),
(2, 'tiendat09041999@gmail.com', '$2y$10$9y5ILr5I2ikrwn.PIIuBO.hf4sgNCIQNGgnK9LiFKJAkMCpEo4ZEe', 'Nguyễn Tiến Đạt', 'Nghệ An', 386123369, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fanh5.JPG?alt=media&token=b5ecc0bd-265b-4397-890a-a9f21acdcec5', 2, '2021-04-22 00:00:00'),
(3, 'chatt@gmail.com', '$2y$10$9TdTFzyZf6NSsBwYmC5GzeZy.XUkVZPzlZxgLgwUT2fED1B9XgXzy', 'Phạm Nhật Vượng', 'Hà Tĩnh', 386123362, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/140296755_1749190178578007_2960540718958561319_o.jpg?alt=media&token=f37c851c-d038-46d1-b1cc-dcfe9c1d82e6', 3, '2021-04-14 00:00:00'),
(4, 'chat@gmail.com', '$2y$10$wQfTE4QMZMzDXvnZUKpilebekPnxpJzaJ3iNuTztrJTvcXl9qJgX2', 'Trần Thanh Hải', 'Nghệ An', 386123362, NULL, 2, '2021-04-14 00:00:00'),
(5, 'chaat@gmail.com', '$2y$10$EuTxJ.QfxBXwyVW4SwqAtuT8vGny4x0XZLCnVDAF6oM4ZSmm0o5zC', 'Đỗ Như Nghiệp', 'nghe an', 123456789, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/basket-emply.PNG?alt=media&token=732d4ff3-9ebf-4f43-b89f-22c91787e89d', 3, '2021-04-14 00:00:00'),
(6, 'chat5@gmail.com', '$2y$10$Um09IMsHpWZEkPc/OyuSCe3LNq9NOBfQHU1fgusdhC.0ZBKHaiIHG', 'Nguyễn Văn Nam', 'Nghệ An', 386123362, NULL, 2, '2021-04-14 00:00:00'),
(7, 'hoailong@gmail.com', '$2y$10$Um09IMsHpWZEkPc/OyuSCe3LNq9NOBfQHU1fgusdhC.0ZBKHaiIHG', 'Phan Văn Hoài', 'Hà Tĩnh', 386123362, NULL, 2, '2021-04-20 00:00:00'),
(11, 'vuquangminh@gmail.com', '$2y$10$Um09IMsHpWZEkPc/OyuSCe3LNq9NOBfQHU1fgusdhC.0ZBKHaiIHG', 'Vũ Quang Minh', 'Hưng Yên', 386123362, NULL, 3, '2021-04-20 00:00:00'),
(13, 'datnt140@gmail.com', '$2y$10$9TdTFzyZf6NSsBwYmC5GzeZy.XUkVZPzlZxgLgwUT2fED1B9XgXzy', 'Nguyễn Văn C', 'Quảng Ninh', 386123362, NULL, 1, '2021-04-22 00:00:00'),
(14, 'buiminhthao@gmail.com', '$2y$10$H6xvhbazAWGbLmpSrrgSr.joKeCVGqSW/56K3IciUwhKzBtrvo4Gu', 'Bùi Minh Thảo', 'Hà Nội', 982769175, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thao.jpg?alt=media&token=09d62f9a-71b8-480c-a341-7b958662323d', 3, '2021-05-05 09:24:55'),
(15, 'nguyenngocvuong@gmail.com', '$2y$10$qyIHDnk9Ud9QAVmEOhLOGe1w3WKnANzP5nbTlqtDOjDP8gHiEpg06', 'Nguyễn Ngọc Vượng', 'Số 6, Đường Hải Thượng Lãn Ông, Thị xã Thái Hòa, Tỉnh Nghệ An', 336181546, NULL, 3, '2021-05-05 10:21:48'),
(16, 'nguyenthianhhang@gmail.com', '$2y$10$7TpBz8pufkKpFVNmP4PXJO8Mab9PF38ca0r2mCgGHHLHcDDiWoQeC', 'Nguyễn Thị Anh Hằng', 'Cam Lộc, Hà Tĩnh', 386123361, NULL, 3, '2021-05-06 09:30:56');

--
-- Bẫy `account`
--
DELIMITER $$
CREATE TRIGGER `after_account_create` AFTER INSERT ON `account` FOR EACH ROW begin
    declare makh bigint(20);
    declare loaitk varchar(255);
    set makh = NEW.account_id;
    set loaitk = NEW.account_type_id;
    if loaitk = '3' then
		insert into computerstore.voucher (customer_id, voucher_level) values (makh, 50);
    end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_account_delete` AFTER DELETE ON `account` FOR EACH ROW begin
    declare makh bigint(20);
    declare loaitk varchar(255);
    declare isactive tinyint(1);
    
    set makh = OLD.account_id;
    set loaitk = OLD.account_type_id;
    if loaitk = '3'then
		delete from voucher where voucher.customer_id = makh;
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `account_type`
--

CREATE TABLE `account_type` (
  `account_type_id` int(11) NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `account_type`
--

INSERT INTO `account_type` (`account_type_id`, `value`, `description`) VALUES
(1, 'AD', 'Quản trị'),
(2, 'NV', 'Nhân Viên'),
(3, 'KH', 'Khách Hàng');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bill`
--

CREATE TABLE `bill` (
  `bill_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `order_status_id` int(11) NOT NULL,
  `order_type_id` int(11) DEFAULT NULL,
  `total_money` double NOT NULL DEFAULT 0,
  `into_money` double NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `bill`
--

INSERT INTO `bill` (`bill_id`, `employee_id`, `customer_id`, `order_status_id`, `order_type_id`, `total_money`, `into_money`, `created_at`) VALUES
(8, 2, 5, 2, 1, 6374500, 6374500, '2021-04-27 00:00:00'),
(13, 2, 3, 5, 2, 36109500, 36109500, '2021-04-27 00:00:00'),
(16, 2, 5, 1, NULL, 11970000, 11970000, '2021-04-29 03:48:06'),
(18, NULL, 11, 2, 1, 798000, 798000, '2021-05-03 11:54:59'),
(19, NULL, 11, 2, 2, 11970000, 11970000, '2021-05-03 11:56:51'),
(20, NULL, 11, 2, 2, 12967500, 12967500, '2021-05-03 11:59:59'),
(21, NULL, 11, 2, 2, 6374500, 6374500, '2021-05-03 12:04:09'),
(22, NULL, 11, 2, 2, 5538500, 5538500, '2021-05-03 12:11:10'),
(24, NULL, 14, 2, 1, 27300000, 27300000, '2021-05-05 10:11:08'),
(29, NULL, 15, 1, NULL, 840000, 840000, '2021-05-05 10:46:48'),
(30, NULL, 14, 1, 1, 840000, 840000, '2021-05-06 10:12:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bill_detail`
--

CREATE TABLE `bill_detail` (
  `bill_detail_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` double(15,2) NOT NULL,
  `amount` int(11) NOT NULL,
  `warranty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `bill_detail`
--

INSERT INTO `bill_detail` (`bill_detail_id`, `bill_id`, `product_id`, `price`, `amount`, `warranty`) VALUES
(13, 8, 13, 6374500.00, 3, 0),
(39, 13, 32, 12967500.00, 4, 12),
(41, 13, 3, 11970000.00, 2, 12),
(43, 16, 3, 11970000.00, 1, 0),
(45, 18, 42, 798000.00, 1, 0),
(46, 19, 3, 11970000.00, 1, 0),
(47, 20, 4, 12967500.00, 1, 0),
(48, 21, 13, 6374500.00, 1, 0),
(49, 22, 34, 5538500.00, 1, 0),
(50, 24, 4, 13650000.00, 2, 0),
(53, 29, 42, 840000.00, 1, 0),
(54, 30, 42, 840000.00, 1, 0);

--
-- Bẫy `bill_detail`
--
DELIMITER $$
CREATE TRIGGER `after_bill_detail_delete` AFTER DELETE ON `bill_detail` FOR EACH ROW begin

    declare masp bigint(20);
    declare mahd bigint(20);
    declare slhd int(11) default 0;
    declare slsp int(11) default 0;
    declare gia_ban_moi double(15,2) default 0;
    declare tong_tien_hd double(15,2) default 0.00;
    declare tt double(15,2) default 0.00;
    
    set mahd = OLD.bill_id;
    set masp = OLD.product_id;    
    set gia_ban_moi = OLD.price;
    set slhd = OLD.amount;
    
    set tong_tien_hd = (select total_money from computerstore.bill where bill.bill_id = mahd);
    set slsp = (select amount from computerstore.product where product.product_id = masp);
    
   
    set tt = (tong_tien_hd - gia_ban_moi*slhd);
    update product set product.amount = (slsp+slhd) where product.product_id = masp;
    update bill set bill.into_money = tt where bill.bill_id = mahd;
    update bill set bill.total_money = tt where bill.bill_id = mahd;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_bill_detail_insert` AFTER INSERT ON `bill_detail` FOR EACH ROW begin
    declare masp bigint(20);
    declare mahd bigint(20);
    declare ds_ldt varchar(255);
    declare slhd int(11) default 0;
    declare slsp int(11) default 0;
    declare gia_ban_moi double(15,2) default 0;
    declare tong_tien_hd double(15,2) default 0.00;
    declare tt double(15,2) default 0.00;
    
    set mahd = NEW.bill_id;
	set masp = NEW.product_id;    
    set gia_ban_moi = NEW.price;
    set slhd = NEW.amount;
    
    set tong_tien_hd = (select total_money from computerstore.bill where bill.bill_id = mahd);
    set slsp = (select amount from computerstore.product where product.product_id = masp);
    
    
    if slsp >= slhd then
		set tt = (tong_tien_hd + gia_ban_moi*slhd);
		update product set product.amount = (slsp-slhd) where product.product_id = masp;
		update bill set bill.into_money = tt where bill.bill_id = mahd;
		update bill set bill.total_money = tt where bill.bill_id = mahd;
		
        
    end if;

end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comment`
--

CREATE TABLE `comment` (
  `comment_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `comment_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `comment`
--

INSERT INTO `comment` (`comment_id`, `product_id`, `customer_id`, `comment_content`, `create_at`) VALUES
(1, 2, 5, 'aaa', '2021-04-27 10:10:49');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon`
--

CREATE TABLE `coupon` (
  `coupon_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `total_money` double(15,2) NOT NULL DEFAULT 0.00,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `coupon`
--

INSERT INTO `coupon` (`coupon_id`, `employee_id`, `supplier_id`, `total_money`, `note`, `created_at`) VALUES
(1, 4, 5, 740000000.00, NULL, '2021-04-19 00:00:00'),
(2, 7, 1, 224500000.00, NULL, '2021-04-20 00:00:00'),
(3, 1, 7, 116900000.00, NULL, '2021-04-20 00:00:00'),
(4, 4, 6, 362000000.00, NULL, '2021-04-21 00:00:00'),
(5, 6, 1, 191000000.00, NULL, '2021-04-21 00:00:00'),
(6, 11, 6, 296500000.00, NULL, '2021-04-21 00:00:00'),
(7, 3, 7, 92000000.00, NULL, '2021-04-21 00:00:00'),
(8, 2, 5, 60000000.00, NULL, '2021-05-05 10:18:28'),
(9, 13, 7, 2000000.00, NULL, '2021-05-05 10:19:57');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon_detail`
--

CREATE TABLE `coupon_detail` (
  `coupon_detail_id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` double(15,2) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `coupon_detail`
--

INSERT INTO `coupon_detail` (`coupon_detail_id`, `coupon_id`, `product_id`, `price`, `amount`) VALUES
(1, 1, 1, 24000000.00, 20),
(2, 1, 2, 26000000.00, 10),
(3, 2, 3, 12000000.00, 5),
(4, 2, 4, 13000000.00, 5),
(5, 2, 5, 17000000.00, 5),
(7, 2, 12, 2900000.00, 5),
(8, 3, 13, 6100000.00, 5),
(9, 3, 14, 200000.00, 2),
(10, 3, 15, 1300000.00, 5),
(11, 3, 16, 1900000.00, 5),
(12, 3, 17, 1500000.00, 5),
(14, 3, 18, 12500000.00, 5),
(15, 4, 19, 7000000.00, 10),
(16, 4, 20, 6900000.00, 10),
(17, 4, 21, 10000000.00, 5),
(18, 4, 22, 11000000.00, 5),
(19, 4, 23, 7500000.00, 10),
(20, 4, 24, 4300000.00, 10),
(21, 5, 25, 6800000.00, 10),
(22, 5, 26, 1400000.00, 5),
(23, 5, 27, 3000000.00, 5),
(24, 5, 28, 2200000.00, 5),
(25, 5, 29, 9000000.00, 10),
(26, 6, 30, 1600000.00, 5),
(27, 6, 31, 5200000.00, 5),
(29, 6, 32, 13000000.00, 10),
(30, 6, 33, 3800000.00, 10),
(31, 6, 34, 5300000.00, 5),
(32, 6, 35, 13600000.00, 5),
(33, 7, 36, 1500000.00, 10),
(34, 7, 37, 350000.00, 10),
(35, 7, 38, 900000.00, 20),
(36, 7, 39, 2000000.00, 10),
(37, 7, 40, 450000.00, 10),
(38, 7, 41, 900000.00, 10),
(39, 7, 42, 700000.00, 15),
(40, 7, 43, 700000.00, 10),
(41, 7, 44, 900000.00, 5),
(44, 8, 1, 30000000.00, 2),
(45, 9, 44, 1000000.00, 2);

--
-- Bẫy `coupon_detail`
--
DELIMITER $$
CREATE TRIGGER `after_coupon_detail_delete` AFTER DELETE ON `coupon_detail` FOR EACH ROW begin
    declare masp bigint(20);
    declare mapn bigint(20);
    declare slpn int(11) default 0;
    declare slsp int(11) default 0;
    declare sldtsp int(11) default -1;
    declare gia_nhap_sp double(15,2);
    declare tong_tien_pn double(15,2);
    
    set masp = OLD.product_id;
    set mapn =  OLD.coupon_id;
    set slpn =  OLD.amount;
    set gia_nhap_sp =  OLD.price;
    
    set tong_tien_pn = (select total_money from computerstore.coupon where coupon.coupon_id = mapn);
    set slsp = (select amount from computerstore.product where product.product_id = masp);    
      
    
		update computerstore.product set computerstore.product.amount = (slsp-slpn) 
		where computerstore.product.product_id = masp;
        update computerstore.coupon set computerstore.coupon.total_money = (total_money- slpn*gia_nhap_sp) 
		where computerstore.coupon.coupon_id = mapn;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_coupon_detail_insert` AFTER INSERT ON `coupon_detail` FOR EACH ROW begin
    declare muc1 double(15,2) default 500000.00;
    declare muc2 double(15,2) default 2000000.00;
    declare muc3 double(15,2) default 5000000.00;
    declare muc4 double(15,2) default 10000000.00;
    declare muc5 double(15,2) default 20000000.00;
    declare muc6 double(15,2) default 50000000.00;
    declare masp bigint(20);
    declare mapn bigint(20);
    declare slpn int(11) default 0;
    declare slsp int(11) default 0;
    declare gia_nhap_sp double(15,2) default 0.00;
    declare gia_ban_sp double(15,2) default 0.00;
    declare tong_tien_pn double(15,2) default 0.00;
    
    set mapn = NEW.coupon_id;
    set masp = NEW.product_id;
    set slpn = NEW.amount;
    set gia_nhap_sp = NEW.price;
    set slsp = (select amount from computerstore.product where product.product_id = masp);
    set tong_tien_pn = (select total_money from computerstore.coupon where coupon.coupon_id = mapn);
	
    if gia_nhap_sp<=muc1 then
		set gia_ban_sp = (gia_nhap_sp*1.25);
	elseif gia_nhap_sp>muc1 and gia_nhap_sp<=muc2 then
		set gia_ban_sp = (gia_nhap_sp*1.2);
	elseif gia_nhap_sp>muc2 and gia_nhap_sp<=muc3 then
		set gia_ban_sp = (gia_nhap_sp*1.15);
	elseif gia_nhap_sp>muc3 and gia_nhap_sp<=muc4 then
		set gia_ban_sp = (gia_nhap_sp*1.1);
	elseif gia_nhap_sp>muc4 and gia_nhap_sp<=muc5 then
		set gia_ban_sp = (gia_nhap_sp*1.05);
	else
		set gia_ban_sp = (gia_nhap_sp*1.04);
	end if;
        
    update computerstore.coupon set computerstore.coupon.total_money= (tong_tien_pn + slpn*gia_nhap_sp)
	where computerstore.coupon.coupon_id = mapn;
    update computerstore.product set computerstore.product.amount = (slsp+slpn) where computerstore.product.product_id = masp;
    update computerstore.product set computerstore.product.price = gia_ban_sp where computerstore.product.product_id = masp;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `inventoryproducts`
-- (See below for the actual view)
--
CREATE TABLE `inventoryproducts` (
`product_id` int(11)
,`product_name` varchar(255)
,`trademark_id` int(11)
,`product_type_id` int(11)
,`price` double
,`amount` int(11)
,`description` text
,`trademark_name` varchar(255)
,`product_type_name` varchar(255)
,`image` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(166, '2014_10_12_000000_create_users_table', 1),
(167, '2014_10_12_100000_create_password_resets_table', 1),
(168, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(169, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(170, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(171, '2016_06_01_000004_create_oauth_clients_table', 1),
(172, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1),
(173, '2021_02_28_031552_create_accounts_table', 1),
(174, '2021_02_28_031748_create_account_types_table', 1),
(175, '2021_02_28_031802_create_bills_table', 1),
(176, '2021_02_28_031816_create_bill_details_table', 1),
(177, '2021_02_28_031830_create_comments_table', 1),
(178, '2021_02_28_031847_create_coupons_table', 1),
(179, '2021_02_28_031857_create_coupon_details_table', 1),
(180, '2021_02_28_031913_create_news_table', 1),
(181, '2021_02_28_032028_create_order_types_table', 1),
(182, '2021_02_28_032103_create_products_table', 1),
(183, '2021_02_28_032148_create_product_images_table', 1),
(184, '2021_02_28_032229_create_product_types_table', 1),
(185, '2021_02_28_032303_create_suppliers_table', 1),
(186, '2021_02_28_032319_create_trademarks_table', 1),
(187, '2021_03_01_092052_create_status_orders_table', 1),
(188, '2021_04_03_040236_create_vouchers_table', 1),
(189, '2021_04_03_040447_create_promotion_dates_table', 1),
(190, '2021_04_03_040547_create_product_promotions_table', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `news`
--

CREATE TABLE `news` (
  `news_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `news_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `highlight` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `news`
--

INSERT INTO `news` (`news_id`, `title`, `news_content`, `highlight`, `thumbnail`, `url`, `created_at`) VALUES
(1, 'Bạn không nên mua MacBook M1 lúc này', 'Sau màn ra mắt thành công của chip xử lý M1, Apple đã sẵn sàng giới thiệu MacBook M2 trong nửa cuối năm nay. Do đó, hãy chờ đợi để có quyết định sáng suốt.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2F48230042021.jpg?alt=media&token=3a873dbc-fbd4-4826-92ef-a27bb21b64de', 'https://zingnews.vn/apple-sap-ra-mat-macbook-m2-post1210106.html', '2021-05-01'),
(2, 'Dùng MacBook, bạn nên từ bỏ trình duyệt Chrome', 'Sử dụng Safari, tắt Bluetooth khi không cần thiết là những cách đơn giản giúp tiết kiệm pin cho MacBook.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fbannentubotrinhduyetchorme.jpeg?alt=media&token=44bfab75-361f-4df0-9247-862282c1c703', 'https://zingnews.vn/meo-tiet-kiem-pin-cho-macbook-post1206586.html', '2021-05-01'),
(3, 'Dấu hiệu nhận diện app đa cấp lừa đảo', 'Các mô hình đa cấp thường xuất hiện với lời kêu gọi kiếm được rất nhiều tiền, đánh vào tâm lý muốn giàu, đổi đời nhanh của người dân.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fdauhieunhandienapdacapluadao.jpg?alt=media&token=af4214e0-8f29-4a04-a847-608ee663ce5c', 'https://zingnews.vn/dau-hieu-nhan-dien-app-da-cap-lua-dao-post1208904.html', '2021-05-01'),
(4, 'Bắt nhịp xu hướng laptop với Acer Spire 5 và Swift 3', 'Laptop Acer Aspire 5 và Swift 3 sở hữu thiết kế hiện đại và hiệu năng mạnh mẽ, đem lại cho người dùng trải nghiệm đáng giá và phong cách thời thượng.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fbatnhipxuhuonglaptop.jpg?alt=media&token=d2e38ead-c4a5-46c1-ad25-5e429301a65a', 'https://zingnews.vn/bat-nhip-xu-huong-laptop-voi-acer-spire-5-va-swift-3-post1209787.html', '2021-05-01'),
(5, 'Nên mua MacBook cũ hay laptop Windows mới?', 'Mình đang là sinh viên năm 2, có khoảng 20 triệu đồng và phân vân giữa việc chọn mua MacBook Pro 2016 cũ với laptop Windows mới. Nhờ mọi người tư vấn giúp ạ.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fmacbook_pro_vs_xps_15_1.jpg?alt=media&token=9738044c-7746-42f6-8076-e749727a9b3a', 'https://zingnews.vn/nen-mua-macbook-cu-hay-laptop-windows-moi-post1207768.html', '2021-05-01'),
(6, 'Cách kiểm tra độ chai pin trên smartphone Android', 'Mình đang sử dụng chiếc Galaxy S10 được gần 2 năm và muốn kiểm tra tình trạng pin của máy. Anh, chị nào biết hướng dẫn mình với. Mình cảm ơn ạ.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fcachkiemtradochaipinandroid.jpg?alt=media&token=93d72317-09bb-44ea-adb4-f2892b11641f', 'https://zingnews.vn/cach-kiem-tra-do-chai-pin-tren-smartphone-android-post1207127.html', '2021-05-01'),
(7, '\'Lôi kéo người khác đầu tư app đa cấp cũng phạm luật\'', 'Chuyên gia nhận định mô hình app đa cấp không tập trung sản phẩm, dịch vụ mà chỉ chú trọng lôi kéo được nhiều người tham gia nhất có thể. Việc kêu gọi này có khả năng phạm pháp.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Floikeodautuapdacap.jpg?alt=media&token=d2a2fbb1-4364-477f-9f1e-d8d93ab78462', 'https://zingnews.vn/loi-keo-nguoi-khac-dau-tu-app-da-cap-cung-pham-luat-post1209326.html', '2021-05-01'),
(8, 'Loạt smartphone thú vị nhưng hiếm gặp ở Việt Nam', 'Xiaomi Mi 11 Ultra, Google Pixel 4a hay Red Magic Pro đều là những mẫu smartphone tốt, nhiều công nghệ mới nhưng không được bán chính hãng ở Việt Nam.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Floatsmartphone.jpg?alt=media&token=fba997b5-24d6-4f94-9984-28475d50c1fb', 'https://zingnews.vn/loat-smartphone-thu-vi-nhung-hiem-gap-o-viet-nam-post1209865.html', '2021-05-01'),
(9, 'Bảo tàng ở Nga vẫn dùng máy tính Apple tuổi đời hơn 30 năm', 'Chiếc máy tính Apple II tại Bảo tàng Lenin (Nga) vẫn được sử dụng để trình chiếu sau hơn 30 năm.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fbaotangonga.jpg?alt=media&token=dd63dc3a-0f52-44de-a15d-cce7812e48b4', 'https://zingnews.vn/bao-tang-nga-van-dung-may-tinh-apple-30-nam-tuoi-post1210012.html', '2021-05-01'),
(10, 'Người dân Ấn Độ lên mạng xã hội để cầu viện quốc tế', 'Hàng nghìn lời cầu cứu viện trợ bình oxy hay giường bệnh đã được đăng lên các nền tảng lớn như Facebook, WhatsApp hay Twitter.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fnguoiandolenmangxahoi.jpg?alt=media&token=32597a3e-ff68-4f17-a1dc-a5b984b4c36c', 'https://zingnews.vn/nguoi-dan-an-do-len-mang-xa-hoi-de-cau-vien-quoc-te-post1209029.html', '2021-05-01');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('0152fb3da0110887b46d319a2bf68aaddf5caa5707465c12380f2a7624dfde5c606ee0e0c56ec850', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:55:13', '2021-04-25 21:55:13', '2022-04-26 04:55:13'),
('02d88fa8e5ab5e1146041a4455e8953e45ac29ed8665e195eb59eec2bfdf41b82a008df50ec6bf80', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 07:26:27', '2021-04-27 07:26:27', '2022-04-27 14:26:27'),
('04aef87ffa3d9b7f6ab53f9d766c796a2db300146f172fda004f76293a667642d9d2e6e79efdb24e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:09:51', '2021-04-29 07:09:51', '2022-04-29 14:09:51'),
('057cc8fccefd249fb6ede7f8b19d060d44524ad38c437de89572a91d643af92417f1728108e7a7a5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 09:21:17', '2021-05-04 09:21:17', '2022-05-04 16:21:17'),
('0752e6ae44e9cf27f472ee6cdc2d66af9b334ad5dca781b2468b000eca6d1771b6a4db3865b992f7', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 04:06:37', '2021-05-05 04:06:37', '2022-05-05 11:06:37'),
('093d64861979255b023bf743a1cf4ff7dfb366671edc94e6569ca725f436c0c1f40db2fa89c985ea', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:21:14', '2021-04-26 20:21:14', '2022-04-27 03:21:14'),
('093e0d13450530ad8cd5d664a89afa5057c65fe6f760dc95316af97c57c98f95e79c18713d7cfb19', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:34:20', '2021-04-25 20:34:20', '2022-04-26 03:34:20'),
('0941e9999a1034993976591d10a4166814cbe3cd804396af57d805860100ebfab530cee360999e52', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:17:01', '2021-05-05 08:17:01', '2022-05-05 15:17:01'),
('09812a76417b74e3d3841e2d77d1c4425b6edc1d6643c0d716f59d63525a474d7fbbd05936b68b45', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-30 22:06:15', '2021-04-30 22:06:15', '2022-05-01 05:06:15'),
('0b125970d9e7f56e39dccdf75e9a3edb7695877e6d84ec85fa59fe3aaae1f10c853bad1f3c419c7f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:24', '2021-04-29 07:24:24', '2022-04-29 14:24:24'),
('0b41e696af084ce9da08dd7b37ddd8b4b42d4845a4c328c4954e2f1af04deab7193e0d19d06005ae', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 09:51:06', '2021-04-26 09:51:06', '2022-04-26 16:51:06'),
('0bb6fc16ad0fd3ec71f4d5df740e081198c2a96f76e0737b6d6408fe21020d41a95084873edd4089', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:29:49', '2021-04-25 22:29:49', '2022-04-26 05:29:49'),
('0bf346bf931dd05da70778396c18757a5892c7af97cf086d71cb937a27e7cab5f3cb83f79fd7f31f', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:57:06', '2021-04-25 21:57:06', '2022-04-26 04:57:06'),
('0d96076d77a4533cfd0a8d6f76bcd303c3fb0b69f30f7e597c66c4f92746519dab7b711f6f8d39c6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:57', '2021-04-29 07:24:57', '2022-04-29 14:24:57'),
('0e95dc6e7764aa13008882ac0397dc061a3d25e1399ec459d376a9a81020331a4861961b75b63133', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:09:06', '2021-04-17 03:09:06', '2022-04-17 10:09:06'),
('10960c9c8f83af491a0b3dc201795901d9fe2f755fef12b65adbae34df9b0720012b8d590bd299b8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:36:41', '2021-04-22 02:36:41', '2022-04-22 09:36:41'),
('11298a1f07488cf4e4d34a482175142514bf485d02758153836aa241a0a1e5532ec3dc324a9d27dd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:04:45', '2021-04-26 20:04:45', '2022-04-27 03:04:45'),
('113fe96145fac45d3e0fb4cd6672049662d10d6c545fd3a4f1d895c26e2f50dc905c489adfdc1a85', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 00:45:54', '2021-05-06 00:45:54', '2022-05-06 07:45:54'),
('11bb754e6c744f466f99618106b0d8d654ffa93bb59fb0416f02deda6a1e2326669ea6234e7da46f', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:00:39', '2021-05-05 08:00:39', '2022-05-05 15:00:39'),
('11f9578006226baae9dac925f5ce31a43f4ec1e2c808fbdedb6bc12e536e82243b8456be1ad96026', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:23:33', '2021-04-25 22:23:33', '2022-04-26 05:23:33'),
('12752d46afdd7d79531dedb4966de61c01901a5b23cefabab686ce3489a487d4ccf0b0f2be1a94a2', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 09:48:47', '2021-04-26 09:48:47', '2022-04-26 16:48:47'),
('12c7d1cb2689b26963f434186ec567e5f1bae77b15d9064b4a3e7fe0d91d43d70382e4fdc1a08661', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 02:21:10', '2021-04-27 02:21:10', '2022-04-27 09:21:10'),
('150ee69194c340dae3afc7a8d7264f775b5083ce6641431b9647cba9ac3b43c827955732324fd7a9', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:58:54', '2021-04-29 07:58:54', '2022-04-29 14:58:54'),
('15393a2f18d85ad4d894e6cf9a64a45a83c3c45ea5f64f40f4027c1642ee2099a4702f228c0c294d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:25:36', '2021-04-25 22:25:36', '2022-04-26 05:25:36'),
('1636684ad1e9d38b4e121f7b1a244c7107ff6a70fc9ab9bf3487fa0e74c9e1f43152f3e8f08f7bb3', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:47:21', '2021-04-29 07:47:21', '2022-04-29 14:47:21'),
('168edac3de80c1377527f6e921fb01e4cbc0f9ed2103eea98a2710cb39bdf2524ed8daa33bcecbb2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 10:25:30', '2021-04-26 10:25:30', '2022-04-26 17:25:30'),
('16f1c0e2a00e94c2a2756632a9cf04b1304a9e6ec603e223894c2f5bbb012f40685f812613a6f921', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:29:17', '2021-04-25 20:29:17', '2022-04-26 03:29:17'),
('174d0726c51bdaf662230ddb2f3f7361887cf6aca1ebc84efddd381d038a8c16a45c90b85e5652f1', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:24:07', '2021-04-25 21:24:07', '2022-04-26 04:24:07'),
('1797f61d361cae08dfee8cb3dd0ac3e843fb1fc241f265baeb1895790c15412d28b448ec52237663', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 21:15:28', '2021-04-26 21:15:28', '2022-04-27 04:15:28'),
('17bd2fc31e692fa74a488f4b1374c1bccf8414ce9d0cf8c80f0fc094c29e9517504137d93114fbd9', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:06:50', '2021-04-25 21:06:50', '2022-04-26 04:06:50'),
('1d2bbac15f03f6e48483e872f7ec97f613bfe10016f37715dc415335955f61a894ad6f1411b5e06b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 03:00:06', '2021-05-06 03:00:06', '2022-05-06 10:00:06'),
('1d6e2c2e193d4e0ae94d22aacf046023a26a814bd1a90087f3c45e8de789271ba2180eccdabacbba', 16, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 07:31:23', '2021-05-06 07:31:23', '2022-05-06 14:31:23'),
('1e3861bc0869f32010ef7fdb6b8d6159cd89a3ab442448be789060380fc3b5b5c2971e4bd0d2b67e', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:27:24', '2021-04-26 05:27:24', '2022-04-26 12:27:24'),
('1f998de7cb426cc195b0b22a554bd12cb380bece260604fe759e09172ec88dbce01aaaf44abfffc6', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:18:26', '2021-04-26 05:18:26', '2022-04-26 12:18:26'),
('20dd4d342a8214a62cc04396e4b2578eb613e9e9e6dac615ec52d9a9e55da5d685a6e60f41fd8c7e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:20:08', '2021-04-29 07:20:08', '2022-04-29 14:20:08'),
('2108c8c1508de4b173efb86bb069b0dc0da5027967f6a460479d05b027cda8c4c697c6f83fb97590', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:05:53', '2021-05-05 08:05:53', '2022-05-05 15:05:53'),
('21ca2621a695a628d3005b6af23eb900eef402b363df0988b810d65ef5223e1b2c93f898a5e929a4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:00:20', '2021-04-25 22:00:20', '2022-04-26 05:00:20'),
('224df956b806e59bebbe970cd91a24dac75a9906dab93bb238eff89b4cc5acbc5426357e3421c045', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-23 21:11:31', '2021-04-23 21:11:31', '2022-04-24 04:11:31'),
('232b41fa026ef8c6c58b039e38a97673b1923f14eec47657abbcae16edd3b0ed18b531c6a6518446', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:07', '2021-04-29 07:24:07', '2022-04-29 14:24:07'),
('25899b2c0ec5b1edeaddde2f6df733d1e471953ab5fcc05cbcdfdf86ed4f00c4557f7f6916849115', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 15:21:48', '2021-05-05 15:21:48', '2022-05-05 22:21:48'),
('265b6dde1ed1d375bf6bdef061070529878d3612a9989c7e5cf915742efd06353ec7f41c46929164', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:48:13', '2021-04-29 07:48:13', '2022-04-29 14:48:13'),
('26bb63ae508840ad166fb18514b8c3b2d9d1564e9bd38add8b88ebbee106242a175fd9f00d26a04b', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:31:20', '2021-04-27 03:31:20', '2022-04-27 10:31:20'),
('26f8bd77f33c64fca8b854c14e6a096b7b3384b092c44820e6805e81520ddce363f7a3c0bd4a1fa1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 20:55:34', '2021-05-04 20:55:34', '2022-05-05 03:55:34'),
('2842316c938f0e6ff4a9df15dfc24f2714b5bb454115c49beef88c28c4298c5942c2d9db636d1821', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:10:16', '2021-04-29 07:10:16', '2022-04-29 14:10:16'),
('28a85df05084cd91856d3ca6e5e6b602528c83f252882cc425f4bf9eff8156b68d4df80f26233e2a', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 01:20:12', '2021-04-22 01:20:12', '2022-04-22 08:20:12'),
('28dcb87d53ed36caa1e51c14e966e7630eb3a00b714a6b9f01fb03eb5534c5d94cd69aca23f6fcc5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 22:15:35', '2021-04-26 22:15:35', '2022-04-27 05:15:35'),
('2a8154806c7b8cfa8fa70ec95a2384cf7b3aaacaff250c62291ff5a24f054496569a54377531d0d5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:23:14', '2021-04-27 03:23:14', '2022-04-27 10:23:14'),
('2aa2ad313cda37b318868d63f74f91fe80efbd8a2712aff6b5289a7e42a739c07281a57e80ff9034', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:00:35', '2021-04-25 21:00:35', '2022-04-26 04:00:35'),
('2dabfcddde0fcdd423fd144f162e62bf6688d8af0a72f725259e35e2ac29c84756eaf3ba2ecc5c7d', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:32:29', '2021-04-27 03:32:29', '2022-04-27 10:32:29'),
('2ee064d3cc162d545c24986aa57561edcd5ad06557d94919b2135441311ba9923e41605b77f257c0', 11, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-02 21:54:54', '2021-05-02 21:54:54', '2022-05-03 04:54:54'),
('2f7b8017bf87eb4dc49772f69b67e284b5eac36681d9843a2d7b388d4273bc88902e40575f827d70', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:14:00', '2021-04-17 03:14:00', '2022-04-17 10:14:00'),
('300cd7eeb3f6e6e65213dc6ceadd2f2e70548f37fedb7c36e8a8dc99125ae6ab22e4ce50b8fc0751', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-19 08:11:12', '2021-04-19 08:11:12', '2022-04-19 15:11:12'),
('334ee4b0bd2189a5ee2157dd86329af0355782bfeba3479c419a14fecc01088d30773f929b022353', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 10:34:36', '2021-04-28 10:34:36', '2022-04-28 17:34:36'),
('336a497a4f5fbd92e57a01e92d2e82b015c8320aacbe4abdb39bdb746253c1c9945c5e9346248b64', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:05:41', '2021-04-26 05:05:41', '2022-04-26 12:05:41'),
('33cec80037a0e5bc708ad06234603456412dfd2610c9bbb0fd485ab2796ffab33d3140a2b9959ef1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:13:47', '2021-04-17 03:13:47', '2022-04-17 10:13:47'),
('3473910f9afe70c09276d94740bace80839e605203b7def79cb206ec08dadf75e9ebfdab46f94975', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:47:13', '2021-04-22 02:47:13', '2022-04-22 09:47:13'),
('3627d9f2859c4c5be6cf03c5783dfaf6deed1f5691e7349c00bf05c52f3e3c542c236d7508cc1602', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-21 07:34:27', '2021-04-21 07:34:27', '2022-04-21 14:34:27'),
('36cbb9d999fd0d13e68a703313f951104f1a371a66258f8504300edb0442d3e735fbf0eefca972ae', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 03:10:21', '2021-05-04 03:10:21', '2022-05-04 10:10:21'),
('38f8ad9dd3e6e74cc8c21e45cb5d9466ab461b0cfe29ab3ebe62c4f8de3fe8680fc211e1a6e22f6d', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 03:06:49', '2021-05-06 03:06:49', '2022-05-06 10:06:49'),
('3a7e9aeb63298afd51712b90ec50dd2a70f5b1635a47ad7e8f1dc4a2e6dcff0a34532bd614c00874', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:34:59', '2021-04-26 05:34:59', '2022-04-26 12:34:59'),
('3b72b1237e38e6f5d4ee735f65f672cca5925c15576169bda687ea15bee394d8fa7f06c3a40257fb', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:28:59', '2021-05-05 08:28:59', '2022-05-05 15:28:59'),
('3b8d033ddf9333ea8dea3e99f8fb032a7c47972175dc62610527eaf8a2d755467b604a32974488f8', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 03:02:03', '2021-05-06 03:02:03', '2022-05-06 10:02:03'),
('3c83e440aa05d7e7b39164ae40f571a8e02fd70e0a7528dcda28972f8f709fd6b86c4469fb98ee5d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:17:27', '2021-05-06 08:17:27', '2022-05-06 15:17:27'),
('3e5057a23c64d818440cab5828ef583ee48986c2919547094da5880dc55f842f7132e76103ed0553', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 02:36:35', '2021-05-06 02:36:35', '2022-05-06 09:36:35'),
('3e68378f0c7f960d1124f7e11e5b5f8968196373363703096908406fc1ba871499d5c6df5fe7b158', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 01:43:47', '2021-04-22 01:43:47', '2022-04-22 08:43:47'),
('3f29d807cf7ddb98f9b43ec4dea4a08405c453772ee3961044dd7cab8310a1c2ebe7ca294efae22e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 08:12:55', '2021-04-25 08:12:55', '2022-04-25 15:12:55'),
('3f3f26b1d1e46528e5442e8ed68202d25d1adaa94feb527f21f6fb5ebec0f2ea6b9df3107f2f67b8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:41:59', '2021-04-22 02:41:59', '2022-04-22 09:41:59'),
('3fafe39a713514107fa00830823cc70540fcaad92ac5ff40abc659a331d83b2b50bbfa4953b56881', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:32:18', '2021-05-05 08:32:18', '2022-05-05 15:32:18'),
('3fbe7bba8213cc2b5cb2857795bfcea96c3fa714d0549ac73c772d22bc67a9d1d2f9c13e52bb9ef7', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:08:06', '2021-04-29 08:08:06', '2022-04-29 15:08:06'),
('417908ccbb2ab5073a83ba4a474de65db7d61eb4a01d6c080949d973989b9538e3b8179891c5db6f', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:12:47', '2021-04-25 21:12:47', '2022-04-26 04:12:47'),
('427784d22d8a9c3fe7bbc9e8d89c418c3ada40571515ee0263e20a89fb9ec07f567769b3b9a8c736', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:21:38', '2021-04-26 20:21:38', '2022-04-27 03:21:38'),
('446e171aab431eb88041dabd569ce6c564dc388611721779d8e0b3885eeb814d6ecad0f54aa0fa40', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 20:12:48', '2021-05-05 20:12:48', '2022-05-06 03:12:48'),
('44d26eba438b318ea2849d9f7bdaa989b398aa72167bd746778a4cda5be48e958f5d811feaec8540', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:07:36', '2021-04-26 00:07:36', '2022-04-26 07:07:36'),
('4557a8c29af05cf03a18565d1a2c65089f13dfaabdeedf33d4e381fcdab84d10e07b808be924ff24', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:15:34', '2021-05-06 08:15:34', '2022-05-06 15:15:34'),
('47764d47f711900496f4f21173569c98be898854d6c352a55964cb818ee1dc222160e02ab3e30f11', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:37:41', '2021-04-25 20:37:41', '2022-04-26 03:37:41'),
('47861f69b167c928e5fe9dd2b9c4bcf920645472e46cf7a0cb2aa6fce2fe0ae3532891999da0d317', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-07 21:14:04', '2021-05-07 21:14:04', '2022-05-08 04:14:04'),
('484a2e724f51f419a3c711028f726ff3e1a5354c81e3565d421eb9d4f7be60dec9850d659132d05d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:35:11', '2021-04-26 00:35:11', '2022-04-26 07:35:11'),
('48e54bc29c98f72ce58963a564de1100ad2882d7545a93c72746d7bf7736c9b0a7fbc6b0fcf02811', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 23:53:25', '2021-04-25 23:53:25', '2022-04-26 06:53:25'),
('4db8fe1624a1f38598d88c2d40900156ecaf3d6ffc8b2071199adabf8ec8637c6e0a3accac45e8fe', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:36:05', '2021-04-25 20:36:05', '2022-04-26 03:36:05'),
('4e69aacabd5b3f3f0e3f1e68ad0db63c7c36708804e0909150c4a139d11f55e5fe6f54128f99ae4a', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:14:59', '2021-04-25 21:14:59', '2022-04-26 04:14:59'),
('509d17191312652703179563bcd531b246fe0918542b6bef73ef109009538bdb4553f539044aa481', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 01:45:41', '2021-04-22 01:45:41', '2022-04-22 08:45:41'),
('515e650eae0970dc36f5db26373b1e30c3a7166372bc738bfacf75056c22d60123e9e2bb4078fe3f', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 10:25:59', '2021-04-26 10:25:59', '2022-04-26 17:25:59'),
('51c2d185975ea2b0125a2e9490cf0a1e1559e153e05badd12061a5ad641935f8eb186678c9f02e8e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:57:35', '2021-04-25 20:57:35', '2022-04-26 03:57:35'),
('523752ab1d1ff217167fd2b9cde7311e8dfb1e3dd6a1be5b4f84d85a7ce2121c33c3fdf07f5ccfd2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 03:01:00', '2021-05-04 03:01:00', '2022-05-04 10:01:00'),
('54e3c99b479a988fcb56ecd3d6df232890c27eda8e27633d29fd3a4dfc47a9e0d47275f82c0ab1c6', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:29:53', '2021-05-05 08:29:53', '2022-05-05 15:29:53'),
('57f367788735cf04774f4f4e40d02d257171efe1cd21fe082f1a4c0523fe5d7f6253360a10de4733', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 01:28:37', '2021-05-06 01:28:37', '2022-05-06 08:28:37'),
('580d46fe3115f1b55e18dc6b7ef8cdf75c426e603823f3ca964bd61908e8dbd63bed0f75b6fd1091', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:54:13', '2021-04-26 08:54:13', '2022-04-26 15:54:13'),
('5900de4023daa449d4986a504dde69b2209fc4fcc8cbb5a138d7cd75d9ae7b4021d156552980877a', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 01:50:28', '2021-04-25 01:50:28', '2022-04-25 08:50:28'),
('596c062f6796c419f81ad372ac2e48bfa0033cc86848d0031caf5912fe2eebe5681f0fa3245bfd6e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:01:57', '2021-04-26 00:01:57', '2022-04-26 07:01:57'),
('5b0c6da4f1727ed9045469992a13ea9ad30bd361e85b85f71b8f4637e83bed7f3d8f9ec363f426a0', 6, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:36:32', '2021-04-25 03:36:32', '2022-04-25 10:36:32'),
('5b23a09908a4799411ef112d4b621bbcc00ba2cedf569470762de841fe95746f721af5ec97cf0423', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-07 20:03:32', '2021-05-07 20:03:32', '2022-05-08 03:03:32'),
('5b9fea179f86cd6a0de5cb3fe85c0f1f6e070705b272c2255c7f901dbba2bfeae98e869631d3ad2d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 20:51:04', '2021-05-06 20:51:04', '2022-05-07 03:51:04'),
('5cf8d8a63713b450aa4d8f8fe6eebd0a460ed822c41a12dffbf19f1ba0e5cd64f6f7c3848d675dbf', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:46:45', '2021-05-05 08:46:45', '2022-05-05 15:46:45'),
('5cfbf6e9e3762ad786968d16f89b6ddf84291944f64827949a32a83f3ecdfa04789548d944425b70', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:25:53', '2021-04-22 02:25:53', '2022-04-22 09:25:53'),
('5e81b5ca8379ac4091c76781d02e9de2b75105adbfa655590026781b0a8b8b3aa950b526c70bff3b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:04:06', '2021-04-26 08:04:06', '2022-04-26 15:04:06'),
('5fd62e30f0757c29affa012e7256f8399b08d900ec0cb3969184c8f5e22f4de6797ba3213524e03f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-20 03:16:33', '2021-04-20 03:16:33', '2022-04-20 10:16:33'),
('60ee40b1c21d50c574ae6ba48f4ee443e67130a841994507e98b876edba59fb2faa3e9f80545adbf', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:22:05', '2021-05-05 08:22:05', '2022-05-05 15:22:05'),
('62c06fd3eb4d58d856fda1f539acbe1a7bbe1d609eb52e58a817e0e750f0e9b0242ed063f957f94c', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:51:50', '2021-04-26 08:51:50', '2022-04-26 15:51:50'),
('644c9b137cd524025d1bfdef75a6a058259656300c2a6ecd4f656590ce83641e914c6ed77ea1b9a5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-19 20:47:53', '2021-04-19 20:47:53', '2022-04-20 03:47:53'),
('6574c60ec1a19620d5f79bcc272344e1a144472b3b38fc6c0794591ebe26a9e1e82777cd6691abbb', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:41:55', '2021-05-05 08:41:55', '2022-05-05 15:41:55'),
('66a97409b5e92d9524f39b1f818a69a608e56dcacff427c1111a2c219a7d4256daf2308bf75a6798', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:45:11', '2021-04-22 02:45:11', '2022-04-22 09:45:11'),
('67c5a32e2e6f84e9d88fc93eaf1d2622d27c211a3fc0fca9635df1d12eeedb2d9f2e406ba5df0fa0', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:54:46', '2021-04-29 07:54:46', '2022-04-29 14:54:46'),
('6848c1791aae838d8c8c7cb3cfabfc2087f765dbc4e4300dbcf4f67498cb46ec129801742a93e980', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 00:30:27', '2021-04-27 00:30:27', '2022-04-27 07:30:27'),
('69bbf8c7e6d002f2266b4664b61f306bc7c051fd8b5be932a8705b5e988c7f5b9f40d21b6277ba12', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:14:10', '2021-04-17 03:14:10', '2022-04-17 10:14:10'),
('69bc825d905d2859e5e20f97f3ec4cb8684a273f24d155cc133e96bdf5c7206ccc2d303835e6f266', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 00:15:42', '2021-04-27 00:15:42', '2022-04-27 07:15:42'),
('6b214e183331a9a50cb6b371eec7daed320e07ffb3436cf23c2555913629ffa6d6901c49700ec39b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 22:04:15', '2021-04-26 22:04:15', '2022-04-27 05:04:15'),
('6e0f203f9203fcc90a7519afa86c3dee456f7be09f5a780bbb3c418c540dd8ed4debec3831ca76ac', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:24:44', '2021-04-25 21:24:44', '2022-04-26 04:24:44'),
('6fbc1409d6a920b03ff1ff6ba43fbf99b7450c631ad21b17353df3045479877f7a31c71cbd288b37', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:17:43', '2021-04-25 21:17:43', '2022-04-26 04:17:43'),
('70379a66605c2b03d3b1750be4c5c85305fb5012b8b842438a5859ede4b167b5ac68c0ac27056257', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 19:56:39', '2021-05-06 19:56:39', '2022-05-07 02:56:39'),
('7739a3691d707c583638b7d4412f0e57197b575abfd9f983033ed7d176814ba2f15abec2d1a2b89a', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:20:09', '2021-05-06 08:20:09', '2022-05-06 15:20:09'),
('7817e29515dd2109b066a762a7283e33f3d5d2d48097c36089122babe6036237b533fa8124a7e2e1', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:48:45', '2021-04-29 07:48:45', '2022-04-29 14:48:45'),
('7899e710fbe5df73d853038e01852b2d1d5f2fb871804abc5e9f712733517b3cc11f0de21f743418', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:50:31', '2021-04-26 08:50:31', '2022-04-26 15:50:31'),
('79e616d80f464802736ec80d7eec3b98b0d090612aae8273442c80aaa4685f4b43aad7c28419b818', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:46:01', '2021-04-25 21:46:01', '2022-04-26 04:46:01'),
('79f256f3c52a45361fbd88901b8cabdf6ca4485fe3d3ff31aef17b09e4ce8e8832056d3b08dd7479', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:09:45', '2021-04-17 03:09:45', '2022-04-17 10:09:45'),
('7c1b6591cc9b12a13b6d7c8c4ecb603c0386699f79ba950d7ae96e3890228ef285684cb9ad31d705', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:34:13', '2021-04-25 03:34:13', '2022-04-25 10:34:13'),
('7d8a87b214ec99158ad6d5a023f2f09d9d602d349da2c3b7c7015bfd4a1ab0744bff2d147eff1d72', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:05:35', '2021-04-29 08:05:35', '2022-04-29 15:05:35'),
('7da31e361fc43fa2f10a74516cf407ea8adeb1e6de747649bd84be011a32bf6ca4324221d2d549a4', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 03:58:25', '2021-05-05 03:58:25', '2022-05-05 10:58:25'),
('7dd0c30980c442f9372e5fd3a4c73f899c8772dec3bec5fd599759db3c491f2109b955c8304285c1', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 02:32:20', '2021-05-06 02:32:20', '2022-05-06 09:32:20'),
('8000ae6bcbf04ca1930556e35aff87210220efd2878bb5965e615f1bd2cbe0e510af95e254c92ebf', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:47:41', '2021-04-25 20:47:41', '2022-04-26 03:47:41'),
('800568b638e7e582d54770eed777aeda933a07b46922cdf2e969175af4c675596b64becf3c7c900c', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 02:00:47', '2021-04-27 02:00:47', '2022-04-27 09:00:47'),
('824a4175103bf938c4021329e00ba680df78a499b7768f98975fab31d7280f64f5c1c1de37ccb6b7', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:23:50', '2021-04-29 07:23:50', '2022-04-29 14:23:50'),
('863a0470b3475fcc37edc3906f24dcb5d99a4bbf0d0d68d3daae3fe075b631966ce6fef5464c67e4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:50:05', '2021-04-25 21:50:05', '2022-04-26 04:50:05'),
('87b0c3f093a1c642e32aa8610e94fae87fcaafcec4d7bd03e15bb85169e9dab8e86d524bdcb4ee0b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 07:48:17', '2021-05-05 07:48:17', '2022-05-05 14:48:17'),
('89495a77251c4103bb4509cdfbe907f1ed4f2be74949faa426290434bb114ec5ce5105f58a473c20', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:06:45', '2021-04-26 08:06:45', '2022-04-26 15:06:45'),
('8aec027058b1ba778af747322541dce2c30ec75e30a3e823649afc22db6083169020d46532b22140', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 06:19:41', '2021-04-26 06:19:41', '2022-04-26 13:19:41'),
('8b66e4d73967e5bb1e26e0f47a808399dde6c940664326e3abf590e8947282df5aeb2647e63cbbf8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 19:41:50', '2021-04-29 19:41:50', '2022-04-30 02:41:50'),
('8d1e2153c788645a16cb84d177397b2933f314c4e5b3c6b43e745f3fcc32cd4814b518576d5c2a7e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:06:08', '2021-04-29 08:06:08', '2022-04-29 15:06:08'),
('8ea3f5a5e2b0b84167de909913a05d9e8c7a42cba7b293c12b87cd383cc4691a0d05259feccf0f24', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-20 21:10:06', '2021-04-20 21:10:06', '2022-04-21 04:10:06'),
('8f321715dfeb6cd10636f92a6a641ea8e4ed6113f3e3b12b6dea4402a614d1eb0ce21a653d12d368', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 04:01:44', '2021-04-17 04:01:44', '2022-04-17 11:01:44'),
('90a2d09d5c376c844ec281d1201b55518b3aebc2e57579a846743cac3052d9ca9f6cec6557968a85', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:55:14', '2021-04-26 08:55:14', '2022-04-26 15:55:14'),
('93540726e4fc8f33e776803bc62f28076d40dda341d2b80802176dc18a4788b1de1ced60f41833c5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:45:54', '2021-05-06 08:45:54', '2022-05-06 15:45:54'),
('944c765fc6cbf92ba51e4e7d2d0d2d97249d7e5decbd1286878eec94f5170be3b06a9bcb46ceff5a', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:28:39', '2021-04-22 02:28:39', '2022-04-22 09:28:39'),
('94c5595c21d03af529686b30ed791f70f095770f72aea8d1a8b68fdc3853152b23542df96b07046d', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 14:24:55', '2021-05-05 14:24:55', '2022-05-05 21:24:55'),
('9550d8f4fe42e8fd394d3607d07297ea6e7e20e7314e0ad4b52c4072fd75ba63ecdc4ffabb54a2a8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:45:26', '2021-04-25 22:45:26', '2022-04-26 05:45:26'),
('95a389842e345401abcd369969a673bdb5de1128dedf4d186d7dfd85791d2c6f0f4e7dcc10ca01b6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 20:24:04', '2021-05-06 20:24:04', '2022-05-07 03:24:04'),
('962f0e9e7b74e2627de2d8fc572d288209087d497abb47e87504f67a20b7f5ab5e7a8414ba4104fb', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:20:30', '2021-04-27 03:20:30', '2022-04-27 10:20:30'),
('97df4d2b1abab0cce9fc10f0906e73ad7b3a01c3c242691773b023c5d7dca1eca7fa281005fc2c64', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:25:50', '2021-04-29 07:25:50', '2022-04-29 14:25:50'),
('97e7af3013829662322d067249142d67cf3eea1453cf84d2bd5592e6442eba9fe985106349417ca3', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-20 08:29:44', '2021-04-20 08:29:44', '2022-04-20 15:29:44'),
('9bb5e984c004a0d68b1798cf3aaeab33e7f5b3937a8161fc53e95baf4e5d327183a0e55aa4c5fc14', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:31:08', '2021-04-25 22:31:08', '2022-04-26 05:31:08'),
('9d629beb81792979bbc512a50ab29cc03de328707ae2397101a271be4bb57df5b1d8c2e4568340ee', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 08:28:30', '2021-04-25 08:28:30', '2022-04-25 15:28:30'),
('9fac0c215826eac3379ef8e2bac75c6e9c986737835058e1664e7c239309acb9dd7cc33be65060c8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:58:29', '2021-04-25 21:58:29', '2022-04-26 04:58:29'),
('a03532419b3e1a589bebc413d1ec806c49dce75d37a9bf02876b26272daa6a80110d43c4c43d1009', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:20:38', '2021-04-25 22:20:38', '2022-04-26 05:20:38'),
('a05bda1b5976856b13c069fa2e0a479e7bf11d6660a090250fbd39837baac6aceb68c33f0e1eaed8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 20:37:20', '2021-04-28 20:37:20', '2022-04-29 03:37:20'),
('a194adb7f3b6164a1be036879c85f42bc0ceaf4a3fa05b3c9901de3db8070e8c6d35f8baf616f29b', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-30 20:43:12', '2021-04-30 20:43:12', '2022-05-01 03:43:12'),
('a1c2063960c5fd43197844089cd3039809abe28f4e180fb8638664b6d08255acab6d569f60ee703d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:51:04', '2021-04-29 07:51:04', '2022-04-29 14:51:04'),
('a2d406afd55a529ff410ee31f074fcbbae478dc97ef1bd539162afa501cbddb28978ad21cf567735', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:31:43', '2021-04-26 00:31:43', '2022-04-26 07:31:43'),
('a40707639b868e5828827932620024389d61bd5ac48d76f83eda0409ec52bbb7629029c055cc609b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:23:37', '2021-04-25 22:23:37', '2022-04-26 05:23:37'),
('a4736f9824b57e734742498ce5c46a34940eb44e297314f222046c186421317d6a9e4073714f6b6d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:23:13', '2021-04-26 00:23:13', '2022-04-26 07:23:13'),
('a4ee517b12d8fc12e7381adab34b284c9313fd6cf3027c3fb6632886d2ede849adc734f5a1dfa71d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:21:45', '2021-04-22 02:21:45', '2022-04-22 09:21:45'),
('a6b3f08dc65f111a8d32a99726721db4dca95443c30ca88dbb4d0883db9eba92bde854851ceb7176', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:48:29', '2021-04-26 08:48:29', '2022-04-26 15:48:29'),
('aa47249156ae5cfb5c5f07f02639e9645b4edf11b5b693fa07770d977da522ce0f155f19fc16583b', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 21:24:12', '2021-04-28 21:24:12', '2022-04-29 04:24:12'),
('aacf5db82fb73ebc20de4b17c06ad7196a25455bf7be167b5ee2212d46fc247f9ef8f561c29a8f7d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 06:57:29', '2021-04-29 06:57:29', '2022-04-29 13:57:29'),
('ad3ae2ff76ef2af3b71e2b814398aab01afe555c2021ec4c65590ac2dfa5102b75b7737578830bbe', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 02:37:31', '2021-04-26 02:37:31', '2022-04-26 09:37:31'),
('af3e528140410b8f1159906c7ea80d172e896b39deb49879c3d7562e8b62736f1e708b5504687bbd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:03:40', '2021-04-29 08:03:40', '2022-04-29 15:03:40'),
('b02665ade51fc0b2d242886677703248a20988849423689edf40bc6fe8231b48e990941a4b549beb', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 01:35:35', '2021-04-29 01:35:35', '2022-04-29 08:35:35'),
('b0c6965ff6fad453835ae4577e23ddd241cb3f2be94e24f13b9e19b6dd888dfc875dee18fd23bfe0', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:12:09', '2021-04-25 21:12:09', '2022-04-26 04:12:09'),
('b2289d15daa68000504a97df2588049a7b6a299ee9971c1d4a11460b0153b2d93b6e4a32cc99d098', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 21:13:05', '2021-05-06 21:13:05', '2022-05-07 04:13:05'),
('b2602fbbc9e8390dde3648b37abe3a57e426b1fd3cdc40086805b956b76d90db4aff638b797f02b4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:10:11', '2021-04-25 22:10:11', '2022-04-26 05:10:11'),
('b690265fd3dfea427038aaeef720aca978cff248ed76a6ea3383e8f8b5b7cdab966255ccb1755037', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:49:33', '2021-04-29 07:49:33', '2022-04-29 14:49:33'),
('b7084b34fcf2aa176d25a8e3faef4bc6de062042613c54b0775556fe3d0058ea73c4037c06f6f827', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:53:34', '2021-04-25 21:53:34', '2022-04-26 04:53:34'),
('b942671c69ce27b2983fc2c89e2c07eba38749a22bc09a4d7456a6d59979303e02e4d4d4ae08fcdd', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 02:33:08', '2021-05-06 02:33:08', '2022-05-06 09:33:08'),
('bb375486eb0ef2b0621ef8df0158338cebc424344b014954dbf7387df290a5134683e29ce297058d', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:39:25', '2021-05-05 08:39:25', '2022-05-05 15:39:25'),
('bbcbc9ee4dff8f09c4a1fba09d9f2d6791d29b55b915630bcdf24aa8fcd03cf2fa91554b36c29221', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:35:40', '2021-04-25 21:35:40', '2022-04-26 04:35:40'),
('bc6a281892da587174fe0b8e2904d556c936fdb8fee030192b3647302947d395ab9fd8e7fb4cad7d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:25:25', '2021-04-25 20:25:25', '2022-04-26 03:25:25'),
('bd286ef122a85c94b529b0cc3231a7df336b6656b40abe2e2ddb243e88d3fd319e3c38e2cedb1f36', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:53:20', '2021-04-25 20:53:20', '2022-04-26 03:53:20'),
('bd9942a09bfb532573fa396c40c19289ba4965037b3913564ac0e8aa28637d5408b533fd4c647415', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-23 22:00:59', '2021-04-23 22:00:59', '2022-04-24 05:00:59'),
('beb062028a6a704b52a9aaede18f4e9329c1dc5f7745d09a23ae60d8a9131b79a3f275719bb40bf6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:15', '2021-04-29 07:24:15', '2022-04-29 14:24:15'),
('c20bcdbf1f960bc44b17e318ad91c40c44d9ba7c6c054161b968fe91061e48e87feb8cf76ee6351b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:41:55', '2021-04-25 03:41:55', '2022-04-25 10:41:55'),
('c259faa561c82a124b0955d694ad0ec0ec1fcaf0ae9aadaa4b370fa90740f57ba74ea8c09ff2637d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:34:27', '2021-04-25 21:34:27', '2022-04-26 04:34:27'),
('c2a9fcb4187d40025e36b323fc3ad771dad6feb0fd8008c034bdc1ae0699d2239e468e9fbf5b25f2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 07:56:15', '2021-04-28 07:56:15', '2022-04-28 14:56:15'),
('c3547124330f519904771d09848b2cd7379adadef8877d1a66b69eb431f6eb9e3f8c96efebfdf3f4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:12:57', '2021-04-25 22:12:57', '2022-04-26 05:12:57'),
('c46f70b334b103877f993b00be26a2e829b287c88ecf0381291949d3f10b51d94d77dbbdd1841f55', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:39:11', '2021-04-26 05:39:11', '2022-04-26 12:39:11'),
('c790aa0ba7168b6e52e59d5a7d12d3206fc1acac51cbd4f1b1424558c4fb9c2406cf91c99e5af387', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:04:57', '2021-04-25 21:04:57', '2022-04-26 04:04:57'),
('c9844ac222f562d47eecc59127837b17177c018573c77703d51a18a17fb7d0aa4cc8a5cdd783f396', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:19:35', '2021-04-25 22:19:35', '2022-04-26 05:19:35'),
('ce41b2d8a148593f742335f40acd41c680c1a80712224262f3dd9f8faace7c4aeed55b20684c6fb3', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:55:59', '2021-04-26 20:55:59', '2022-04-27 03:55:59'),
('ce637c37d2cc5f0c6069935e0bec2b83f52f46d26ce7e48e69ae42edd121ed1dfcb54052bdd2040d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 04:38:37', '2021-04-26 04:38:37', '2022-04-26 11:38:37'),
('cf3b704bd64aa1ec2393737e13ef2ed253a5a07267269ea95144d94db200b7849a32889db3b3d40b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:24:29', '2021-04-25 22:24:29', '2022-04-26 05:24:29'),
('d0562a2277d17d3d180e0f4a9dc8be17512ef7b2ec4f1b20954ed887666ac6bb7194547682eccd12', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:01:50', '2021-04-25 22:01:50', '2022-04-26 05:01:50'),
('d1b498eb2feed722dfba9f5ce66a9461143cd92071704c0dc944366b6b41d8cef3a84efaa6670b50', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 08:28:47', '2021-04-25 08:28:47', '2022-04-25 15:28:47'),
('d1bde4abdb1ba6a1569b2df12c01983747881bf71df472227b6bd1a3f8c2a33bde66db7697e7f7f1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 00:52:21', '2021-04-22 00:52:21', '2022-04-22 07:52:21'),
('d302bfeebf99de64571553bc7dc5ada483036e45451d2e48f6694f52cc9a6f05c97d276220da8310', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:51:15', '2021-04-29 07:51:15', '2022-04-29 14:51:15'),
('d5483691f281653696fde7e4303fdfaeaa318431e4ee19d2115c354a89208e77e8fd8dfa98003bcd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:17:44', '2021-04-29 07:17:44', '2022-04-29 14:17:44'),
('d9d2945072871a60ce528fbea75a98959bf804a5382caf5d0e579f4eaa2a15a6f82026ae3df115c3', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:28:09', '2021-04-25 20:28:09', '2022-04-26 03:28:09'),
('dadaf9ba97220567e9a8beca8f3e0a7174781d458181ffeb9b1ebbd5a600aac3821929de046881f3', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:09:56', '2021-04-17 03:09:56', '2022-04-17 10:09:56'),
('dc45fd53dae4b8284746e7d3cb55a33e114e58ad90e896ee34c5f8096e34e93602404b76c9f94910', 16, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 14:30:57', '2021-05-06 14:30:57', '2022-05-06 21:30:57'),
('dccd2d72e4fae68ccf5f5304e9999963ebccecb70aedb536ca82f8a09e086ec64fdfdb94e4a4f7bb', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:41:25', '2021-04-25 20:41:25', '2022-04-26 03:41:25'),
('dd3c60720c2e24393dd053d551c2b859c26bc5fead0c22e766d15c56f37f66ad3c4427d1e8fe40e6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 20:00:15', '2021-04-28 20:00:15', '2022-04-29 03:00:15'),
('de0736be6e3dcb94fa67688e0b3b31e86971f9b50462a80d8adf8615f6d3dc364d7b300e7b536497', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 01:44:56', '2021-04-29 01:44:56', '2022-04-29 08:44:56'),
('e05bf6824edea41ed951b721eb01803e8ad1b5e92af9f1fc0d94edf16dfe15a3cc8ca69c21fd778b', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-19 06:38:35', '2021-04-19 06:38:35', '2022-04-19 13:38:35'),
('e0f8c2a913448487ee9a6c49d0f53c6f8571b45b2a6ff96b0e4facd34f5c23d84193c7f76d834f23', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:29:02', '2021-04-25 21:29:02', '2022-04-26 04:29:02'),
('e19ba6987ca0f826ed5df71b7c69ce5b82aa3116fd3ba9bf561291df82fc4eb5adf723cb7e32f3ba', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:04:51', '2021-04-26 00:04:51', '2022-04-26 07:04:51'),
('e460396cd1ade18dbee928303cab31fc17a7b9ac9b51c38ca7fa6116ee88b5a5854b5f50ba5085a6', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 21:19:34', '2021-04-26 21:19:34', '2022-04-27 04:19:34'),
('e603476906df74dec7264a88d3da046b9f60f85fdfbac30b8d6eeb90d8684b1a3800083897f6344b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:36:44', '2021-04-25 22:36:44', '2022-04-26 05:36:44'),
('e6f3fbace9678891d12197f435e9558ddc95cf48fa2967c53c25bfcd24650483b52a69c1d4d06796', 6, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:36:31', '2021-04-25 03:36:31', '2022-04-25 10:36:31'),
('e755cecb00bca80c0155e926ed019c66d4fbd1e62bf3c1a2a2643f2f2b77a5af65ef4021fce37c5d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:05:45', '2021-04-25 22:05:45', '2022-04-26 05:05:45'),
('e8f8c9c8a4a9c979547929551034d53ae76177c627110036f705dbefad33fcfa5edca02ba1f9c003', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:58:01', '2021-04-25 20:58:01', '2022-04-26 03:58:01'),
('e961e975472d4d0bec958e482493b8d0a9b776170985f6b726ba6fee449867c2468e3e6e531bde86', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-21 19:59:52', '2021-04-21 19:59:52', '2022-04-22 02:59:52'),
('e9b3a1a2aab9dedee5a2dc6075323e1acd17d3d9479c2508cb10bf45fb457a76b364716f91e9d7d2', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:48:53', '2021-04-22 02:48:53', '2022-04-22 09:48:53'),
('ee8e218c22a92b81304a4f8d9e32a8559cd3e915c3604f6f993774b078bebbaf4256b38e30b7dc1c', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:20:03', '2021-04-22 02:20:03', '2022-04-22 09:20:03'),
('efad34a68bc08789311b233fed334cda39673c8e352ba6c4d2a49802aec9e2644814a8471619791c', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:32:33', '2021-04-26 20:32:33', '2022-04-27 03:32:33'),
('efde4df7810351fded06f2ad3c02dfb32c4c5f6e58a3b9e1d9457d8ab2769121b393c4c0b9c891ce', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 03:01:24', '2021-05-06 03:01:24', '2022-05-06 10:01:24'),
('f1a8eec2aa5635c390d2ab5bf2adcb6a022c0b6e7da730a9e3151dbb36096d6b78a46b6b55bab6f5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 01:21:54', '2021-04-27 01:21:54', '2022-04-27 08:21:54'),
('f1f6deed674c812e32f7ff4b3c98ee84bf04e1f5cf68c239dee68a143debc2d5e0bf6e896d826c8e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:28:27', '2021-05-06 08:28:27', '2022-05-06 15:28:27'),
('f3375b5c0d3245b03dbbbd7eb2c4e123733a64609de19266169af99dbc8b6a00196617527c735382', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:30:53', '2021-04-26 05:30:53', '2022-04-26 12:30:53'),
('f401c94188e1422acd1570e8122b02278251ef230bd0460b15127fe1b14ff4e130a4c6cc42d07800', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:18:40', '2021-05-05 08:18:40', '2022-05-05 15:18:40'),
('f62d2bbcbadd56a2b0a23c73177feedf7afcb62ee5f56c828b80250bc8f27e2098854401b599b6ad', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:43:09', '2021-04-22 02:43:09', '2022-04-22 09:43:09'),
('f7a7f3a9c91b9b10fd45d8650df9a7421c532160ec8a1cc09dbdb3184b215ef601fb3eb3217500a1', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:43:55', '2021-04-22 02:43:55', '2022-04-22 09:43:55'),
('f9bb66bc9d5f1a8a965321247ccb5086c47e154c94fc6b4655f2db6c453118d9d6384f1d47952655', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 07:25:24', '2021-05-05 07:25:24', '2022-05-05 14:25:24'),
('fbc80d0703334536cae37947e8badd9feda3dbde70cebeb8679a7a6ab94e7329301ff8562437f624', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 01:46:47', '2021-04-29 01:46:47', '2022-04-29 08:46:47'),
('fe2e1f799b1e38572fc3babd6c4dfed722838a235cb729706a231b3cd1455d600a31bef0620e13db', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:08:22', '2021-04-25 21:08:22', '2022-04-26 04:08:22'),
('ff4effa1257225fb6c2f653ba32ca5f723f8473bdb7a239feaf79f4bf9c82a08594dc921304f0dc5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 02:05:25', '2021-04-27 02:05:25', '2022-04-27 09:05:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `client_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `provider`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
('93373a5a-8260-4ce5-8248-216dc5c86ab6', NULL, 'Laravel Personal Access Client', 'JI6TrZfU1Uneq6tqGhBTUpPfTxRq5JL76Z0sfC9J', NULL, 'http://localhost', 1, 0, 0, '2021-04-17 03:08:35', '2021-04-17 03:08:35'),
('93373a5a-a5be-4186-aff7-e6472e6611bb', NULL, 'Laravel Password Grant Client', 'u6ywcLvLwD2DOxplIUQfhL7XHOzhAYPqmOAa42gW', 'users', 'http://localhost', 0, 1, 0, '2021-04-17 03:08:35', '2021-04-17 03:08:35');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', '2021-04-17 03:08:35', '2021-04-17 03:08:35');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_status`
--

CREATE TABLE `order_status` (
  `order_status_id` int(11) NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_status`
--

INSERT INTO `order_status` (`order_status_id`, `value`, `description`) VALUES
(1, '1', 'SELECTING'),
(2, '2', 'PENDING'),
(3, '3', 'PROCESSING'),
(4, '4', 'SHIPPING'),
(5, '5', 'DONE'),
(6, '6', 'CANCEL');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_type`
--

CREATE TABLE `order_type` (
  `order_type_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_type`
--

INSERT INTO `order_type` (`order_type_id`, `value`, `description`) VALUES
(1, 1, 'Thanh toán bằng tiền mặt'),
(2, 2, 'Thanh toán bằng chuyển khoản');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `trademark_id` int(11) NOT NULL,
  `product_type_id` int(11) NOT NULL,
  `price` double NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `warranty` int(11) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `trademark_id`, `product_type_id`, `price`, `amount`, `warranty`, `description`) VALUES
(1, 'Laptop LG Gram 14ZD90N-V.AX55A5 (i5 1035G7/8GB RAM/512GBSSD/14.0 inch FHD/FP/Xám Bạc) (model 2020)', 4, 3, 31200000, 24, 12, 'CPU: Intel Core i5 1035G7\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 14.0 inch FHD\nHĐH: Dos\nMàu: Xám Bạc.'),
(2, 'Laptop LG Gram 15ZD90N-V.AX56A5 (i5 1035G7/8GB RAM/512GBSSD/15.6 inch FHD/FP/Trắng) (model 2020)', 4, 3, 27040000, 0, 0, 'CPU: Intel Core i5 1035G7\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 15.6 inch FHD\nHĐH: Dos\nMàu: Trắng'),
(3, 'Laptop Acer Aspire A514-54-3204 (NX.A23SV.009) (i3 1115G4/4GB RAM/512GBSSD/14.0 inch FHD/Win10/Bạc)', 4, 3, 12600000, 1, 12, 'CPU: Intel Core i3 1115G4\nRAM: 4GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 14 inch FHD\nHĐH: Win 10\nMàu: Bạc'),
(4, 'Laptop Dell Vostro 3405 (V4R53500U003W) (R5 3500U 8GB RAM/512GB SSD/14.0 inch FHD/Win10/Đen)', 1, 3, 13650000, 0, 0, 'CPU: AMD R5 3500U\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 14 inch FHD\nHĐH: Win 10\nMàu: Đenn'),
(5, 'Laptop Dell Vostro 5402 (V4I5003W) (i5 1135G7 8GBRAM/256GB SSD/14.0 inch FHD/Win10/Xám)', 1, 3, 17850000, 0, 0, 'CPU: Intel Core i5 1135G7\nRAM: 8GB\nỔ cứng: 256GB SSD\nVGA: Onboard\nMàn hình: 14 inch FHD\nHĐH: Win 10\nMàu: Xám'),
(11, 'RAM Desktop Gskill Trident Z Neo (F4-3600C16D-16GTZNC) 16GB (2x8GB) DDR4 3600MHz', 5, 1, 3450000, 0, 0, 'Dòng sản phẩm Gskill Trident Z Neo mới nhất của Gskill\nPhù hợp với nền tảng AMD\nDung lượng: 2 x 8GB\nThế hệ: DDR4\nBus: 3600MHz'),
(12, 'DDRam 4 Kingston ECC 16GB 2400Mhz - KSM24ED8/16ME', 12, 1, 3335000, 0, 0, 'Dòng RAM ECC dành cho máy chủ của Kingston\nDung lượng: 1 x 16GB\nThế hệ: DDR4\nBus: 2400MHz'),
(13, 'DDRam 4 Kingston ECC 32GB/2666 - KSM26RD4/32HAI Registered', 12, 1, 6710000, 5, 0, 'Dòng sản phẩm ECC của Kingston\nDung lượng: 1 x 32GB\nThế hệ: DDR4\nBus: 2666MHz'),
(14, 'RAM Desktop AXPRO 2GB (1x2GB) DDR3 1600MHz', 13, 1, 250000, 2, 0, 'Dung lượng 2GB\nKiểu Ram DDRam 3\nBus Ram hỗ trợ 1600'),
(15, 'RAM desktop DDR4 Micron ECC 16GB/2133Mhz (ECC Registered)', 11, 1, 1560000, 5, 0, 'Kiểu Ram: ECC Registered\nDung lượng: 1 x 16GB\nThế hệ: DDR4\nBus: 2133MHz'),
(16, 'Mainboard MSI B450M GAMING PLUS (AMD B450, Socket AM4, m-ATX, 2 khe RAM DDR4)', 14, 9, 2280000, 5, 0, 'Hỗ trợ AMD® RYZEN ™ thế hệ thứ nhất và thứ 2 / Ryzen ™ với bộ xử lý đồ họa Radeon ™ Vega cho Socket AM4\nHỗ trợ bộ nhớ DDR4-3466 (OC)\nTrải nghiệm game Fast Lightning: TURBO M.2, StoreMI\nTăng cường âm thanh với Nahimic: Thưởng cho đôi tai của bạn với chất lượng âm thanh đẳng cấp cho trải nghiệm chơi game sống động nhất\nCore Boost: Với bố cục cao cấp và thiết kế điện kỹ thuật số để hỗ trợ nhiều lõi hơn và mang lại hiệu suất tốt hơn.\nDDR4 Boost: Tăng cường hiệu năng bộ nhớ DDR4 với A-XMP\nSẵn sàng VR: Tự động tối ưu hóa hệ thống của bạn để sử dụng VR, đẩy hiệu suất tối đa.'),
(17, 'Mainboard GIGABYTE H310M-DS2 (Intel H310, Socket 1151, m-ATX, 2 khe RAM DDR4)', 15, 9, 1800000, 2, 0, 'Kích thước: ATX\nSocket: LGA 1151v2\nChipset: H310\nKhe RAM tối đa: 2\nLoại RAM hỗ trợ: DDR4'),
(18, 'Mainboard ASUS Z10PE-D16 WS (DUAL CPU WORKSTATION)', 2, 9, 13125000, 16, 0, 'Intel® Socket 2011-3 kép/ Chipset Intel C612 PCH\nThiết kế luồng không khí chuyển động đều với 16 khe cắm DIMM\nGiải pháp Điện năng Tuyệt đối – Các linh kiện cao cấp cho hiệu quả sử dụng điện năng hàng đầu\nBIOS độc đáo để ép xung Hai CPU – Tăng hiệu năng ép xung của CPU lên đến 10%\nQuản lý hoàn toàn máy chủ từ xa với module IPMI 2.0-compliant ASMB8-iKVM và ASWM Enterprise'),
(19, 'Mainboard ASUS Z10PA-D8C (DUAL CPU WORKSTATION)', 2, 9, 7700000, 10, 0, 'Bo mạch máy chủ ASUS Z10PA-D8C đã tích hợp các tính năng linh hoạt vào một kiểu dáng 12”x10” và có thể dễ dàng lắp vừa rất nhiều thùng máy ATX tiêu chuẩn. Thông qua thiết kế sáng tạo và kỹ thuật chế tác hạng nhất, bo mạch máy chủ này mang đến giải pháp lưu trữ toàn diện, hiệu năng máy chủ với một thiết kế nhỏ gọn, cùng các linh kiện cao cấp cho hiệu quả làm việc cao cấp. Với hỗ trợ cho hai CPU và một thiết kế có thể lắp vừa các thùng ATX, Z10PA-D8C là giải pháp lý tưởng cho hệ thống máy chủ nhóm, máy chủ lưu trữ Hadoop, các ứng dụng máy chủ lưu trữ khác và trung tâm dữ liệu của các doanh nghiệp vừa và nhỏ (SMB).'),
(20, 'Mainboard Asrock Rack EP2C602 - Dual CPU Socket 2011', 16, 9, 7590000, 10, 0, 'Sản phẩm sử dụng CPU Intel Xeon E5 - 2680 v2 (Mã SP: CPUI252). Tối ưu đa nhiệm của hệ thống máy chủ Server và máy Trạm WORKSTATIONS'),
(21, 'CPU Intel Xeon Silver 4110 (2.1GHz turbo up to 3.0GHz, 8 nhân, 16 luồng, 11MB Cache, 85W) - Socket Intel LGA 3647', 18, 8, 11000000, 5, 0, 'Dòng sản phẩm chuyên biệt dành cho server/máy trạm\n8 nhân & 16 luồng\nXung nhịp: 2.1GHz (Cơ bản) / 3.0GHz (Boost)\nSocket: LGA 3647\nHỗ trợ RAM ECC\nKhông kèm quạt tản nhiệt từ hãng\nKhông tích hợp sẵn iGPU'),
(22, 'CPU Intel Core i9-9900KF (3.6GHz turbo up to 5.0GHz, 8 nhân 16 luồng, 16MB Cache, 95W) - Socket Intel LGA 1151-v2', 18, 8, 11550000, 4, 0, 'Phiên bản cắt giảm đi nhân đồ họa tích hợp của 9900K\nSố nhân: 8\nSố luồng: 16\nTốc độ cơ bản: 3.6 GHz\nTốc độ tối đa: 5.0 GHz\nCache: 16MB\nTiến trình sản xuất: 14nm'),
(23, 'CPU AMD Ryzen 7 3700X (3.6GHz turbo up to 4.4GHz, 8 nhân 16 luồng, 36MB Cache, 65W) - Socket AMD AM4', 17, 8, 8250000, 10, 0, 'CPU Ryzen thế hệ thứ 3, tiến trình sản xuất 7nm\n8 nhân, 16 luồng, xung nhịp mặc định 3.6 GHz, xung nhịp boost tối đa 4.4 GHz\nHỗ trợ PCI-e 4.0\nCó hỗ trợ ép xung\nĐi kèm tản nhiệt Wraith Prism với RGB LED'),
(24, 'CPU AMD Ryzen 5 3400G (3.7GHz turbo up to 4.2GHz, 4 nhân 8 luồng, 4MB Cache, Radeon Vega 11, 65W) - Socket AMD AM4', 17, 8, 4945000, 10, 0, 'a'),
(25, 'CPU Intel Xeon E-2236 (3.4GHz turbo up to 4.8GHz, 6 nhân, 12 luồng, 12 MB Cache, 80W) - Socket Intel LGA 1151-v2', 18, 8, 7480000, 15, 0, 'a'),
(26, 'Nguồn FSP Power Supply HYDRO Series Model HD600 Active PFC (80 Plus Bronze/Màu Đen)', 20, 11, 1680000, 5, 0, 'Model : HD600'),
(27, 'Nguồn Corsair SF Series SF600 600W (80 Plus Gold Certified High Performance SFX/Màu Đen)', 21, 11, 3450000, 6, 0, 'Hãng sản xuất: Corsair\nChủng loại: Corsair SF Series SF600\nChuẩn nguồn : ATX12V ver2.31\nCông suất danh định : 600W\nCông suất thực : 600W\nĐường điện vào: (100~240V)'),
(28, 'Nguồn FSP Power Supply HYDRO-GE Series Model HGE650 Active PFC (80 Plus Gold/Full Modular/ ATX/Màu Đen)', 20, 11, 2530000, 9, 0, 'Tuân thủ ATX12 v2.4 & EPS12 v2.92\nHiệu quả cao ≧ 90%\nPFC hoạt động ≧ 0,9\nĐạt chứng nhận 80PLUS® GOLD\nNhãn dán có thể thay đổi cho những người đam mê DIY và game thủ\nThiết kế đường 12V Single Rail\nDây nguồn rời toàn bộ với cáp dẹt\nToàn bộ tụ điện của Nhật Bản\nHỗ trợ các đầu nối PCI-Express 6 + 2 pin\nQuạt FDB 135mm yên tĩnh và lâu dài\nBảo vệ hoàn toàn: OCP, OVP, SCP, OPP, UVP, OTP\nĐược chứng nhận tiêu chuẩn an toàn toàn cầu\nNguồn FSP HYDRO-GE Series Model HGE650 - White - Active PFC - 80 Plus Gold'),
(29, 'Nguồn Asus ROG Thor 1200W Platinum - RGB 1200W 80 Plus Platinum Full Modular', 2, 11, 9900000, 10, 0, 'Công nghệ Aura Sync : Tùy biến nâng cao với LED RGB địa chỉ và tương thích Aura Sync\nMàn hình nguồn OLED : Theo dõi việc sử dụng điện năng theo thời gian thực bằng màn hình nguồn OLED\nGiải pháp tản nhiệt ROG : làm mát 0dB với thiết kế quạt hình cánh chống bụi đạt chứng nhận IP5X và tản nhiệt ROG\n80 PLUS Platinum : Được tích hợp các tụ điện 100% của Nhật Bản và các linh kiện cao cấp khác\nCáp luồn: Đảm bảo lắp đặt dễ dàng và tính thẩm mỹ vượt trội'),
(30, 'Nguồn Jetek P700 700W (Màu Đen/Led RGB )', 19, 11, 1920000, 5, 0, 'Hiệu suất cao lên tới 85%\nThiết kế cấu truc tổ ong, tối ưu luồng gió lưu thông làm mát\nNgõ ra điện áp +12V tăng cường công suất, mở rộng khả năng sử dụng\nQuạt làm mát 12cm đem lại sự yên tĩnh khi hoạt động\nDC to DC Converter\nQuạt RGB độc đáo'),
(31, 'Card màn hình GIGABYTE RX570 GAMING-4G (rev. 2.0) (4GB GDDR5, 256-bit, HDMI+DP, 1x8-pin)', 15, 10, 5720000, 5, 0, 'VGA Gigabyte RX570GAMING-4GD\nDung lượng bộ nhớ: 4GB GDDR5\nOC Mode : 1255MHz\nGaming Mode (Default): 1244MHz\nCổng kết nổi: 3x DP, 1x HDMI'),
(32, 'Card màn hình GIGABYTE GTX 1660 Super OC-6G (6GB GDDR6, 192-bit, HDMI+DP, 1x8-pin)', 15, 10, 13650000, 18, 0, 'Dung lượng bộ nhớ: 6GB GDDR6\nCore clock: 1830 MHz\nBăng thông: 192-bit\nKết nối: DisplayPort 1.4 *3, HDMI 2.0b *1\nNguồn yêu cầu: 450W'),
(33, 'Card màn hình ASUS ROG STRIX RX570-O4G GAMING (4GB GDDR5, 256-bit, DVI+HDMI+DP, 1x8-pin)', 2, 10, 4370000, 10, 0, 'Dung lượng bộ nhớ: 4GB GDDR5\nLên tới 1310 Mhz (Chế độ ép xung)\nLên tới 1300 Mhz (Chế độ chơi game)\nBăng thông: 256-bit\nKhuyến cáo dùng nguồn 450W'),
(34, 'Vga Card ASUS Dual RX580 - O8G', 2, 10, 5830000, 6, 0, 'Engine đồ họa : AMD Radeon RX 580\nBộ nhớ : GDDR5 8GB\nEngine Clock : 1380 MHz (OC Mode)\nĐộ phân giải : Digital Max Resolution:7680x4320\nPower Connectors  : 1 x 8-pin'),
(35, 'Card màn hình MSI GTX 1660 Super GAMING X (6GB GDDR6, 192-bit, HDMI+DP)', 14, 10, 14280000, 5, 0, 'Phiên bản GTX 1660 Super tốt nhất từ MSI\nXung nhân tối đa: 1830 MHz\nBộ nhớ: 6GB GDDR6\nCổng kết nối: DisplayPort x 3 / HDMI x 1\nQuạt TORX Fan 2.0\nHỗ trợ NVIDIA G-SYNC™ và HDR'),
(36, 'Mouse Roccat Kone Pure Optical Core Performance', 22, 15, 1800000, 10, 0, 'Chuột chơi game cao cấp dành cho game thủ thuật tay phải\nMắt cảm biến Laser 8200 DPI\nĐèn LED 16.8 triệu màu tùy chỉnh\nNút bấm Omron cho tuổi thọ 10 triệu lượt nhấn và cảm giác nhấn mềm mại\n7 nút bấm có thể điều chỉnh tùy biến bằng driver\nNút cuộn được trang bị công nghệ Titan\nBộ nhớ bên trong lên tới 500KB\nVỏ ngoai của chuột cực kì bền bỉ'),
(37, 'Mouse V-King M525 RGB Gaming Black', 23, 15, 437500, 10, 0, 'Mouse V-King M525 RGB Gaming\nMắt cảm biến PMW3325\nĐộ phẩn giải: 8000 DPI\nThiết kế đối xứng phù hợp cho cả 2 tay\nNút bấm có tuổi thọ lên đến 30 triệu lần nhấn\nTrang bị led RGB có thể tuỳ chỉnh'),
(38, 'Mouse Cougar Minos X5 RGB Pixart 3360', 24, 15, 1080000, 20, 0, 'Mouse Cougar Minos X5 RGB Pixart 3360\nMinos X5 sử dụng mắt cảm biến chơi game cao cấp nhất thế giới là Pixart 3360\nCũng là chú chuột rẻ nhất sử dụng mắt cảm biến này\nNút chuột Omron cho cảm giác bấm mềm mại\nHệ thống led RGB 16,8 triệu màu\nThiết kế Ambidextrous phù hợp với nhiều tựa game như FPS và MOBA\nPhù hợp với game thủ tay Nhỏ - Trung Bình'),
(39, 'Tai nghe Kingston HyperX Cloud II Gaming  Red (KHX-HSCP-RD)', 12, 13, 2400000, 10, 0, 'Phiên bản Cloud 2 II với công nghệ giả lập âm thanh vòm 7.1\nSử dụng chiếc Soundcard 7.1, chỉ cần cắm và sử dụng\nKhông cần Driver điều chỉnh\nThiết kế cứng cáp, cảm giác đeo thoải mái trong nhiều giờ\nChất âm thiên sáng, chi tiết tốt, phù hợp với các game thi đấu ESPORTS\nMicrophone có thể được tháo rời thuận tiện\nĐược khuyên dùng bởi các game thủ CS:GO chuyên nghiệp'),
(40, 'Tai nghe Zidli ZH11S LED RGB USB Black', 25, 13, 562500, 10, 0, 'Tai nghe Zidli ZH11S RGB\nChuẩn kết nối : USB\nEarcup full-size trang bị ốp da chống ồn\nKhung thép chắc chắn\nLed RGB'),
(41, 'Tai nghe Logitech G231 Prodigy Gaming Headset', 26, 13, 1080000, 22, 0, 'Kiểu kết nối: Tai nghe có dây\nMicrophone: Có\nKích thước driver: 40 mm\nTrở kháng: 32 ohms\nTần số phản hồi: 20 - 20,000 Hz\nKhối lượng: 255 g\nTai nghe chơi game Logitech G231\nTai nghe âm thanh Stereo chất lượng cao\nĐệm tai nghe làm bằng vải cho cảm giác thooải mái khi đeo lâu dài\nTrọng lượng nhẹ, mic có thể gập gọn\nTích hợp bộ điều khiển trên dây'),
(42, 'Bàn phím gaming Fuhlen M87S RGB Mechanical Blue Switch 87 Black', 27, 14, 840000, 18, 0, 'Chiếc bàn phím cơ bán chạy nhất của Fuhlen\nPhiên bản mới 2019 với font chữ đẹp hơn\nLoại bỏ logo Rồng trước đây của Fuhlen\nLoại Switch Huano mới với sự cải tiến chất lương gõ cho cảm giác nhấn tương đương Kailh Switch\nLed RGB sáng nhất trong phân khúc dưới 1 triệu đồng'),
(43, 'Bàn phím cơ Geezer GS4 RGB Mechanical Blue Switch 87 Black', 28, 14, 840000, 16, 0, 'Hãng sản xuất : Bàn phím Geezer\nChủng loại : Keyboard Geezer GS4 RGB Mechanical Blue Switch 87 Black\nChuẩn bàn phím : Có dây\nChuẩn giao tiếp : USB'),
(44, 'Bàn phím gaming Eblue Eblue EKM 757BGUS-IU USB Black', 29, 14, 1200000, 5, 0, 'Hãng sản xuất : Bàn phím EBLUE\nChủng loại : Keyboard Eblue Mazer Mechanical EKM 757BGUS-IU USB Black\nChuẩn bàn phím : Có dây\nChuẩn giao tiếp : USB 2.0\nCông nghệ phím : Bàn phím cơ -Switch: đen, xanh Content');

--
-- Bẫy `product`
--
DELIMITER $$
CREATE TRIGGER `after_product_delete` AFTER DELETE ON `product` FOR EACH ROW begin
    declare masp bigint(20);
    declare isactive tinyint(1);
    
    set masp = OLD.product_id;
    delete from product_promotion where product_promotion.product_id = masp;
    delete from product_image where product_image.product_id = masp;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_product_insert` AFTER INSERT ON `product` FOR EACH ROW begin
    declare makh bigint(20);
    
    declare list_makh cursor for (select account_id from computerstore.account where account.account_type_id = '3');
    open list_makh;
	fetch list_makh into makh;
        insert into voucher (customer_id, voucher_level) values (makh, 20); 
    close list_makh;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `products`
-- (See below for the actual view)
--
CREATE TABLE `products` (
`product_id` int(11)
,`product_name` varchar(255)
,`trademark_id` int(11)
,`product_type_id` int(11)
,`price` double
,`amount` int(11)
,`description` text
,`trademark_name` varchar(255)
,`product_type_name` varchar(255)
,`image` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_image`
--

CREATE TABLE `product_image` (
  `product_image_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product_image`
--

INSERT INTO `product_image` (`product_image_id`, `product_id`, `image`) VALUES
(1, 1, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/laptop-1.png?alt=media&token=9d11cf53-b08c-42d2-aa5b-4960339f77e8'),
(2, 2, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/laptop-3.png?alt=media&token=6685494a-e0bf-49af-91f8-da017f1a95f4'),
(3, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/laptop-4.png?alt=media&token=3d0c47ec-e933-475d-b80c-b39121bce70f'),
(4, 4, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/laptop-2.png?alt=media&token=9c95e637-3974-4bed-acea-f19e0174cd8a'),
(5, 5, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/laptop-6.png?alt=media&token=442198d7-cd6e-43f3-a199-60f66eb2ae77'),
(6, 11, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/48711_gskill_trident_z_neo.jpg?alt=media&token=c763c4a8-a6eb-42b6-bb4c-4a1966ca3add'),
(7, 12, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/47346_kingston_ecc_16gb_2400mhz_ksm24ed8.jpg?alt=media&token=b6d3db27-add2-4b49-acfd-e7e70504a2ca'),
(8, 13, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/47682_kingston_ecc__32gb2666_ksm26rd432hai.jpg?alt=media&token=811f2b48-01f0-4f57-bc4d-874636e870ef'),
(9, 14, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/18043_ram_axpro_green_pcb_ddr3.jpg?alt=media&token=2c35335f-157d-4f71-8339-eaf539ddcadb'),
(10, 15, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/49954_micron_ecc_16gb_2133mhz.jpg?alt=media&token=96d5011f-3b03-4bd9-92c2-684bde62e0e0'),
(11, 16, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/43988_mainboard_msi_b450m_gaming_plus_0004_5.jpg?alt=media&token=034b2b21-dc89-41f2-90ff-2948737056ad'),
(12, 17, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/41790_mainboard_gigabyte_h310m_ds2_0000_1.jpg?alt=media&token=ffe38478-453b-4910-8685-59a82ab082d8'),
(13, 18, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/27076_asus_z10pe_d16_ws_dual_cpu_workstation_0000_1.jpg?alt=media&token=2ce0623f-078c-4ecc-9664-0986aa363f6d'),
(14, 19, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/33404_mainboard_asus_z10pa_d8c_dual_cpu_workstation_0000_1.jpg?alt=media&token=fb8d7220-cd54-49f2-b7f5-257adb8208c7'),
(16, 20, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/36253_mainboard_asrock_rack_ep2c602_dual_cpu_socket_2011_0001_2.jpg?alt=media&token=0e2d4d31-08be-486e-a700-89b68e67ac1a'),
(17, 21, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_40825_hnc_intel_xeon_silver_right_facing_850x850.jpg?alt=media&token=b75e6539-2925-400a-87f9-16505f8b58c2'),
(18, 22, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_45160_hnc_intel_i9_9900kf_right_facing_850x850.jpg?alt=media&token=8fe5c779-6baf-4266-a569-29a934b5d3dd'),
(19, 23, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_47184_hnc_amd_ryzen_7_right_facing_850x850.jpg?alt=media&token=b786cb3f-e250-4216-a4f6-3addd809d547'),
(20, 24, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_47181_hnc_ryzen_5g_right_facing_850x850.jpg?alt=media&token=c2bed570-83f7-4f1b-b6e2-fedbaeaf319c'),
(21, 25, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_48418_hnc_intel_xeon_e_coffee_lake_right_facing_850x850.jpg?alt=media&token=20f9b3a3-b13b-490c-9f15-e4d7e2187a58'),
(22, 26, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_31135_nguon_fsp_hydro_series_600w_model_hd600_0001_2.jpg?alt=media&token=4c490b79-0bee-4a35-a1a4-187d188c7b89'),
(23, 27, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_35292_corsair_sf_series_sf600_600w_80_plus_gold_certified_high_performance_sfx_0007_8.jpg?alt=media&token=63a9c1c7-1229-4430-bff2-28a40b06c61f'),
(24, 28, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_40894_fsp_power_supply_hydro_ge_series_model_hge650_0001_2.jpg?alt=media&token=c4f78a44-6658-4372-803f-78fcad571229'),
(25, 29, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_45770_rog_thor_1200p_box_psu.jpg?alt=media&token=32c3f113-3b45-4537-b0ab-eda5cc85887a'),
(26, 30, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_49302_nguon_may_tinh_jetek_p700_rgb_80_plus_bronze_0003_1__2_.jpg?alt=media&token=f7ec2911-e05e-4280-bc64-8591d2c0b766'),
(27, 31, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_48191_rx_570_rev_2.jpg?alt=media&token=fcf376ee-a578-433f-9aa7-749cd0fec6e4'),
(28, 32, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_49667_gigabyte_1660_super_oc.png?alt=media&token=b1bf2eb8-daba-4292-a021-266ef4f1c970'),
(29, 33, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_37978_arez_strix_rx570_o4g_gaming_box_vga.png?alt=media&token=7e351bf1-7467-4bd2-85b5-1c841b8b7568'),
(30, 34, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_37921_arez_dual_rx580_o8g_box_vga.png?alt=media&token=82635a25-559b-4707-8bd1-a67a391dac0a'),
(31, 35, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_49690_msi_gtx_1660_super_gaming_6g_x__01.jpg?alt=media&token=960739b8-26ae-46bc-93a5-694b4ff282a5'),
(32, 36, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_15245_0_merc009_001.jpg?alt=media&token=ac411b44-0bbc-4d62-b3c6-a105ed185670'),
(33, 37, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_58480_mouse_v_king_m525_rgb_gaming_black.jpg?alt=media&token=d97fae1a-1780-4b3a-8467-bdfe5c761331'),
(34, 38, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_38590_mouse_cougar_minos_x5_rgb_pixart_3360_0001_1.jpg?alt=media&token=ec626191-720b-4679-b981-c5beec998c6a'),
(35, 39, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_27422_tai_nghe_kingston_hyperx_cloud_2_gaming_red_0000_1.jpg?alt=media&token=656c70af-7b91-46f4-9e86-57505552ebcb'),
(36, 40, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_41070_tai_nghe_zidli_zh11s_rgb_led_black_0000_1.jpg?alt=media&token=1920bb6c-6c57-46a0-a285-be4a79743c7b'),
(37, 41, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_34371_tai_nghe_logitech_g231_prodigy_gaming_headset_0000_1.jpg?alt=media&token=cca279db-49ba-4515-b4ce-adec773016f6'),
(38, 42, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_36329_keyboard_fuhlen_m87s_rgb_mechanical_blue_switch_87_black.jpg?alt=media&token=8afcee7b-ab71-4f5e-9c38-d1c6e0a26519'),
(39, 43, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_38255_keyboard_geezer_gs4_rgb_mechanical_blue_switch_87_black.jpg?alt=media&token=b4c70a0d-5dff-4813-838e-009673e8c261'),
(40, 44, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_40795_keyboard_eblue_eblue_ekm_757bgus_iu_usb_black_0002_3.jpg?alt=media&token=8fec233e-7744-4b28-937f-a10d8a602d93');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `product_image_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_promotion`
--

CREATE TABLE `product_promotion` (
  `product_promotion_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `promotion_date_id` int(11) NOT NULL,
  `promotion_level` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product_promotion`
--

INSERT INTO `product_promotion` (`product_promotion_id`, `product_id`, `promotion_date_id`, `promotion_level`) VALUES
(1, 1, 1, 3),
(2, 2, 1, 5),
(3, 3, 1, 5),
(4, 4, 1, 5),
(5, 5, 1, 5),
(6, 11, 1, 5),
(7, 12, 1, 5),
(8, 13, 1, 5),
(9, 14, 1, 5),
(10, 15, 1, 5),
(11, 16, 1, 5),
(12, 17, 1, 5),
(13, 18, 1, 5),
(14, 19, 1, 5),
(15, 20, 1, 5),
(16, 21, 1, 5),
(17, 22, 1, 5),
(18, 23, 1, 5),
(19, 24, 1, 5),
(20, 25, 1, 5),
(21, 26, 1, 5),
(22, 27, 1, 5),
(23, 28, 1, 5),
(24, 29, 1, 5),
(25, 30, 1, 5),
(26, 31, 1, 5),
(27, 32, 1, 5),
(28, 33, 1, 5),
(29, 34, 1, 5),
(30, 35, 1, 5),
(31, 36, 1, 5),
(32, 37, 1, 5),
(33, 38, 1, 5),
(34, 39, 1, 5),
(35, 40, 1, 5),
(36, 41, 1, 5),
(37, 42, 1, 5),
(38, 43, 1, 5),
(39, 44, 1, 5),
(40, 1, 2, 5),
(41, 2, 2, 5),
(42, 3, 2, 5),
(43, 4, 2, 5),
(44, 5, 2, 5),
(45, 11, 2, 5),
(46, 12, 2, 5),
(47, 13, 2, 5),
(48, 14, 2, 5),
(49, 15, 2, 5),
(50, 16, 2, 5),
(51, 17, 2, 5),
(52, 18, 2, 5),
(53, 19, 2, 5),
(54, 20, 2, 5),
(55, 21, 2, 5),
(56, 22, 2, 5),
(57, 23, 2, 5),
(58, 24, 2, 5),
(59, 25, 2, 5),
(60, 26, 2, 5),
(61, 27, 2, 5),
(62, 28, 2, 5),
(63, 29, 2, 5),
(64, 30, 2, 5),
(65, 31, 2, 5),
(66, 32, 2, 5),
(67, 33, 2, 5),
(68, 34, 2, 5),
(69, 35, 2, 5),
(70, 36, 2, 5),
(71, 37, 2, 5),
(72, 38, 2, 5),
(73, 39, 2, 5),
(74, 40, 2, 5),
(75, 41, 2, 5),
(76, 42, 2, 5),
(77, 43, 2, 5),
(78, 44, 2, 5),
(79, 1, 3, 5),
(80, 2, 3, 5),
(81, 3, 3, 5),
(82, 4, 3, 5),
(83, 5, 3, 5),
(84, 11, 3, 5),
(85, 12, 3, 5),
(86, 13, 3, 5),
(87, 14, 3, 5),
(88, 15, 3, 5),
(89, 16, 3, 5),
(90, 17, 3, 5),
(91, 18, 3, 5),
(92, 19, 3, 5),
(93, 20, 3, 5),
(94, 21, 3, 5),
(95, 22, 3, 5),
(96, 23, 3, 5),
(97, 24, 3, 5),
(98, 25, 3, 5),
(99, 26, 3, 5),
(100, 27, 3, 5),
(101, 28, 3, 5),
(102, 29, 3, 5),
(103, 30, 3, 5),
(104, 31, 3, 5),
(105, 32, 3, 5),
(106, 33, 3, 5),
(107, 34, 3, 5),
(108, 35, 3, 5),
(109, 36, 3, 5),
(110, 37, 3, 5),
(111, 38, 3, 5),
(112, 39, 3, 5),
(113, 40, 3, 5),
(114, 41, 3, 5),
(115, 42, 3, 5),
(116, 43, 3, 5),
(117, 44, 3, 5),
(118, 1, 4, 10),
(119, 2, 4, 10),
(120, 3, 4, 10),
(121, 4, 4, 10),
(122, 5, 4, 10),
(123, 11, 4, 10),
(124, 12, 4, 10),
(125, 13, 4, 10),
(126, 14, 4, 10),
(127, 15, 4, 10),
(128, 16, 4, 10),
(129, 17, 4, 10),
(130, 18, 4, 10),
(131, 19, 4, 10),
(132, 20, 4, 10),
(133, 21, 4, 10),
(134, 22, 4, 10),
(135, 23, 4, 10),
(136, 24, 4, 10),
(137, 25, 4, 10),
(138, 26, 4, 10),
(139, 27, 4, 10),
(140, 28, 4, 10),
(141, 29, 4, 10),
(142, 30, 4, 10),
(143, 31, 4, 10),
(144, 32, 4, 10),
(145, 33, 4, 10),
(146, 34, 4, 10),
(147, 35, 4, 10),
(148, 36, 4, 10),
(149, 37, 4, 10),
(150, 38, 4, 10),
(151, 39, 4, 10),
(152, 40, 4, 10),
(153, 41, 4, 10),
(154, 42, 4, 10),
(155, 43, 4, 10),
(156, 44, 4, 10),
(157, 1, 5, 5),
(158, 2, 5, 5),
(159, 3, 5, 5),
(160, 4, 5, 5),
(161, 5, 5, 5),
(162, 11, 5, 5),
(163, 12, 5, 5),
(164, 13, 5, 5),
(165, 14, 5, 5),
(166, 15, 5, 5),
(167, 16, 5, 5),
(168, 17, 5, 5),
(169, 18, 5, 5),
(170, 19, 5, 5),
(171, 20, 5, 5),
(172, 21, 5, 5),
(173, 22, 5, 5),
(174, 23, 5, 5),
(175, 24, 5, 5),
(176, 25, 5, 5),
(177, 26, 5, 5),
(178, 27, 5, 5),
(179, 28, 5, 5),
(180, 29, 5, 5),
(181, 30, 5, 5),
(182, 31, 5, 5),
(183, 32, 5, 5),
(184, 33, 5, 5),
(185, 34, 5, 5),
(186, 35, 5, 5),
(187, 36, 5, 5),
(188, 37, 5, 5),
(189, 38, 5, 5),
(190, 39, 5, 5),
(191, 40, 5, 5),
(192, 41, 5, 5),
(193, 42, 5, 5),
(194, 43, 5, 5),
(195, 44, 5, 5),
(196, 1, 6, 5),
(197, 2, 6, 5),
(198, 3, 6, 5),
(199, 4, 6, 5),
(200, 5, 6, 5),
(201, 11, 6, 5),
(202, 12, 6, 5),
(203, 13, 6, 5),
(204, 14, 6, 5),
(205, 15, 6, 5),
(206, 16, 6, 5),
(207, 17, 6, 5),
(208, 18, 6, 5),
(209, 19, 6, 5),
(210, 20, 6, 5),
(211, 21, 6, 5),
(212, 22, 6, 5),
(213, 23, 6, 5),
(214, 24, 6, 5),
(215, 25, 6, 5),
(216, 26, 6, 5),
(217, 27, 6, 5),
(218, 28, 6, 5),
(219, 29, 6, 5),
(220, 30, 6, 5),
(221, 31, 6, 5),
(222, 32, 6, 5),
(223, 33, 6, 5),
(224, 34, 6, 5),
(225, 35, 6, 5),
(226, 36, 6, 5),
(227, 37, 6, 5),
(228, 38, 6, 5),
(229, 39, 6, 5),
(230, 40, 6, 5),
(231, 41, 6, 5),
(232, 42, 6, 5),
(233, 43, 6, 5),
(234, 44, 6, 5),
(235, 1, 7, 6),
(236, 2, 7, 6),
(237, 3, 7, 6),
(238, 4, 7, 6),
(239, 5, 7, 6),
(240, 11, 7, 6),
(241, 12, 7, 6),
(242, 13, 7, 6),
(243, 14, 7, 6),
(244, 15, 7, 6),
(245, 16, 7, 6),
(246, 17, 7, 6),
(247, 18, 7, 6),
(248, 19, 7, 6),
(249, 20, 7, 6),
(250, 21, 7, 6),
(251, 22, 7, 6),
(252, 23, 7, 6),
(253, 24, 7, 6),
(254, 25, 7, 6),
(255, 26, 7, 6),
(256, 27, 7, 6),
(257, 28, 7, 6),
(258, 29, 7, 6),
(259, 30, 7, 6),
(260, 31, 7, 6),
(261, 32, 7, 6),
(262, 33, 7, 6),
(263, 34, 7, 6),
(264, 35, 7, 6),
(265, 36, 7, 6),
(266, 37, 7, 6),
(267, 38, 7, 6),
(268, 39, 7, 6),
(269, 40, 7, 6),
(270, 41, 7, 6),
(271, 42, 7, 6),
(272, 43, 7, 6),
(273, 44, 7, 6),
(274, 1, 8, 5),
(275, 2, 8, 5),
(276, 3, 8, 5),
(277, 4, 8, 5),
(278, 5, 8, 5),
(279, 11, 8, 5),
(280, 12, 8, 5),
(281, 13, 8, 5),
(282, 14, 8, 5),
(283, 15, 8, 5),
(284, 16, 8, 5),
(285, 17, 8, 5),
(286, 18, 8, 5),
(287, 19, 8, 5),
(288, 20, 8, 5),
(289, 21, 8, 5),
(290, 22, 8, 5),
(291, 23, 8, 5),
(292, 24, 8, 5),
(293, 25, 8, 5),
(294, 26, 8, 5),
(295, 27, 8, 5),
(296, 28, 8, 5),
(297, 29, 8, 5),
(298, 30, 8, 5),
(299, 31, 8, 5),
(300, 32, 8, 5),
(301, 33, 8, 5),
(302, 34, 8, 5),
(303, 35, 8, 5),
(304, 36, 8, 5),
(305, 37, 8, 5),
(306, 38, 8, 5),
(307, 39, 8, 5),
(308, 40, 8, 5),
(309, 41, 8, 5),
(310, 42, 8, 5),
(311, 43, 8, 5),
(312, 44, 8, 5),
(313, 1, 9, 5),
(314, 2, 9, 5),
(315, 3, 9, 5),
(316, 4, 9, 5),
(317, 5, 9, 5),
(318, 11, 9, 5),
(319, 12, 9, 5),
(320, 13, 9, 5),
(321, 14, 9, 5),
(322, 15, 9, 5),
(323, 16, 9, 5),
(324, 17, 9, 5),
(325, 18, 9, 5),
(326, 19, 9, 5),
(327, 20, 9, 5),
(328, 21, 9, 5),
(329, 22, 9, 5),
(330, 23, 9, 5),
(331, 24, 9, 5),
(332, 25, 9, 5),
(333, 26, 9, 5),
(334, 27, 9, 5),
(335, 28, 9, 5),
(336, 29, 9, 5),
(337, 30, 9, 5),
(338, 31, 9, 5),
(339, 32, 9, 5),
(340, 33, 9, 5),
(341, 34, 9, 5),
(342, 35, 9, 5),
(343, 36, 9, 5),
(344, 37, 9, 5),
(345, 38, 9, 5),
(346, 39, 9, 5),
(347, 40, 9, 5),
(348, 41, 9, 5),
(349, 42, 9, 5),
(350, 43, 9, 5),
(351, 44, 9, 5),
(352, 1, 10, 5),
(353, 2, 10, 5),
(354, 3, 10, 5),
(355, 4, 10, 5),
(356, 5, 10, 5),
(357, 11, 10, 5),
(358, 12, 10, 5),
(359, 13, 10, 5),
(360, 14, 10, 5),
(361, 15, 10, 5),
(362, 16, 10, 5),
(363, 17, 10, 5),
(364, 18, 10, 5),
(365, 19, 10, 5),
(366, 20, 10, 5),
(367, 21, 10, 5),
(368, 22, 10, 5),
(369, 23, 10, 5),
(370, 24, 10, 5),
(371, 25, 10, 5),
(372, 26, 10, 5),
(373, 27, 10, 5),
(374, 28, 10, 5),
(375, 29, 10, 5),
(376, 30, 10, 5),
(377, 31, 10, 5),
(378, 32, 10, 5),
(379, 33, 10, 5),
(380, 34, 10, 5),
(381, 35, 10, 5),
(382, 36, 10, 5),
(383, 37, 10, 5),
(384, 38, 10, 5),
(385, 39, 10, 5),
(386, 40, 10, 5),
(387, 41, 10, 5),
(388, 42, 10, 5),
(389, 43, 10, 5),
(390, 44, 10, 5),
(391, 1, 11, 5),
(392, 2, 11, 5),
(393, 3, 11, 5),
(394, 4, 11, 5),
(395, 5, 11, 5),
(396, 11, 11, 5),
(397, 12, 11, 5),
(398, 13, 11, 5),
(399, 14, 11, 5),
(400, 15, 11, 5),
(401, 16, 11, 5),
(402, 17, 11, 5),
(403, 18, 11, 5),
(404, 19, 11, 5),
(405, 20, 11, 5),
(406, 21, 11, 5),
(407, 22, 11, 5),
(408, 23, 11, 5),
(409, 24, 11, 5),
(410, 25, 11, 5),
(411, 26, 11, 5),
(412, 27, 11, 5),
(413, 28, 11, 5),
(414, 29, 11, 5),
(415, 30, 11, 5),
(416, 31, 11, 5),
(417, 32, 11, 5),
(418, 33, 11, 5),
(419, 34, 11, 5),
(420, 35, 11, 5),
(421, 36, 11, 5),
(422, 37, 11, 5),
(423, 38, 11, 5),
(424, 39, 11, 5),
(425, 40, 11, 5),
(426, 41, 11, 5),
(427, 42, 11, 5),
(428, 43, 11, 5),
(429, 44, 11, 5);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_promotions`
--

CREATE TABLE `product_promotions` (
  `product_promotion_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `promotion_date_id` bigint(20) NOT NULL,
  `promotion_level` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_type`
--

CREATE TABLE `product_type` (
  `product_type_id` int(11) NOT NULL,
  `product_type_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product_type`
--

INSERT INTO `product_type` (`product_type_id`, `product_type_name`, `description`) VALUES
(1, 'RAM', 'Bộ nhớ trong'),
(2, 'SSD,HDD', 'Ổ cứng'),
(3, 'Laptop', 'máy tính xách tay'),
(8, 'CPU', 'Bộ vi xử lý'),
(9, 'Main', 'Bo mạch chủ'),
(10, 'VGA', 'Card đồ họa'),
(11, 'PSU', 'Nguồn máy tính'),
(12, 'CASE', 'Vỏ cây máy tính'),
(13, 'Headphone', 'Tai nghe'),
(14, 'Keyboard', 'Bàn phím'),
(15, 'Mouse', 'Chuột ');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `promotion_date`
--

CREATE TABLE `promotion_date` (
  `promotion_date_id` int(11) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `promotion_date`
--

INSERT INTO `promotion_date` (`promotion_date_id`, `date`) VALUES
(1, '2021-04-22'),
(2, '2021-04-24'),
(3, '2021-04-25'),
(4, '2021-04-26'),
(5, '2021-04-27'),
(6, '2021-04-29'),
(7, '2021-04-30'),
(8, '2021-05-01'),
(9, '2021-05-02'),
(10, '2021-05-03'),
(11, '2021-05-04');

--
-- Bẫy `promotion_date`
--
DELIMITER $$
CREATE TRIGGER `after_promotion_date_delete` AFTER DELETE ON `promotion_date` FOR EACH ROW begin
    declare promotion_date_id bigint(20);
    
    set promotion_date_id = OLD.promotion_date_id ;
    delete from product_promotion where product_promotion.promotion_date_id = promotion_date_id;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `supplier_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supplier_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hotline` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `supplier_name`, `supplier_address`, `email`, `hotline`) VALUES
(1, 'Hà Nội Computer', 'Số  48 Thái Hà - Đống Đa - Hà Nội', 'Hoangphuong@anphatpc.com.vn', '0918.557.001'),
(5, 'An Phát', 'Hà Nội', 'huy@anphatpc.com.vn', '19000323'),
(6, 'Phong Vũ', 'số 371/ 20 Hai Bà Trưng, Phường 8, Quận 3, TPHCM', 'hoptac@phongvu.vn', '1800 6865'),
(7, 'KCC Shop', 'Số 2, ngõ 43 Cổ Nhuế, Phường Cổ Nhuế 2, Quận Bắc Từ Liêm, Thành phố Hà Nội', 'kccshop@gmail.com', '0912.074.444');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trademark`
--

CREATE TABLE `trademark` (
  `trademark_id` int(11) NOT NULL,
  `trademark_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `trademark`
--

INSERT INTO `trademark` (`trademark_id`, `trademark_name`, `image`) VALUES
(1, 'Dell', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/dell.PNG?alt=media&token=ee683a78-56df-46e4-8441-09598fdcaf5f'),
(2, 'Asus', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/asus.jpg?alt=media&token=70e92d2d-cfa5-420f-9626-07da6fb2723a'),
(3, 'Macbook', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/apple.jpg?alt=media&token=59351197-9d07-4188-bef6-991f0f18683f'),
(4, 'LG', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/LG.png?alt=media&token=ae38d16c-c75c-4b9d-8c84-88aa4f6e02e6'),
(5, 'Gskill', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/G.Skill.gif?alt=media&token=0a6977b4-7148-441f-bc84-b11380282d13'),
(11, 'Micron', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/micron.jpg?alt=media&token=89c22c6a-6b7e-4cf8-950f-c12eb7b6cd17'),
(12, 'Kingston', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/kingston.png?alt=media&token=2336f5ab-5a0d-498c-950c-fac8298888df'),
(13, 'AXPRO', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/axpro.jpg?alt=media&token=7e1c5618-6a53-4d10-8d73-5d3dd316759f'),
(14, 'MSI', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/msi.png?alt=media&token=53189108-b2a0-4f7f-afa5-53825b10d14b'),
(15, 'GIGABYTE', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/gigabyte.jpg?alt=media&token=9a85520a-6999-4415-80ec-43054e42d47f'),
(16, 'ASRock', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/asrock.jpg?alt=media&token=534b7ccc-b271-441b-a942-cb95ae97d7fe'),
(17, 'AMD', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/amd.jpg?alt=media&token=6812eb2f-a064-454b-9c69-f1a32a519c7c'),
(18, 'Intel', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/intel.jpg?alt=media&token=97ad12cd-531a-448f-b865-52e46ea74741'),
(19, 'Jetek', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/jetek.jpg?alt=media&token=22ee61dc-dfa9-4fc8-884e-d6b830ba1a08'),
(20, 'FSP', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/fsp.jpg?alt=media&token=024297e4-abf8-4c88-a513-748146afaeb8'),
(21, 'Corsair', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/corsair.jpg?alt=media&token=64d20c4f-bdee-43d4-885c-ab8b5a93a434'),
(22, 'Roccat', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/roccat.jpg?alt=media&token=fa2af8b6-ef92-459a-a791-dfad62504688'),
(23, 'V-King', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/vking.jpg?alt=media&token=f00cb31d-ee1d-4515-836c-7540c55f46b9'),
(24, 'Cougar', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/cougar.jpg?alt=media&token=d7cd5847-7827-44b8-b824-017b596121e8'),
(25, 'Zidli', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/zidli.jpg?alt=media&token=29316d2b-d1d8-4d20-b009-0236c6fc0b4d'),
(26, 'Logitech', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/logitech.jpg?alt=media&token=27749e09-9aa1-4f79-a3c5-a554783e99ac'),
(27, 'Fuhlen', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/fuhlen.jpg?alt=media&token=5a0e2ec1-6504-4863-802a-21139203bdc2'),
(28, 'Geezer', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/geezer.jpg?alt=media&token=9e32aee8-b890-4ed5-947b-223d4e844230'),
(29, 'Eblue', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/eblue.jpg?alt=media&token=732ea669-a3b6-4993-a4c6-4e1170542624');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `voucher`
--

CREATE TABLE `voucher` (
  `voucher_id` int(11) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `voucher_level` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `voucher`
--

INSERT INTO `voucher` (`voucher_id`, `customer_id`, `voucher_level`) VALUES
(2, 11, 50),
(3, 3, 20),
(4, 14, 50),
(5, 15, 50),
(6, 16, 50),
(7, 3, 20);

-- --------------------------------------------------------

--
-- Cấu trúc cho view `inventoryproducts`
--
DROP TABLE IF EXISTS `inventoryproducts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `inventoryproducts`  AS SELECT `product`.`product_id` AS `product_id`, `product`.`product_name` AS `product_name`, `product`.`trademark_id` AS `trademark_id`, `product`.`product_type_id` AS `product_type_id`, `product`.`price` AS `price`, `product`.`amount` AS `amount`, `product`.`description` AS `description`, `trademark`.`trademark_name` AS `trademark_name`, `product_type`.`product_type_name` AS `product_type_name`, (select `trademark`.`image` from `product_image` where `product_image`.`product_id` = `product`.`product_id` and `trademark`.`image` is not null) AS `image` FROM ((`product` join `trademark`) join `product_type`) WHERE `product`.`product_type_id` = `product_type`.`product_type_id` AND `product`.`trademark_id` = `trademark`.`trademark_id` AND `product`.`amount` > 0 ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `products`
--
DROP TABLE IF EXISTS `products`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `products`  AS SELECT `product`.`product_id` AS `product_id`, `product`.`product_name` AS `product_name`, `product`.`trademark_id` AS `trademark_id`, `product`.`product_type_id` AS `product_type_id`, `product`.`price` AS `price`, `product`.`amount` AS `amount`, `product`.`description` AS `description`, `trademark`.`trademark_name` AS `trademark_name`, `product_type`.`product_type_name` AS `product_type_name`, (select `product_image`.`image` from `product_image` where `product_image`.`product_id` = `product`.`product_id` and `product_image`.`image` is not null) AS `image` FROM ((`product` join `trademark`) join `product_type`) WHERE `product`.`product_type_id` = `product_type`.`product_type_id` AND `product`.`trademark_id` = `trademark`.`trademark_id` ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`account_id`);

--
-- Chỉ mục cho bảng `account_type`
--
ALTER TABLE `account_type`
  ADD PRIMARY KEY (`account_type_id`);

--
-- Chỉ mục cho bảng `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`bill_id`);

--
-- Chỉ mục cho bảng `bill_detail`
--
ALTER TABLE `bill_detail`
  ADD PRIMARY KEY (`bill_detail_id`);

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`);

--
-- Chỉ mục cho bảng `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`comment_id`);

--
-- Chỉ mục cho bảng `coupon`
--
ALTER TABLE `coupon`
  ADD PRIMARY KEY (`coupon_id`);

--
-- Chỉ mục cho bảng `coupon_detail`
--
ALTER TABLE `coupon_detail`
  ADD PRIMARY KEY (`coupon_detail_id`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`);

--
-- Chỉ mục cho bảng `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Chỉ mục cho bảng `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Chỉ mục cho bảng `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Chỉ mục cho bảng `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Chỉ mục cho bảng `order_status`
--
ALTER TABLE `order_status`
  ADD PRIMARY KEY (`order_status_id`);

--
-- Chỉ mục cho bảng `order_type`
--
ALTER TABLE `order_type`
  ADD PRIMARY KEY (`order_type_id`);

--
-- Chỉ mục cho bảng `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Chỉ mục cho bảng `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Chỉ mục cho bảng `product_image`
--
ALTER TABLE `product_image`
  ADD PRIMARY KEY (`product_image_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`product_image_id`);

--
-- Chỉ mục cho bảng `product_promotion`
--
ALTER TABLE `product_promotion`
  ADD PRIMARY KEY (`product_promotion_id`);

--
-- Chỉ mục cho bảng `product_promotions`
--
ALTER TABLE `product_promotions`
  ADD PRIMARY KEY (`product_promotion_id`);

--
-- Chỉ mục cho bảng `product_type`
--
ALTER TABLE `product_type`
  ADD PRIMARY KEY (`product_type_id`);

--
-- Chỉ mục cho bảng `promotion_date`
--
ALTER TABLE `promotion_date`
  ADD PRIMARY KEY (`promotion_date_id`);

--
-- Chỉ mục cho bảng `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Chỉ mục cho bảng `trademark`
--
ALTER TABLE `trademark`
  ADD PRIMARY KEY (`trademark_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Chỉ mục cho bảng `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`voucher_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `account`
--
ALTER TABLE `account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `account_type`
--
ALTER TABLE `account_type`
  MODIFY `account_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `bill`
--
ALTER TABLE `bill`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT cho bảng `bill_detail`
--
ALTER TABLE `bill_detail`
  MODIFY `bill_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `comment`
--
ALTER TABLE `comment`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `coupon`
--
ALTER TABLE `coupon`
  MODIFY `coupon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `coupon_detail`
--
ALTER TABLE `coupon_detail`
  MODIFY `coupon_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT cho bảng `news`
--
ALTER TABLE `news`
  MODIFY `news_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `order_status`
--
ALTER TABLE `order_status`
  MODIFY `order_status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `order_type`
--
ALTER TABLE `order_type`
  MODIFY `order_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT cho bảng `product_image`
--
ALTER TABLE `product_image`
  MODIFY `product_image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `product_image_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_promotion`
--
ALTER TABLE `product_promotion`
  MODIFY `product_promotion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=469;

--
-- AUTO_INCREMENT cho bảng `product_promotions`
--
ALTER TABLE `product_promotions`
  MODIFY `product_promotion_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_type`
--
ALTER TABLE `product_type`
  MODIFY `product_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `promotion_date`
--
ALTER TABLE `promotion_date`
  MODIFY `promotion_date_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `trademark`
--
ALTER TABLE `trademark`
  MODIFY `trademark_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `voucher`
--
ALTER TABLE `voucher`
  MODIFY `voucher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
