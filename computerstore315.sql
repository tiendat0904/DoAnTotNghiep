-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 31, 2021 lúc 11:06 AM
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
	
	(price*(1-(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id and promotion_date.date is not null)/100)) as price_new,
    (SELECT COUNT(*) from comment WHERE comment.product_id = product.product_id) AS countComment
	from product, trademark, product_type
	where product.product_type_id = product_type.product_type_id
	and product.trademark_id = trademark.trademark_id and product.product_id = masp;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listProduct` (IN `ngay` DATE)  begin
	select product.*, trademark_name, product_type_name, 
	(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id) as promotion_level,
	
	(price*(1-(select promotion_level from product_promotion, promotion_date where product_promotion.promotion_date_id = promotion_date.promotion_date_id and promotion_date.date = ngay and product_promotion.product_id = product.product_id and promotion_date.date is not null)/100)) as price_new,
    (SELECT COUNT(*) from comment WHERE comment.product_id = product.product_id) AS countComment
    
    
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
  `created_at` datetime NOT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `updatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `account`
--

INSERT INTO `account` (`account_id`, `email`, `password`, `full_name`, `address`, `phone_number`, `image`, `account_type_id`, `created_at`, `updatedBy`, `updatedDate`) VALUES
(1, 'hasagidzo@gmail.com', '$2y$10$I9p0uTQOMaFOHw6iZTJvausfXaN7WQ.nsUSeFJT1kwETRIslBapnm', 'Phạm Nhật Namn', 'Hà Nội', 386123362, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fdefault-avatar-profile.jpg?alt=media&token=fda73be2-cab4-4e57-9436-12bd88affe61', 3, '2021-04-14 00:00:00', 2, '2021-05-24 11:22:16'),
(2, 'tiendat09041999@gmail.com', '$2y$10$9y5ILr5I2ikrwn.PIIuBO.hf4sgNCIQNGgnK9LiFKJAkMCpEo4ZEe', 'Nguyễn Tiến Đạt', 'Nghệ An', 386123369, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fanh5.JPG?alt=media&token=b5ecc0bd-265b-4397-890a-a9f21acdcec5', 2, '2021-04-22 00:00:00', NULL, NULL),
(3, 'chatt@gmail.com', '$2y$10$9TdTFzyZf6NSsBwYmC5GzeZy.XUkVZPzlZxgLgwUT2fED1B9XgXzy', 'Phạm Nhật Vượng', 'Hà Tĩnh', 386123362, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/140296755_1749190178578007_2960540718958561319_o.jpg?alt=media&token=f37c851c-d038-46d1-b1cc-dcfe9c1d82e6', 3, '2021-04-14 00:00:00', 13, '2021-05-31 03:59:51'),
(4, 'tranthanhhai@gmail.com', '$2y$10$wQfTE4QMZMzDXvnZUKpilebekPnxpJzaJ3iNuTztrJTvcXl9qJgX2', 'Trần Thanh Hải', 'Nghệ An', 386123362, NULL, 2, '2021-04-14 00:00:00', NULL, NULL),
(5, 'donhunghiep@gmail.com', '$2y$10$EuTxJ.QfxBXwyVW4SwqAtuT8vGny4x0XZLCnVDAF6oM4ZSmm0o5zC', 'Đỗ Như Nghiệp', 'Nam Định', 123456789, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/basket-emply.PNG?alt=media&token=732d4ff3-9ebf-4f43-b89f-22c91787e89d', 2, '2021-04-14 00:00:00', NULL, NULL),
(6, 'nguyenvannam@gmail.com', '$2y$10$Um09IMsHpWZEkPc/OyuSCe3LNq9NOBfQHU1fgusdhC.0ZBKHaiIHG', 'Nguyễn Văn Nam', 'Hà nội', 386123362, NULL, 2, '2021-04-14 00:00:00', NULL, NULL),
(7, 'phanvanhoai@gmail.com', '$2y$10$Um09IMsHpWZEkPc/OyuSCe3LNq9NOBfQHU1fgusdhC.0ZBKHaiIHG', 'Phan Văn Hoài', 'Hà Tĩnh', 386123362, NULL, 2, '2021-04-20 00:00:00', NULL, NULL),
(11, 'vuquangminh@gmail.com', '$2y$10$Um09IMsHpWZEkPc/OyuSCe3LNq9NOBfQHU1fgusdhC.0ZBKHaiIHG', 'Vũ Quang Minh', 'Hưng Yên', 386123362, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fdefault-avatar-profile.jpg?alt=media&token=fda73be2-cab4-4e57-9436-12bd88affe61', 2, '2021-04-20 00:00:00', NULL, NULL),
(13, 'tiendatcomputerstore@gmail.com', '$2y$10$oZ03XxyC2FS.RIcAMFTvgOtajm50eZGCBavNdUHEdwBRqfk45/VlW', 'TienDatComputer', 'Nghệ An', 386123369, NULL, 1, '2021-04-22 00:00:00', 13, '2021-05-26 10:15:56'),
(14, 'buiminhthao@gmail.com', '$2y$10$GWMzJJSdSaT7yukLc/D.NO1M57lexf4bRg2/R5Kf7qNWh75rk3GSm', 'Bùi Minh Thảo', 'Hà Nộii', 982769175, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thao.jpg?alt=media&token=09d62f9a-71b8-480c-a341-7b958662323d', 3, '2021-05-05 09:24:55', NULL, NULL),
(16, 'nguyenthianhhang@gmail.com', '$2y$10$7TpBz8pufkKpFVNmP4PXJO8Mab9PF38ca0r2mCgGHHLHcDDiWoQeC', 'Nguyễn Thị Anh Hằng', 'Cam Lộc, Hà Tĩnh', 386123361, NULL, 3, '2021-05-06 09:30:56', NULL, NULL);

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
		insert into computerstore.voucher (customer_id, voucher_level) values (makh, 30);
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
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` int(10) NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_money` double NOT NULL DEFAULT 0,
  `into_money` double NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `bill`
--

INSERT INTO `bill` (`bill_id`, `employee_id`, `customer_id`, `order_status_id`, `order_type_id`, `name`, `email`, `address`, `phone_number`, `note`, `total_money`, `into_money`, `created_at`, `updatedDate`) VALUES
(1, 13, 0, 5, 1, 'Nguyễn Tiến Đạt', 'hasagidzo@gmail.com', 'Ngõ 5 Nguyễn Khánh Toàn, Quan Hoa,Cầu Giấy,Hà Nội', 386123369, 'Nhận hàng trong giờ hành chính', 24960000, 24960000, '2021-05-26 04:56:36', '2021-05-27 05:18:05'),
(2, 2, 0, 3, 2, 'Nguyễn Văn Toàn', 'nguyenvantoan@gmail.com', 'Số 312 Đào Tấn,Ba Đình,Hà Nội', 376456456, '', 720000, 720000, '2021-05-26 05:45:34', '2021-05-27 09:51:52'),
(3, 2, 0, 4, 1, 'Nguyễn Công Phượng', 'nguyencongphuong@gmail.com', 'Anh Sơn, Nghệ An', 386123362, '', 25380000, 25380000, '2021-05-26 05:52:56', '2021-05-27 09:52:02'),
(4, 2, 0, 5, 2, 'Vũ Văn Thanh', 'vuvanthanh@gmail.com', 'số 33 Chùa Láng,Đống Đa,Hà Nội', 386123322, '', 24160000, 24160000, '2021-05-27 05:56:08', '2021-05-27 09:52:14'),
(5, NULL, 0, 2, 1, 'Vũ Tuấn Anh', 'vutuananh@gmail.com', 'Ninh Bình', 397545678, '', 17850000, 17850000, '2021-05-27 05:59:36', NULL),
(6, NULL, 14, 2, 2, 'Bùi Minh Thảo', 'buiminhthao@gmail.com', 'Hà Nộii', 982769175, '', 46770000, 46770000, '2021-05-25 06:08:06', '2021-05-27 06:08:23'),
(8, NULL, 14, 2, 1, 'Bùi Minh Thảo', 'buiminhthao@gmail.com', 'Hà Nộii', 982769175, '', 11950000, 11950000, '2021-05-24 09:44:07', '2021-05-27 09:44:21'),
(9, NULL, 16, 2, 2, 'Nguyễn Thị Anh Hằng', 'nguyenthianhhang@gmail.com', 'Cam Lộc, Hà Tĩnh', 386123361, '', 27540000, 27540000, '2021-05-23 09:46:01', '2021-05-27 09:46:15'),
(10, NULL, 16, 2, 1, 'Nguyễn Thị Anh Hằng', 'nguyenthianhhang@gmail.com', 'Cam Lộc, Hà Tĩnh', 386123361, '', 22690000, 22690000, '2021-05-23 09:50:13', '2021-05-27 09:50:36');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bill_detail`
--

CREATE TABLE `bill_detail` (
  `bill_detail_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` double(15,2) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `bill_detail`
--

INSERT INTO `bill_detail` (`bill_detail_id`, `bill_id`, `product_id`, `price`, `amount`) VALUES
(1, 1, 2, 24960000.00, 1),
(2, 2, 42, 720000.00, 1),
(3, 3, 21, 11000000.00, 1),
(4, 3, 138, 1800000.00, 1),
(5, 3, 31, 4600000.00, 1),
(6, 3, 150, 7260000.00, 1),
(7, 3, 42, 720000.00, 1),
(8, 4, 22, 11025000.00, 1),
(9, 4, 34, 4600000.00, 1),
(10, 4, 152, 5175000.00, 1),
(11, 4, 44, 960000.00, 1),
(12, 4, 27, 2400000.00, 1),
(13, 5, 5, 17850000.00, 1),
(14, 6, 21, 11000000.00, 1),
(15, 6, 22, 11025000.00, 1),
(16, 6, 23, 7700000.00, 1),
(17, 6, 27, 2400000.00, 1),
(18, 6, 34, 4600000.00, 1),
(19, 6, 44, 960000.00, 1),
(20, 6, 152, 5175000.00, 1),
(21, 6, 154, 3910000.00, 1),
(30, 8, 16, 2040000.00, 1),
(31, 8, 27, 2400000.00, 1),
(32, 8, 37, 250000.00, 1),
(33, 8, 150, 7260000.00, 1),
(34, 9, 13, 6050000.00, 1),
(35, 9, 17, 1680000.00, 1),
(36, 9, 32, 13650000.00, 1),
(37, 9, 145, 6160000.00, 1),
(38, 10, 11, 2400000.00, 1),
(39, 10, 16, 2040000.00, 1),
(40, 10, 32, 13650000.00, 1),
(41, 10, 144, 4600000.00, 1);

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
-- Cấu trúc bảng cho bảng `build_pc`
--

CREATE TABLE `build_pc` (
  `build_pc_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` double NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `build_pc`
--

INSERT INTO `build_pc` (`build_pc_id`, `customer_id`, `product_id`, `price`, `quantity`) VALUES
(43, 14, 27, 2400000, 1),
(44, 14, 150, 7260000, 1),
(45, 14, 37, 250000, 1),
(50, 16, 16, 2040000, 1),
(51, 16, 32, 13650000, 1),
(52, 16, 11, 2400000, 1),
(53, 16, 144, 4600000, 1);

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
  `parentCommentId` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `rate` int(11) DEFAULT 0,
  `comment_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `comment`
--

INSERT INTO `comment` (`comment_id`, `parentCommentId`, `product_id`, `account_id`, `rate`, `comment_content`, `status`, `created_at`) VALUES
(1, NULL, 95, 14, 5, 'Sản phẩm sử dụng tốt !', 'Đã xác nhận', '2021-05-27 12:17:46'),
(2, NULL, 95, 14, 0, 'Con này nặng bao nhiêu ạ ?', 'Đã xác nhận', '2021-05-27 12:20:04'),
(3, 2, 95, 13, 0, 'Sản phẩm này nặng khoảng gần 2kg ạ .', 'Đã xác nhận', '2021-05-27 12:23:18'),
(4, NULL, 2, 14, 5, 'sản phẩm quá đẹp !', 'Đã xác nhận', '2021-05-28 12:14:19'),
(5, NULL, 2, 1, 4, 'sản phẩm chơi game mượt lắm !', 'Đã xác nhận', '2021-05-29 10:29:53'),
(6, NULL, 2, 14, 0, 'Laptop này có code được lập trình web không ạ ?', 'Đã xác nhận', '2021-05-29 10:49:04'),
(7, 6, 2, 13, 0, 'có nha bạn, laptop này cân mọi lập trình web ạ .', 'Đã xác nhận', '2021-05-29 11:41:15');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon`
--

CREATE TABLE `coupon` (
  `coupon_id` int(11) NOT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `employee_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `total_money` double(15,2) NOT NULL DEFAULT 0.00,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `updatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `coupon`
--

INSERT INTO `coupon` (`coupon_id`, `coupon_code`, `employee_id`, `supplier_id`, `total_money`, `note`, `created_at`, `updatedBy`, `updatedDate`) VALUES
(1, 'HNC1', 6, 1, 621000000.00, NULL, '2021-05-25 05:44:33', NULL, NULL),
(2, 'HNC2', 6, 1, 654000000.00, NULL, '2021-05-25 05:49:55', NULL, NULL),
(3, 'AP1', 4, 5, 505000000.00, NULL, '2021-05-25 05:54:10', NULL, NULL),
(4, 'AP2', 4, 5, 159000000.00, NULL, '2021-05-25 05:58:38', NULL, NULL),
(5, 'PV1', 5, 6, 1244000000.00, NULL, '2021-05-25 06:03:22', NULL, NULL),
(6, 'PV2', 5, 6, 466000000.00, NULL, '2021-05-25 06:07:36', NULL, NULL),
(7, 'KCC1', 6, 7, 912000000.00, NULL, '2021-05-25 06:14:23', NULL, NULL),
(8, 'KCC2', 6, 7, 521000000.00, NULL, '2021-05-25 06:17:23', NULL, NULL),
(9, 'HNC3', 7, 1, 116000000.00, NULL, '2021-05-25 06:21:29', NULL, NULL),
(10, 'AP3', 7, 5, 330000000.00, NULL, '2021-05-25 06:24:57', NULL, NULL),
(11, 'PV3', 11, 6, 462000000.00, NULL, '2021-05-25 06:29:59', NULL, NULL),
(12, 'PV4', 11, 6, 305500000.00, NULL, '2021-05-25 06:33:53', NULL, NULL),
(13, 'KCC3', 2, 7, 290500000.00, NULL, '2021-05-25 06:37:57', NULL, NULL),
(14, 'HNC4', 2, 1, 285600000.00, NULL, '2021-05-25 06:46:25', NULL, NULL);

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
(1, 1, 1, 23000000.00, 5),
(2, 1, 2, 24000000.00, 5),
(3, 1, 3, 12000000.00, 5),
(4, 1, 4, 13000000.00, 5),
(5, 1, 5, 17000000.00, 5),
(6, 1, 11, 2000000.00, 10),
(7, 1, 12, 2200000.00, 10),
(8, 1, 13, 5500000.00, 10),
(9, 1, 14, 100000.00, 10),
(10, 1, 15, 1200000.00, 10),
(11, 2, 16, 1700000.00, 10),
(12, 2, 17, 1400000.00, 10),
(13, 2, 18, 12000000.00, 10),
(14, 2, 19, 6800000.00, 10),
(15, 2, 20, 6500000.00, 10),
(16, 2, 21, 10000000.00, 10),
(17, 2, 22, 10500000.00, 10),
(18, 2, 23, 7000000.00, 10),
(19, 2, 24, 3000000.00, 10),
(20, 2, 25, 6500000.00, 10),
(21, 3, 26, 1000000.00, 10),
(22, 3, 27, 2000000.00, 10),
(23, 3, 28, 1500000.00, 10),
(24, 3, 29, 9000000.00, 10),
(25, 3, 30, 1000000.00, 10),
(26, 3, 31, 4000000.00, 10),
(27, 3, 32, 13000000.00, 10),
(28, 3, 33, 3000000.00, 10),
(29, 3, 34, 4000000.00, 10),
(30, 3, 35, 12000000.00, 10),
(31, 4, 36, 1000000.00, 10),
(32, 4, 37, 200000.00, 10),
(33, 4, 38, 800000.00, 10),
(34, 4, 39, 1800000.00, 10),
(35, 4, 40, 400000.00, 10),
(36, 4, 41, 800000.00, 10),
(37, 4, 42, 600000.00, 10),
(38, 4, 43, 500000.00, 10),
(39, 4, 44, 800000.00, 10),
(40, 4, 81, 18000000.00, 5),
(41, 5, 82, 10000000.00, 5),
(42, 5, 83, 45000000.00, 5),
(43, 5, 84, 28000000.00, 5),
(44, 5, 85, 50000000.00, 5),
(45, 5, 86, 28000000.00, 5),
(46, 5, 87, 28000000.00, 5),
(47, 5, 88, 18000000.00, 5),
(48, 5, 89, 19000000.00, 5),
(49, 5, 90, 17000000.00, 5),
(50, 5, 91, 2900000.00, 10),
(51, 6, 92, 5500000.00, 10),
(52, 6, 93, 6500000.00, 10),
(53, 6, 94, 7000000.00, 10),
(54, 6, 95, 6000000.00, 10),
(55, 6, 96, 2000000.00, 10),
(56, 6, 97, 1000000.00, 10),
(57, 6, 98, 2700000.00, 10),
(58, 6, 99, 4700000.00, 10),
(59, 6, 100, 7700000.00, 10),
(60, 6, 101, 3500000.00, 10),
(61, 7, 102, 7700000.00, 10),
(62, 7, 103, 5000000.00, 10),
(63, 7, 104, 20000000.00, 10),
(64, 7, 105, 25000000.00, 10),
(65, 7, 106, 1500000.00, 10),
(66, 7, 107, 3000000.00, 10),
(67, 7, 108, 3000000.00, 10),
(68, 7, 109, 1200000.00, 10),
(69, 7, 110, 3800000.00, 10),
(70, 7, 111, 13000000.00, 10),
(71, 7, 112, 8000000.00, 10),
(72, 8, 113, 14000000.00, 10),
(73, 8, 114, 14000000.00, 10),
(74, 8, 115, 12000000.00, 10),
(75, 8, 116, 800000.00, 10),
(76, 8, 117, 900000.00, 10),
(77, 8, 118, 2900000.00, 10),
(78, 8, 119, 4000000.00, 10),
(79, 8, 120, 1600000.00, 10),
(80, 8, 121, 1100000.00, 10),
(81, 8, 122, 800000.00, 10),
(82, 9, 123, 1100000.00, 10),
(83, 9, 124, 1700000.00, 10),
(84, 9, 125, 1200000.00, 10),
(85, 9, 126, 800000.00, 10),
(86, 9, 127, 900000.00, 10),
(87, 9, 128, 500000.00, 10),
(88, 9, 129, 400000.00, 10),
(89, 9, 130, 2200000.00, 10),
(90, 9, 131, 1100000.00, 10),
(91, 9, 132, 1700000.00, 10),
(92, 10, 133, 3500000.00, 10),
(93, 10, 134, 2200000.00, 10),
(94, 10, 135, 1500000.00, 10),
(95, 10, 136, 1000000.00, 10),
(96, 10, 137, 500000.00, 10),
(97, 10, 138, 1500000.00, 10),
(98, 10, 139, 9500000.00, 10),
(99, 10, 140, 4200000.00, 10),
(100, 10, 141, 7300000.00, 10),
(101, 10, 142, 1800000.00, 10),
(102, 11, 143, 4700000.00, 10),
(103, 11, 144, 4000000.00, 10),
(104, 11, 145, 5600000.00, 10),
(105, 11, 146, 1200000.00, 10),
(106, 11, 147, 2000000.00, 10),
(107, 11, 148, 3000000.00, 10),
(108, 11, 149, 5600000.00, 10),
(109, 11, 150, 6600000.00, 10),
(110, 11, 151, 9000000.00, 10),
(111, 11, 152, 4500000.00, 10),
(112, 12, 153, 5400000.00, 10),
(113, 12, 154, 3400000.00, 10),
(114, 12, 155, 5400000.00, 10),
(115, 12, 156, 6000000.00, 10),
(116, 12, 157, 550000.00, 10),
(117, 12, 158, 1000000.00, 10),
(118, 12, 159, 2000000.00, 10),
(119, 12, 160, 800000.00, 10),
(120, 12, 161, 500000.00, 10),
(121, 12, 162, 5500000.00, 10),
(122, 13, 163, 5500000.00, 10),
(123, 13, 164, 5500000.00, 10),
(124, 13, 165, 5600000.00, 10),
(125, 13, 166, 2000000.00, 10),
(126, 13, 167, 3500000.00, 10),
(127, 13, 168, 800000.00, 10),
(128, 13, 169, 150000.00, 10),
(129, 13, 170, 2500000.00, 10),
(130, 13, 171, 3000000.00, 10),
(131, 13, 172, 500000.00, 10),
(132, 14, 173, 800000.00, 10),
(133, 14, 174, 7000000.00, 10),
(134, 14, 175, 5700000.00, 10),
(135, 14, 176, 7200000.00, 10),
(137, 14, 178, 3200000.00, 10),
(138, 14, 179, 4000000.00, 10),
(139, 1, 177, 6600000.00, 10),
(140, 14, 177, 660000.00, 10);

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
,`warranty` int(11)
,`description` text
,`trademark_name` varchar(255)
,`product_type_name` varchar(255)
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
  `created_at` date DEFAULT NULL,
  `createdBy` int(11) NOT NULL,
  `updatedDate` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `news`
--

INSERT INTO `news` (`news_id`, `title`, `news_content`, `highlight`, `thumbnail`, `url`, `created_at`, `createdBy`, `updatedDate`, `updatedBy`) VALUES
(1, 'Bạn không nên mua MacBook M1 lúc này ?', 'Sau màn ra mắt thành công của chip xử lý M1, Apple đã sẵn sàng giới thiệu MacBook M2 trong nửa cuối năm nay. Do đó, hãy chờ đợi để có quyết định sáng suốt.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2F48230042021.jpg?alt=media&token=3a873dbc-fbd4-4826-92ef-a27bb21b64de', 'https://zingnews.vn/apple-sap-ra-mat-macbook-m2-post1210106.html', '2021-05-01', 2, '2021-05-24 11:30:59', 2),
(2, 'Dùng MacBook, bạn nên từ bỏ trình duyệt Chrome..', 'Sử dụng Safari, tắt Bluetooth khi không cần thiết là những cách đơn giản giúp tiết kiệm pin cho MacBook.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fbannentubotrinhduyetchorme.jpeg?alt=media&token=44bfab75-361f-4df0-9247-862282c1c703', 'https://zingnews.vn/meo-tiet-kiem-pin-cho-macbook-post1206586.html', '2021-05-01', 2, '2021-05-24 11:54:40', 2),
(3, 'Dấu hiệu nhận diện app đa cấp lừa đảoo', 'Các mô hình đa cấp thường xuất hiện với lời kêu gọi kiếm được rất nhiều tiền, đánh vào tâm lý muốn giàu, đổi đời nhanh của người dân.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fdauhieunhandienapdacapluadao.jpg?alt=media&token=af4214e0-8f29-4a04-a847-608ee663ce5c', 'https://zingnews.vn/dau-hieu-nhan-dien-app-da-cap-lua-dao-post1208904.html', '2021-05-01', 2, '2021-05-24 11:54:52', 2),
(4, 'Bắt nhịp xu hướng laptop với Acer Spire 5 và Swift 3', 'Laptop Acer Aspire 5 và Swift 3 sở hữu thiết kế hiện đại và hiệu năng mạnh mẽ, đem lại cho người dùng trải nghiệm đáng giá và phong cách thời thượng.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fbatnhipxuhuonglaptop.jpg?alt=media&token=d2e38ead-c4a5-46c1-ad25-5e429301a65a', 'https://zingnews.vn/bat-nhip-xu-huong-laptop-voi-acer-spire-5-va-swift-3-post1209787.html', '2021-05-01', 2, NULL, NULL),
(5, 'Nên mua MacBook cũ hay laptop Windows mới?', 'Mình đang là sinh viên năm 2, có khoảng 20 triệu đồng và phân vân giữa việc chọn mua MacBook Pro 2016 cũ với laptop Windows mới. Nhờ mọi người tư vấn giúp ạ.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fmacbook_pro_vs_xps_15_1.jpg?alt=media&token=9738044c-7746-42f6-8076-e749727a9b3a', 'https://zingnews.vn/nen-mua-macbook-cu-hay-laptop-windows-moi-post1207768.html', '2021-05-01', 2, NULL, NULL),
(6, 'Cách kiểm tra độ chai pin trên smartphone Android', 'Mình đang sử dụng chiếc Galaxy S10 được gần 2 năm và muốn kiểm tra tình trạng pin của máy. Anh, chị nào biết hướng dẫn mình với. Mình cảm ơn ạ.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fcachkiemtradochaipinandroid.jpg?alt=media&token=93d72317-09bb-44ea-adb4-f2892b11641f', 'https://zingnews.vn/cach-kiem-tra-do-chai-pin-tren-smartphone-android-post1207127.html', '2021-05-01', 2, NULL, NULL),
(7, '\'Lôi kéo người khác đầu tư app đa cấp cũng phạm luật\'', 'Chuyên gia nhận định mô hình app đa cấp không tập trung sản phẩm, dịch vụ mà chỉ chú trọng lôi kéo được nhiều người tham gia nhất có thể. Việc kêu gọi này có khả năng phạm pháp.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Floikeodautuapdacap.jpg?alt=media&token=d2a2fbb1-4364-477f-9f1e-d8d93ab78462', 'https://zingnews.vn/loi-keo-nguoi-khac-dau-tu-app-da-cap-cung-pham-luat-post1209326.html', '2021-05-01', 2, NULL, NULL),
(8, 'Loạt smartphone thú vị nhưng hiếm gặp ở Việt Nam', 'Xiaomi Mi 11 Ultra, Google Pixel 4a hay Red Magic Pro đều là những mẫu smartphone tốt, nhiều công nghệ mới nhưng không được bán chính hãng ở Việt Nam.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Floatsmartphone.jpg?alt=media&token=fba997b5-24d6-4f94-9984-28475d50c1fb', 'https://zingnews.vn/loat-smartphone-thu-vi-nhung-hiem-gap-o-viet-nam-post1209865.html', '2021-05-01', 2, NULL, NULL),
(9, 'Bảo tàng ở Nga vẫn dùng máy tính Apple tuổi đời hơn 30 năm.', 'Chiếc máy tính Apple II tại Bảo tàng Lenin (Nga) vẫn được sử dụng để trình chiếu sau hơn 30 năm.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fbaotangonga.jpg?alt=media&token=dd63dc3a-0f52-44de-a15d-cce7812e48b4', 'https://zingnews.vn/bao-tang-nga-van-dung-may-tinh-apple-30-nam-tuoi-post1210012.html', '2021-05-01', 2, '2021-05-24 02:53:04', 2),
(10, 'Người dân Ấn Độ lên mạng xã hội để cầu viện quốc tế', 'Hàng nghìn lời cầu cứu viện trợ bình oxy hay giường bệnh đã được đăng lên các nền tảng lớn như Facebook, WhatsApp hay Twitter.', NULL, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/thuonghieu%2Fnguoiandolenmangxahoi.jpg?alt=media&token=32597a3e-ff68-4f17-a1dc-a5b984b4c36c', 'https://zingnews.vn/nguoi-dan-an-do-len-mang-xa-hoi-de-cau-vien-quoc-te-post1209029.html', '2021-05-01', 2, NULL, NULL);

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
('0010881d091d3bf8400cd5934085e0fa485861852338c193c1cf8c642b7c2ce76eb5ce42b94dd233', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 07:36:55', '2021-05-11 07:36:55', '2022-05-11 14:36:55'),
('0047e6a82afed08197359be1b7183c533f6e3f192e8db7161b881a3df2f8a54d0f4fe95621ea7652', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 00:29:22', '2021-05-12 00:29:22', '2022-05-12 07:29:22'),
('0152fb3da0110887b46d319a2bf68aaddf5caa5707465c12380f2a7624dfde5c606ee0e0c56ec850', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:55:13', '2021-04-25 21:55:13', '2022-04-26 04:55:13'),
('02779774c91b08f17df60ee7ff452e86fe8eb6d03779b2ec8d90a2f19c301c204be4f108d36e8079', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 04:00:31', '2021-05-27 04:00:31', '2022-05-27 11:00:31'),
('02b7bae2ced8c28a5fab594a3df086b261f71e491ac0acb680ae50a1ab995ffed50ba920e38bc095', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-22 22:01:46', '2021-05-22 22:01:46', '2022-05-23 05:01:46'),
('02d88fa8e5ab5e1146041a4455e8953e45ac29ed8665e195eb59eec2bfdf41b82a008df50ec6bf80', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 07:26:27', '2021-04-27 07:26:27', '2022-04-27 14:26:27'),
('04aef87ffa3d9b7f6ab53f9d766c796a2db300146f172fda004f76293a667642d9d2e6e79efdb24e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:09:51', '2021-04-29 07:09:51', '2022-04-29 14:09:51'),
('04b5a2a9a3856bc8d80ca8c6c7d712943f126dc921cd6ef9375163266fafb7f59cda719372cb673f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:31', '2021-05-18 07:21:31', '2022-05-18 14:21:31'),
('056865067cac94a6becf9e26b4e7ccbf93f05782abceae1b82803b55ab952b3f4d1c969038e0eae3', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-24 00:25:09', '2021-05-24 00:25:09', '2022-05-24 07:25:09'),
('057cc8fccefd249fb6ede7f8b19d060d44524ad38c437de89572a91d643af92417f1728108e7a7a5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 09:21:17', '2021-05-04 09:21:17', '2022-05-04 16:21:17'),
('0752e6ae44e9cf27f472ee6cdc2d66af9b334ad5dca781b2468b000eca6d1771b6a4db3865b992f7', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 04:06:37', '2021-05-05 04:06:37', '2022-05-05 11:06:37'),
('077759321a6709a464dd9f1602cd5ef81150e030ff0f984e68d5d35413da67f172fd01f559a9a6d2', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 21:23:04', '2021-05-18 21:23:04', '2022-05-19 04:23:04'),
('093d64861979255b023bf743a1cf4ff7dfb366671edc94e6569ca725f436c0c1f40db2fa89c985ea', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:21:14', '2021-04-26 20:21:14', '2022-04-27 03:21:14'),
('093e0d13450530ad8cd5d664a89afa5057c65fe6f760dc95316af97c57c98f95e79c18713d7cfb19', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:34:20', '2021-04-25 20:34:20', '2022-04-26 03:34:20'),
('0941e9999a1034993976591d10a4166814cbe3cd804396af57d805860100ebfab530cee360999e52', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:17:01', '2021-05-05 08:17:01', '2022-05-05 15:17:01'),
('09812a76417b74e3d3841e2d77d1c4425b6edc1d6643c0d716f59d63525a474d7fbbd05936b68b45', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-30 22:06:15', '2021-04-30 22:06:15', '2022-05-01 05:06:15'),
('0a7a0fc90e934f033f6567a171c1ad95c363c37d5e314277535fae2d7b1916fb76dda3fc4ccafe12', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:30', '2021-05-18 07:21:30', '2022-05-18 14:21:30'),
('0b125970d9e7f56e39dccdf75e9a3edb7695877e6d84ec85fa59fe3aaae1f10c853bad1f3c419c7f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:24', '2021-04-29 07:24:24', '2022-04-29 14:24:24'),
('0b41e696af084ce9da08dd7b37ddd8b4b42d4845a4c328c4954e2f1af04deab7193e0d19d06005ae', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 09:51:06', '2021-04-26 09:51:06', '2022-04-26 16:51:06'),
('0bb6fc16ad0fd3ec71f4d5df740e081198c2a96f76e0737b6d6408fe21020d41a95084873edd4089', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:29:49', '2021-04-25 22:29:49', '2022-04-26 05:29:49'),
('0bf346bf931dd05da70778396c18757a5892c7af97cf086d71cb937a27e7cab5f3cb83f79fd7f31f', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:57:06', '2021-04-25 21:57:06', '2022-04-26 04:57:06'),
('0cecc6504c98bb73c1d94b40c659b31afdc415064c8a4aaa4305e1dce4cc9f44bf68ad2186ed8872', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 06:55:52', '2021-05-15 06:55:52', '2022-05-15 13:55:52'),
('0d1df6866f88194e76270751457add10016f64aaa8b04bec3d1fa49825bff654277be2d1c67bcff6', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 08:15:33', '2021-05-26 08:15:33', '2022-05-26 15:15:33'),
('0d96076d77a4533cfd0a8d6f76bcd303c3fb0b69f30f7e597c66c4f92746519dab7b711f6f8d39c6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:57', '2021-04-29 07:24:57', '2022-04-29 14:24:57'),
('0df2a66f1c98bbdb0908e9375e9f57e9cc282c8a2a157a58146473cdab8cd08027147f656d6e4534', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-22 21:00:38', '2021-05-22 21:00:38', '2022-05-23 04:00:38'),
('0e95dc6e7764aa13008882ac0397dc061a3d25e1399ec459d376a9a81020331a4861961b75b63133', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:09:06', '2021-04-17 03:09:06', '2022-04-17 10:09:06'),
('10960c9c8f83af491a0b3dc201795901d9fe2f755fef12b65adbae34df9b0720012b8d590bd299b8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:36:41', '2021-04-22 02:36:41', '2022-04-22 09:36:41'),
('10f0f63c16e45172290de0968b18ee71c30a76a79e4a308b04ed9cf6dc77deaf1ce6f4c52f29967f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 07:46:42', '2021-05-26 07:46:42', '2022-05-26 14:46:42'),
('11298a1f07488cf4e4d34a482175142514bf485d02758153836aa241a0a1e5532ec3dc324a9d27dd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:04:45', '2021-04-26 20:04:45', '2022-04-27 03:04:45'),
('113fe96145fac45d3e0fb4cd6672049662d10d6c545fd3a4f1d895c26e2f50dc905c489adfdc1a85', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 00:45:54', '2021-05-06 00:45:54', '2022-05-06 07:45:54'),
('11bb754e6c744f466f99618106b0d8d654ffa93bb59fb0416f02deda6a1e2326669ea6234e7da46f', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:00:39', '2021-05-05 08:00:39', '2022-05-05 15:00:39'),
('11f5ee53a4ab94486cecb30adccc91bb542bd9703f2b8a1ff019f44b61e7941a88404bc47c96994e', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 08:00:13', '2021-05-15 08:00:13', '2022-05-15 15:00:13'),
('11f9578006226baae9dac925f5ce31a43f4ec1e2c808fbdedb6bc12e536e82243b8456be1ad96026', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:23:33', '2021-04-25 22:23:33', '2022-04-26 05:23:33'),
('12356df7282f8c86386a18be7f7d39718287aa7cc1caf80c141a2496dd90ac448fd0ea0579ebef52', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 03:14:50', '2021-05-27 03:14:50', '2022-05-27 10:14:50'),
('12752d46afdd7d79531dedb4966de61c01901a5b23cefabab686ce3489a487d4ccf0b0f2be1a94a2', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 09:48:47', '2021-04-26 09:48:47', '2022-04-26 16:48:47'),
('128d91f14e88f9ad4476fbda4e5028f40b1678f66c27504449fcc415dccefea0773f832d38c8235a', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 01:59:43', '2021-05-18 01:59:43', '2022-05-18 08:59:43'),
('12c7d1cb2689b26963f434186ec567e5f1bae77b15d9064b4a3e7fe0d91d43d70382e4fdc1a08661', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 02:21:10', '2021-04-27 02:21:10', '2022-04-27 09:21:10'),
('131e4ed4ef9b02656b1bbfb893f3ae81fd79a8406763dcc6b0f411561824fa86c6a3854291ce7726', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-21 19:49:02', '2021-05-21 19:49:02', '2022-05-22 02:49:02'),
('134d8ae0da3ea4fad26be28817fc19d82b68df85f39bdea125f1106406ee727c4b896124eaa937e8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:29', '2021-05-18 07:21:29', '2022-05-18 14:21:29'),
('14195cbbee427b31cc22277cbcbe2eb583824d18c8e60c0f6bce3f6d2c1a13fec61b12d495cc3f46', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:28', '2021-05-18 07:21:28', '2022-05-18 14:21:28'),
('14a8b599ce0a36fa28cf1485f8727ab922d6417fcf19c51c8203863e1cced35ea089bd028aa8216a', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-22 08:18:42', '2021-05-22 08:18:42', '2022-05-22 15:18:42'),
('14bfe4c07d97a2123bf01e1ac4fd7df22cdfa85cb41ca15fd865a36b0beaca25dd527ee768daab6e', 7, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:35:16', '2021-05-25 03:35:16', '2022-05-25 10:35:16'),
('150ee69194c340dae3afc7a8d7264f775b5083ce6641431b9647cba9ac3b43c827955732324fd7a9', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:58:54', '2021-04-29 07:58:54', '2022-04-29 14:58:54'),
('15393a2f18d85ad4d894e6cf9a64a45a83c3c45ea5f64f40f4027c1642ee2099a4702f228c0c294d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:25:36', '2021-04-25 22:25:36', '2022-04-26 05:25:36'),
('1636684ad1e9d38b4e121f7b1a244c7107ff6a70fc9ab9bf3487fa0e74c9e1f43152f3e8f08f7bb3', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:47:21', '2021-04-29 07:47:21', '2022-04-29 14:47:21'),
('168edac3de80c1377527f6e921fb01e4cbc0f9ed2103eea98a2710cb39bdf2524ed8daa33bcecbb2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 10:25:30', '2021-04-26 10:25:30', '2022-04-26 17:25:30'),
('16f1c0e2a00e94c2a2756632a9cf04b1304a9e6ec603e223894c2f5bbb012f40685f812613a6f921', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:29:17', '2021-04-25 20:29:17', '2022-04-26 03:29:17'),
('174d0726c51bdaf662230ddb2f3f7361887cf6aca1ebc84efddd381d038a8c16a45c90b85e5652f1', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:24:07', '2021-04-25 21:24:07', '2022-04-26 04:24:07'),
('1797f61d361cae08dfee8cb3dd0ac3e843fb1fc241f265baeb1895790c15412d28b448ec52237663', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 21:15:28', '2021-04-26 21:15:28', '2022-04-27 04:15:28'),
('17bd2fc31e692fa74a488f4b1374c1bccf8414ce9d0cf8c80f0fc094c29e9517504137d93114fbd9', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:06:50', '2021-04-25 21:06:50', '2022-04-26 04:06:50'),
('1866e5c89adac511ed5f8cca2d9f5292b0024b0ddf45a8ef8d90f2e359971935cfe2c7fb5228f97e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-22 20:20:01', '2021-05-22 20:20:01', '2022-05-23 03:20:01'),
('18d8472c7e4c7349aac0b77f695c93db26ff096832b2ebb860ab47cd44bb6d9d62eb4bc0446fe0a9', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-14 00:44:31', '2021-05-14 00:44:31', '2022-05-14 07:44:31'),
('198641d7756e3852c8910238fe954c3e458c2069ffb20faa40b0877432bb1028266d4b0c46c86abe', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 08:26:07', '2021-05-27 08:26:07', '2022-05-27 15:26:07'),
('1ceb75fc8da56b1a197acc18138b9c686c75e4aaa1ec7d82943c7013a2de5f33e5d9c0f31f8b2c94', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:28', '2021-05-18 07:21:28', '2022-05-18 14:21:28'),
('1d2bbac15f03f6e48483e872f7ec97f613bfe10016f37715dc415335955f61a894ad6f1411b5e06b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 03:00:06', '2021-05-06 03:00:06', '2022-05-06 10:00:06'),
('1d6e2c2e193d4e0ae94d22aacf046023a26a814bd1a90087f3c45e8de789271ba2180eccdabacbba', 16, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 07:31:23', '2021-05-06 07:31:23', '2022-05-06 14:31:23'),
('1e3861bc0869f32010ef7fdb6b8d6159cd89a3ab442448be789060380fc3b5b5c2971e4bd0d2b67e', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:27:24', '2021-04-26 05:27:24', '2022-04-26 12:27:24'),
('1edc3d5f57b01f1b97196c378347d3bf241cf4e66636530cdc789d006bcc2170ee88c28239728bdb', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 04:19:02', '2021-05-18 04:19:02', '2022-05-18 11:19:02'),
('1f0171bd973c0ccbc465eb1dd5d7c943e780d59b6401cdcbd9bac1fb9d4bfcba752ee6e002107544', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-22 20:50:33', '2021-05-22 20:50:33', '2022-05-23 03:50:33'),
('1f9687d3da7b993f5600431c7cbd5a9b0a48b7a454d0d7fbed9ab3d3d0cfe424184e393db3f0835e', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-08 09:34:06', '2021-05-08 09:34:06', '2022-05-08 16:34:06'),
('1f998de7cb426cc195b0b22a554bd12cb380bece260604fe759e09172ec88dbce01aaaf44abfffc6', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:18:26', '2021-04-26 05:18:26', '2022-04-26 12:18:26'),
('20c07ad8d9c8d5516293ffcfab4b9f204d0cfd8aa46cedfdbb62ac952898d10cbea676a6f75cc093', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-08 09:29:52', '2021-05-08 09:29:52', '2022-05-08 16:29:52'),
('20dd4d342a8214a62cc04396e4b2578eb613e9e9e6dac615ec52d9a9e55da5d685a6e60f41fd8c7e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:20:08', '2021-04-29 07:20:08', '2022-04-29 14:20:08'),
('2108c8c1508de4b173efb86bb069b0dc0da5027967f6a460479d05b027cda8c4c697c6f83fb97590', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:05:53', '2021-05-05 08:05:53', '2022-05-05 15:05:53'),
('21ca2621a695a628d3005b6af23eb900eef402b363df0988b810d65ef5223e1b2c93f898a5e929a4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:00:20', '2021-04-25 22:00:20', '2022-04-26 05:00:20'),
('224df956b806e59bebbe970cd91a24dac75a9906dab93bb238eff89b4cc5acbc5426357e3421c045', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-23 21:11:31', '2021-04-23 21:11:31', '2022-04-24 04:11:31'),
('232b41fa026ef8c6c58b039e38a97673b1923f14eec47657abbcae16edd3b0ed18b531c6a6518446', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:07', '2021-04-29 07:24:07', '2022-04-29 14:24:07'),
('23fff7e8cbde8ae9540a6cb79209db0d3bb0ce03cf50dc3d775cc8e48b990ab8f985353511bcf92a', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:24:15', '2021-05-12 23:24:15', '2022-05-13 06:24:15'),
('249ad99576ef6d9a01307731c8fb4a3ac6e23ec47c844dd1cbf74e020f1e22a68811661b29ac23b9', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:32', '2021-05-18 07:21:32', '2022-05-18 14:21:32'),
('25899b2c0ec5b1edeaddde2f6df733d1e471953ab5fcc05cbcdfdf86ed4f00c4557f7f6916849115', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 15:21:48', '2021-05-05 15:21:48', '2022-05-05 22:21:48'),
('265b6dde1ed1d375bf6bdef061070529878d3612a9989c7e5cf915742efd06353ec7f41c46929164', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:48:13', '2021-04-29 07:48:13', '2022-04-29 14:48:13'),
('26bb63ae508840ad166fb18514b8c3b2d9d1564e9bd38add8b88ebbee106242a175fd9f00d26a04b', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:31:20', '2021-04-27 03:31:20', '2022-04-27 10:31:20'),
('26f8bd77f33c64fca8b854c14e6a096b7b3384b092c44820e6805e81520ddce363f7a3c0bd4a1fa1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 20:55:34', '2021-05-04 20:55:34', '2022-05-05 03:55:34'),
('27cda6e0a9c3fc8c87491a18dc8ef5490cd42ad507088b7da811ca8275f279712db30f108a6be3b0', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 06:51:02', '2021-05-15 06:51:02', '2022-05-15 13:51:02'),
('27e4be31a6ddc945e1c9d334269224ce2a214d09645398bfd77ad4b988395b43f0edd6a24d823b66', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 07:21:57', '2021-05-11 07:21:57', '2022-05-11 14:21:57'),
('2820fc641f00ce53488015e08d863cc32663911e2152f942e24c762b93e02eeb1c7ec8a9f5009ef8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 02:32:16', '2021-05-15 02:32:16', '2022-05-15 09:32:16'),
('2842316c938f0e6ff4a9df15dfc24f2714b5bb454115c49beef88c28c4298c5942c2d9db636d1821', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:10:16', '2021-04-29 07:10:16', '2022-04-29 14:10:16'),
('28a85df05084cd91856d3ca6e5e6b602528c83f252882cc425f4bf9eff8156b68d4df80f26233e2a', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 01:20:12', '2021-04-22 01:20:12', '2022-04-22 08:20:12'),
('28dcb87d53ed36caa1e51c14e966e7630eb3a00b714a6b9f01fb03eb5534c5d94cd69aca23f6fcc5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 22:15:35', '2021-04-26 22:15:35', '2022-04-27 05:15:35'),
('2a8154806c7b8cfa8fa70ec95a2384cf7b3aaacaff250c62291ff5a24f054496569a54377531d0d5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:23:14', '2021-04-27 03:23:14', '2022-04-27 10:23:14'),
('2aa2ad313cda37b318868d63f74f91fe80efbd8a2712aff6b5289a7e42a739c07281a57e80ff9034', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:00:35', '2021-04-25 21:00:35', '2022-04-26 04:00:35'),
('2dabfcddde0fcdd423fd144f162e62bf6688d8af0a72f725259e35e2ac29c84756eaf3ba2ecc5c7d', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:32:29', '2021-04-27 03:32:29', '2022-04-27 10:32:29'),
('2ee064d3cc162d545c24986aa57561edcd5ad06557d94919b2135441311ba9923e41605b77f257c0', 11, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-02 21:54:54', '2021-05-02 21:54:54', '2022-05-03 04:54:54'),
('2f7b8017bf87eb4dc49772f69b67e284b5eac36681d9843a2d7b388d4273bc88902e40575f827d70', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:14:00', '2021-04-17 03:14:00', '2022-04-17 10:14:00'),
('300cd7eeb3f6e6e65213dc6ceadd2f2e70548f37fedb7c36e8a8dc99125ae6ab22e4ce50b8fc0751', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-19 08:11:12', '2021-04-19 08:11:12', '2022-04-19 15:11:12'),
('30f9132e2f9edf943d12efb7ba870f5f2a1c78574f3176f433874c86494fd1c77ed4b792330af927', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 02:15:13', '2021-05-26 02:15:13', '2022-05-26 09:15:13'),
('316f996316f54f1d47b9ee5549ce745ac635df6df6cb270acc6598c3a1635c8fa3ad7aad84805117', 4, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:34:20', '2021-05-25 03:34:20', '2022-05-25 10:34:20'),
('3170353995166df49fcc6aefbfb66effef057272fc26eeb026dcb60bb4a5addace6fedc69d08f1fb', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 07:25:44', '2021-05-11 07:25:44', '2022-05-11 14:25:44'),
('334ee4b0bd2189a5ee2157dd86329af0355782bfeba3479c419a14fecc01088d30773f929b022353', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 10:34:36', '2021-04-28 10:34:36', '2022-04-28 17:34:36'),
('336a497a4f5fbd92e57a01e92d2e82b015c8320aacbe4abdb39bdb746253c1c9945c5e9346248b64', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:05:41', '2021-04-26 05:05:41', '2022-04-26 12:05:41'),
('33cec80037a0e5bc708ad06234603456412dfd2610c9bbb0fd485ab2796ffab33d3140a2b9959ef1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:13:47', '2021-04-17 03:13:47', '2022-04-17 10:13:47'),
('3473910f9afe70c09276d94740bace80839e605203b7def79cb206ec08dadf75e9ebfdab46f94975', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:47:13', '2021-04-22 02:47:13', '2022-04-22 09:47:13'),
('3627d9f2859c4c5be6cf03c5783dfaf6deed1f5691e7349c00bf05c52f3e3c542c236d7508cc1602', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-21 07:34:27', '2021-04-21 07:34:27', '2022-04-21 14:34:27'),
('36cbb9d999fd0d13e68a703313f951104f1a371a66258f8504300edb0442d3e735fbf0eefca972ae', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 03:10:21', '2021-05-04 03:10:21', '2022-05-04 10:10:21'),
('38c82c2dd827c01997353c4f5cae6511b2880b2243dc72f5c7a8c6beb087d5058dfaefad8a9c672c', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-19 01:49:25', '2021-05-19 01:49:25', '2022-05-19 08:49:25'),
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
('415f86061bd25cead04bf4386cb0248b043f71bb4c898db3ebb392186a496de572a5f92854d52c0c', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 15:15:56', '2021-05-26 15:15:56', '2022-05-26 22:15:56'),
('417908ccbb2ab5073a83ba4a474de65db7d61eb4a01d6c080949d973989b9538e3b8179891c5db6f', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:12:47', '2021-04-25 21:12:47', '2022-04-26 04:12:47'),
('41deecdeb5e0a2bd0bdf876934cd9da13df8ed55e548b15f569f0475bd7e7822dbb8b99790f2a09f', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-09 04:01:53', '2021-05-09 04:01:53', '2022-05-09 11:01:53'),
('427784d22d8a9c3fe7bbc9e8d89c418c3ada40571515ee0263e20a89fb9ec07f567769b3b9a8c736', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:21:38', '2021-04-26 20:21:38', '2022-04-27 03:21:38'),
('42a721997ee10ba09990ac89b32fb6233e9aea367f00e38aca8a721f4769d62355136f9bdfe5360f', 11, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:34:36', '2021-05-25 03:34:36', '2022-05-25 10:34:36'),
('4348c0abc200f46a8c14e697319cf387abf783a4d100ff4f027910aa1df3aed5f2b9f18b4cbf0d3c', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:16:14', '2021-05-12 23:16:14', '2022-05-13 06:16:14'),
('446e171aab431eb88041dabd569ce6c564dc388611721779d8e0b3885eeb814d6ecad0f54aa0fa40', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 20:12:48', '2021-05-05 20:12:48', '2022-05-06 03:12:48'),
('448404957d576ca20cb088c3ece2389bdd3e66836f4c7dfddd08e277833f6befb9161223236f2fe0', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 21:22:07', '2021-05-18 21:22:07', '2022-05-19 04:22:07'),
('44d26eba438b318ea2849d9f7bdaa989b398aa72167bd746778a4cda5be48e958f5d811feaec8540', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:07:36', '2021-04-26 00:07:36', '2022-04-26 07:07:36'),
('44e77ac28a1e3b1a390b4a7d2cadb0ddd8b86ebfb2743b03ae9c956954e9157cf543c3243c2511c0', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-28 02:51:57', '2021-05-28 02:51:57', '2022-05-28 09:51:57'),
('4557a8c29af05cf03a18565d1a2c65089f13dfaabdeedf33d4e381fcdab84d10e07b808be924ff24', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:15:34', '2021-05-06 08:15:34', '2022-05-06 15:15:34'),
('47764d47f711900496f4f21173569c98be898854d6c352a55964cb818ee1dc222160e02ab3e30f11', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:37:41', '2021-04-25 20:37:41', '2022-04-26 03:37:41'),
('47861f69b167c928e5fe9dd2b9c4bcf920645472e46cf7a0cb2aa6fce2fe0ae3532891999da0d317', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-07 21:14:04', '2021-05-07 21:14:04', '2022-05-08 04:14:04'),
('484a2e724f51f419a3c711028f726ff3e1a5354c81e3565d421eb9d4f7be60dec9850d659132d05d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:35:11', '2021-04-26 00:35:11', '2022-04-26 07:35:11'),
('4878e6a49b272196c1e83a2cec81811138935201158fe6bc8c47405ddbe2dd6edebbe99dc81ba32a', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-08 08:05:53', '2021-05-08 08:05:53', '2022-05-08 15:05:53'),
('48e54bc29c98f72ce58963a564de1100ad2882d7545a93c72746d7bf7736c9b0a7fbc6b0fcf02811', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 23:53:25', '2021-04-25 23:53:25', '2022-04-26 06:53:25'),
('493f55fb00f6ffee6128e8a113e0336f15a9b6c25a22f3084f37522ab4386a838106884f3cc51b37', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 04:23:01', '2021-05-26 04:23:01', '2022-05-26 11:23:01'),
('4ac430d96e453b425b6a8473e587f8abe802c3e4457c304ca202d75f19b271589fac43cc07c931b6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:20', '2021-05-18 07:21:20', '2022-05-18 14:21:20'),
('4b95d1940e6dee9ebecb896f1bd313a9e641ab07707f61503223b1cbf9c4a4b61678ad2f7666af83', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-17 08:56:19', '2021-05-17 08:56:19', '2022-05-17 15:56:19'),
('4db8fe1624a1f38598d88c2d40900156ecaf3d6ffc8b2071199adabf8ec8637c6e0a3accac45e8fe', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:36:05', '2021-04-25 20:36:05', '2022-04-26 03:36:05'),
('4e69aacabd5b3f3f0e3f1e68ad0db63c7c36708804e0909150c4a139d11f55e5fe6f54128f99ae4a', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:14:59', '2021-04-25 21:14:59', '2022-04-26 04:14:59'),
('4f301201de07a82580919c6792734d610eeed91faf3fd49c189869f33dfb4b9bfb1bc6737f2664f7', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 03:22:25', '2021-05-11 03:22:25', '2022-05-11 10:22:25'),
('509d17191312652703179563bcd531b246fe0918542b6bef73ef109009538bdb4553f539044aa481', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 01:45:41', '2021-04-22 01:45:41', '2022-04-22 08:45:41'),
('515e650eae0970dc36f5db26373b1e30c3a7166372bc738bfacf75056c22d60123e9e2bb4078fe3f', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 10:25:59', '2021-04-26 10:25:59', '2022-04-26 17:25:59'),
('519d197de40e07d9caafef982faa35c5588f632aa91254a12284aaf9ac98c35d0b9bacbf60517286', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:20:27', '2021-05-12 23:20:27', '2022-05-13 06:20:27'),
('51adfac2857c30aa74f254d0d5beff5781f2d068f60d2d391d4a085bf3e0b2eb001a5f5ed6488553', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 08:17:44', '2021-05-26 08:17:44', '2022-05-26 15:17:44'),
('51c2d185975ea2b0125a2e9490cf0a1e1559e153e05badd12061a5ad641935f8eb186678c9f02e8e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:57:35', '2021-04-25 20:57:35', '2022-04-26 03:57:35'),
('523752ab1d1ff217167fd2b9cde7311e8dfb1e3dd6a1be5b4f84d85a7ce2121c33c3fdf07f5ccfd2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-04 03:01:00', '2021-05-04 03:01:00', '2022-05-04 10:01:00'),
('54e3c99b479a988fcb56ecd3d6df232890c27eda8e27633d29fd3a4dfc47a9e0d47275f82c0ab1c6', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:29:53', '2021-05-05 08:29:53', '2022-05-05 15:29:53'),
('57e7c51f2af0443337b6addef8780cfa28fa94bdc6d39b46a0a79db255421a7fb14ea1c3e42387ee', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-14 00:23:38', '2021-05-14 00:23:38', '2022-05-14 07:23:38'),
('57f367788735cf04774f4f4e40d02d257171efe1cd21fe082f1a4c0523fe5d7f6253360a10de4733', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 01:28:37', '2021-05-06 01:28:37', '2022-05-06 08:28:37'),
('580d46fe3115f1b55e18dc6b7ef8cdf75c426e603823f3ca964bd61908e8dbd63bed0f75b6fd1091', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:54:13', '2021-04-26 08:54:13', '2022-04-26 15:54:13'),
('5900de4023daa449d4986a504dde69b2209fc4fcc8cbb5a138d7cd75d9ae7b4021d156552980877a', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 01:50:28', '2021-04-25 01:50:28', '2022-04-25 08:50:28'),
('596c062f6796c419f81ad372ac2e48bfa0033cc86848d0031caf5912fe2eebe5681f0fa3245bfd6e', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:01:57', '2021-04-26 00:01:57', '2022-04-26 07:01:57'),
('59a5d3091d6af40bd0ffb2dbc854bc5d948981ce00e71bcceb2999eaa7f73324b79a9b9afa92ca3f', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-28 20:48:32', '2021-05-28 20:48:32', '2022-05-29 03:48:32'),
('59d969cc378dfa851a352de412e3e31c33035c6f1bcf66d7a6283f90a4d701ca878a6275d25bd36d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 02:34:34', '2021-05-15 02:34:34', '2022-05-15 09:34:34'),
('5b0c6da4f1727ed9045469992a13ea9ad30bd361e85b85f71b8f4637e83bed7f3d8f9ec363f426a0', 6, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:36:32', '2021-04-25 03:36:32', '2022-04-25 10:36:32'),
('5b23a09908a4799411ef112d4b621bbcc00ba2cedf569470762de841fe95746f721af5ec97cf0423', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-07 20:03:32', '2021-05-07 20:03:32', '2022-05-08 03:03:32'),
('5b9fea179f86cd6a0de5cb3fe85c0f1f6e070705b272c2255c7f901dbba2bfeae98e869631d3ad2d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 20:51:04', '2021-05-06 20:51:04', '2022-05-07 03:51:04'),
('5cf8d8a63713b450aa4d8f8fe6eebd0a460ed822c41a12dffbf19f1ba0e5cd64f6f7c3848d675dbf', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:46:45', '2021-05-05 08:46:45', '2022-05-05 15:46:45'),
('5cfbf6e9e3762ad786968d16f89b6ddf84291944f64827949a32a83f3ecdfa04789548d944425b70', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:25:53', '2021-04-22 02:25:53', '2022-04-22 09:25:53'),
('5d09597cf6a981ba60a675fbd451593ffcb4accf133c9b784df9f559941c350df6c50bc43c575115', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 00:11:04', '2021-05-12 00:11:04', '2022-05-12 07:11:04'),
('5e670f66a4ff7cfca1543c103cb1d2ccd20e29f87f5027ce168f3a39757a4200c3862c6beecf6503', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-22 02:49:59', '2021-05-22 02:49:59', '2022-05-22 09:49:59'),
('5e81b5ca8379ac4091c76781d02e9de2b75105adbfa655590026781b0a8b8b3aa950b526c70bff3b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:04:06', '2021-04-26 08:04:06', '2022-04-26 15:04:06'),
('5fd62e30f0757c29affa012e7256f8399b08d900ec0cb3969184c8f5e22f4de6797ba3213524e03f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-20 03:16:33', '2021-04-20 03:16:33', '2022-04-20 10:16:33'),
('60ee40b1c21d50c574ae6ba48f4ee443e67130a841994507e98b876edba59fb2faa3e9f80545adbf', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:22:05', '2021-05-05 08:22:05', '2022-05-05 15:22:05'),
('618d57e2a58583e31d9c18eef15b8d100bb2a38d6a03c3aa8fe7eeed267e8df3cb486bf4c696e029', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 03:32:26', '2021-05-18 03:32:26', '2022-05-18 10:32:26'),
('61b5b283344f9b0c43fb77edd2fed3537bd16fc6f68ab9a7c82a823a094af1cc0b9bdbbd5553c0aa', 6, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 04:07:54', '2021-05-25 04:07:54', '2022-05-25 11:07:54'),
('62c06fd3eb4d58d856fda1f539acbe1a7bbe1d609eb52e58a817e0e750f0e9b0242ed063f957f94c', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:51:50', '2021-04-26 08:51:50', '2022-04-26 15:51:50'),
('644c9b137cd524025d1bfdef75a6a058259656300c2a6ecd4f656590ce83641e914c6ed77ea1b9a5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-19 20:47:53', '2021-04-19 20:47:53', '2022-04-20 03:47:53'),
('644d055a01e5978ca401b0f9ae32bc331e8fb632930bef23c1f5708105b931d91f9f5724c1574881', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:26', '2021-05-18 07:21:26', '2022-05-18 14:21:26'),
('6470839594251fee13c7db5f13c40dfc6f5b55d7c9e5a85ea5b6e2af61508691a9a175a623551a46', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-09 04:04:17', '2021-05-09 04:04:17', '2022-05-09 11:04:17'),
('64a0b0a56310ba2eef6f5691ea1fdb73e458afc6723ea5cacc64bde385ebfc0fc878fe16d71044b5', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-16 07:32:33', '2021-05-16 07:32:33', '2022-05-16 14:32:33'),
('65436970022d0fc2bbbe238937241c39f499216c49acf29c561ee86da62c420d96f0aa78a399d271', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 08:13:22', '2021-05-26 08:13:22', '2022-05-26 15:13:22'),
('6574c60ec1a19620d5f79bcc272344e1a144472b3b38fc6c0794591ebe26a9e1e82777cd6691abbb', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:41:55', '2021-05-05 08:41:55', '2022-05-05 15:41:55'),
('66a97409b5e92d9524f39b1f818a69a608e56dcacff427c1111a2c219a7d4256daf2308bf75a6798', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:45:11', '2021-04-22 02:45:11', '2022-04-22 09:45:11'),
('67c5a32e2e6f84e9d88fc93eaf1d2622d27c211a3fc0fca9635df1d12eeedb2d9f2e406ba5df0fa0', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:54:46', '2021-04-29 07:54:46', '2022-04-29 14:54:46'),
('6848c1791aae838d8c8c7cb3cfabfc2087f765dbc4e4300dbcf4f67498cb46ec129801742a93e980', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 00:30:27', '2021-04-27 00:30:27', '2022-04-27 07:30:27'),
('689bae45f43258fb0df87cfc664b53c032185ad05f7e98d53a4bbdb26d57d011b58c0bb1787d1179', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:23:39', '2021-05-12 23:23:39', '2022-05-13 06:23:39'),
('68f0762a018b66bd120ff1f1183e5b5f72439446ef9154d5e568c72f89d5152b4d8013cf310a9dc5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 07:51:26', '2021-05-27 07:51:26', '2022-05-27 14:51:26'),
('69bbf8c7e6d002f2266b4664b61f306bc7c051fd8b5be932a8705b5e988c7f5b9f40d21b6277ba12', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:14:10', '2021-04-17 03:14:10', '2022-04-17 10:14:10'),
('69bc825d905d2859e5e20f97f3ec4cb8684a273f24d155cc133e96bdf5c7206ccc2d303835e6f266', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 00:15:42', '2021-04-27 00:15:42', '2022-04-27 07:15:42'),
('6a9154408fe1431b321e8fbc5b8c5cb8fdd2cb30a19233d5a333c0801eb565b993fcac96c9cc29bb', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-23 21:11:31', '2021-05-23 21:11:31', '2022-05-24 04:11:31'),
('6b214e183331a9a50cb6b371eec7daed320e07ffb3436cf23c2555913629ffa6d6901c49700ec39b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 22:04:15', '2021-04-26 22:04:15', '2022-04-27 05:04:15'),
('6b5e23827f121182334a4110418718121a5bac5f56431b9c9914e7dab216dee4446df1589d013ec5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-21 07:30:29', '2021-05-21 07:30:29', '2022-05-21 14:30:29'),
('6e0f203f9203fcc90a7519afa86c3dee456f7be09f5a780bbb3c418c540dd8ed4debec3831ca76ac', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:24:44', '2021-04-25 21:24:44', '2022-04-26 04:24:44'),
('6e1fab50388815c4e22bde4fb16c001835e96b2e21ae83332676e6f8447748c2c1e51139975f0ac6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 01:48:24', '2021-05-15 01:48:24', '2022-05-15 08:48:24'),
('6e4a3de3294b72f48dd35b8dec1658909c7e932470105de305b811cd222d9f6528968f4eb1480938', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 02:36:19', '2021-05-15 02:36:19', '2022-05-15 09:36:19'),
('6fbc1409d6a920b03ff1ff6ba43fbf99b7450c631ad21b17353df3045479877f7a31c71cbd288b37', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:17:43', '2021-04-25 21:17:43', '2022-04-26 04:17:43'),
('70379a66605c2b03d3b1750be4c5c85305fb5012b8b842438a5859ede4b167b5ac68c0ac27056257', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 19:56:39', '2021-05-06 19:56:39', '2022-05-07 02:56:39'),
('71be9d22a3e466da6638014b20d709af86881e70524f7beb8f0a5ad366a490f892d6ae8be42bbb8c', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 20:15:42', '2021-05-12 20:15:42', '2022-05-13 03:15:42'),
('7522fdccd607aab109d560248a0f88a3f67952d619c541c37b5a0588b7e5d454390324c87ed1341c', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-21 07:30:37', '2021-05-21 07:30:37', '2022-05-21 14:30:37'),
('752cc4887d7cdb414ac62707c3dc3c8f5cb383a83b043dc127deb58bf378ac270dca7b7028238b93', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:31', '2021-05-18 07:21:31', '2022-05-18 14:21:31'),
('770152fdc984bde6e99c77d6265154e630cfe6aa650b17bcb558d1de35004128a6133b0fa27bbe6d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:33', '2021-05-18 07:21:33', '2022-05-18 14:21:33'),
('7739a3691d707c583638b7d4412f0e57197b575abfd9f983033ed7d176814ba2f15abec2d1a2b89a', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:20:09', '2021-05-06 08:20:09', '2022-05-06 15:20:09'),
('77d97feba825dc15a7a4ea47adb1257a10fc0b49e79edcb98ff272fbfc81320460e2e184128c535f', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 22:22:32', '2021-05-26 22:22:32', '2022-05-27 05:22:32'),
('7817e29515dd2109b066a762a7283e33f3d5d2d48097c36089122babe6036237b533fa8124a7e2e1', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:48:45', '2021-04-29 07:48:45', '2022-04-29 14:48:45'),
('786a472d11d93c6c1dc2f762d6251d4dd2d2580b7c3209d1c37ae5c42723745e7a7ab472554e2a47', 11, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 04:25:49', '2021-05-25 04:25:49', '2022-05-25 11:25:49'),
('7899e710fbe5df73d853038e01852b2d1d5f2fb871804abc5e9f712733517b3cc11f0de21f743418', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:50:31', '2021-04-26 08:50:31', '2022-04-26 15:50:31'),
('79e616d80f464802736ec80d7eec3b98b0d090612aae8273442c80aaa4685f4b43aad7c28419b818', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:46:01', '2021-04-25 21:46:01', '2022-04-26 04:46:01'),
('79f256f3c52a45361fbd88901b8cabdf6ca4485fe3d3ff31aef17b09e4ce8e8832056d3b08dd7479', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:09:45', '2021-04-17 03:09:45', '2022-04-17 10:09:45'),
('79fe201fb378a25449d44aac2f1f1c24d90cc10d766085f3496362c87bbca6b3d9a6ee485c3948c0', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 04:34:24', '2021-05-25 04:34:24', '2022-05-25 11:34:24'),
('7bfe47e1335a19b682ed69b73f82ab6200a5dd2075cbe407f96977c81b326bd59d919fa7e3665fc4', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-09 04:03:55', '2021-05-09 04:03:55', '2022-05-09 11:03:55'),
('7c1b6591cc9b12a13b6d7c8c4ecb603c0386699f79ba950d7ae96e3890228ef285684cb9ad31d705', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:34:13', '2021-04-25 03:34:13', '2022-04-25 10:34:13'),
('7c96151189d4cf674437a7164862ef3d4aae2dd676d3ba1b742f1780e1aa2dde86db42eb7568b054', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-29 20:38:35', '2021-05-29 20:38:35', '2022-05-30 03:38:35'),
('7d37f47268c55b6aa6ba10ef76252a4a8ae3a61dd8a338c45ade7a32eeb64476e23f0861b5747833', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:30', '2021-05-18 07:21:30', '2022-05-18 14:21:30'),
('7d8a87b214ec99158ad6d5a023f2f09d9d602d349da2c3b7c7015bfd4a1ab0744bff2d147eff1d72', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:05:35', '2021-04-29 08:05:35', '2022-04-29 15:05:35'),
('7da31e361fc43fa2f10a74516cf407ea8adeb1e6de747649bd84be011a32bf6ca4324221d2d549a4', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 03:58:25', '2021-05-05 03:58:25', '2022-05-05 10:58:25'),
('7dd0c30980c442f9372e5fd3a4c73f899c8772dec3bec5fd599759db3c491f2109b955c8304285c1', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 02:32:20', '2021-05-06 02:32:20', '2022-05-06 09:32:20'),
('8000ae6bcbf04ca1930556e35aff87210220efd2878bb5965e615f1bd2cbe0e510af95e254c92ebf', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:47:41', '2021-04-25 20:47:41', '2022-04-26 03:47:41'),
('800568b638e7e582d54770eed777aeda933a07b46922cdf2e969175af4c675596b64becf3c7c900c', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 02:00:47', '2021-04-27 02:00:47', '2022-04-27 09:00:47'),
('81993168e3c7ea4031c0d5db5eeec7b218625be66f7fe58db47ccdc4badd5b4d9fb66f3b4274112a', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 20:19:27', '2021-05-12 20:19:27', '2022-05-13 03:19:27'),
('824a4175103bf938c4021329e00ba680df78a499b7768f98975fab31d7280f64f5c1c1de37ccb6b7', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:23:50', '2021-04-29 07:23:50', '2022-04-29 14:23:50'),
('832c842137b862bdc9a4fbd7d429c46d2d2222aa6d8e03807acfb77f09dda63de80e39c63716ef9a', 6, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:35:41', '2021-05-25 03:35:41', '2022-05-25 10:35:41'),
('8510d16d13f877aab1992256dc140c670ee32def3eaa918923b711c81016822f8b3f0930e610de97', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 07:19:23', '2021-05-11 07:19:23', '2022-05-11 14:19:23'),
('863a0470b3475fcc37edc3906f24dcb5d99a4bbf0d0d68d3daae3fe075b631966ce6fef5464c67e4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:50:05', '2021-04-25 21:50:05', '2022-04-26 04:50:05'),
('87b0c3f093a1c642e32aa8610e94fae87fcaafcec4d7bd03e15bb85169e9dab8e86d524bdcb4ee0b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 07:48:17', '2021-05-05 07:48:17', '2022-05-05 14:48:17'),
('888b8c51c24c3b46f10d0f5d9c0321fdc242c10076f7248fc469fc717a8627859e8c448360995580', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 08:18:22', '2021-05-26 08:18:22', '2022-05-26 15:18:22'),
('89495a77251c4103bb4509cdfbe907f1ed4f2be74949faa426290434bb114ec5ce5105f58a473c20', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:06:45', '2021-04-26 08:06:45', '2022-04-26 15:06:45'),
('89a39f2dd3e2c2e18342d0dc6cc60d78fcb4307271daa68554503b88766abccd609a030bc56a97f6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-23 02:10:11', '2021-05-23 02:10:11', '2022-05-23 09:10:11'),
('89c3c6a8343097cc952b1e5b834e2c076f251641af8471308be637b3bea5c209e7af08fb17c83dad', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 20:17:13', '2021-05-12 20:17:13', '2022-05-13 03:17:13'),
('89eaea8388f52c189d3ebf01421ad81c9a7fdc0f5c6ec359ac265abca84166521e080d26cc3893dd', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-14 00:40:48', '2021-05-14 00:40:48', '2022-05-14 07:40:48'),
('8a115654c8deae6275106b37874d88dc240f905d8a8ac1c6ec1f918868bba5448fd61be538eafdbe', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-21 19:48:55', '2021-05-21 19:48:55', '2022-05-22 02:48:55'),
('8aec027058b1ba778af747322541dce2c30ec75e30a3e823649afc22db6083169020d46532b22140', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 06:19:41', '2021-04-26 06:19:41', '2022-04-26 13:19:41'),
('8b66e4d73967e5bb1e26e0f47a808399dde6c940664326e3abf590e8947282df5aeb2647e63cbbf8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 19:41:50', '2021-04-29 19:41:50', '2022-04-30 02:41:50'),
('8d1e2153c788645a16cb84d177397b2933f314c4e5b3c6b43e745f3fcc32cd4814b518576d5c2a7e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:06:08', '2021-04-29 08:06:08', '2022-04-29 15:06:08'),
('8d49682d27b92b23d51e27113497dab6759de18558ae51f22477c1726377fe7fb515080266652e8e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 20:16:53', '2021-05-25 20:16:53', '2022-05-26 03:16:53'),
('8ea3f5a5e2b0b84167de909913a05d9e8c7a42cba7b293c12b87cd383cc4691a0d05259feccf0f24', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-20 21:10:06', '2021-04-20 21:10:06', '2022-04-21 04:10:06'),
('8ef9dc533842b751499a9baf02e848d36d8c09712b22857e3f4164115a687e2f73a9aaeae7d215fa', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 02:07:36', '2021-05-18 02:07:36', '2022-05-18 09:07:36'),
('8f321715dfeb6cd10636f92a6a641ea8e4ed6113f3e3b12b6dea4402a614d1eb0ce21a653d12d368', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 04:01:44', '2021-04-17 04:01:44', '2022-04-17 11:01:44'),
('8f3dbc0686bc20d6737865c41f6379fb94bc13559d8c477c817bb4c71b6cf7f8a11297958da2cc85', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 21:21:58', '2021-05-18 21:21:58', '2022-05-19 04:21:58'),
('90a2d09d5c376c844ec281d1201b55518b3aebc2e57579a846743cac3052d9ca9f6cec6557968a85', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:55:14', '2021-04-26 08:55:14', '2022-04-26 15:55:14'),
('91de0d406d7aa7ee09bf99a8ad160f1adcd4512b3be706fb9eaa67d82db0d9ea0b8c9c3c18e4b1f8', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 07:32:51', '2021-05-15 07:32:51', '2022-05-15 14:32:51'),
('92da4f5ea25f1fcfa232b5872a8392acc641c7e8b4e49e3583426174ae854b9d22a422ba6a505b55', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:23:47', '2021-05-12 23:23:47', '2022-05-13 06:23:47'),
('93540726e4fc8f33e776803bc62f28076d40dda341d2b80802176dc18a4788b1de1ced60f41833c5', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:45:54', '2021-05-06 08:45:54', '2022-05-06 15:45:54'),
('939c2bc548e6281def5757a79c5b5d8d57aa7e735bdd6560c6e256a4c4ab37d77ded4dbb6bcab689', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-28 20:29:17', '2021-05-28 20:29:17', '2022-05-29 03:29:17'),
('93f6b24eae0e1f3bcd840b59cd9a075e5bd6f49c507b39e22104f1fe1a37e874bf13de7063937ba4', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 07:22:09', '2021-05-15 07:22:09', '2022-05-15 14:22:09'),
('944c765fc6cbf92ba51e4e7d2d0d2d97249d7e5decbd1286878eec94f5170be3b06a9bcb46ceff5a', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:28:39', '2021-04-22 02:28:39', '2022-04-22 09:28:39');
INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('94c5595c21d03af529686b30ed791f70f095770f72aea8d1a8b68fdc3853152b23542df96b07046d', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 14:24:55', '2021-05-05 14:24:55', '2022-05-05 21:24:55'),
('9550d8f4fe42e8fd394d3607d07297ea6e7e20e7314e0ad4b52c4072fd75ba63ecdc4ffabb54a2a8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:45:26', '2021-04-25 22:45:26', '2022-04-26 05:45:26'),
('958cf9c5a4d6c3d6375b13abd9925c42ea861955c318d45ab71464c8cf96e7a22e95f4cdd98eccff', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-08 09:27:47', '2021-05-08 09:27:47', '2022-05-08 16:27:47'),
('95a389842e345401abcd369969a673bdb5de1128dedf4d186d7dfd85791d2c6f0f4e7dcc10ca01b6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 20:24:04', '2021-05-06 20:24:04', '2022-05-07 03:24:04'),
('962f0e9e7b74e2627de2d8fc572d288209087d497abb47e87504f67a20b7f5ab5e7a8414ba4104fb', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 03:20:30', '2021-04-27 03:20:30', '2022-04-27 10:20:30'),
('977243c98dfd1ca44a061d45819aa3e10d0d4807a6761361f514dea33ea1052afab6488f5740d2b1', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 08:52:26', '2021-05-25 08:52:26', '2022-05-25 15:52:26'),
('97df4d2b1abab0cce9fc10f0906e73ad7b3a01c3c242691773b023c5d7dca1eca7fa281005fc2c64', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:25:50', '2021-04-29 07:25:50', '2022-04-29 14:25:50'),
('97dfaee45f22651315bd78c36738c6054edafc0d9f73d27489b17a88b9528323e4f7d7de63a6d2fa', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:16:18', '2021-05-12 23:16:18', '2022-05-13 06:16:18'),
('97e7af3013829662322d067249142d67cf3eea1453cf84d2bd5592e6442eba9fe985106349417ca3', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-20 08:29:44', '2021-04-20 08:29:44', '2022-04-20 15:29:44'),
('995c78bfaf7c9331e6c4eb96b25d31f1fecbcad8c48dbc23e04bb6f91a9808cb19e3f32ce6e3a6ee', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-21 19:48:42', '2021-05-21 19:48:42', '2022-05-22 02:48:42'),
('99d3d44242f56dd8ffeb5b9bf68bd53258f5a721ffef82355e887ee7f2da71b756530a40cec4c5cd', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-08 09:33:37', '2021-05-08 09:33:37', '2022-05-08 16:33:37'),
('9b355f397c5a0a92a6070f3d398cbe4d41a395a79d55d7af8df0b18842bbe910fd49a25714c6bbf8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-16 07:33:03', '2021-05-16 07:33:03', '2022-05-16 14:33:03'),
('9b8e3e360b5f13f36a75fd8c0cd17f8d5ef2d668db3cb861ce8db47e46fa597cc52189d1f46f43b0', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 21:41:42', '2021-05-11 21:41:42', '2022-05-12 04:41:42'),
('9bb5e984c004a0d68b1798cf3aaeab33e7f5b3937a8161fc53e95baf4e5d327183a0e55aa4c5fc14', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:31:08', '2021-04-25 22:31:08', '2022-04-26 05:31:08'),
('9d629beb81792979bbc512a50ab29cc03de328707ae2397101a271be4bb57df5b1d8c2e4568340ee', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 08:28:30', '2021-04-25 08:28:30', '2022-04-25 15:28:30'),
('9fac0c215826eac3379ef8e2bac75c6e9c986737835058e1664e7c239309acb9dd7cc33be65060c8', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:58:29', '2021-04-25 21:58:29', '2022-04-26 04:58:29'),
('a03532419b3e1a589bebc413d1ec806c49dce75d37a9bf02876b26272daa6a80110d43c4c43d1009', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:20:38', '2021-04-25 22:20:38', '2022-04-26 05:20:38'),
('a03de7e3b7c9ebcb9745f6165c5666eea5c9c16635403ae25fbd75878e7d562802ee60bf479be838', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 04:23:37', '2021-05-26 04:23:37', '2022-05-26 11:23:37'),
('a05bda1b5976856b13c069fa2e0a479e7bf11d6660a090250fbd39837baac6aceb68c33f0e1eaed8', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 20:37:20', '2021-04-28 20:37:20', '2022-04-29 03:37:20'),
('a194adb7f3b6164a1be036879c85f42bc0ceaf4a3fa05b3c9901de3db8070e8c6d35f8baf616f29b', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-30 20:43:12', '2021-04-30 20:43:12', '2022-05-01 03:43:12'),
('a1c2063960c5fd43197844089cd3039809abe28f4e180fb8638664b6d08255acab6d569f60ee703d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:51:04', '2021-04-29 07:51:04', '2022-04-29 14:51:04'),
('a2d406afd55a529ff410ee31f074fcbbae478dc97ef1bd539162afa501cbddb28978ad21cf567735', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:31:43', '2021-04-26 00:31:43', '2022-04-26 07:31:43'),
('a40707639b868e5828827932620024389d61bd5ac48d76f83eda0409ec52bbb7629029c055cc609b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:23:37', '2021-04-25 22:23:37', '2022-04-26 05:23:37'),
('a4736f9824b57e734742498ce5c46a34940eb44e297314f222046c186421317d6a9e4073714f6b6d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:23:13', '2021-04-26 00:23:13', '2022-04-26 07:23:13'),
('a4ee517b12d8fc12e7381adab34b284c9313fd6cf3027c3fb6632886d2ede849adc734f5a1dfa71d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:21:45', '2021-04-22 02:21:45', '2022-04-22 09:21:45'),
('a660a02cd40a9d7e8065544f0bb86e9500b8c99243ae242bdad9b4e60bb9b0e1e0c2ceda04536d92', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 22:13:48', '2021-05-27 22:13:48', '2022-05-28 05:13:48'),
('a6b3f08dc65f111a8d32a99726721db4dca95443c30ca88dbb4d0883db9eba92bde854851ceb7176', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 08:48:29', '2021-04-26 08:48:29', '2022-04-26 15:48:29'),
('aa47249156ae5cfb5c5f07f02639e9645b4edf11b5b693fa07770d977da522ce0f155f19fc16583b', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 21:24:12', '2021-04-28 21:24:12', '2022-04-29 04:24:12'),
('aacf5db82fb73ebc20de4b17c06ad7196a25455bf7be167b5ee2212d46fc247f9ef8f561c29a8f7d', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 06:57:29', '2021-04-29 06:57:29', '2022-04-29 13:57:29'),
('ad3ae2ff76ef2af3b71e2b814398aab01afe555c2021ec4c65590ac2dfa5102b75b7737578830bbe', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 02:37:31', '2021-04-26 02:37:31', '2022-04-26 09:37:31'),
('af3e528140410b8f1159906c7ea80d172e896b39deb49879c3d7562e8b62736f1e708b5504687bbd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 08:03:40', '2021-04-29 08:03:40', '2022-04-29 15:03:40'),
('b02665ade51fc0b2d242886677703248a20988849423689edf40bc6fe8231b48e990941a4b549beb', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 01:35:35', '2021-04-29 01:35:35', '2022-04-29 08:35:35'),
('b0a719e7959694a7bbc62cd923081a89bcf486ae12bf342a831e46f50df2d62a2bff97036c9487cd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:58:50', '2021-05-25 03:58:50', '2022-05-25 10:58:50'),
('b0c6965ff6fad453835ae4577e23ddd241cb3f2be94e24f13b9e19b6dd888dfc875dee18fd23bfe0', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:12:09', '2021-04-25 21:12:09', '2022-04-26 04:12:09'),
('b0d76ca7e8d1375f353bfc9f4fb02948543ef1d4235982ad1df558d129107cb20274addffbbe91c5', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-19 07:30:43', '2021-05-19 07:30:43', '2022-05-19 14:30:43'),
('b2289d15daa68000504a97df2588049a7b6a299ee9971c1d4a11460b0153b2d93b6e4a32cc99d098', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 21:13:05', '2021-05-06 21:13:05', '2022-05-07 04:13:05'),
('b24cdb141b016edd1d8b7ab103e5899ea1ab6376e3f570ce72f7a0c0af0363da35dc0a10f1c927d4', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:29', '2021-05-18 07:21:29', '2022-05-18 14:21:29'),
('b2602fbbc9e8390dde3648b37abe3a57e426b1fd3cdc40086805b956b76d90db4aff638b797f02b4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:10:11', '2021-04-25 22:10:11', '2022-04-26 05:10:11'),
('b279509f771f65835ee5db1a343dd16e353d657af72837f529ff937132b119a65a0f6df1ba8da777', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:20:58', '2021-05-12 23:20:58', '2022-05-13 06:20:58'),
('b3993083c31d34927f92e683b19adf630678b4efee9b6d323add6f0bf7c2e14cf12fb9a3e39db2bd', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:30', '2021-05-18 07:21:30', '2022-05-18 14:21:30'),
('b690265fd3dfea427038aaeef720aca978cff248ed76a6ea3383e8f8b5b7cdab966255ccb1755037', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:49:33', '2021-04-29 07:49:33', '2022-04-29 14:49:33'),
('b6c8b8e80a78038cd43f67c09a89189bdb4f20fc9697430b7b047e6f07115639b19e5156938fc3cd', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 07:11:45', '2021-05-12 07:11:45', '2022-05-12 14:11:45'),
('b7084b34fcf2aa176d25a8e3faef4bc6de062042613c54b0775556fe3d0058ea73c4037c06f6f827', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:53:34', '2021-04-25 21:53:34', '2022-04-26 04:53:34'),
('b942671c69ce27b2983fc2c89e2c07eba38749a22bc09a4d7456a6d59979303e02e4d4d4ae08fcdd', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 02:33:08', '2021-05-06 02:33:08', '2022-05-06 09:33:08'),
('ba1fd1223f183d012a5d7d8cfbd8192170ca8526fb0876d6c50b5038acc71784b429a91b0b1155f5', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 06:49:21', '2021-05-15 06:49:21', '2022-05-15 13:49:21'),
('bb375486eb0ef2b0621ef8df0158338cebc424344b014954dbf7387df290a5134683e29ce297058d', 15, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:39:25', '2021-05-05 08:39:25', '2022-05-05 15:39:25'),
('bbcbc9ee4dff8f09c4a1fba09d9f2d6791d29b55b915630bcdf24aa8fcd03cf2fa91554b36c29221', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:35:40', '2021-04-25 21:35:40', '2022-04-26 04:35:40'),
('bc37824b27e979dea5f7177d7ee856db4698839f6ef8a3555e752bb89df225a6c0ceafc2bd5ae845', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-09 04:14:57', '2021-05-09 04:14:57', '2022-05-09 11:14:57'),
('bc6a281892da587174fe0b8e2904d556c936fdb8fee030192b3647302947d395ab9fd8e7fb4cad7d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:25:25', '2021-04-25 20:25:25', '2022-04-26 03:25:25'),
('bca6861352679271bf5bc8afac0f0335e3d7495b8e298d5941c5c83c5047c01393bf6a674c61bf48', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-31 01:50:44', '2021-05-31 01:50:44', '2022-05-31 08:50:44'),
('bd286ef122a85c94b529b0cc3231a7df336b6656b40abe2e2ddb243e88d3fd319e3c38e2cedb1f36', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:53:20', '2021-04-25 20:53:20', '2022-04-26 03:53:20'),
('bd9942a09bfb532573fa396c40c19289ba4965037b3913564ac0e8aa28637d5408b533fd4c647415', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-23 22:00:59', '2021-04-23 22:00:59', '2022-04-24 05:00:59'),
('beb062028a6a704b52a9aaede18f4e9329c1dc5f7745d09a23ae60d8a9131b79a3f275719bb40bf6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:24:15', '2021-04-29 07:24:15', '2022-04-29 14:24:15'),
('c20bcdbf1f960bc44b17e318ad91c40c44d9ba7c6c054161b968fe91061e48e87feb8cf76ee6351b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:41:55', '2021-04-25 03:41:55', '2022-04-25 10:41:55'),
('c259faa561c82a124b0955d694ad0ec0ec1fcaf0ae9aadaa4b370fa90740f57ba74ea8c09ff2637d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:34:27', '2021-04-25 21:34:27', '2022-04-26 04:34:27'),
('c2a9fcb4187d40025e36b323fc3ad771dad6feb0fd8008c034bdc1ae0699d2239e468e9fbf5b25f2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 07:56:15', '2021-04-28 07:56:15', '2022-04-28 14:56:15'),
('c3547124330f519904771d09848b2cd7379adadef8877d1a66b69eb431f6eb9e3f8c96efebfdf3f4', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:12:57', '2021-04-25 22:12:57', '2022-04-26 05:12:57'),
('c46050a27f03394fcdecf77e278885955d74e9a04b1961b88aff2638c489d099aeb8ea6a87e8a854', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 03:32:22', '2021-05-27 03:32:22', '2022-05-27 10:32:22'),
('c46f70b334b103877f993b00be26a2e829b287c88ecf0381291949d3f10b51d94d77dbbdd1841f55', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:39:11', '2021-04-26 05:39:11', '2022-04-26 12:39:11'),
('c4c9cba18d9830c685d48a860c97c69c7cb20d6bd3c5b0dd5da1c414bf67a21df4435df57cdc65d5', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-16 07:32:56', '2021-05-16 07:32:56', '2022-05-16 14:32:56'),
('c550da9cc9af55459b4cca73c4a6fa3ed8c87f31c2134cad906e30a36bbe54f1a3b3d1feeec5bbcc', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 20:20:17', '2021-05-12 20:20:17', '2022-05-13 03:20:17'),
('c5e1afeff14d6f8631ae498678095327f680f4da04e14d53d0946ec24ac257a48c26054fa987f8eb', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 07:21:23', '2021-05-15 07:21:23', '2022-05-15 14:21:23'),
('c63fc6dd192bf1c20d7b0564360c4f7156911bf45cdb63f8c445c9c6ec763197592061284ac963c0', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-16 07:31:50', '2021-05-16 07:31:50', '2022-05-16 14:31:50'),
('c706792097e482c6a9612e2ab949ae9bf33e582b55344b1b8ad611190fd89da82342fcaabab543f1', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 07:05:17', '2021-05-12 07:05:17', '2022-05-12 14:05:17'),
('c790aa0ba7168b6e52e59d5a7d12d3206fc1acac51cbd4f1b1424558c4fb9c2406cf91c99e5af387', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:04:57', '2021-04-25 21:04:57', '2022-04-26 04:04:57'),
('c82075de90aed8afd74dfa35ec8f16d246826ea5b553410e122306ee9bfa331c95ce78e5295ce057', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-14 21:48:19', '2021-05-14 21:48:19', '2022-05-15 04:48:19'),
('c95e74a9ede0d34f00aa7ef1b716d350b7bb5cc4b288975cd8148e2fd0e3b9b0686c7e91a9b7c045', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:21:54', '2021-05-12 23:21:54', '2022-05-13 06:21:54'),
('c9844ac222f562d47eecc59127837b17177c018573c77703d51a18a17fb7d0aa4cc8a5cdd783f396', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:19:35', '2021-04-25 22:19:35', '2022-04-26 05:19:35'),
('c9fc2d1934f1744adcd48ec4328fb63490d8c08e8535396eb89a2c32f19f0aa8e94bf39285e8d743', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-19 08:10:18', '2021-05-19 08:10:18', '2022-05-19 15:10:18'),
('caff61ba4fdcd156ace47cb68467f6a558b4af7ef013c22c92cbe431da93debf9813cda908aabc25', 16, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-27 07:45:32', '2021-05-27 07:45:32', '2022-05-27 14:45:32'),
('cb4c7113244cdec759bde8a786b65927741c71ff710d7ddbde936847e56fe2a48d3aca23c56dffee', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:28', '2021-05-18 07:21:28', '2022-05-18 14:21:28'),
('ccc657ea1f2b75d9c93e62d3bc4dc2419c922979ec4daf818114b7432ae7e4a68054ab42474abebf', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:33', '2021-05-18 07:21:33', '2022-05-18 14:21:33'),
('cccb9fb4b6792b6243da5a994bca315f6de499ff76ece1823ffca9088c0a77bb9000ba61c291c2d5', 7, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 04:17:37', '2021-05-25 04:17:37', '2022-05-25 11:17:37'),
('ce41b2d8a148593f742335f40acd41c680c1a80712224262f3dd9f8faace7c4aeed55b20684c6fb3', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:55:59', '2021-04-26 20:55:59', '2022-04-27 03:55:59'),
('ce637c37d2cc5f0c6069935e0bec2b83f52f46d26ce7e48e69ae42edd121ed1dfcb54052bdd2040d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 04:38:37', '2021-04-26 04:38:37', '2022-04-26 11:38:37'),
('cf3b704bd64aa1ec2393737e13ef2ed253a5a07267269ea95144d94db200b7849a32889db3b3d40b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:24:29', '2021-04-25 22:24:29', '2022-04-26 05:24:29'),
('cf6534bb0038d8351d2c721897f8c35ff02a87a12c40d662a4edbfb327a69de32e2805d3dd1c7b88', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 21:23:00', '2021-05-18 21:23:00', '2022-05-19 04:23:00'),
('cfc4ff2f37096fae356deb3b4eed39a8c3ba73c1b6bce3a43fef48763bc40f9967234debff06d571', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 01:55:41', '2021-05-12 01:55:41', '2022-05-12 08:55:41'),
('d0562a2277d17d3d180e0f4a9dc8be17512ef7b2ec4f1b20954ed887666ac6bb7194547682eccd12', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:01:50', '2021-04-25 22:01:50', '2022-04-26 05:01:50'),
('d1b498eb2feed722dfba9f5ce66a9461143cd92071704c0dc944366b6b41d8cef3a84efaa6670b50', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 08:28:47', '2021-04-25 08:28:47', '2022-04-25 15:28:47'),
('d1bde4abdb1ba6a1569b2df12c01983747881bf71df472227b6bd1a3f8c2a33bde66db7697e7f7f1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 00:52:21', '2021-04-22 00:52:21', '2022-04-22 07:52:21'),
('d22920520dfcb13f174a102c5f0aa24e88a02a8a1c72cda35a6df66eb8e6849f7dc670f1e3cf711c', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:27', '2021-05-18 07:21:27', '2022-05-18 14:21:27'),
('d302bfeebf99de64571553bc7dc5ada483036e45451d2e48f6694f52cc9a6f05c97d276220da8310', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:51:15', '2021-04-29 07:51:15', '2022-04-29 14:51:15'),
('d4697a7b465239a5d8b475ec4026668bea274637a65e83cefb19ad347af1551eb5b1d388b1cce6a1', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:21', '2021-05-18 07:21:21', '2022-05-18 14:21:21'),
('d4a9c3e9fe98e66fefcb31db01a6a05c25c317a7507a153fec89a797ecdc2e6529c6fe08e2a1c373', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-14 21:46:49', '2021-05-14 21:46:49', '2022-05-15 04:46:49'),
('d5483691f281653696fde7e4303fdfaeaa318431e4ee19d2115c354a89208e77e8fd8dfa98003bcd', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 07:17:44', '2021-04-29 07:17:44', '2022-04-29 14:17:44'),
('d771cd368dc93cea6829b661c8a216d9d5afb5c62c277099442e16e04b90a611a69a9cd8542ed444', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 06:47:17', '2021-05-15 06:47:17', '2022-05-15 13:47:17'),
('d88ce036d0930435ef052c3e04795aff4a2044b6a4642dc11507828e9522ba06408a74e66e123eec', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:34:51', '2021-05-25 03:34:51', '2022-05-25 10:34:51'),
('d929519b52a8d66a43e7b7f4d95c1cfc5ba3de9a050392bfb083d270e5db364683224a6d133b4a46', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-10 08:20:06', '2021-05-10 08:20:06', '2022-05-10 15:20:06'),
('d95798e0f9f5d9fb38257e7bb2128a2174742f20508d91cb0a957a315ad627c41f576d8aecd1d23b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:15:57', '2021-05-12 23:15:57', '2022-05-13 06:15:57'),
('d9d2945072871a60ce528fbea75a98959bf804a5382caf5d0e579f4eaa2a15a6f82026ae3df115c3', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:28:09', '2021-04-25 20:28:09', '2022-04-26 03:28:09'),
('daa13f989a3b5dd542af884d7d57cc8e2f482387c730be4e3ef34b09fcfd38d4482ae9865cbebdf5', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-08 08:22:13', '2021-05-08 08:22:13', '2022-05-08 15:22:13'),
('dadaf9ba97220567e9a8beca8f3e0a7174781d458181ffeb9b1ebbd5a600aac3821929de046881f3', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-17 03:09:56', '2021-04-17 03:09:56', '2022-04-17 10:09:56'),
('db6e617f1500b6f0bf7cff0a61d256cef12e4066e8ddafcb2896ed9622f73a07760ddff96372337c', 17, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 14:50:00', '2021-05-26 14:50:00', '2022-05-26 21:50:00'),
('dc45fd53dae4b8284746e7d3cb55a33e114e58ad90e896ee34c5f8096e34e93602404b76c9f94910', 16, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 14:30:57', '2021-05-06 14:30:57', '2022-05-06 21:30:57'),
('dccd2d72e4fae68ccf5f5304e9999963ebccecb70aedb536ca82f8a09e086ec64fdfdb94e4a4f7bb', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:41:25', '2021-04-25 20:41:25', '2022-04-26 03:41:25'),
('dd3c60720c2e24393dd053d551c2b859c26bc5fead0c22e766d15c56f37f66ad3c4427d1e8fe40e6', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-28 20:00:15', '2021-04-28 20:00:15', '2022-04-29 03:00:15'),
('de0736be6e3dcb94fa67688e0b3b31e86971f9b50462a80d8adf8615f6d3dc364d7b300e7b536497', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 01:44:56', '2021-04-29 01:44:56', '2022-04-29 08:44:56'),
('ded3c45eb49f20a2f71b39087043f4c8aae45d99b0363e07fb26730cdcc1b79fa11785be11f9ae8e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:32', '2021-05-18 07:21:32', '2022-05-18 14:21:32'),
('e05bf6824edea41ed951b721eb01803e8ad1b5e92af9f1fc0d94edf16dfe15a3cc8ca69c21fd778b', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-19 06:38:35', '2021-04-19 06:38:35', '2022-04-19 13:38:35'),
('e0f8c2a913448487ee9a6c49d0f53c6f8571b45b2a6ff96b0e4facd34f5c23d84193c7f76d834f23', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:29:02', '2021-04-25 21:29:02', '2022-04-26 04:29:02'),
('e19ba6987ca0f826ed5df71b7c69ce5b82aa3116fd3ba9bf561291df82fc4eb5adf723cb7e32f3ba', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 00:04:51', '2021-04-26 00:04:51', '2022-04-26 07:04:51'),
('e3981bdf790e99aee43b3ac256bfcad3057b0a2fdf5a1ebcb0517a1ae139c9a9904087fe65137f03', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:27', '2021-05-18 07:21:27', '2022-05-18 14:21:27'),
('e460396cd1ade18dbee928303cab31fc17a7b9ac9b51c38ca7fa6116ee88b5a5854b5f50ba5085a6', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 21:19:34', '2021-04-26 21:19:34', '2022-04-27 04:19:34'),
('e49766f3213520da5b8f8c23c46b1c75165dc804da1f374cb0b068925970d577a4a112b8d849d6da', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-26 21:58:29', '2021-05-26 21:58:29', '2022-05-27 04:58:29'),
('e53abb1a6da6a4013cb35a5fee099c0532b8ca444dcba26b06695c80298a1e9a910ca551e4736546', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-14 00:24:36', '2021-05-14 00:24:36', '2022-05-14 07:24:36'),
('e553dfd229f7766dea3ad214c73e78eb41bedfb26bb66146907c4b920c5dc2bdac62f7bb4bd2e511', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-16 07:45:32', '2021-05-16 07:45:32', '2022-05-16 14:45:32'),
('e603476906df74dec7264a88d3da046b9f60f85fdfbac30b8d6eeb90d8684b1a3800083897f6344b', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:36:44', '2021-04-25 22:36:44', '2022-04-26 05:36:44'),
('e60d6ee508ce0aefb0c922fec747d41dbc01be2640e67ab14d96fe18c6822c830fbd1256ba1b210b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 21:35:37', '2021-05-25 21:35:37', '2022-05-26 04:35:37'),
('e6f3fbace9678891d12197f435e9558ddc95cf48fa2967c53c25bfcd24650483b52a69c1d4d06796', 6, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 03:36:31', '2021-04-25 03:36:31', '2022-04-25 10:36:31'),
('e755cecb00bca80c0155e926ed019c66d4fbd1e62bf3c1a2a2643f2f2b77a5af65ef4021fce37c5d', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 22:05:45', '2021-04-25 22:05:45', '2022-04-26 05:05:45'),
('e8f8c9c8a4a9c979547929551034d53ae76177c627110036f705dbefad33fcfa5edca02ba1f9c003', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 20:58:01', '2021-04-25 20:58:01', '2022-04-26 03:58:01'),
('e961e975472d4d0bec958e482493b8d0a9b776170985f6b726ba6fee449867c2468e3e6e531bde86', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-21 19:59:52', '2021-04-21 19:59:52', '2022-04-22 02:59:52'),
('e9b3a1a2aab9dedee5a2dc6075323e1acd17d3d9479c2508cb10bf45fb457a76b364716f91e9d7d2', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:48:53', '2021-04-22 02:48:53', '2022-04-22 09:48:53'),
('e9cc451af2084313ec1b4a5f1be81228c18ff192961938c4e9937d56902f1ab322355de2c0b89f48', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 08:43:27', '2021-05-11 08:43:27', '2022-05-11 15:43:27'),
('ea3065ba967b12d94fd542e8a3930a659a91f1ac7411f552d5140b1b0fbbbe6b686d81da45e87fbc', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:32', '2021-05-18 07:21:32', '2022-05-18 14:21:32'),
('ea944be205de2c87abe39d90f4d350460f0661165f5f39fa352cb3f8d983948a13be98c30fa712e2', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:26', '2021-05-18 07:21:26', '2022-05-18 14:21:26'),
('ee8e218c22a92b81304a4f8d9e32a8559cd3e915c3604f6f993774b078bebbaf4256b38e30b7dc1c', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:20:03', '2021-04-22 02:20:03', '2022-04-22 09:20:03'),
('ef45f937b3cb85e6ead6125f5e39fdc79b1696392caa8d2042c584bf27272dd9c75dd142698d4d05', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-10 08:15:57', '2021-05-10 08:15:57', '2022-05-10 15:15:57'),
('efad34a68bc08789311b233fed334cda39673c8e352ba6c4d2a49802aec9e2644814a8471619791c', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 20:32:33', '2021-04-26 20:32:33', '2022-04-27 03:32:33'),
('efde4df7810351fded06f2ad3c02dfb32c4c5f6e58a3b9e1d9457d8ab2769121b393c4c0b9c891ce', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 03:01:24', '2021-05-06 03:01:24', '2022-05-06 10:01:24'),
('eff8f86452ab8c4ef3f966dc3e29847c093e4e9af667d7802a464580837c709408e8ac643145827b', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 23:24:32', '2021-05-12 23:24:32', '2022-05-13 06:24:32'),
('f0e509c8aeb75cdc09404bba471a628c709109f85ade118129a6e4f7e6de99f8c2825396391641d8', 4, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-25 03:50:06', '2021-05-25 03:50:06', '2022-05-25 10:50:06'),
('f19be16f16e70076773cd53231a626374efd6d948662c9d6a6fafebf943be54720094a541e649ace', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-13 06:30:29', '2021-05-13 06:30:29', '2022-05-13 13:30:29'),
('f1a8eec2aa5635c390d2ab5bf2adcb6a022c0b6e7da730a9e3151dbb36096d6b78a46b6b55bab6f5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 01:21:54', '2021-04-27 01:21:54', '2022-04-27 08:21:54'),
('f1f6deed674c812e32f7ff4b3c98ee84bf04e1f5cf68c239dee68a143debc2d5e0bf6e896d826c8e', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-06 08:28:27', '2021-05-06 08:28:27', '2022-05-06 15:28:27'),
('f3375b5c0d3245b03dbbbd7eb2c4e123733a64609de19266169af99dbc8b6a00196617527c735382', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-26 05:30:53', '2021-04-26 05:30:53', '2022-04-26 12:30:53'),
('f401c94188e1422acd1570e8122b02278251ef230bd0460b15127fe1b14ff4e130a4c6cc42d07800', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 08:18:40', '2021-05-05 08:18:40', '2022-05-05 15:18:40'),
('f4f2d82a10b15f1c1cb6856b21ca9bd97382cac7a6c1b7d102995ed062e17d1c68a4cc4891001c2f', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:31', '2021-05-18 07:21:31', '2022-05-18 14:21:31'),
('f5008aa67c9cd23e22dd8f272ae2a42ad06abf19d325d3f1f51717d35cab87c455005760ec44b087', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-10 08:26:16', '2021-05-10 08:26:16', '2022-05-10 15:26:16'),
('f62d2bbcbadd56a2b0a23c73177feedf7afcb62ee5f56c828b80250bc8f27e2098854401b599b6ad', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:43:09', '2021-04-22 02:43:09', '2022-04-22 09:43:09'),
('f636128c110b99db32cd1ab27d193a25620e94d3d2ab26d0c56cc4dcfb1e28b2a76e8e3d6558ca69', 2, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 07:21:29', '2021-05-18 07:21:29', '2022-05-18 14:21:29'),
('f65d5970ea712a7d8db40f42818c8e9aea17d56255c5d05d7a4d4361305cb06bee4b26c424f19684', 1, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-18 02:33:24', '2021-05-18 02:33:24', '2022-05-18 09:33:24'),
('f7a7f3a9c91b9b10fd45d8650df9a7421c532160ec8a1cc09dbdb3184b215ef601fb3eb3217500a1', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-22 02:43:55', '2021-04-22 02:43:55', '2022-04-22 09:43:55'),
('f8114709833bf05ae30af15262d92e453c28e6c2580df9f371b2e2d6466d115e5c75887354d63425', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-16 07:32:29', '2021-05-16 07:32:29', '2022-05-16 14:32:29'),
('f84a2f33b25ebb21c0aa9abb9c291fa2863933abd62c196297d292bc82aea3a9cfe96985036ed2a9', 18, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-31 09:00:30', '2021-05-31 09:00:30', '2022-05-31 16:00:30'),
('f9bb66bc9d5f1a8a965321247ccb5086c47e154c94fc6b4655f2db6c453118d9d6384f1d47952655', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-05 07:25:24', '2021-05-05 07:25:24', '2022-05-05 14:25:24'),
('fab4223a58cb06f9aa3053f59825331b24fd100a5bb0775493c98145954d8105012048c3118c64e1', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-12 03:28:16', '2021-05-12 03:28:16', '2022-05-12 10:28:16'),
('fbc80d0703334536cae37947e8badd9feda3dbde70cebeb8679a7a6ab94e7329301ff8562437f624', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-29 01:46:47', '2021-04-29 01:46:47', '2022-04-29 08:46:47'),
('fc802ac43fcc9b537c3bf570dcf5697e9b9514e720ecd347d566111906a85cc7f2c505605d68e04a', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-28 20:36:30', '2021-05-28 20:36:30', '2022-05-29 03:36:30'),
('fcaf4b5dafb62b963d726e053dde05bea654c11b19c769a4961d5f38e7210a1090d366be14ff9c8c', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 07:08:11', '2021-05-15 07:08:11', '2022-05-15 14:08:11'),
('fe2e1f799b1e38572fc3babd6c4dfed722838a235cb729706a231b3cd1455d600a31bef0620e13db', 5, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-25 21:08:22', '2021-04-25 21:08:22', '2022-04-26 04:08:22'),
('fe4d77e58c377490e04cdd47380b2484ca26ba1ac485486e43a6daab87cd37b5786d1f07ad64cbee', 13, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-28 20:49:39', '2021-05-28 20:49:39', '2022-05-29 03:49:39'),
('fe645b1f0c1c47461c5c4204c7c34f710b3ead022bd4c1d4622df0197ac897fd5ea3a41841b30d6c', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-15 07:28:31', '2021-05-15 07:28:31', '2022-05-15 14:28:31'),
('ff4effa1257225fb6c2f653ba32ca5f723f8473bdb7a239feaf79f4bf9c82a08594dc921304f0dc5', 3, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-04-27 02:05:25', '2021-04-27 02:05:25', '2022-04-27 09:05:25'),
('ff68f95cc7df459613e8bdfd69ed198fcf9a7bb83ac3bf96a7e7045d877431a9726880bf02b33863', 14, '93373a5a-8260-4ce5-8248-216dc5c86ab6', 'ComputerStore', '[]', 0, '2021-05-11 19:35:44', '2021-05-11 19:35:44', '2022-05-12 02:35:44');

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
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `view` int(11) NOT NULL DEFAULT 0,
  `rate` float DEFAULT 0,
  `created_at` datetime NOT NULL,
  `createdBy` int(11) NOT NULL,
  `updatedDate` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `trademark_id`, `product_type_id`, `price`, `amount`, `warranty`, `description`, `view`, `rate`, `created_at`, `createdBy`, `updatedDate`, `updatedBy`) VALUES
(1, 'Laptop LG Gram 14ZD90N-V.AX55A5 (i5 1035G7/8GB RAM/512GBSSD/14.0 inch FHD/FP/Xám Bạc) (model 2020)', 4, 3, 23920000, 5, 12, 'CPU: Intel Core i5 1035G7\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 14.0 inch FHD\nHĐH: Dos\nMàu: Xám Bạc.', 13, 0, '2021-05-15 08:47:23', 2, '2021-05-24 00:00:00', 2),
(2, 'Laptop LG Gram 15ZD90N-V.AX56A5 (i5 1035G7/8GB RAM/512GBSSD/15.6 inch FHD/FP/Trắng) (model 2020)', 4, 3, 24960000, 4, 12, 'CPU: Intel Core i5 1035G7\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 15.6 inch FHD\nHĐH: Dos\nMàu: Trắng', 44, 4.5, '2021-05-15 08:47:23', 2, '2021-05-24 02:48:53', 2),
(3, 'Laptop Acer Aspire A514-54-3204 (NX.A23SV.009) (i3 1115G4/4GB RAM/512GBSSD/14.0 inch FHD/Win10/Bạc)', 42, 3, 12600000, 5, 12, 'CPU: Intel Core i3 1115G4\nRAM: 4GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 14 inch FHD\nHĐH: Win 10\nMàu: Bạc', 0, 0, '2021-05-15 08:47:23', 2, '2021-05-24 03:47:54', 2),
(4, 'Laptop Dell Vostro 3405 (V4R53500U003W) (R5 3500U 8GB RAM/512GB SSD/14.0 inch FHD/Win10/Đen)', 1, 3, 13650000, 5, 24, 'CPU: AMD R5 3500U\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 14 inch FHD\nHĐH: Win 10\nMàu: Đenn', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(5, 'Laptop Dell Vostro 5402 (V4I5003W) (i5 1135G7 8GBRAM/256GB SSD/14.0 inch FHD/Win10/Xám)', 1, 3, 17850000, 4, 24, 'CPU: Intel Core i5 1135G7\nRAM: 8GB\nỔ cứng: 256GB SSD\nVGA: Onboard\nMàn hình: 14 inch FHD\nHĐH: Win 10\nMàu: Xám', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(11, 'RAM Desktop Gskill Trident Z Neo (F4-3600C16D-16GTZNC) 16GB (2x8GB) DDR4 3600MHz', 5, 1, 2400000, 9, 24, 'Dòng sản phẩm Gskill Trident Z Neo mới nhất của Gskill\nPhù hợp với nền tảng AMD\nDung lượng: 2 x 8GB\nThế hệ: DDR4\nBus: 3600MHz', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(12, 'DDRam 4 Kingston ECC 16GB 2400Mhz - KSM24ED8/16ME', 12, 1, 2530000, 10, 24, 'Dòng RAM ECC dành cho máy chủ của Kingston\nDung lượng: 1 x 16GB\nThế hệ: DDR4\nBus: 2400MHz', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(13, 'DDRam 4 Kingston ECC 32GB/2666 - KSM26RD4/32HAI Registered', 12, 1, 6050000, 9, 12, 'Dòng sản phẩm ECC của Kingston\nDung lượng: 1 x 32GB\nThế hệ: DDR4\nBus: 2666MHz', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(14, 'RAM Desktop AXPRO 2GB (1x2GB) DDR3 1600MHz', 13, 1, 125000, 10, 24, 'Dung lượng 2GB\nKiểu Ram DDRam 3\nBus Ram hỗ trợ 1600', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(15, 'RAM desktop DDR4 Micron ECC 16GB/2133Mhz (ECC Registered)', 11, 1, 1440000, 10, 24, 'Kiểu Ram: ECC Registered\nDung lượng: 1 x 16GB\nThế hệ: DDR4\nBus: 2133MHz', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(16, 'Mainboard MSI B450M GAMING PLUS (AMD B450, Socket AM4, m-ATX, 2 khe RAM DDR4)', 14, 9, 2040000, 8, 36, 'Hỗ trợ AMD® RYZEN ™ thế hệ thứ nhất và thứ 2 / Ryzen ™ với bộ xử lý đồ họa Radeon ™ Vega cho Socket AM4\nHỗ trợ bộ nhớ DDR4-3466 (OC)\nTrải nghiệm game Fast Lightning: TURBO M.2, StoreMI\nTăng cường âm thanh với Nahimic: Thưởng cho đôi tai của bạn với chất lượng âm thanh đẳng cấp cho trải nghiệm chơi game sống động nhất\nCore Boost: Với bố cục cao cấp và thiết kế điện kỹ thuật số để hỗ trợ nhiều lõi hơn và mang lại hiệu suất tốt hơn.\nDDR4 Boost: Tăng cường hiệu năng bộ nhớ DDR4 với A-XMP\nSẵn sàng VR: Tự động tối ưu hóa hệ thống của bạn để sử dụng VR, đẩy hiệu suất tối đa.', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(17, 'Mainboard GIGABYTE H310M-DS2 (Intel H310, Socket 1151, m-ATX, 2 khe RAM DDR4)', 15, 9, 1680000, 9, 36, 'Kích thước: ATX\nSocket: LGA 1151v2\nChipset: H310\nKhe RAM tối đa: 2\nLoại RAM hỗ trợ: DDR4', 1, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(18, 'Mainboard ASUS Z10PE-D16 WS (DUAL CPU WORKSTATION)', 2, 9, 12600000, 10, 12, 'Intel® Socket 2011-3 kép/ Chipset Intel C612 PCH\nThiết kế luồng không khí chuyển động đều với 16 khe cắm DIMM\nGiải pháp Điện năng Tuyệt đối – Các linh kiện cao cấp cho hiệu quả sử dụng điện năng hàng đầu\nBIOS độc đáo để ép xung Hai CPU – Tăng hiệu năng ép xung của CPU lên đến 10%\nQuản lý hoàn toàn máy chủ từ xa với module IPMI 2.0-compliant ASMB8-iKVM và ASWM Enterprise', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(19, 'Mainboard ASUS Z10PA-D8C (DUAL CPU WORKSTATION)', 2, 9, 7480000, 10, 36, 'Bo mạch máy chủ ASUS Z10PA-D8C đã tích hợp các tính năng linh hoạt vào một kiểu dáng 12”x10” và có thể dễ dàng lắp vừa rất nhiều thùng máy ATX tiêu chuẩn. Thông qua thiết kế sáng tạo và kỹ thuật chế tác hạng nhất, bo mạch máy chủ này mang đến giải pháp lưu trữ toàn diện, hiệu năng máy chủ với một thiết kế nhỏ gọn, cùng các linh kiện cao cấp cho hiệu quả làm việc cao cấp. Với hỗ trợ cho hai CPU và một thiết kế có thể lắp vừa các thùng ATX, Z10PA-D8C là giải pháp lý tưởng cho hệ thống máy chủ nhóm, máy chủ lưu trữ Hadoop, các ứng dụng máy chủ lưu trữ khác và trung tâm dữ liệu của các doanh nghiệp vừa và nhỏ (SMB).', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(20, 'Mainboard Asrock Rack EP2C602 - Dual CPU Socket 2011', 16, 9, 7150000, 10, 36, 'Sản phẩm sử dụng CPU Intel Xeon E5 - 2680 v2 (Mã SP: CPUI252). Tối ưu đa nhiệm của hệ thống máy chủ Server và máy Trạm WORKSTATIONS', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(21, 'CPU Intel Xeon Silver 4110 (2.1GHz turbo up to 3.0GHz, 8 nhân, 16 luồng, 11MB Cache, 85W) - Socket Intel LGA 3647', 18, 8, 11000000, 8, 36, 'Dòng sản phẩm chuyên biệt dành cho server/máy trạm\n8 nhân & 16 luồng\nXung nhịp: 2.1GHz (Cơ bản) / 3.0GHz (Boost)\nSocket: LGA 3647\nHỗ trợ RAM ECC\nKhông kèm quạt tản nhiệt từ hãng\nKhông tích hợp sẵn iGPU', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(22, 'CPU Intel Core i9-9900KF (3.6GHz turbo up to 5.0GHz, 8 nhân 16 luồng, 16MB Cache, 95W) - Socket Intel LGA 1151-v2', 18, 8, 11025000, 8, 36, 'Phiên bản cắt giảm đi nhân đồ họa tích hợp của 9900K\nSố nhân: 8\nSố luồng: 16\nTốc độ cơ bản: 3.6 GHz\nTốc độ tối đa: 5.0 GHz\nCache: 16MB\nTiến trình sản xuất: 14nm', 5, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(23, 'CPU AMD Ryzen 7 3700X (3.6GHz turbo up to 4.4GHz, 8 nhân 16 luồng, 36MB Cache, 65W) - Socket AMD AM4', 17, 8, 7700000, 9, 36, 'CPU Ryzen thế hệ thứ 3, tiến trình sản xuất 7nm\n8 nhân, 16 luồng, xung nhịp mặc định 3.6 GHz, xung nhịp boost tối đa 4.4 GHz\nHỗ trợ PCI-e 4.0\nCó hỗ trợ ép xung\nĐi kèm tản nhiệt Wraith Prism với RGB LED', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(24, 'CPU AMD Ryzen 5 3400G (3.7GHz turbo up to 4.2GHz, 4 nhân 8 luồng, 4MB Cache, Radeon Vega 11, 65W) - Socket AMD AM4', 17, 8, 3450000, 10, 36, 'APU Ryzen thế hệ thứ 3, tiến trình sản xuất 12nm\n4 nhân, 8 luồng, xung nhịp mặc định 3.7 GHz, xung nhịp boost tối đa 4.2 GHz\nTích hợp Radeon™ RX Vega 11 Graphics\nHỗ trợ PCI-e 3.0\nCó hỗ trợ ép xung\nĐi kèm tản nhiệt Wraith Spire', 0, 0, '2021-05-15 08:47:23', 2, '2021-05-24 07:32:59', 2),
(25, 'CPU Intel Xeon E-2236 (3.4GHz turbo up to 4.8GHz, 6 nhân, 12 luồng, 12 MB Cache, 80W) - Socket Intel LGA 1151-v2', 18, 8, 7150000, 10, 36, 'Dòng sản phẩm chuyên biệt dành cho máy trạm giá rẻ\nPhù hợp cho các phần mềm render, thiết kế\n6 nhân & 12 luồng\nXung nhịp: 3.4 GHz (Cơ bản) / 4.8 GHz (Boost)\nSocket: LGA 1151v2 (C246)\nHỗ trợ RAM ECC\nKhông tích hợp sẵn iGPU', 0, 0, '2021-05-15 08:47:23', 2, '2021-05-24 07:35:00', 2),
(26, 'Nguồn FSP Power Supply HYDRO Series Model HD600 Active PFC (80 Plus Bronze/Màu Đen)', 20, 11, 1200000, 10, 36, 'Model : HD600', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(27, 'Nguồn Corsair SF Series SF600 600W (80 Plus Gold Certified High Performance SFX/Màu Đen)', 21, 11, 2400000, 7, 36, 'Hãng sản xuất: Corsair\nChủng loại: Corsair SF Series SF600\nChuẩn nguồn : ATX12V ver2.31\nCông suất danh định : 600W\nCông suất thực : 600W\nĐường điện vào: (100~240V)', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(28, 'Nguồn FSP Power Supply HYDRO-GE Series Model HGE650 Active PFC (80 Plus Gold/Full Modular/ ATX/Màu Đen)', 20, 11, 1800000, 10, 36, 'Tuân thủ ATX12 v2.4 & EPS12 v2.92\nHiệu quả cao ≧ 90%\nPFC hoạt động ≧ 0,9\nĐạt chứng nhận 80PLUS® GOLD\nNhãn dán có thể thay đổi cho những người đam mê DIY và game thủ\nThiết kế đường 12V Single Rail\nDây nguồn rời toàn bộ với cáp dẹt\nToàn bộ tụ điện của Nhật Bản\nHỗ trợ các đầu nối PCI-Express 6 + 2 pin\nQuạt FDB 135mm yên tĩnh và lâu dài\nBảo vệ hoàn toàn: OCP, OVP, SCP, OPP, UVP, OTP\nĐược chứng nhận tiêu chuẩn an toàn toàn cầu\nNguồn FSP HYDRO-GE Series Model HGE650 - White - Active PFC - 80 Plus Gold', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(29, 'Nguồn Asus ROG Thor 1200W Platinum - RGB 1200W 80 Plus Platinum Full Modular', 2, 11, 9900000, 10, 36, 'Công nghệ Aura Sync : Tùy biến nâng cao với LED RGB địa chỉ và tương thích Aura Sync\nMàn hình nguồn OLED : Theo dõi việc sử dụng điện năng theo thời gian thực bằng màn hình nguồn OLED\nGiải pháp tản nhiệt ROG : làm mát 0dB với thiết kế quạt hình cánh chống bụi đạt chứng nhận IP5X và tản nhiệt ROG\n80 PLUS Platinum : Được tích hợp các tụ điện 100% của Nhật Bản và các linh kiện cao cấp khác\nCáp luồn: Đảm bảo lắp đặt dễ dàng và tính thẩm mỹ vượt trội', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(30, 'Nguồn Jetek P700 700W (Màu Đen/Led RGB )', 19, 11, 1200000, 10, 36, 'Hiệu suất cao lên tới 85%\nThiết kế cấu truc tổ ong, tối ưu luồng gió lưu thông làm mát\nNgõ ra điện áp +12V tăng cường công suất, mở rộng khả năng sử dụng\nQuạt làm mát 12cm đem lại sự yên tĩnh khi hoạt động\nDC to DC Converter\nQuạt RGB độc đáo', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(31, 'Card màn hình GIGABYTE RX570 GAMING-4G (rev. 2.0) (4GB GDDR5, 256-bit, HDMI+DP, 1x8-pin)', 15, 10, 4600000, 9, 36, 'VGA Gigabyte RX570GAMING-4GD\nDung lượng bộ nhớ: 4GB GDDR5\nOC Mode : 1255MHz\nGaming Mode (Default): 1244MHz\nCổng kết nổi: 3x DP, 1x HDMI', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(32, 'Card màn hình GIGABYTE GTX 1660 Super OC-6G (6GB GDDR6, 192-bit, HDMI+DP, 1x8-pin)', 15, 10, 13650000, 8, 12, 'Dung lượng bộ nhớ: 6GB GDDR6\nCore clock: 1830 MHz\nBăng thông: 192-bit\nKết nối: DisplayPort 1.4 *3, HDMI 2.0b *1\nNguồn yêu cầu: 450W', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(33, 'Card màn hình ASUS ROG STRIX RX570-O4G GAMING (4GB GDDR5, 256-bit, DVI+HDMI+DP, 1x8-pin)', 2, 10, 3450000, 10, 36, 'Dung lượng bộ nhớ: 4GB GDDR5\nLên tới 1310 Mhz (Chế độ ép xung)\nLên tới 1300 Mhz (Chế độ chơi game)\nBăng thông: 256-bit\nKhuyến cáo dùng nguồn 450W', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(34, 'Vga Card ASUS Dual RX580 - O8G', 2, 10, 4600000, 8, 36, 'Engine đồ họa : AMD Radeon RX 580\nBộ nhớ : GDDR5 8GB\nEngine Clock : 1380 MHz (OC Mode)\nĐộ phân giải : Digital Max Resolution:7680x4320\nPower Connectors  : 1 x 8-pin', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(35, 'Card màn hình MSI GTX 1660 Super GAMING X (6GB GDDR6, 192-bit, HDMI+DP)', 14, 10, 12600000, 10, 36, 'Phiên bản GTX 1660 Super tốt nhất từ MSI\nXung nhân tối đa: 1830 MHz\nBộ nhớ: 6GB GDDR6\nCổng kết nối: DisplayPort x 3 / HDMI x 1\nQuạt TORX Fan 2.0\nHỗ trợ NVIDIA G-SYNC™ và HDR', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(36, 'Mouse Roccat Kone Pure Optical Core Performance', 22, 15, 1200000, 10, 12, 'Chuột chơi game cao cấp dành cho game thủ thuật tay phải\nMắt cảm biến Laser 8200 DPI\nĐèn LED 16.8 triệu màu tùy chỉnh\nNút bấm Omron cho tuổi thọ 10 triệu lượt nhấn và cảm giác nhấn mềm mại\n7 nút bấm có thể điều chỉnh tùy biến bằng driver\nNút cuộn được trang bị công nghệ Titan\nBộ nhớ bên trong lên tới 500KB\nVỏ ngoai của chuột cực kì bền bỉ', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(37, 'Mouse V-King M525 RGB Gaming Black', 23, 15, 250000, 9, 12, 'Mouse V-King M525 RGB Gaming\nMắt cảm biến PMW3325\nĐộ phẩn giải: 8000 DPI\nThiết kế đối xứng phù hợp cho cả 2 tay\nNút bấm có tuổi thọ lên đến 30 triệu lần nhấn\nTrang bị led RGB có thể tuỳ chỉnh', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(38, 'Mouse Cougar Minos X5 RGB Pixart 3360', 24, 15, 960000, 10, 12, 'Mouse Cougar Minos X5 RGB Pixart 3360\nMinos X5 sử dụng mắt cảm biến chơi game cao cấp nhất thế giới là Pixart 3360\nCũng là chú chuột rẻ nhất sử dụng mắt cảm biến này\nNút chuột Omron cho cảm giác bấm mềm mại\nHệ thống led RGB 16,8 triệu màu\nThiết kế Ambidextrous phù hợp với nhiều tựa game như FPS và MOBA\nPhù hợp với game thủ tay Nhỏ - Trung Bình', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(39, 'Tai nghe Kingston HyperX Cloud II Gaming  Red (KHX-HSCP-RD)', 12, 13, 2160000, 10, 12, 'Phiên bản Cloud 2 II với công nghệ giả lập âm thanh vòm 7.1\nSử dụng chiếc Soundcard 7.1, chỉ cần cắm và sử dụng\nKhông cần Driver điều chỉnh\nThiết kế cứng cáp, cảm giác đeo thoải mái trong nhiều giờ\nChất âm thiên sáng, chi tiết tốt, phù hợp với các game thi đấu ESPORTS\nMicrophone có thể được tháo rời thuận tiện\nĐược khuyên dùng bởi các game thủ CS:GO chuyên nghiệp', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(40, 'Tai nghe Zidli ZH11S LED RGB USB Black', 25, 13, 500000, 10, 12, 'Tai nghe Zidli ZH11S RGB\nChuẩn kết nối : USB\nEarcup full-size trang bị ốp da chống ồn\nKhung thép chắc chắn\nLed RGB', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(41, 'Tai nghe Logitech G231 Prodigy Gaming Headset', 26, 13, 960000, 10, 12, 'Kiểu kết nối: Tai nghe có dây\nMicrophone: Có\nKích thước driver: 40 mm\nTrở kháng: 32 ohms\nTần số phản hồi: 20 - 20,000 Hz\nKhối lượng: 255 g\nTai nghe chơi game Logitech G231\nTai nghe âm thanh Stereo chất lượng cao\nĐệm tai nghe làm bằng vải cho cảm giác thooải mái khi đeo lâu dài\nTrọng lượng nhẹ, mic có thể gập gọn\nTích hợp bộ điều khiển trên dây', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(42, 'Bàn phím gaming Fuhlen M87S RGB Mechanical Blue Switch 87 Black', 27, 14, 720000, 8, 24, 'Chiếc bàn phím cơ bán chạy nhất của Fuhlen\nPhiên bản mới 2019 với font chữ đẹp hơn\nLoại bỏ logo Rồng trước đây của Fuhlen\nLoại Switch Huano mới với sự cải tiến chất lương gõ cho cảm giác nhấn tương đương Kailh Switch\nLed RGB sáng nhất trong phân khúc dưới 1 triệu đồng', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(43, 'Bàn phím cơ Geezer GS4 RGB Mechanical Blue Switch 87 Black', 28, 14, 625000, 10, 0, 'Hãng sản xuất : Bàn phím Geezer\nChủng loại : Keyboard Geezer GS4 RGB Mechanical Blue Switch 87 Black\nChuẩn bàn phím : Có dây\nChuẩn giao tiếp : USB', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(44, 'Bàn phím gaming Eblue Eblue EKM 757BGUS-IU USB Black', 29, 14, 960000, 8, 12, 'Hãng sản xuất : Bàn phím EBLUE\nChủng loại : Keyboard Eblue Mazer Mechanical EKM 757BGUS-IU USB Black\nChuẩn bàn phím : Có dây\nChuẩn giao tiếp : USB 2.0\nCông nghệ phím : Bàn phím cơ -Switch: đen, xanh Content', 0, 0, '2021-05-15 08:47:23', 2, '0000-00-00 00:00:00', 0),
(81, 'Laptop Acer Gaming Nitro 5 AN515-55-5923 (NH.Q7NSV.004) (i5 10300H/ 8GB Ram/ 512GB SSD/ GTX1650Ti 4G/15.6 inch FHD 144Hz/Win 10) (2020)', 42, 3, 18900000, 5, 12, 'CPU: Intel core i5 10300H\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: NVIDIA GTX1650Ti 4G\nMàn hình: 15.6 inch FHD 144hz\nHĐH: Win 10\nMàu: Đen', 0, 0, '2021-05-24 03:59:47', 2, NULL, NULL),
(82, 'Laptop Acer Aspire A315-57G-31YD (NX.HZRSV.008) (i3 1005G1/4GB RAM/256GB SSD/MX330 2G/15.6 inch FHD/Win 10/Đen)', 42, 3, 11000000, 5, 12, 'CPU: Intel Core i3 1005G1\nRAM: 4GB\nỔ cứng: 256GB SSD\nVGA: MX330 2G\nMàn hình: 15.6 inch FHD\nHĐH: Win 10\nMàu: Đen', 0, 0, '2021-05-24 04:02:20', 2, NULL, NULL),
(83, 'Laptop LG Gram 17Z90N-G.AH78A5 (i7 1165G7/16GB RAM/1TB SSD/17 inch WQXGA/Win10/Đen) (2021)', 4, 3, 46800000, 5, 12, 'Màn hình 17” IPS tỷ lệ 16:10, độ phân giải WQXGA (2560x1600)\nBộ vi xử lí Intel® Core™ thế hệ thứ 11\nTrọng lượng 1,350g trong thân máy 15,6”\nPin 80Wh (lên tới 17h)\nThunderbolt™ 4, Cảm biến vân tay', 14, 0, '2021-05-24 04:05:08', 2, NULL, NULL),
(84, 'Laptop Dell Inspiron 7490 (6RKVN1) (i7 10510U/16GB RAM/512GB SSD/14 inch FHD/MX250 2GB/Win 10/Bạc)', 1, 3, 29120000, 5, 12, 'CPU: Intel Core i7 10510U\nRAM: 16GB RAM\nỔ cứng: 512GB SSD\nVGA: NVIDIA MX250 2GB\nMàn hình: 14\" FHD\nHệ điều hành: Win 10\nMàu sắc: Bạc', 0, 0, '2021-05-24 04:07:46', 2, NULL, NULL),
(85, 'Apple Macbook Pro 16 Touch Bar (MVVJ2SA/A) (i7 2.6Ghz/16GB RAM/512GB SSD/16.0/Radeon 5300M 4G/ 16.0/Mac OS/Xám) (2019)', 3, 3, 52000000, 5, 12, 'CPU: Intel Core i7 2.6Ghz\nRAM: 16GB RAM\nỔ cứng: 512GB SSD\nVGA: AMD Radeon 5300M 4G\nMàn hình: 16-inch\nHệ điều hành: Mac OS\nMàu sắc: Xám', 0, 0, '2021-05-24 04:11:09', 2, NULL, NULL),
(86, 'Apple Macbook Air 13 (MVH22) (i5 1.1Ghz/8GB /512GB SSD/13.3 inch IPS/MacOS/Xám) (2020)', 3, 3, 29120000, 5, 12, 'CPU: Intel Core i5 1.1Ghz\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 13.3 inch FHD\nBàn phím: có đèn led\nHĐH: Mac OS\nMàu: Xám', 0, 0, '2021-05-24 04:12:33', 2, NULL, NULL),
(87, 'Apple Macbook Air 13 (MVH52) (i5 1.1Ghz/8GB /512GB SSD/13.3 inch IPS/MacOS/Vàng) (2020)', 3, 3, 29120000, 5, 12, 'CPU: Intel Core i5 1.1Ghz\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Onboard\nMàn hình: 13.3 inch FHD\nBàn phím: có đèn led\nHĐH: Mac OS\nMàu: Vàng', 0, 0, '2021-05-24 04:15:34', 2, NULL, NULL),
(88, 'Laptop Lenovo Thinkpad E15 (20RDS0DU00) (i7 10510U/8GB RAM/512GB SSD/RX640 2GB/15.6 FHD/Dos/Đen)', 43, 3, 18900000, 5, 12, 'CPU: Intel Core i7 10510U\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Radeon RX640 2GB\nMàn hình: 15.6 inch FHD\nHĐH: Dos\nMàu: Đen', 0, 0, '2021-05-24 04:28:29', 2, NULL, NULL),
(89, 'Laptop Lenovo Legion 5-15IMH05 (82AU004XVN) (i5 10300H/8GB RAM/512GB SSD/15.6 FHD/GTX1650 4G/Win/Đen', 43, 3, 19950000, 5, 12, 'CPU: Intel Core i5 10300H\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: Nvidia GTX1650 4G\nMàn hình: 15.6 inch FHD\nHĐH: Win 10\nMàu: Đen', 0, 0, '2021-05-24 04:30:24', 2, NULL, NULL),
(90, 'Laptop Lenovo Gaming 3-15IMH05 (81Y4006SVN) (i5 10300H/8GB RAM/512GB SSD/15.6 FHD/GTX1650 4G/Win/Đen', 43, 3, 17850000, 5, 24, 'CPU: Intel Core i5 10300H\nRAM: 8GB\nỔ cứng: 512GB SSD\nVGA: GTX1650 4G\nMàn hình: 15.6 inch FHD\nHĐH: Win 10\nMàu: Đen', 0, 0, '2021-05-24 04:31:45', 2, NULL, NULL),
(91, 'Mainboard ASROCK B560M STEEL LEGEND (Intel B560, Socket 1200, m-ATX, 4 khe Ram DDR4)', 16, 9, 3335000, 10, 36, 'Bo mạch chủ tầm trung socket LGA 1200\nChipset Intel B560\nKích thước: M-ATX\nSố khe RAM: 4', 0, 0, '2021-05-24 04:50:13', 2, NULL, NULL),
(92, 'Mainboard MSI MPG X570 GAMING EDGE Wifi (AMD X570, Socket AM4, E-ATX, 4 khe RAM DDR4)', 14, 9, 6050000, 10, 36, 'Socket: AM4 hỗ trợ CPU RYZEN 9\nKích thước: ATX\nKhe cắm RAM: 4 khe (Tối đa 128GB)\nKhe cắm mở rộng: 1 x PCI-E X16,1 x PCI-E X4,3 x PCI-E X1\nKhe cắm ổ cứng: 6 x SATAIII, 2 x M.2 SLOT', 0, 0, '2021-05-24 04:54:38', 2, NULL, NULL),
(93, 'Mainboard MSI MPG Z490 GAMING CARBON WIFI (Intel Z490, Socket 1200, ATX, 4 khe RAM DDR4)', 14, 9, 7150000, 10, 36, 'Chuẩn mainboard: ATX\nSocket: 1200, Chipset: Z490\nHỗ trợ RAM: 4 khe DDR4, tối đa 128GB\nLưu trữ: 2 x M.2 NVMe, 6 x SATA 3 6Gb/s\nCổng xuất hình: 1 x HDMI, 1 x Display Port', 0, 0, '2021-05-24 04:57:35', 2, NULL, NULL),
(94, 'Mainboard GIGABYTE Z390 Aorus Master (Intel Z390, Socket 1151, ATX, 4 khe RAM DDR4)', 15, 9, 7700000, 10, 36, 'Socket: LGA1151 hỗ trợ CPU intel thế hệ 8 và 9\nKích thước: ATX\nKhe cắm RAM: 4 khe (Tối đa 64GB)\nKhe cắm mở rộng: 3 x PCIe 3.0 x16, 3 x PCIe 3.0 x1, 1 x M.2 Socket 1\nKhe cắm ổ cứng: 3 x M.2 Socket 3, 6 x SATA 6Gb/s', 0, 0, '2021-05-24 04:59:58', 2, NULL, NULL),
(95, 'Mainboard GIGABYTE Z390 Aorus Ultra (Intel Z390, Socket 1151, ATX, 4 khe RAM DDR4)', 15, 9, 6600000, 10, 36, 'Socket: LGA1151 hỗ trợ CPU intel thế hệ 8 và 9\nKích thước: ATX\nKhe cắm RAM: 4 khe (Tối đa 64GB)\nKhe cắm mở rộng: 3x PCIe 3.0 x16, 3x PCIe 3.0 x1\nKhe cắm ổ cứng: 6 x SATA 6Gb/s, 3x M.2 Socket 3', 1, 0, '2021-05-24 05:01:32', 2, NULL, NULL),
(96, 'RAM Desktop ADATA XPG Spectrix D41 RGB Grey (AX4U300038G16A-DT41) 16GB (2x8GB) 3000MHz', 44, 1, 2400000, 10, 60, 'Dung lượng: 2 x 8GB\nThế hệ: DDR4\nBus: 3000MHz\nLED RGB', 0, 0, '2021-05-25 03:15:22', 2, NULL, NULL),
(97, 'RAM Desktop Adata XPG Spectrix D41 RGB Grey (AX4U300038G16A-ST41) 8GB (1x8GB) DDR4 3000Mhz', 44, 1, 1200000, 10, 24, 'Dòng RAM phát sáng RGB tuyệt đẹp từ Adata\nDung lượng: 8GB\nĐóng gói: 1x8GB\nTốc độ tối đa: 3000MHz', 0, 0, '2021-05-25 03:18:04', 2, NULL, NULL),
(98, 'RAM Desktop CORSAIR Vengeance PRO RGB (CMW16GX4M2D3000C16) 16GB (2x8GB) DDR4 3000MHz', 21, 1, 3105000, 10, 24, 'Dòng sản phẩm cao cấp của Corsair\nDung lượng: 2 x 8GB\nThế hệ: DDR4\nBus: 3000MHz', 0, 0, '2021-05-25 03:20:00', 2, NULL, NULL),
(99, 'RAM Desktop CORSAIR Vengeance PRO RGB (CMW32GX4M2D3000C16) 32GB (2x16GB) DDR4 3000MHz', 21, 1, 5405000, 10, 36, 'Dòng sản phẩm cao cấp của Corsair\nDung lượng: 2 x 8GB\nThế hệ: DDR4\nBus: 3000MHz', 0, 0, '2021-05-25 03:22:01', 2, NULL, NULL),
(100, 'RAM Desktop Gskill Trident Z RGB (F4-3600C18D-64GTZR) 64GB (2x32GB) DDR4 3600MHz', 5, 1, 8470000, 10, 36, 'Dung lượng: 2 x 32GB\nThế hệ: DDR4\nBus: 3600MHz\nLED RGB', 0, 0, '2021-05-25 03:25:14', 2, NULL, NULL),
(101, 'CPU AMD Ryzen 5 3500 (3.6GHz turbo up to 4.1GHz, 6 nhân 6 luồng, 16MB Cache, 65W) - Socket AMD AM4', 17, 8, 4025000, 10, 36, 'CPU Ryzen 5 thế hệ thứ 3 của AMD\n6 nhân & 6 luồng\nXung cơ bản: 3.6 GHz\nXung tối đa (boost): 4.1 GHz\nChạy tốt trên các mainboard socket AM4\nPhù hợp cho nhiều mục đích sử dụng', 0, 0, '2021-05-25 03:33:43', 2, NULL, NULL),
(102, 'CPU AMD Ryzen 5 5600X (3.7 GHz Upto 4.6GHz / 35MB / 6 Cores, 12 Threads / 65W / Socket AM4)', 17, 8, 8470000, 10, 36, 'CPU Ryzen 5 5600X\nKiến trúc Zen 3 mới nhất của AMD\nSố nhân: 6\nSố luồng: 12\nXung nhịp CPU: 3.7 - 4.6Ghz (Boost Clock)\nTDP: 65W', 0, 0, '2021-05-25 03:37:25', 2, NULL, NULL),
(103, 'CPU AMD Ryzen 5 3600 (3.6GHz turbo up to 4.2GHz, 6 nhân 12 luồng, 35MB Cache, 65W) - Socket AMD AM4', 17, 8, 5750000, 10, 36, 'CPU Ryzen thế hệ thứ 3, tiến trình sản xuất 7nm\n6 nhân, 12 luồng, xung nhịp mặc định 3.6 GHz, xung nhịp boost tối đa 4.2 GHz\nHỗ trợ PCI-e 4.0\nCó hỗ trợ ép xung\nĐi kèm tản nhiệt Wraith Stealth', 0, 0, '2021-05-25 03:39:00', 2, NULL, NULL),
(104, 'CPU Intel Core i9-10940X (3.3GHz turbo up to 4.6GHz, 14 nhân, 28 luồng, 19.25 MB Cache, 165W) - Socket Intel LGA 2066)', 18, 8, 21000000, 10, 36, 'CPU Core i thế hệ thứ 10 của Intel\n14 nhân & 28 luồng\nXung cơ bản: 3.3 GHz\nXung tối đa (boost): 4.6 GHz\nChạy tốt trên các mainboard socket 2066\nPhù hợp cho những nhà sáng tạo nội dung', 0, 0, '2021-05-25 03:40:49', 2, NULL, NULL),
(105, 'CPU Intel Core i9-10980XE (3.0GHz turbo up to 4.6Ghz, 18 nhân 36 luồng, 24.75MB Cache, 165W) - Socket Intel LGA 2066', 18, 8, 26000000, 10, 36, 'CPU Core i thế hệ thứ 10 của Intel\n18 nhân & 36 luồng\nXung cơ bản: 3.0 GHz\nXung tối đa (boost): 4.4 GHz\nChạy tốt trên các mainboard socket 2066\nPhù hợp cho những nhà sáng tạo nội dung', 0, 0, '2021-05-25 03:42:12', 2, NULL, NULL),
(106, 'Nguồn FSP Power Supply HYPER M85+ Series Model HA650M Active PFC (80 Plus Bronze/Direct Cable/Micro ATX/Màu Đen)', 20, 11, 1800000, 10, 60, 'Tiêu chuẩn ATX12V V2.4 & EPS12V V2.92\nHiệu suất cao ≥ 85%\nActive PFC ≧ 0,9\nĐạt Chứng nhận 80PLUS® Bronze\nThiết kế đường Single Rail 12V\nTụ điện hoàn toàn của Nhật Bản\nThiết kế mô đun với cáp dẹt\nQuạt 120mm\nBảo vệ hoàn toàn: OCP, OVP, SCP, OPP, OTP\nAn toàn toàn cầu được phê duyệt', 0, 0, '2021-05-25 03:49:53', 2, NULL, NULL),
(107, 'Nguồn Corsair RM Series RM850 - 850W (80 Plus Gold Certified Full Modular/Màu Đen)', 21, 11, 3450000, 10, 120, 'Chứng nhận 80 PLUS Gold: hoạt động hiệu quả , tiết kiệm điện năng, ít tiếng ồn và nhiệt độ mát hơn.\nTự điều chỉnh tiếng ồn khi hoạt động: quạt 135mm với đường cong quạt được tính toán đặc biệt đảm bảo tiếng ồn khi hoạt động được giữ ở mức tối thiểu, ngay cả khi hoạt động tối đa công suất\nSử dụng tụ điện 105 ° C: tụ điện cấp công nghiệp cho hiệu suất cao và hoạt động ổn định\nTương thích với chế độ chờ mới nhất của Microsoft: thời gian thức dậy cực nhanh và hiệu quả tải thấp tốt hơn.\nChế độ quạt Zero RPM: ở mức tải thấp và trung bình Quạt làm mát tắt hoàn toàn cho hoạt động gần như im lặng.', 0, 0, '2021-05-25 03:51:50', 2, NULL, NULL),
(108, 'Nguồn Asus ROG Strix 750W Gold - 750W 80 Plus Gold Full Modular', 2, 11, 3450000, 10, 36, 'Quạt Axial-tech Fan vòng bi kép mát mẻ và bền bỉ\nROG Heatsink giúp làm mát và làm tăng tuổi thọ linh kiện\nHiệu suất đạt chuẩn 80 PLUS GOLD\nSử dụng linh kiện và tụ điện cao cấp đến từ Nhật Bản\nChuẩn Full-Module giúp lắp đặt và đi dây dễ dàng', 0, 0, '2021-05-25 03:53:16', 2, NULL, NULL),
(109, 'Nguồn Jetek P600 600W (Màu Đen/Led RGB )', 19, 11, 1440000, 10, 65, 'Hiệu suất cao lên tới 80%\nThiết kế cấu truc tổ ong, tối ưu luồng gió lưu thông làm mát\nNgõ ra điện áp +12V tăng cường công suất, mở rộng khả năng sử dụng\nQuạt làm mát 12cm đem lại sự yên tĩnh khi hoạt động\nDC to DC Converter\nĐèn led RGB tích hợp độc đáo', 0, 0, '2021-05-25 03:54:24', 2, NULL, NULL),
(110, 'Nguồn Cooler Master V1000 1000W (80 Plus Gold Full Modular/Màu Đen)', 45, 11, 4370000, 10, 60, 'Nguồn Coolermaster V1000 80 plus GOLD có thiết kế cáp hoàn toàn, kết hợp một đầu ra 1000W + 12V duy nhất cung cấp tới 83A.\nChứng nhận 80 PLUS Gold: hiệu suất lên tới 93% @ tải 50%\nQuạt FDB im lặng 135mm cho độ ồn thấp hơn và tuổi thọ dài hơn\nTám đầu nối chân PCI-E 6 + 2 để hỗ trợ GPU cao cấp\n100% tụ điện chất lượng cao của Nhật Bản đảm bảo hiệu suất và độ tin cậy...', 0, 0, '2021-05-25 03:55:53', 2, NULL, NULL),
(111, 'Card màn hình MSI GTX 1660 Super VENTUS XS OC (6GB GDDR6, 192-bit, HDMI+DP)', 14, 10, 13650000, 10, 36, 'Phiên bản GTX 1660 Super đời mới từ MSI\nXung nhân tối đa: 1815 MHz\nBộ nhớ: 6GB GDDR6\nCổng kết nối: DisplayPort x 3 / HDMI x 1\nQuạt TORX Fan 2.0\nHỗ trợ NVIDIA G-SYNC™ và HDR', 0, 0, '2021-05-25 04:01:31', 2, NULL, NULL),
(112, 'Card màn hình LEADTEK GTX 1650 D6 LP (4GB GDDR6, 128-bit, DVI+HDMI+DP)', 46, 10, 8800000, 10, 36, 'Nhân đồ họa: Nvidia GTX 1650\nSố nhân Cuda: 896\nXung nhịp GPU tối đa: 1590 Mhz\nDung lượng VRAM: 4Gb GDDR6', 0, 0, '2021-05-25 04:02:34', 2, NULL, NULL),
(113, 'Card màn hình LEADTEK WINFAST GTX 1660 Super HURRICANE 6G (6GB GDDR6, 192-bit, DVI+HDMI+DP, 1x8-pin)', 46, 10, 14700000, 10, 36, 'Nhân đồ họa Nvidia GTX 1660 Super\nDung lượng bộ nhớ: 6GB GDDR6\nSố nhân CUDA: 1408\nXung GPU tối đa: 1830 Mhz', 0, 0, '2021-05-25 04:04:26', 2, NULL, NULL),
(114, 'Card màn hình INNO3D GTX 1660 Super TWIN X2 (6GB GDDR6, 192-bit, HDMI+DP, 1x8-pin)', 47, 10, 14700000, 10, 36, 'Phiên bản GTX 1660 Super giá rẻ của Inno3D\nXung nhân tối đa: 1785 MHz\nBộ nhớ: 6GB GDDR6\nCổng kết nối: DisplayPort x 3/HDMI 2.0b x 1\nNguồn đề nghị: 450W trở lên', 0, 0, '2021-05-25 04:06:01', 2, NULL, NULL),
(115, 'Card màn hình INNO3D GeForce GTX 1660 TWIN X2 (6GB GDDR6, 192-bit, HDMI+DP, 1x8-pin)', 47, 10, 12600000, 10, 36, 'Phiên bản GTX 1660 giá rẻ của Inno3D\nXung nhân tối đa: 1785 MHz\nBộ nhớ: 6GB GDDR5\nCổng kết nối: DisplayPort x 3/HDMI 2.0b x 1\nĐèn LED RGB\nNguồn đề nghị: 450W trở lên', 0, 0, '2021-05-25 04:06:56', 2, NULL, NULL),
(116, 'Tai nghe Corsair HS35 Stereo Carbon', 21, 13, 960000, 10, 24, 'Tai nghe chơi game giá rẻ Corsair HS35 Stereo\nMàng loa kích cỡ 50mm\nMicro có thể tháo rời\nTích hợp nút chỉnh âm lượng ngay trên phần đệm tai nghe\nTương thích với nhiều nền tảng khác nhau: PC, PS4, XBOX One, Nintendo Switch, Mobile devices', 0, 0, '2021-05-25 04:12:18', 2, NULL, NULL),
(117, 'Tai nghe Gaming Corsair HS50 PRO Stereo Carbon', 21, 13, 1080000, 10, 24, 'Loại tai nghe: HS50 PRO\nMàu: Carbon\nDải tần số: Headphone: 20 – 20.000 Hz, Microphone: 100 – 100.000 Hz\nTrở kháng: Headphone: 32 Ohms @ 1 kHz, Microphone: 2.0k Ohms\nDrivers: 50mm\nJack cắm: 3.5mm\nĐộ nhạy tai nghe: 111dB (+/-3dB)\nMicro: -40dB (+/-3dB)\nTương thích nền tảng: PC/ PS4/ XBOX One/ Nintendo Switch/ Mobile\nChiều dài day cáp: 1.8m', 0, 0, '2021-05-25 04:13:25', 2, NULL, NULL),
(118, 'Tai nghe Kingston HyperX Cloud Revolver S Black (HX-HSCRS-GM/AS)', 12, 13, 3335000, 10, 24, 'Chiếc tai nghe cao cấp nhất của Kingston HyperX\nPhiên bản nâng cấp của Revolver với giả lập âm thanh vòm 7.1\nTrang bị USB Soundcard 7.1, chỉ cần cắm và dùng, không cần cài đặt Driver\nThiết kế dạng đóng, cho khả năng cách âm cao\nKhung thép bền bỉ và cứng cáp nhưng vẫn cho cảm giác đeo thoải mái\nMicrophone có thể được tháo rời thuận tiện\nLà chiếc tai nghe được khuyên dùng bởi các game thủ CS:GO Chuyên Nghiệp', 0, 0, '2021-05-25 04:14:30', 2, NULL, NULL),
(119, 'Tai nghe Razer Kraken Kitty Chroma Quartz RZ04-02980200-R3M1', 48, 13, 4600000, 10, 24, 'Tai nghe Razer Kraken Kitty Chroma\nThiết kế tai mèo độc đáo\nLed RGB Chroma 16.8 triệu màu, bao gồm cả phần tai mèo\nCó thể cắm vào nguồn điện sạc dự phòng để hiện led mà không cần cắm vào PC\nMicro với tính năng lọc ồn\nCông nghệ THX Spatial Audio\nĐệm tai nghe làm mát bằng Gel', 0, 0, '2021-05-25 04:16:40', 2, NULL, NULL),
(120, 'Tai nghe Razer Kraken Multi-Platform Wired Green (RZ04-02830200-R3M1)', 48, 13, 1920000, 10, 24, 'Tai nghe Razer Kraken 2019 Multi-Platform Wired\nTrang bị âm thanh vòm 7.1 cho âm thanh sống động (Chỉ thích hợp với PC)\nHeadband bằng vải và được thiết kế dày hơn để thoải mái hơn\nĐệm tai nghe làm mát bằng Gel, thoải mái khi đeo trong thời gian dài\nChất lượng Micro được cải tiến', 0, 0, '2021-05-25 04:17:53', 2, NULL, NULL),
(121, 'Bàn phím gaming Fuhlen S Subverter RGB Mechanical Blue Switch Black', 27, 14, 1320000, 10, 24, 'Sản phẩm phím cơ mới nhất của hãng Fuhlen\nSử dụng switch quang cơ cho cảm giác gõ hoàn hảo, độ bền lên đến 100 triệu lần nhấn\nTính năng Anti-Ghosting cho phép nhận nhiều phím cùng lúc\nLed RGB 16.8 triệu màu nhiều chế độ tùy chỉnh', 0, 0, '2021-05-25 04:26:54', 2, NULL, NULL),
(122, 'Bàn phím gaming Eblue Mazer EKM737 Mechanical Blue Switchs', 29, 14, 960000, 10, 12, 'Bàn phím Eblue Mazer EKM737\nSwitch JWH Blue tuổi thọ trên 50 triệu lần bấm\nKeycap ABS Doubleshot\nVỏ kim loại\nLed nhiều màu\nTính năng anti-ghosting', 0, 0, '2021-05-25 04:27:44', 2, NULL, NULL),
(123, 'Bàn phím cơ AKKO 3084 World Tour Tokyo Blue Switch', 49, 14, 1320000, 10, 12, 'Bàn phím cơ AKKO 3084 World Tour Tokyo Blue Switch\nModel: 3084 (84 keys)\nKết nối: USB Type C, có thể tháo rời\nHỗ trợ NKRO\nKeycap: 85% PBT\nKeycap custom lấy chủ đạo là màu hồng trắng cùng hoa anh đào, núi Phú sĩ, cá chép và mèo may mắn (biểu tượng của Nhật Bản)\nHỗ trợ multimedia, macro và có thể khóa phím windows\nPhụ kiện: 1 sách hướng dẫn sử dụng + 1 keypuller + 1 cover che bụi + 1 dây cáp USB + keycap tặng kèm', 0, 0, '2021-05-25 04:29:24', 2, NULL, NULL),
(124, 'Bàn phím cơ Akko 3108 V2 OSA Grey Parrot Psittacus Gateron Yellow Switch', 49, 14, 2040000, 10, 12, 'Bàn phím cơ Akko 3108 V2 OSA Grey Parrot Psittacus Gateron Yellow Switch\nModel: 3108 (Fullsize, 108 keys)\nKết nối: USB Type C, có thể tháo rời\nHỗ trợ NKRO\nKeycap: PBT Dye-Subbed, OSA profile\nLoại switch: Gateron\nHỗ trợ multimedia, macro và có thể khóa phím windows\nPhụ kiện: 1 sách hướng dẫn sử dụng + 1 keypuller + 1 cover che bụi + keycap tặng kèm + 1 dây cáp USB', 0, 0, '2021-05-25 04:30:35', 2, NULL, NULL),
(125, 'Bàn phím cơ E-Dra EK387 Pro PBT Cherry Blue switch Đen Xám', 50, 14, 1440000, 10, 24, 'Bàn phím cơ E-Dra EK387 Pro PBT Cherry Blue switch\nThiết kế 87 phím nhỏ gọn\nSử dung switch cherry nổi tiếng của Đức\nKeycap PBT Doubleshot', 0, 0, '2021-05-25 04:32:05', 2, NULL, NULL),
(126, 'Bàn phím cơ E-Dra EK307 Mechanica Gaming', 50, 14, 960000, 10, 24, 'Bàn phím E-Dra EK307\nBàn phím cơ với tính năng chống nước\nSwitch quang cơ cao cấp\nĐộ bền : 80 triệu lần nhấn\nLed nhiều màu\nCó thêm kê tay', 0, 0, '2021-05-25 04:32:47', 2, NULL, NULL),
(127, 'Mouse Cougar Revenger S RGB Pixart 3360', 24, 15, 1080000, 10, 12, '1 trong 2 chú chuột chơi game mới nhất và cao cấp nhất của Cougar\nPhiên bản nhỏ gọn hơn của Cougar Revenger và có giá thành rẻ hơn\nSử dụng mắt cảm biến Pixart 3360 cho độ chính xác và ổn định nhất\nDPI lên tới 12000, tiêu chuẩn của mắt cảm biến Pixart 3360\nThiết kế công thái học thích hợp với kiểu cầm chuột Palm và Clawgrip\nHệ thống led RGB 16,8 triệu màu\nPhù hợp với game thủ có tay Nhỏ + Trung bình\nCác game thủ có bàn tay Lớn vui lòng chọn Cougar Revenger', 0, 0, '2021-05-25 04:36:01', 2, NULL, NULL),
(128, 'Chuột AKKO AG325 Dragon Ball Super-GOKU SSG', 49, 15, 625000, 10, 12, 'Chuột AKKO AG325 Dragon Ball Super-GOKU SSG\nThiết kế đối xứng\nMắt đọc PWM3325\nGiao tiếp USB, dây cáp dài 1,8m\nVỏ nhựa ABS\nCon lăn kim loại CNC\nSwitch Omron (50 triệu lần nhấn)\nSố nút: 6 (có nút riêng set DPI 200 cho game FPS)', 0, 0, '2021-05-25 04:37:06', 2, NULL, NULL),
(129, 'Chuột chơi game AKKO AG325 Bilibili', 49, 15, 500000, 10, 12, 'Chuột chơi game AKKO AG325 Bilibili\nThiết kế đối xứng\nMắt đọc PWM3325\nGiao tiếp USB, dây cáp dài 1,8m\nVỏ nhựa ABS\nCon lăn kim loại CNC\nSwitch Omron (50 triệu lần nhấn)\nSố nút: 6 (có nút riêng set DPI 200 cho game FPS)', 0, 0, '2021-05-25 04:38:09', 2, NULL, NULL),
(130, 'Chuột chơi game Corsair Dark Core Wireless RGB SE', 21, 15, 2530000, 10, 24, 'Chuột chơi game Corsair Dark Core Wireless RGB SE\nMắt cảm biến PixArt 3360\nDPI : 16000DPI\n3 Khả năng kết nối : Có dây / Wireless / Bluetooth\n9 nút có thể lập trình\nThời lượng pin cao lên đến 24 giờ\nTùy chỉnh mọi thứ qua phần mềm Corsair Ultility Engine', 0, 0, '2021-05-25 04:39:23', 2, NULL, NULL),
(131, 'Chuột chơi game Corsair M65 RGB Elite Black', 21, 15, 1320000, 10, 24, 'Phiên bản cao cấp nhất của Corsair M65\nThiết kế đặc biệt với phần đáy nhôm nguyên khối\nHệ thống Led RGB 16,8 triệu màu\nNút bấm Omron với 50 triệu lượt nhấn\nMắt cảm biến Pixart 3391 độc quyền của Corsair\nMột trong những mắt cảm biến độ chính xác cao nhất thế giới\nPhù hợp với nhiều thể loại game khác nhau', 0, 0, '2021-05-25 04:40:25', 2, NULL, NULL),
(132, 'Ổ cứng SSD Adata 512GB GAMMIX S11 Pro PCIe NVMe Gen3x4 (Doc 3500MB/s, Ghi 3000MB/s)- (AGAMMIXS11P-512GT-C)', 44, 2, 2040000, 10, 60, 'Giao diện PCIe Gen3x4\ntốc độ đọc/ghi lên đến 3500/3000Mb/giây\nBộ nhớ 3D NAND Flash thế hệ mới', 0, 0, '2021-05-25 04:43:52', 2, NULL, NULL),
(133, 'Ổ cứng SSD Adata GAMMIX S11 Pro 1TB M.2 2280 PCIe NVMe Gen 3x4 (Đọc 3500MB/s - Ghi 3000MB/s)-(AGAMMIXS11P-1TT-C )', 44, 2, 4025000, 10, 60, 'Giao diện PCIe Gen3x4\ntốc độ đọc/ghi lên đến 3500/3000Mb/giây\nBộ nhớ 3D NAND Flash thế hệ mới', 0, 0, '2021-05-25 04:44:49', 2, NULL, NULL),
(134, 'Ổ cứng SSD Gigabyte AORUS RGB 512GB M.2 2280 PCIe Gen 3x4 (Đọc 3480MB/s - Ghi 2000MB/s) - (GP-ASM2NE2512GTTDR)', 15, 2, 2530000, 10, 36, 'Dung lượng: 512GB\nKích thước: M.2 2280\nKết nối: M.2 NVMe\nNAND: 3D-NAND\nTốc độ đọc / ghi (tối đa): 3480MB/s / 2000MB/s', 0, 0, '2021-05-25 04:47:19', 2, NULL, NULL),
(135, 'Ổ cứng SSD Gigabyte 512GB M.2 2280 PCIe NVMe Gen 3x4 (Đoc 1700MB/s, Ghi 1550MB/s) - (GP-GSM2NE3512GNTD)', 15, 2, 1800000, 10, 36, 'Dung lượng: 512GB\nKích thước: M.2 2280\nKết nối: M.2 NVMe\nTốc độ đọc/ghi (tối đa): 1700MB/s | 1550MB/s', 0, 0, '2021-05-25 04:49:19', 2, NULL, NULL),
(136, 'Ổ cứng SSD Kingston A2000M8 250GB M.2 2280 PCIe NVMe Gen 3x4 (Đọc 2000MB/s - Ghi 1000MB/s) - (SA2000M8/250G', 12, 2, 1200000, 10, 60, 'Dung lượng: 250Gb\nTốc độ đọc: 2200MB/s\nTốc độ ghi: 1000MB/s\nChuẩn giao tiếp: M2 NVMe', 0, 0, '2021-05-25 04:51:14', 2, NULL, NULL),
(137, 'Ổ cứng SSD Kingston A400 120GB 2.5 inch SATA3 (Đọc 500MB/s - Ghi 320MB/s) - (SA400S37/120G)', 12, 2, 625000, 10, 36, 'Dung lượng: 120GB\nKích thước: 2.5\"\nKết nối: SATA 3\nTốc độ đọc / ghi (tối đa): 500MB/s / 320MB/s', 0, 0, '2021-05-25 04:52:18', 2, NULL, NULL),
(138, 'Ổ cứng HDD Seagate Barracuda 2TB 3.5 inch 7200RPM, SATA3 6GB/s, 256MB Cache - (ST2000DM008)', 51, 21, 1800000, 9, 24, 'Dung lượng: 2TB\nTốc độ quay: 7200rpm\nBộ nhớ Cache: 256Mb\nChuẩn giao tiếp: SATA3\nKích thước: 3.5Inch', 0, 0, '2021-05-25 04:57:37', 2, NULL, NULL),
(139, 'Ổ cứng HDD Seagate SkyHawk AI 10TB 3.5 inch 7200RPM, SATA3 6GB/s , 256MB Cache- (ST10000VE0008)', 51, 21, 10450000, 10, 36, 'Ổ cứng chuyên dụng cho các hệ thống Camera\nHỗ trợ hệ thống giám sát tối ưu 24/7\nTrang bị bộ cảm biến duy trì hiệu năng hoạt động\nHỗ trợ phát dẫn ATA\nTiêu thụ điện năng rất thấp', 0, 0, '2021-05-25 04:58:26', 2, NULL, NULL),
(140, 'Ổ cứng Toshiba AV S300 6TB 3.5 inch,7200RPM, Sata 3 6Gb/s,256MB Cache (HDWT360UZSVA)', 52, 21, 4830000, 10, 36, 'HDD Toshiba SURVEILLANCE 6TB/7200 3.5\" Sata 3 -HDWT360UZSVA, Ổ cứng chuyên dụng cho đầu thu. Thế hệ ổ cứng chuyên dụng mới của TSB dành cho các hệ thống camera quan sát được tích hợp công nghệ Advanced Format (AF) giúp tăng tốc độ truy xuất dữ liệu lên rất cao, tốc độ vòng quay nhẹ nhàng nhưng hiệu năng cao nhờ vào cơ chế đọc ghi dữ liệu tiên tiến, và công nghệ giảm độ ồn, chống rung, bảo đảm sự êm ái, tiết kiệm điện năng trong khi điều kiện hiệu suất ấn tượng.', 0, 0, '2021-05-25 04:59:45', 2, NULL, NULL),
(141, 'Ổ cứng HDD Toshiba SURVEILLANCE 10TB 7200RPM 3.5 inch Sata 3 -HDWT31AUZSVA', 52, 21, 8030000, 10, 36, 'Dung lượng: 8Tb\nTốc độ quay: 7200rpm\nBộ nhớ Cache: 256Mb\nChuẩn giao tiếp: SATA3\nKích thước: 3.5Inch', 0, 0, '2021-05-25 05:00:28', 2, NULL, NULL),
(142, 'Ổ cứng HDD Western Caviar Black 1TB 3.5 inch 7200RPM, SATA3 6Gb/s, 64MB Cache', 53, 21, 2160000, 10, 60, 'Ổ cứng SATA 3,5 inch hiệu năng cao WD Caviar Black có tốc độ vòng quay 7200 RPM, bộ nhớ cache 256 MB và giao diện SATA 6 Gb/s cho khả năng điện toán tối ưu.\nKiến trúc điện tử hiệu suất cao có bộ xử lý kép và bộ nhớ cache lớn hơn, nhanh hơn cho tốc độ đọc và ghi tối đa.\nStableTrac Trục động cơ được bảo đảm ở cả hai đầu để giảm rung do hệ thống và ổn định các đĩa để theo dõi chính xác, trong các hoạt động đọc và ghi', 0, 0, '2021-05-25 05:01:27', 2, NULL, NULL),
(143, 'Ổ cứng HDD Western Caviar Black 4TB 3.5 inch 7200RPM, SATA3 6Gb/s, 256MB Cache', 53, 21, 5405000, 10, 60, 'Ổ cứng SATA 3,5 inch hiệu năng cao WD Caviar Black có tốc độ vòng quay 7200 RPM, bộ nhớ cache 256 MB và giao diện SATA 6 Gb/s cho khả năng điện toán tối ưu.\nKiến trúc điện tử hiệu suất cao có bộ xử lý kép và bộ nhớ cache lớn hơn, nhanh hơn cho tốc độ đọc và ghi tối đa.\nStableTrac Trục động cơ được bảo đảm ở cả hai đầu để giảm rung do hệ thống và ổn định các đĩa để theo dõi chính xác, trong các hoạt động đọc và ghi.', 0, 0, '2021-05-25 05:02:18', 2, NULL, NULL),
(144, 'Vỏ Case Corsair  678C TG (Mid Tower/Màu Trắng)', 21, 12, 4600000, 9, 24, 'Thiết kế tối giản và gọn gàng với khung thép, với kính cường lực trong suốt bên cạnh để khoe trọn hệ thống của bạn\nVật liệu cách âm ở mặt hông, phía trước và nóc giúp hệ thống luôn êm ái, hoặc chuyển qua tấm lọc bụi đi kèm ở trên nóc để gia tăng khả năng làm mát\nHỗ trợ đủ khoảng trống cho radiator 360mm với thiết lập hút / đẩy ở mặt trước và trên nóc, radiator 280mm/240mm ở sàn và 140mm/120mm ở phía sau\nHỗ trợ tối đa tới 9 quạt 120mm hoặc 7 quạt 140mm cho khả năng làm mát mạnh mẽ\nĐi kèm bộ điều tốc quạt PWM cho 2 quạt SP140 đi kèm và tối đa 4 quạt mở rộng.', 0, 0, '2021-05-25 05:09:46', 2, NULL, NULL),
(145, 'Vỏ Case Corsair  680X RGB TG (Mid Tower/Màu Đen)', 21, 12, 6160000, 9, 24, '4 Quạt và thiết kế giúp tối ưu đường gió tới các linh kiện cần thiết\nLàm tỏa sáng hệ thống của bạn với tổng cộng 48 bóng đèn từ 3 quạt LL120 RGB đi kèm\nHub Corsair Lightning Node PRO biến 680X RGB thành chiếc vỏ case thông minh, bằng phần mềm iCUE mang tới khả năng điều khiển LED đồng bộ toàn hệ thống với các thành phần khác tương thích sử dụng chung Corsair iCUE, bao gồm quạt, đèn led, Ram, bàn phím, chuột, v.v....\nThiết kế 2 khoang giúp dễ dàng lắp đặt hệ thống và giấu dây gọn gàng', 0, 0, '2021-05-25 05:10:43', 2, NULL, NULL),
(146, 'Vỏ Case Phanteks Eclipse P300 Tempered Glass (Mid Tower/Màu Đen) PH-EC300PTG_BK', 55, 12, 1440000, 10, 24, 'Đi kèm đầy đủ lọc bụi\nHỗ trợ GPU dài tối đa 330mm\nHỗ trợ nguồn kích cỡ tiêu chuẩn\nĐi kèm 1 x Quạt Phanteks 120mm\nĐèn led RGB và Led gầm 10 màu\nCác chế độ RGB có thể đồng bộ với mainboard hỗ trợ\nTối ưu luồng gió\n2 x khay HDD cắm từ phía trước\nHỗ trợ tối đa radiaotor 240/280mm mặt trước\n2 vị trí gắn SSD ( đi kèm 1 khay )', 0, 0, '2021-05-25 05:11:46', 2, NULL, NULL),
(147, 'Vỏ Case Phanteks Enthoo Evolv Shift Air Fabric Mesh Panel Satin (Mini Tower/Màu Đen) PH-ES217A_BK', 55, 12, 2400000, 10, 24, 'Có thể đặt nhiều tư thế khác nhau\nLắp đặt dễ dàng\nMặt lưới 2 bên đem tới lượng gió cao\nĐi kèm 2 quạt Phanteks 140mm cao cấp\nHỗ trợ khu vực đi dây gọn gàng\nHỗ trợ dựng dọc GPU chiều dài tối đa tới 350mm\nHỗ trợ lưu trữ đa dạng ( tối đa 1 x 3.5\" HDD và 3 x 2.5\" SSD )\nKhu vực cổng I/O dễ dàng sử dụng\nĐèn led RGB tích hợp\nĐi kèm Riser PCI-e x16\nHỗ trợ tản nhiệt nươc\nHỗ trợ radiator 120mm\nĐi kèm khay gắn bơm', 0, 0, '2021-05-25 05:12:53', 2, NULL, NULL),
(148, 'Vỏ Case Thermaltake View 37   (Mid Tower/Màu Đen/Led RGB Edition)', 54, 12, 3450000, 10, 24, 'Hỗ trợ 2 quạt\nlắp ráp dễ dàng\nmàu: Đen', 0, 0, '2021-05-25 05:15:24', 2, NULL, NULL),
(149, 'Vỏ Case Thermaltake Level 20 GT RGB Plus Edition (Full Tower/Màu Đen/Ghi)', 54, 12, 6160000, 10, 24, 'Full Tower\nMàu đen', 0, 0, '2021-05-25 05:16:27', 2, NULL, NULL),
(150, 'Màn hình Asus VG279Q (27 inch/FHD/IPS/144Hz/1ms/400cd/m²/DP+HDMI+DVI/Loa 2x2w)', 2, 16, 7260000, 8, 36, 'Kích thước 27 inch\nĐộ phân giải 1920 x 1080\nTấm nền IPS\nBề mặt hiển thị Chống lóa 3H\nTốc độ làm tươi 144Hz\nThời gian đáp ứng 1 ms (MPRT) hoặc 3ms (GTG)\nĐộ sáng (nits) 400 cd / m2\nGóc nhìn 178°/178°\nTỷ lệ khung hình 16:9\nTương phản (tối đa) 1000:1 (Typical)', 0, 0, '2021-05-25 09:04:00', 2, NULL, NULL),
(151, 'Màn hình Asus ROG XG258Q (24.5 inch/FHD/240Hz/1ms/400 cd/m²/DP+HDMI/G-SYNC/Compatible/FreeSync/Full HD/Aura RGB)', 2, 16, 9900000, 10, 36, 'Kích thước 24.5 inch\nĐộ phân giải 1920 x 1080\nTấm nền TN\nBề mặt hiển thị Chống lóa 3H\nTốc độ làm tươi 240Hz\nThời gian đáp ứng 1 ms (GTG)\nĐộ sáng (nits) 400 cd / m2\nGóc nhìn 170°/160°\nTỷ lệ khung hình 16:9\nTương phản (tối đa) 1000:1 (Typical)', 0, 0, '2021-05-25 09:06:42', 2, NULL, NULL),
(152, 'Màn hình Dell 23.8 inch U2414H Ultrasharp', 1, 16, 5175000, 8, 36, 'Chủng loại U2414H\nKích Thước Màn Hình 23.8\" Ultrasharp IPS LED\nĐộ Sáng Màn Hình 250 cd/m² (Điển hình)\nTỉ Lệ Tương Phản Tĩnh 1.000:1,: 2 Million:1 (Max) (Dynamic Contrast Ratio)\nĐộ Phân Giải Màn Hình 1920 x 1080\nThời Gian Đáp Ứng 8 ms\nHỗ trợ màu 16.7 million colors\nGóc nhìn 178/178', 0, 0, '2021-05-25 09:09:19', 2, NULL, NULL),
(153, 'Màn hình Dell Ultrasharp U2419H (23.8 inch/FHD/IPS/DP+HDMI/250cd/m²/60Hz/8ms)', 1, 16, 5940000, 10, 36, 'Kích Thước Màn Hình 23.8 INCH\nĐộ Sáng Màn Hình 250 cd/m²\nTỉ Lệ Tương Phản Động MEGA 1000:1\nĐộ Phân Giải Màn Hình Full HD 1920x1080 60 Hz\nThời Gian Đáp Ứng 5 ms\nHỗ trợ màu 16.7 million colours\nGóc nhìn 178/178\nKết nối đa màn hình nối tiếp Daisy Chain', 0, 0, '2021-05-25 09:11:13', 2, NULL, NULL),
(154, 'Màn hình Samsung LC24F390FHEXXV (24 inch/FHD/LED/PLS/250cd/m²/HDMI+VGA/60Hz/5ms/Màn hình cong)', 56, 16, 3910000, 9, 36, 'Kích thước màn hình: 24\"\nTấm nền - Panel: VA\nĐộ phân giải: 1920 x 1080\nTốc độ phản hồi: 4ms\nCổng kết nối: VGA, HDMI\nTốc độ làm mới: 60Hz', 0, 0, '2021-05-25 09:13:09', 2, NULL, NULL),
(155, 'Màn hình Samsung LC27F390FHEXXV (27 inch/FHD/LED/PLS/250cd/m²/HDMI+VGA/60Hz/5ms/Màn hình cong)', 56, 16, 5940000, 10, 36, 'Loại màn hình: LED Full HD Cong\nKích thước: 27inch\nĐộ phân giải: 1920 x 1080 pixels\nĐộ tương phản: Mega\nKết nối: VGA, HDMI', 0, 0, '2021-05-25 09:30:38', 2, NULL, NULL),
(156, 'Loa Logitech Z906 - 5.1', 26, 17, 6600000, 10, 12, 'Thiết Kế: Hệ Thống Loa 5.1\nKết Nối: Jack 3.5mm (headphone) / Jack 3.5mm (input) / RCA (input) / Jack 3.5 (surround input) / Coaxial (input) / Optical (input) / Push Ternminal (output)\nChức Năng: Volume Control / Bass Control / 2.1 Mode / 4.1 Mode / 3D Mode / DTS Interative / Dolby Digital / THX / Loa treo tường được\nCông Suất: 500W RMS\nCông suất loa trầm: 165W\nCông suất loa vệ tinh: 5x67W', 0, 0, '2021-05-25 09:35:42', 2, NULL, NULL),
(157, 'Loa Logitech Z313 - 2.1', 26, 17, 660000, 10, 24, 'Thiết Kế: Hệ Thống Loa 2.1\nKết Nối: Jack 3.5mm (headphone) / Jack 3.5mm (input) / Jack 3.5mm (output)\nChức Năng: Volume Control\nCông Suất: 25W RMS', 0, 0, '2021-05-25 09:37:07', 2, NULL, NULL),
(158, 'Loa Edifier M1380 - 2.1', 59, 17, 1200000, 10, 12, 'Tổng công suất đầu ra: 28W (8W x 2 + 12W )\nĐộ ồn : ≥ 85dBA\nTần số đáp ứng: Vệ tinh: 140Hz - 20KHz | Loa siêu trầm: 20Hz - 130Hz\nĐộ nhạy đầu vào: Vệ tinh: 450mV ± 50mV | Loa siêu trầm: 70mV ± 20mV\nTrở kháng đầu vào: 10KΩ\nKết nối : 3,5 mm , Headphone jack 3.5mm\nLoa siêu trầm / Bass: 5 inch (131mm) từ trường bảo vệ, 4Ω\nKích thước (WxHxD): Vệ tinh: 120 x 151 x 125mm | Loa Sub: 164 x 220 x 280 mm\nTrọng lượng: 4.20Kg (Net) / 5.20Kg (Gross)', 0, 0, '2021-05-25 09:39:29', 2, NULL, NULL),
(159, 'Loa Edifier R1700BT 2.0', 59, 17, 2400000, 10, 12, 'Đầu vào RCA kép để kết nối với nhiều nguồn âm thanh\nHỗ trợ phát nhạc không dây Bluetooth\nĐiều khiển từ xa không dây tiện lợi', 0, 0, '2021-05-25 09:40:28', 2, NULL, NULL),
(160, 'Loa SoundMax A4000 - 4.1', 58, 17, 960000, 10, 12, 'Tổng công suất: 60W\nBộ sản phẩm: 1 loa trầm, 4 loa vệ tinh\nCống suất loa siêu trầm: 20W\nCông suất loa vệ tinh: 10W\nKích thước loa siêu trầm: 265 x 295 x 170 mm.\nKích thước loa vệ tinh: 106 x 92 x 171 mm.\nBộ sản phẩm: 1 loa trầm, 4 loa vệ tinh\nJack kết nối: RCA\nKhe cắm thẻ nhớ SD/USB: Không\nTrọng lượng: 5kg', 0, 0, '2021-05-25 09:41:07', 2, NULL, NULL),
(161, 'Loa SoundMax A820 - 2.1', 58, 17, 625000, 10, 12, 'Model: A820\nMàu sắc: Xám\nNhà sản xuất: Soundmax\nHệ thống loa: 2.1 kênh\nCông suất: 25 W\nCông suất loa trầm: 15 Watt\nCông suất loa vệ tinh: 2 x 5 Watt\nTín hiệu ngõ vào: Jack RCA\nCông suất loa trung tâm: Không\nTín hiệu ngõ ra: Terminal', 0, 0, '2021-05-25 09:42:06', 2, NULL, NULL),
(162, 'Ghế Game Corsair T3 RUSH Charcoal', 21, 18, 6050000, 10, 24, 'Corsair T3 RUSH Charcoal\nGhế chơi game đến từ thương hiệu nổi tiếng Corsair\nBề mặt lưng và đệm ngồi được làm từ vải mềm thoáng khí, bên trong là đệm xốp lạnh nguyên khối cho độ đàn hồi cao\nTay ghế : 4D\nTrụ thuỷ lực : Class 4, trọng tải lên đến 120kg\nĐộ ngả : 90-180 độ\nKhung được cấu tạo từ kim loại chắc chắn', 0, 0, '2021-05-25 09:44:34', 2, NULL, NULL),
(163, 'Ghế Game Corsair T3 RUSH Gray-White', 21, 18, 6050000, 10, 24, 'Corsair T3 RUSH\nGhế chơi game đến từ thương hiệu nổi tiếng Corsair\nBề mặt lưng và đệm ngồi được làm từ vải mềm thoáng khí, bên trong là đệm xốp lạnh nguyên khối cho độ đàn hồi cao\nTay ghế : 4D\nTrụ thuỷ lực : Class 4, trọng tải lên đến 120kg\nĐộ ngả : 90-180 độ\nKhung được cấu tạo từ kim loại chắc chắn', 0, 0, '2021-05-25 09:45:24', 2, NULL, NULL),
(164, 'Ghế Game MSI MAG CH120', 14, 18, 6050000, 10, 12, 'Ghế Game MSI MAG CH120\nGhế Gaming đến từ thương hiệu nổi tiếng MSI\nKhung thép hoàn chỉnh\nTựa lưng ngả lên tới 180 °\nTay vịn và ghế có thể điều chỉnh đa năng 4D\nTrụ thuỷ lực Class 4\nThiết kế chân ghế thép hình sao 5 cánh\nDa PU cực kỳ mịn và yên tĩnh\nGối tựa đầu và đệm sau lưng', 0, 0, '2021-05-25 09:46:33', 2, NULL, NULL),
(165, 'Ghế Game MSI MAG CH120X', 14, 18, 6160000, 10, 12, 'Ghế Game MSI MAG CH120X\nGhế Gaming đến từ thương hiệu nổi tiếng MSI\nKhung thép hoàn chỉnh\nTựa lưng ngả lên tới 180 °\nTay vịn và ghế có thể điều chỉnh đa năng 4D\nTrụ thuỷ lực Class 4\nThiết kế chân ghế thép hình sao 5 cánh\nDa PU cực kỳ mịn và yên tĩnh\nBánh xe khoá 72mm\nGối tựa đầu và đệm sau lưng', 0, 0, '2021-05-25 09:47:22', 2, NULL, NULL),
(166, 'Ghế Chơi Game E-Dra Citizen Black/Black (EGC200)', 50, 18, 2400000, 10, 12, 'Citizen Gaming chair EGC200 Ghế cao cấp dành cho Game\nChất liệu: Da cao cấp PU dễ dàng lau chùi sạch sẽ, tựa lưng dạng lưới chịu lực cao cấp.\nGóc đứng: 92° ± 2° Góc nằm max: 150°\nĐiều chỉnh độ cao: 90 ± 5mm\nGóc quay điểm tựa tay: Độ cao của điểm tựa tay: 70 mm\nĐường kính chân: 60cm\nTrọng tải theo góc đứng: 120kg Khung chân:\nKhung, chân nhựa, bánh xe được thiết kế ko gây tiếng ồn.\nKích thước: 1250x530x670mm', 0, 0, '2021-05-25 09:48:13', 2, NULL, NULL),
(167, 'Ghế gamer E-Dra Hercules EGC203 V2', 50, 18, 4025000, 10, 12, 'Ghế gaming giá tốt cho game thủ\nBọc da PU bền bỉ, dễ dàng vệ sinh\nTựa lưng dạng lưới chịu lực cao cấp\nTrang trí các đường viền nhung sang trọng\nNâng hạ 92° ± 2°\nNgả lưng tối đa 180°', 0, 0, '2021-05-25 09:49:03', 2, NULL, NULL),
(168, 'Fan Case CoolerMaster MasterFan MF120 Halo 3in1', 45, 19, 960000, 10, 12, 'Hệ thống đèn LED Dual Loop ARGB Lighting\nCông nghệ làm mát yên lặng\nThiết kế cánh quạt lai\nKhả năng tương thích cao\nĐiều khiển ARGB có dây\n999.000₫ 1.399.00', 0, 0, '2021-05-25 09:54:00', 2, NULL, NULL),
(169, 'Fan Case CoolerMaster MasterFan MF120 Halo Duo Ring', 45, 19, 187500, 10, 12, 'Hệ thống đèn LED Dual Loop ARGB Lighting\nCông nghệ làm mát yên lặng\nThiết kế cánh quạt lai\nKhả năng tương thích cao\nCảm biến chống kẹt cánh quạ', 0, 0, '2021-05-25 09:54:51', 2, NULL, NULL),
(170, 'Fan Case Corsair LL120 RGB 120mm Dual Light Loop RGB LED 3 Fan Pack with Lighting Node PRO', 21, 19, 2875000, 10, 24, 'Fan RGB led ring độc đáo, tuỳ chỉnh 16.8 triệu màu\nSố vòng quay: 600 RPM - 1500 RPM\nThiết kế phù hợp với mọi loại case\nKích thước quạt: 120mm x 25mm', 0, 0, '2021-05-25 09:55:42', 2, NULL, NULL),
(171, 'Bộ 3 quạt máy tính 120mm Corsair QL120 RGB kèm Node CORE - NEW (CO-9050098-WW)', 21, 19, 3450000, 10, 24, 'Kích thước: 120 x 120 x 25mm\nTốc độ quạt: 1500 +/- 10% RPM\nLưu lượng gió: 41.8 CFM\nĐộ ồn: 26 dbA\nĐèn LED: RGB', 37, 0, '2021-05-25 09:57:03', 2, NULL, NULL),
(172, 'EK-Furious Vardar EVO 120 BB (750-3000rpm)', 60, 19, 625000, 10, 12, 'EK-Furious Vardar EVO 120 BB là quạt tản nhiệt nước chuyên dụng, kếp hợp hiệu quả với các sản phẩm EKWB', 3, 0, '2021-05-25 09:58:04', 2, NULL, NULL),
(173, 'EK-Vardar X3M 120ER D-RGB (500-2200rpm) - Black', 60, 19, 960000, 10, 12, 'Mẫu quạt hiệu năng cao, đặc biệt phù hợp để cho các giải pháp tản nhiệt của những bộ máy hàng đầu\nPhiên bản mới nâng cấp lên LED D-RGB 5v cùng khả năng đồng bộ màu với mainboard\nCánh quạt được thiết kế lại đem tới luồn gió tập trung và tăng cường áp suất gió\nTrục trang bị vòng bi kép đem tới tuổi thọ vượt trội so với các loại trục dầu thông thường, đặc biệt trong môi trường nhiệt độ cao', 0, 0, '2021-05-25 09:59:00', 2, NULL, NULL);
INSERT INTO `product` (`product_id`, `product_name`, `trademark_id`, `product_type_id`, `price`, `amount`, `warranty`, `description`, `view`, `rate`, `created_at`, `createdBy`, `updatedDate`, `updatedBy`) VALUES
(174, 'Tản nhiệt nước CPU AIO GIGABYTE AORUS WATER FORCE X 360', 15, 20, 7700000, 10, 36, 'Tản Nhiệt AORUS WATERFORCE X\nHiệu năng vượt trội với ống tản dung lịch lớn hơn 37%\nMàn hình LCD hiển thị video & ảnh Gif\nThiết kế quạt AORUS RGB hoàn toàn mới\nCover bơm với khả năng xoay 330 độ, linh hoạt với nhiều loại thùng máy\nHỗ trợ thẻ nhớ Micro SD cắm ngay trên tản nhiệt', 0, 0, '2021-05-25 10:01:00', 2, NULL, NULL),
(175, 'Tản nhiệt nước CPU AIO GIGABYTE AORUS WATERFORCE X 240', 15, 20, 6270000, 10, 36, 'Tản Nhiệt AORUS WATERFORCE X\nHiệu năng vượt trội với ống tản dung lịch lớn hơn 37%\nMàn hình LCD hiển thị video & ảnh Gif\nThiết kế quạt AORUS RGB hoàn toàn mới\nCover bơm với khả ăng xoay 330 độ, linh hoạt với nhiều loại thùng máy\nHỗ trợ thẻ nhớ Micro SD cắm ngay trên tản nhiệt', 0, 0, '2021-05-25 10:02:12', 2, NULL, NULL),
(176, 'Tản nhiệt nước ASUS ROG STRIX LC 360 RGB GUNDAM', 2, 20, 7480000, 10, 60, 'Tản nhiệt nước ROG STRIX LC 360 RGB GUNDAM EDITION phiên bản đặc biệt lấy cảm hứng từ Gundam RX-78-2\nHệ thống két làm mát cùng quạt tản nhiệt ROG được thiết kế nhằm mang lại lưu lượng gió và áp suất tĩnh tối ưu\nLED RGB và vỏ bơm mạ NCVM làm nổi bật vẻ đẹp, hiện đại\nĐược thiết kế tinh tế giúp tăng tính thẩm mĩ cho bo mạch chủ và bên trong của case\nỐng dẫn được bọc ngoài giúp nâng cao tuổi thọ và hoạt động bền bỉ trong thời gian dài', 0, 0, '2021-05-25 10:03:11', 2, NULL, NULL),
(177, 'Tản nhiệt nước Asus ROG STRIX LC 360 RGB', 2, 20, 792000, 20, 60, 'Bảo hành vượt trội lên đến 5 năm\nPhiên bản 3 fan giúp nâng cao hiệu năng tản nhiệt cho CPU\nĐồng bộ led RGB với main board bằng phần mềm AURA SYNC\nFAN 120mm ROG độc quyền do ASUS thiết kế\nBề mặt Pump hiển thị logo ROG với led RGB chế độ\nBề mặt đồng tản nhiệt tối ưu nhất\nMáy bơm công suất cao, tối ưu cho việc lưu thông dòng chảy\nỐng dẫn được bọc dù bền bỉ theo thời gian\nHỗ trợ đa dạng socket CPU từ INTEL và AMD', 0, 0, '2021-05-25 10:05:51', 2, NULL, NULL),
(178, 'Tản nhiệt nước Corsair Hydro Series H100i RGB PLATINUM SE', 21, 20, 3680000, 10, 24, 'Hai quạt RGB CORSAIR LL120RGB White, cung cấp tới 16 hiệu ứng chuyển màu, tăng cường lượng gió thổi\nPhiên bản SE đem tới màu trắng sáng, thể hiện phong cách cũng như tông màu đặc biệt\nPhần bơm và block tích hợp RGB nhiều khu vực\nChế độ Zero RPM Mode hoàn toàn yên tĩnh khi tạm dừng quạt ở mức nhiệt độ CPU thấp\nPhần mềm iCUE tuỳ chỉnh thông minh toàn bộ tốc độ cũng như màu sắc của hệ thống\nBlock và bơm thiết kế hạn chế tối đa tiếng ồn mà vẫn đạt hiệu suất ấn tượng\nRadiator 240mm mở rộng bề mặt làm mát và hiệu quả giải nhiệt\nDễ dàng lắp đặt', 0, 0, '2021-05-25 10:06:35', 2, NULL, NULL),
(179, 'Tản nhiệt nước Corsair Hydro Series H100i RGB PLATINUM', 21, 20, 4600000, 10, 24, 'Đẹp\nDễ dàng lắp đặt', 0, 0, '2021-05-25 10:07:30', 2, NULL, NULL);

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
,`warranty` int(11)
,`description` text
,`trademark_name` varchar(255)
,`product_type_name` varchar(255)
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
(40, 44, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/250_40795_keyboard_eblue_eblue_ekm_757bgus_iu_usb_black_0002_3.jpg?alt=media&token=8fec233e-7744-4b28-937f-a10d8a602d93'),
(60, 44, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2F250_40795_keyboard_eblue_eblue_ekm_757bgus_iu_usb_black_0002_3.jpg?alt=media&token=6f0e0476-bb94-46f3-97c0-49de01ca06bd'),
(61, 44, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2F40795_keyboard_eblue_eblue_ekm_757bgus_iu_usb_black_01.jpg?alt=media&token=8928a4db-fb1c-4c5b-ab71-b2aeb82343e0'),
(62, 44, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2F40795_keyboard_eblue_eblue_ekm_757bgus_iu_usb_black_0000_1.jpg?alt=media&token=0e8d91bd-9409-4050-9859-bfd5e1af26fb'),
(92, 1, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52019_laptop_lg_gram_14zd90n_v_ax55a5_i5_1035g7_8gb_ram_512gb_ssd_14_0_inch_fhd_fp_xam_%20(1).jpg?alt=media&token=7feab252-a98c-48c5-9aa7-15103d33be04'),
(93, 1, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F120_52019_laptop_lg_gram_14zd90n_v_ax55a5_i5_1035g7_8gb_ram_512gb_ssd_14_0_inch_fhd_fp_xam_.png?alt=media&token=3b8ac626-ce60-4922-aa27-62f3e42ca9e8'),
(94, 1, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52019_laptop_lg_gram_14zd90n_v_ax55a5_i5_1035g7_8gb_ram_512gb_ssd_14_0_inch_fhd_fp_xam_bac_.jpg?alt=media&token=ccaf8961-18f4-40bf-a032-22a099da87e9'),
(95, 1, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52019_laptop_lg_gram_14zd90n_v_ax55a5_i5_1035g7_8gb_ram_512gb_ssd_14_0_inch_fhd_fp_xam_%20(2).jpg?alt=media&token=916548b7-ac6e-445c-acfd-c14bde0c551d'),
(96, 1, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52019_laptop_lg_gram_14zd90n_v_ax55a5_i5_1035g7_8gb_ram_512gb_ssd_14_0_inch_fhd_fp_xam_bac_model_2020_7.jpg?alt=media&token=2299d8e2-51d2-4628-a5f7-633b'),
(97, 81, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53839_laptop_acer_gaming_nitro_5_an515_55_5923_nhq7nsv004_5.jpg?alt=media&token=3f639907-67cc-4371-85e5-bfc83e9d37e6'),
(98, 81, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53839_laptop_acer_gaming_nitro_5_an515_55_5923_nhq7nsv004_6.jpg?alt=media&token=c741458e-9da2-40cc-89ae-63b3360a5830'),
(99, 81, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53839_laptop_acer_gaming_nitro_5_an515_55_5923_nhq7nsv004_7.jpg?alt=media&token=7ad8a692-70de-4711-8524-243b24d0739b'),
(100, 81, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53839_laptop_acer_gaming_nitro_5_an515_55_5923_nhq7nsv004_8.jpg?alt=media&token=ae716d87-1de3-4c1e-9f94-62fe9cbb43db'),
(101, 81, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53839_laptop_acer_gaming_nitro_5_an515_55_5923_nhq7nsv004_4.jpg?alt=media&token=b0ea05ed-cf7d-43e1-837d-8f394f0b91ce'),
(102, 82, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57436_aspire_3_a315_57g_wp_black__5_.jpg?alt=media&token=73ad2547-6a52-46a9-9eb7-077cc61db47f'),
(103, 82, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57436_aspire_3_a315_57g_wp_black__3_.jpg?alt=media&token=92d393f0-1094-48dd-a66c-938dd85701cf'),
(104, 82, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57436_aspire_3_a315_57g_wp_black__1_.jpg?alt=media&token=84120391-3083-44ce-8d96-ea683b8a60d8'),
(105, 82, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57436_aspire_3_a315_57g_wp_black__4_.jpg?alt=media&token=a9a317b0-66e3-4a2c-a4e6-76f5d291a3f3'),
(106, 82, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57436_aspire_3_a315_57g_wp_black__2_.jpg?alt=media&token=c3303643-6ab9-4f85-80c0-40eb66ca1c1c'),
(107, 83, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58921_17z90p_g_ah78a5.jpg?alt=media&token=0ef06b1c-3e8e-458e-8c51-64b5835bfe86'),
(108, 83, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F120_58921_laptop_lg_gram_17z90n_g_ah78a5_den_2021_6.jpg?alt=media&token=6d597ca2-b056-4f00-88fb-816c42ffbfc7'),
(109, 83, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58921_laptop_lg_gram_17z90n_g_ah78a5_den_2021_9.jpg?alt=media&token=ffa2b17d-2d08-4728-a3af-7cbc2f56783f'),
(110, 83, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58921_laptop_lg_gram_17z90n_g_ah78a5_den_2021_7.jpg?alt=media&token=b9813a5e-9ff7-47c5-afd0-ffe690f46817'),
(111, 83, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58921_laptop_lg_gram_17z90n_g_ah78a5_den_2021_8.jpg?alt=media&token=7676f7f6-98d0-4d8e-8d86-4a71d7dbec4c'),
(112, 84, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F120_50989_laptop_dell_inspiron_7490_6rkvn1_i7_10510u_16gb_ram_512gb_ssd_14_fhd_mx250_%20(1).png?alt=media&token=bab2cda1-9ec9-464c-945b-6330659d5a2c'),
(113, 84, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50989_laptop_dell_inspiron_7490_6rkvn1_i7_10510u_16gb_ram_512gb_ssd_14_fhd_mx250_2gb_win_10_bac_10.jpg?alt=media&token=ee1e306a-d136-4ef0-bf03-57ee5a5ad'),
(114, 84, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F120_50989_laptop_dell_inspiron_7490_6rkvn1_i7_10510u_16gb_ram_512gb_ssd_14_fhd_mx250_2gb_.png?alt=media&token=69e4be17-a6f3-40c0-8ce3-4ac8ae5081e5'),
(115, 84, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50989_laptop_dell_inspiron_7490_6rkvn1_i7_10510u_16gb_ram_512gb_ssd_14_fhd_mx250_2gb_win.jpeg?alt=media&token=0fdc9202-8c7e-4063-b46c-187ec610696c'),
(116, 84, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50989_laptop_dell_inspiron_7490_6rkvn1_i7_10510u_16gb_ram_512gb_ssd_14_fhd_mx250_2gb_win_.png?alt=media&token=a8a49ee1-c556-41a8-a968-74283fe0e1a1'),
(117, 85, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51487_apple_macbook_pro_16_touch_bar_mvvj2sa_a_i7_2_6ghz_16gb_ram_512gb_ssd_16_0_radeon_5300m_%20(2).png?alt=media&token=4129facc-3a64-4c1c-8f45-df37255'),
(118, 85, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51487_apple_macbook_pro_16_touch_bar_mvvj2sa_a_i7_2_6ghz_16gb_ram_512gb_ssd_16_0_radeon_5300m_%20(1).png?alt=media&token=3479fa2c-0e25-4a9a-92a9-bf2fb26'),
(119, 85, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51487_apple_macbook_pro_16_touch_bar_mvvj2sa_a_i7_2_6ghz_16gb_ram_512gb_ssd_16_0_radeon_5.png?alt=media&token=2b0364ab-76ec-466c-9b9f-d51cf7d9686d'),
(120, 85, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51487_apple_macbook_pro_16_touch_bar_mvvj2sa_a_i7_2_6ghz_16gb_ram_512gb_ssd_16_0_radeon_5300m_%20(3).png?alt=media&token=2dc4b160-065a-4c33-bf64-d768a85'),
(121, 85, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51487_apple_macbook_pro_16_touch_bar_mvvj2sa_a_i7_2_6ghz_16gb_ram_512gb_ssd_16_0_radeon_5300m_4g_1.png?alt=media&token=a3521142-91ee-44c7-a834-ab808deeb'),
(122, 86, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53019_apple_macbook_air_13_mvh22_2.jpg?alt=media&token=89802674-1767-4f90-bb11-980a1a7581a7'),
(123, 86, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53019_apple_macbook_air_13_mvh22_5.jpg?alt=media&token=18984bec-101f-401c-82d5-8451c210b6ff'),
(124, 86, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53019_apple_macbook_air_13_mvh22_3.jpg?alt=media&token=27f699a9-f1b7-4ffe-a1ee-5f8ae2846bbf'),
(125, 86, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53019_apple_macbook_air_13_mvh22_1.jpg?alt=media&token=63a7894e-a48b-4abb-8951-553eec74586a'),
(126, 86, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53019_apple_macbook_air_13_mvh22_4.jpg?alt=media&token=c061edc9-5fc7-44ef-97d5-10f5208e6e2c'),
(127, 87, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53021_apple_macbook_air_13_mvh52_1.jpg?alt=media&token=2fd0ccda-455b-4756-bf54-22b4ee6f5258'),
(128, 87, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53021_apple_macbook_air_13_mvh52_2.jpg?alt=media&token=c84fe412-471d-4b09-b4da-4bd49e8eff2e'),
(129, 87, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53021_apple_macbook_air_13_mvh52_4.jpg?alt=media&token=0b558753-62c6-4bd9-9c9d-e04b1828d9d5'),
(130, 87, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53021_apple_macbook_air_13_mvh52_3.jpg?alt=media&token=2e46ddad-cdff-4e2d-910c-1b305b34d1b5'),
(131, 87, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53021_apple_macbook_air_13_mvh52_1.png?alt=media&token=ebebd4e8-63ce-4ee5-a44d-131ca9e2e167'),
(132, 88, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52797_laptop_lenovo_thinkpad_e15_20rds0du00_5.jpg?alt=media&token=1b4e6d1e-c17b-42ae-8a8f-8bdca9ae5aef'),
(133, 88, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52797_laptop_lenovo_thinkpad_e15_20rds0du00_4.jpg?alt=media&token=37edfe54-d4bc-4554-b1ea-3bc7d49f30fe'),
(134, 88, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52797_laptop_lenovo_thinkpad_e15_20rds0du00_2.jpg?alt=media&token=129acc69-1c88-4b72-877f-7f9e34575422'),
(135, 88, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52797_laptop_lenovo_thinkpad_e15_20rds0du00_6.jpg?alt=media&token=8b618e4f-5db5-47a1-b6d7-c1bce6bdfd2e'),
(136, 88, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52797_laptop_lenovo_thinkpad_e15_20rds0du00_3.jpg?alt=media&token=7fd15eac-46c4-4d23-84dc-6e3e9d6d6463'),
(137, 89, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F120_53888_laptop_lenovo_legion_5_15imh05_82au004xvn_den_2.png?alt=media&token=f7687c39-69f5-44bd-893b-d7b740ad878b'),
(138, 89, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53888_laptop_lenovo_legion_5_11.jpg?alt=media&token=c8505fa7-4e45-4022-b750-7e2ee468b738'),
(139, 89, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53888_laptop_lenovo_legion_5_15imh05_82au004xvn_den_3.png?alt=media&token=93d95356-ac74-4b05-b163-b5bebb39730e'),
(140, 89, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53888_laptop_lenovo_legion_5_1.jpg?alt=media&token=62b629cc-d81d-4dcf-a3f0-c87968a60d8c'),
(141, 89, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53888_laptop_lenovo_legion_5_15imh05_82au004xvn_den_4.png?alt=media&token=e448ff6e-2100-4044-bc8a-a3f57bd02970'),
(142, 90, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53891_laptop_lenovo_gaming_3_15imh05_81y4006svn_den_4.png?alt=media&token=393b44a6-023e-471e-8912-6b92e3f2460b'),
(143, 90, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53891_laptop_lenovo_gaming_3_15imh05_81y4006svn_den_3.png?alt=media&token=1f8a0ae6-529a-4214-90d4-2d391557f5eb'),
(144, 90, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53891_laptop_lenovo_gaming_3_15imh05_81y4006svn_den_1.png?alt=media&token=2a5caf50-0698-4e7e-9b5c-1331f30c73ac'),
(145, 90, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53891_laptop_lenovo_gaming_3_15imh05_81y4006svn_den_2.png?alt=media&token=42346ebd-fffc-4205-b439-199bec55989d'),
(146, 2, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F120_52020_laptop_lg_gram_15zd90n_v_ax56a5_i5_1035g7_8gb_ram_512gb_ssd_15_6_inch_.png?alt=media&token=4d72ca9e-b359-4ad3-a1a3-5f9fa5efbd33'),
(147, 2, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52020_laptop_lg_gram_15zd90n_v_ax56a5_i5_1035g7_8gb_ram_512gb_ssd_15_6_inch_fhd_%20(2).jpg?alt=media&token=5507063f-9c08-41ef-a1e0-c8fc8c8b2b1f'),
(148, 2, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52020_laptop_lg_gram_15zd90n_v_ax56a5_i5_1035g7_8gb_ram_512gb_ssd_15_6_inch_fhd_%20(1).jpg?alt=media&token=a8b12be8-62a8-4686-a196-4f58c4e352a5'),
(149, 2, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52020_laptop_lg_gram_15zd90n_v_ax56a5_i5_1035g7_8gb_ram_512gb_ssd_15_6_inch_fhd_fp_x.jpg?alt=media&token=80556bcd-a38e-44c1-9633-e74a7300e62c'),
(150, 2, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52020_laptop_lg_gram_15zd90n_v_ax56a5_i5_1035g7_8gb_ram_512gb_ssd_15_6_inch_fhd_%20(3).jpg?alt=media&token=e08f78d1-e4fb-4b8d-ac64-10b08672bc53'),
(151, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58364_a514_54__7_.png?alt=media&token=06a1a22c-d091-4dff-aa0a-71fc5ca04575'),
(152, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58364_a514_54__4_.png?alt=media&token=af75f8c9-999e-441b-9963-016a04aab6e7'),
(153, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58364_a514_54__2_.png?alt=media&token=1df7e6be-0fd8-40e4-8f0a-de76e64ef900'),
(154, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58364_a514_54__6_.png?alt=media&token=940b6132-9f0e-48e2-be76-49eaa0876d46'),
(155, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58364_a514_54__3_.png?alt=media&token=af6297d6-dbfa-4ca8-bb03-378a1bd4df57'),
(156, 3, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58364_a514_54__5_.png?alt=media&token=ecccabc4-e926-4fb4-91b3-07575234453b'),
(157, 4, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__1_.png?alt=media&token=edd01e92-cf40-4fe2-80da-7ca5380feca0'),
(158, 4, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__4_.png?alt=media&token=a4124554-de0c-4428-a6f5-3f497de93598'),
(159, 4, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__2_.png?alt=media&token=22cc950a-f9c3-4b79-be6a-8f4ee90b5d8f'),
(160, 4, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__3_.png?alt=media&token=1676c861-9400-4067-a484-83ba01a0a3d6'),
(161, 5, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__1_.png?alt=media&token=db3ad626-2edd-4b41-b520-2dec3d4718ea'),
(162, 5, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__4_.png?alt=media&token=acc7e3d9-25d3-4580-9170-6a58f1bde78b'),
(163, 5, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__2_.png?alt=media&token=9b2db844-3681-4876-a8c8-a78e451cee75'),
(164, 5, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56516_vosro3405__3_.png?alt=media&token=12906674-cde7-466e-bdea-827d067b808e'),
(165, 91, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57829_mainboard_asrock_b560m_steel_legend_1%20(1).jpg?alt=media&token=d2f6de3c-bf45-436a-b8ab-258b9e95dd1a'),
(166, 91, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57829_mainboard_asrock_b560m_steel_legend_4.jpg?alt=media&token=e1df5a7c-dc4b-43ca-af50-bfc255363a4a'),
(167, 91, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57829_mainboard_asrock_b560m_steel_legend_1.jpg?alt=media&token=57f9f476-e466-463f-a76e-29ba9b348f62'),
(168, 91, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57829_mainboard_asrock_b560m_steel_legend_5.jpg?alt=media&token=448a08aa-f672-45c4-b195-146a42845ccf'),
(169, 91, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57829_mainboard_asrock_b560m_steel_legend_3.jpg?alt=media&token=2fe8f00e-d99b-466f-b68b-8bcb4bf37241'),
(170, 92, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47518_mainboard_msi_mpg_x570_gaming_edge_wi_fi_0004_2.jpg?alt=media&token=d8d9b335-3c2c-48eb-bcdb-db04a1a99fe1'),
(171, 92, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47518_mainboard_msi_mpg_x570_gaming_edge_wi_fi_0004_5.jpg?alt=media&token=13e2c01f-d82b-4b07-8be3-46239e00f6cb'),
(172, 92, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47518_mainboard_msi_mpg_x570_gaming_edge_wi_fi_0004_4.jpg?alt=media&token=e12ec046-74e3-4bad-bcdb-966f8c75f7b8'),
(173, 92, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47518_mainboard_msi_mpg_x570_gaming_edge_wi_fi_0004_3.jpg?alt=media&token=63393f9b-4e76-4115-ad8d-28898d26f740'),
(174, 92, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47518_mainboard_msi_mpg_x570_gaming_edge_wi_fi_0004_1.jpg?alt=media&token=97811da8-7014-4dca-968a-dd7ecd9e0275'),
(175, 93, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52309_mainboard_msi_mpg_z490_gaming_carbon_wifi_intel_z490_socket_1200_atx_4_khe_ram_ddr4_0005_6.jpg?alt=media&token=8e5b8565-1bf5-4c3d-b728-c4c4c93f10e'),
(176, 93, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52309_mainboard_msi_mpg_z490_gaming_carbon_wifi_intel_z490_socket_1200_atx_4_khe_ram_ddr4_0004_5.jpg?alt=media&token=2c38fc37-b096-491e-bcfe-fe1203cea2c'),
(177, 93, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52309_mainboard_msi_mpg_z490_gaming_carbon_wifi_intel_z490_socket_1200_atx_4_khe_ram_ddr4_0002_3.jpg?alt=media&token=2e237a6e-8401-4817-9767-d03238a3bc0'),
(178, 93, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52309_mainboard_msi_mpg_z490_gaming_carbon_wifi_intel_z490_socket_1200_atx_4_khe_ram_ddr4_0006_7.jpg?alt=media&token=84f28a64-e551-46bb-b1b7-e13e414f7e4'),
(179, 93, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52309_mainboard_msi_mpg_z490_gaming_carbon_wifi_intel_z490_socket_1200_atx_4_khe_ram_ddr4_0001_2.jpg?alt=media&token=147d1787-5290-43f9-99dd-9bd57dca8d5'),
(180, 94, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44258_mainboardgigabyte_z390_aorus_master_0004_5.jpg?alt=media&token=49451e75-2afe-48aa-8e40-ad6f13be268a'),
(181, 94, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44258_mainboardgigabyte_z390_aorus_master_0000_1.jpg?alt=media&token=d88230d6-182d-41e7-ae1c-70fd6d3096fb'),
(182, 94, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44258_mainboardgigabyte_z390_aorus_master_0003_4.jpg?alt=media&token=30114d06-8321-43e6-810a-a68e2f11a748'),
(183, 94, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44258_mainboardgigabyte_z390_aorus_master_0002_3.jpg?alt=media&token=7afec8a0-eb4e-40be-9948-b27974cf81fb'),
(184, 94, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44258_mainboardgigabyte_z390_aorus_master_0001_2.jpg?alt=media&token=72a382c0-dc9e-4582-bcfd-30952c9bc768'),
(185, 95, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44259_mainboardgigabyte_z390_aorus_ultra_0000_1.jpg?alt=media&token=c632e735-0ec4-4cb4-af22-4b75e61c511f'),
(186, 95, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44259_mainboardgigabyte_z390_aorus_ultra_0003_4.jpg?alt=media&token=3f73905f-75fe-41e5-9417-2e44e970fdac'),
(187, 95, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44259_mainboardgigabyte_z390_aorus_ultra_0001_2.jpg?alt=media&token=f06dfe12-20e0-4719-a712-b18f10ced5ca'),
(188, 95, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44259_mainboardgigabyte_z390_aorus_ultra_0004_5.jpg?alt=media&token=2131662f-3e11-4dde-8bfe-484ff3e72728'),
(189, 16, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43988_mainboard_msi_b450m_gaming_plus_0000.jpg?alt=media&token=1f3669b6-9ff5-40bd-bb1e-c65618d51a55'),
(190, 16, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43988_mainboard_msi_b450m_gaming_plus_0001_2.jpg?alt=media&token=ffc0224e-f01b-445c-b676-1985196f6bc4'),
(191, 16, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43988_mainboard_msi_b450m_gaming_plus_0002_3.jpg?alt=media&token=17b53b83-5702-4faf-82bc-bcc38dc3cc0c'),
(192, 16, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43988_mainboard_msi_b450m_gaming_plus_0003_4.jpg?alt=media&token=206817b2-d820-4e05-9793-c43f59a11b07'),
(193, 17, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41790_mainboard_gigabyte_h310m_ds2_0003_4.jpg?alt=media&token=c589adb2-b660-4aed-9671-3060d8e147e3'),
(194, 17, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41790_mainboard_gigabyte_h310m_ds2_0002_3.jpg?alt=media&token=79a82ac9-9036-4cd4-a2b3-6fce86c76261'),
(195, 17, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41790_mainboard_gigabyte_h310m_ds2_0004_5.jpg?alt=media&token=2fd26174-897f-47c7-a032-c2ba2b8ecd6e'),
(196, 17, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41790_mainboard_gigabyte_h310m_ds2_0000_1.jpg?alt=media&token=764f93ce-0afa-4b2f-a675-2d8adb2a82f1'),
(197, 17, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41790_mainboard_gigabyte_h310m_ds2_44.jpg?alt=media&token=3f792b83-4e81-432a-9503-467c3d130562'),
(198, 18, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F27076_asus_z10pe_d16_ws_dual_cpu_workstation_0001_2.jpg?alt=media&token=0388c044-b7f3-4893-bb4b-aa8f88c0062b'),
(199, 18, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F27076_asus_z10pe_d16_ws_dual_cpu_workstation_0003_4.jpg?alt=media&token=a5d19ec6-c507-41ea-af73-3703ec66540d'),
(200, 18, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F27076_asus_z10pe_d16_ws_dual_cpu_workstation_0000_1.jpg?alt=media&token=fb0fe5b8-7bee-4b25-a397-8be55138be58'),
(201, 19, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33404_mainboard_asus_z10pa_d8c_dual_cpu_workstation_0002_3.jpg?alt=media&token=2c7aa118-6709-41cd-a422-0a0ab12bf8c4'),
(202, 19, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33404_mainboard_asus_z10pa_d8c_dual_cpu_workstation_0000_1.jpg?alt=media&token=ecd71efd-200d-4252-b88b-6ef664a679c5'),
(203, 20, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F36253_mainboard_asrock_rack_ep2c602_dual_cpu_socket_2011_0000(1).jpg?alt=media&token=533a1d2e-2d20-4a38-a6a9-b987e20644c6'),
(204, 20, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F36253_mainboard_asrock_rack_ep2c602_dual_cpu_socket_2011_0000.jpg?alt=media&token=f3ea0529-86ed-4054-9718-0b5964d60297'),
(205, 96, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47690_ram_adata_d41_grey_3.jpg?alt=media&token=2aa346c3-0676-4128-94a6-af128bc23cdb'),
(206, 96, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47690_z1972359849395_e583c6c87342df938a9fc9f83d59e50d.jpg?alt=media&token=817de1fd-6c00-4e7a-a04f-b57bb4941774'),
(207, 96, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47690_z1972359854394_65957c7a0e650d5392624686d5e66abe.jpg?alt=media&token=648c7d65-8ccf-46f4-a2d9-3ba9f088ac0d'),
(208, 96, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47690_ram_adata_d41_grey.jpg?alt=media&token=e06703c8-c7bb-48a8-b12d-d9deda1b1eb9'),
(209, 97, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51397_ram_adata_d41_grey_single.jpg?alt=media&token=2a1c0539-cf71-453a-86c4-f0a365447218'),
(210, 97, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51397_ram_desktop_adata_xpg_spectrix_d41_rgb_grey_ax4u300038g16a_st41_8gb_1x8gb_ddr4_3000mhz_33.jpg?alt=media&token=56e6613c-c502-4a43-88f7-cb4b811013ec'),
(211, 97, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51397_ram_desktop_adata_xpg_spectrix_d41_rgb_grey_ax4u300038g16a_st41_8gb_1x8gb_ddr4_3000mhz_22.jpg?alt=media&token=13df05d8-2e28-4fe3-bf60-1c9dae51eb8e'),
(212, 97, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51397_ram_desktop_adata_xpg_spectrix_d41_rgb_grey_ax4u300038g16a_st41_8gb_1x8gb_ddr4_3000mhz_11.jpg?alt=media&token=30ee43ba-b997-4f86-8986-4f19c5a324f2'),
(213, 98, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47008_corsair_vengeance_pro_rgb.jpg?alt=media&token=65b056ac-b07c-4adb-aed3-76ce44f87fef'),
(214, 98, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47008_corsair_vengeance_pro_rgb__2_.jpg?alt=media&token=0c5e51f7-db80-4701-8a93-bea625098303'),
(215, 98, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47008_ram_4_corsair_16gb3000_2x8gb_cmw16gx4m2d3000c16_vengeance_pro_rgb_black_111.jpg?alt=media&token=0d05efaf-2055-4ca8-8180-3b25560121b7'),
(216, 99, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47009_corsair_vengeance_pro_rgb__2_.jpg?alt=media&token=50ae0350-3ae0-414b-bc41-a87369fab270'),
(217, 99, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47009_corsair_vengeance_pro_rgb1.jpg?alt=media&token=cf628e49-e1c8-4cdd-a4f9-69dd9baaaea5'),
(218, 99, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47009_52283_3215d887937e6e20376f.jpg?alt=media&token=bc0262e1-ef8e-43e7-89c0-f850171fdbb1'),
(219, 99, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47009_ram_4_corsair_32gb3000_2x16gb_cmw32gx4m2d3000c16_vengeance_pro_rgb_black_22.jpg?alt=media&token=ea8198c1-608b-40f4-98b5-3c7590de4e12'),
(220, 99, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47009_ram_4_corsair_32gb3000_2x16gb_cmw32gx4m2d3000c16_vengeance_pro_rgb_black__11.jpg?alt=media&token=43f56545-3da5-48af-94c0-d3c7d6f566ee'),
(221, 100, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54208_ram_desktop_gskill_trident_z_rgb__2x32gb__ddr4_3600mhz.jpg?alt=media&token=8ecbca30-942f-45c5-aff6-7629838b8708'),
(222, 100, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54208_ram_desktop_gskill_trident_z_rgb__f4_3600c18d_64gtzr__64gb__2x32gb__ddr4_3600mhz_5.jpg?alt=media&token=98eaf5cf-c04f-40db-98a0-fd475dabe6eb'),
(223, 100, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54208_ram_desktop_gskill_trident_z_rgb__f4_3600c18d_64gtzr__64gb__2x32gb__ddr4_3600mhz_4.jpg?alt=media&token=891f1b25-d2a0-4d20-9296-2a7af4f32b2e'),
(224, 100, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54208_ram_desktop_gskill_trident_z_rgb.jpg?alt=media&token=fef7fcdd-40c3-4fa0-b9ef-5d7dabfbc4f7'),
(225, 11, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48711_gskill_trident_z_neo.jpg?alt=media&token=f024edd2-a3dc-454b-aa87-6f958efcaef2'),
(226, 11, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48711_gskill_trident_z_neo_3.jpg?alt=media&token=af895233-1c37-4ba3-a8f5-9e4e57f26651'),
(227, 11, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48711_gskill_trident_z_neo_2.jpg?alt=media&token=38e01c1b-0ca2-4430-94b1-bfbf79b44fe7'),
(228, 11, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48711_ram_desktop_gskill_trident_z_neo_f4_3600c16d_16gtznc_16gb_2x8gb_ddr4_3600mhz_1.jpg?alt=media&token=1b94e5ac-831f-46c5-a42a-18ad88b3f224'),
(229, 11, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48711_ram_desktop_gskill_trident_z_neo_f4_3600c16d_16gtznc_16gb_2x8gb_ddr4_3600mhz_3.jpg?alt=media&token=baf6928d-845e-4af3-8b0b-637ccd9efcdc'),
(230, 14, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F18043_raav1.jpg?alt=media&token=b3e33889-cd23-4d41-b87c-bea7518802d1'),
(231, 14, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F18043_raav2.jpg?alt=media&token=31def665-f8cb-4aa4-98b9-20b58300d93a'),
(232, 14, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F18043_ram_axpro_green_pcb_ddr3.jpg?alt=media&token=5d1b0de3-ee29-4997-8bae-ed135f9d93e9'),
(233, 101, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5_2.jpg?alt=media&token=c491ddfd-eceb-452e-a876-7b89123aa18a'),
(234, 101, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5_3.jpg?alt=media&token=dff3f771-5328-4148-96f2-2c1ce9ebd166'),
(235, 101, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5.jpg?alt=media&token=b28c4ab3-49a0-4059-ad3d-b090bb38554a'),
(236, 101, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_hnc_amd_ryzen_5_left_facing_850x850.jpg?alt=media&token=8c5beba6-80d5-48ab-b958-7d52b3aeacf3'),
(237, 101, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5_4.jpg?alt=media&token=0ba991b6-c210-424a-b801-013d7f9a63e9'),
(238, 102, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56282_cpu_amd_ryzen_5_5600x.jpg?alt=media&token=ca7a4f00-4fb1-4021-97bf-5ccfc7fac717'),
(239, 102, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56282_cpu_amd_ryzen_5_5600x_11.jpg?alt=media&token=bca799a5-eec9-45c1-ba09-0fd19c524f3e'),
(240, 102, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56282_cpu_amd_ryzen_5_5600x_11%20(1).jpg?alt=media&token=01bcfa1e-d091-411d-91d0-4371a6e50f4d'),
(241, 102, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56282_cpu_amd_ryzen_5_5600x_22.jpg?alt=media&token=ff494dd7-3d16-4164-9521-643e2b1b745d'),
(242, 102, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56282_cpu_amd_ryzen_5_5600x_22%20(1).jpg?alt=media&token=bc638676-dc63-41e5-b997-da690d520e08'),
(243, 103, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5_2.jpg?alt=media&token=e04aaa55-b3a6-47a4-b406-c724e06cd5b9'),
(244, 103, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5_3.jpg?alt=media&token=2f5e2b2c-7d29-48f6-afc0-b8cc6c285101'),
(245, 103, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5_4.jpg?alt=media&token=93fa4887-aee4-41cc-a7ef-4aadc8e692b9'),
(246, 103, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_hnc_amd_ryzen_5_left_facing_850x850.jpg?alt=media&token=f182923b-7cfa-4f0b-8e33-be7697e07975'),
(247, 103, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49430_amd_ryzen_5.jpg?alt=media&token=80018e7b-2527-4f9b-a912-b7c1fbcfb9cd'),
(248, 104, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49437_hnc_intel_i9_10900x_right_facing_850x850.jpg?alt=media&token=72040b87-2622-459e-bbc9-5be13c5da940'),
(249, 104, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49437_intel_core_i9_10940x_2.jpg?alt=media&token=9ae1e3a5-7bb5-45e4-8bf9-68c3cfe1b661'),
(250, 104, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49437_intel_core_i9_10940x_3.jpg?alt=media&token=79250f25-d49d-4715-84c7-9bba6b6293cf'),
(251, 104, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49437_intel_core_i9_10940x.jpg?alt=media&token=983761a2-b82b-49ad-8b12-ef8b9372c911'),
(252, 104, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49437_lian_li_modding_1.jpg?alt=media&token=3f43eb55-7a94-4444-811a-281d741e3889'),
(253, 105, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49438_hnc_intel_i9_10980xe_right_face_850x850.jpg?alt=media&token=735906f3-9799-46c2-a9ee-b4484b7d7f47'),
(254, 106, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41685_fsp_power_supply_hyper_m85__series_model_ha550m__0000_1.jpg?alt=media&token=e1a9873a-5c87-439d-bc22-5324a7ca1577'),
(255, 106, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41685_fsp_power_supply_hyper_m85__series_model_ha550m__0001_2.jpg?alt=media&token=9a4adaf5-aef7-4153-8299-905c0dd7f086'),
(256, 106, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41685_fsp_hyper_m85_650_bronze__5_.jpg?alt=media&token=d83fccab-9a6f-4806-80a1-ef7417cdf400'),
(257, 106, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41685_fsp_hyper_m85_650_bronze__4_.jpg?alt=media&token=180b4957-8f55-4a92-8197-22450456ae5f'),
(258, 106, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41685_fsp_hyper_m85_650_bronze__6_.jpg?alt=media&token=dca413cb-0ffc-4eeb-be16-aa532002b2c7'),
(259, 107, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48214____nh______i_di___n_0006_7.jpg?alt=media&token=a7d279dd-cd08-41f6-a6ba-be890b0a5067'),
(260, 107, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48214____nh______i_di___n_0004_5.jpg?alt=media&token=0a9bb57b-82c1-4e3d-89a9-c5fd0cedce4a'),
(261, 107, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48214____nh______i_di___n_0003_4.jpg?alt=media&token=b5ec5cc1-c773-4237-a116-4c6b2e0e44fc'),
(262, 107, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48214____nh______i_di___n_0005_6.jpg?alt=media&token=5cea3770-0038-4df3-834c-bb3d57b64e56'),
(263, 107, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48214____nh______i_di___n_0007_8.jpg?alt=media&token=5b0e7f80-90bd-4c6d-8c2a-3fd19fca03d9'),
(264, 108, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47766_rog_strix_psu_750_6.jpg?alt=media&token=b98046fe-4c94-429d-a1ca-cd6209f546f2'),
(265, 108, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47766_rog_strix_psu_750_5.jpg?alt=media&token=decb387c-df9e-44c4-b55c-83394d347aed'),
(266, 108, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47766_rog_strix_psu_750_2.jpg?alt=media&token=27ce60e6-02d4-4851-91fc-545c5bc456a5'),
(267, 108, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47766_rog_strix_psu_750_3.jpg?alt=media&token=813ab3ee-2a84-4901-8a7c-732b9a75ed22'),
(268, 108, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47766_rog_strix_psu_750_4.jpg?alt=media&token=2b3369dc-5a2b-4a58-97ba-ba640c4be71c'),
(269, 109, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48074_nguon_may_tinh_jetek_p_rgb_80_plus_bronze__1_.jpg?alt=media&token=8be5ec52-952d-4cf7-bdd8-98bc3482db1d'),
(270, 109, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48074_nguon_may_tinh_jetek_p_rgb_80_plus_bronze__3_.jpg?alt=media&token=c97d7f89-9f76-4a23-b1f4-8b798a60de72'),
(271, 109, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48074_nguon_may_tinh_jetek_p_rgb_80_plus_bronze__2_.jpg?alt=media&token=84a9107c-7089-4852-ad8a-a4b7041ec12e'),
(272, 109, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48074_nguon_may_tinh_jetek_p_rgb_80_plus_bronze__5_.jpg?alt=media&token=ae668816-0e9a-4d50-ba36-8fad1f09bca8'),
(273, 110, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48984_coolermaster_v1000_gold_0005_1__1_.jpg?alt=media&token=d1999484-ca6c-492e-a0f0-53322ad96d74'),
(274, 110, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48984_coolermaster_v1000_gold_0004_1__2_.jpg?alt=media&token=85b78a0a-7227-4a20-bd2b-144fcce66c53'),
(275, 110, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48984_coolermaster_v1000_gold_0002_1__4_.jpg?alt=media&token=34a1c775-c93d-4045-ac15-529395b07a39'),
(276, 110, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48984_coolermaster_v1000_gold_0000_1__6_.jpg?alt=media&token=8e88264b-39a2-4562-970b-19e2fc095a30'),
(277, 110, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48984_coolermaster_v1000_gold_0003_1__3_.jpg?alt=media&token=d3454058-6243-4972-9b06-fc1eaf8178bd'),
(278, 111, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49691_msi_gtx_1660_super_ventus_xs_oc__03.jpg?alt=media&token=f558c075-c1e3-44fc-be48-a61a8f5967cc'),
(279, 111, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49691_msi_gtx_1660_super_ventus_xs_oc__04.jpg?alt=media&token=4629d365-d56e-464d-a796-f5ea20489948'),
(280, 111, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49691_msi_gtx_1660_super_ventus_xs_oc__02.jpg?alt=media&token=9501f75d-13dc-43a8-aceb-fb5d49a9235e');
INSERT INTO `product_image` (`product_image_id`, `product_id`, `image`) VALUES
(281, 111, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49691_card_man_hinh_msi_gtx_1660_super_ventus_xs_oc_001.jpg?alt=media&token=2a4232a4-6854-48c5-9ab0-1ca16ee0849b'),
(282, 112, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59174_card_man_hinh_leadtek_gtx_1650_d6_4.jpg?alt=media&token=cb582fc0-3b96-4a75-ac3f-b5e104200035'),
(283, 112, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59174_card_man_hinh_leadtek_gtx_1650_d6_3.jpg?alt=media&token=1b7844c9-8725-4d0a-8c94-37ed8c2b2118'),
(284, 112, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59174_card_man_hinh_leadtek_gtx_1650_d6_1.jpg?alt=media&token=289cf27a-9d7b-4bf5-a326-c1769ac6cfa6'),
(285, 112, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59174_card_man_hinh_leadtek_gtx_1650_d6_2.jpg?alt=media&token=b928ddad-f53f-4c69-8499-37202442b721'),
(286, 113, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56703_card_man_hinh_leadtek_winfast_gtx_1660_super_hurricane_6g_1.jpg?alt=media&token=fc29d3c5-c923-423b-acdc-a6d6e9692557'),
(287, 113, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56703_card_man_hinh_leadtek_winfast_gtx_1660_super_hurricane_6g_2.jpg?alt=media&token=a0d9f5d6-4cfa-44ca-895f-8fc28c2a0552'),
(288, 113, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56703_card_man_hinh_leadtek_winfast_gtx_1660_super_hurricane_6g_3.jpg?alt=media&token=2a970c44-7792-49c0-a201-5d41da268964'),
(289, 113, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F56703_card_man_hinh_leadtek_winfast_gtx_1660_super_hurricane_6g_11.jpg?alt=media&token=c947e10a-0ed9-4ab1-9053-ac49cf71dd3b'),
(290, 114, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49621_hnc_inno3d_1660_super_x2___2.jpg?alt=media&token=c4843691-a7cc-42fd-81b6-e0d730b0bbb6'),
(291, 114, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49621_hnc_inno3d_1660_super_x2___4.jpg?alt=media&token=a8566788-c0ce-4aa2-a29b-f1a70188f558'),
(292, 114, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49621_hnc_inno3d_1660_super_x2___3.jpg?alt=media&token=8c803414-3788-4805-a1d2-aa8f95d848cc'),
(293, 114, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49621_inno3d_gtx_1660_super_twin_x2_01.jpg?alt=media&token=16b7a5f2-0e5d-4fd8-a843-a03c63ec3935'),
(294, 115, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46183_inno3d_geforce_gtx_1660_twin_x2__01_01.jpg?alt=media&token=bebc5865-fb3e-42e9-af2c-82c3ac775908'),
(295, 115, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46183_inno3d_geforce_gtx_1660_twin_x2__02.jpg?alt=media&token=d00053cf-33ea-44e8-bd63-e784bc567edd'),
(296, 116, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47733_tai_nghe_corsair_hs35_stereo_carbon_0002_3.jpg?alt=media&token=247c3eea-dc50-446f-8c24-04dd0fe5a83f'),
(297, 116, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47733_tai_nghe_corsair_hs35_stereo_carbon_0001_2.jpg?alt=media&token=d4437dec-d7a3-4e47-83a1-d9257602a723'),
(298, 116, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47733_tai_nghe_corsair_hs35_stereo_carbon_0004_1.jpg?alt=media&token=db1e2f36-812e-468d-9db8-829d47dcd7e9'),
(299, 116, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47733_tai_nghe_corsair_hs35_stereo_carbon_0000_5.jpg?alt=media&token=10abcb9e-6ec1-4f62-9bcf-12472be4fd6a'),
(300, 116, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47733_tai_nghe_corsair_hs35_stereo_carbon_0003_5.jpg?alt=media&token=aea8e425-ebec-491a-a755-3d06a183ff86'),
(301, 117, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50250_tai_nghe_gaming_corsair_hs50_pro_stereo_carbon_0004_3.jpg?alt=media&token=b0a4ca8d-42a1-49cc-a162-ff68fe727422'),
(302, 117, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50250_tai_nghe_gaming_corsair_hs50_pro_stereo_carbon_0005_4.jpg?alt=media&token=35748b1b-6e37-43e4-b51b-5a085e00b406'),
(303, 117, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50250_tai_nghe_gaming_corsair_hs50_pro_stereo_carbon_0000_2.jpg?alt=media&token=48591893-6b1b-4622-a2dc-fb418b412ffa'),
(304, 117, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50250_tai_nghe_gaming_corsair_hs50_pro_stereo_carbon_0001_1.jpg?alt=media&token=2e5919b9-952b-4ee6-92c1-6ea8ed898d6d'),
(305, 117, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F50250_tai_nghe_gaming_corsair_hs50_pro_stereo_carbon_02.jpg?alt=media&token=866681f6-fd1a-4048-93fd-b6473f901049'),
(306, 118, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F37115_tai_nghe_kingston_hyperx_cloud_revolver_s_black_hx_hscrs_gmas_0003_2.jpg?alt=media&token=f26e9f8d-bbc9-4f4f-bc22-2d991b3eafa1'),
(307, 118, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F37115_tai_nghe_kingston_hyperx_cloud_revolver_s_black_hx_hscrs_gmas_0002_1.jpg?alt=media&token=fd5b62b1-8b4f-42bd-af34-a51adb155029'),
(308, 118, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F37115_tai_nghe_kingston_hyperx_cloud_revolver_s_black_hx_hscrs_gmas_0004_3.jpg?alt=media&token=593f6e5f-8987-4548-a77d-37913abe789d'),
(309, 118, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F37115_tai_nghe_kingston_hyperx_cloud_revolver_s_black_hx_hscrs_gmas_02.jpg?alt=media&token=f2efedc0-7f5d-4645-ba6e-7998624e1d4b'),
(310, 118, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F37115_tai_nghe_kingston_hyperx_cloud_revolver_s_black_hx_hscrs_gmas_0000_5.jpg?alt=media&token=04c14ee0-6fb8-4486-af39-8118c8f5de5d'),
(311, 119, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51506_razer_kraken_kitty_quartz_headset_gaming__2_.jpg?alt=media&token=312b32b4-b863-48c0-8197-8a997a9d05f5'),
(312, 119, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51506_razer_kraken_kitty_quartz_headset_gaming__7_.jpg?alt=media&token=6deebd49-37ab-4a57-849e-e06ab6d71631'),
(313, 119, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51506_razer_kraken_kitty_quartz_headset_gaming__3_.jpg?alt=media&token=1b530f4e-1d94-4c00-ac9c-4352476b9824'),
(314, 119, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51506_razer_kraken_kitty_quartz_headset_gaming__1_.jpg?alt=media&token=efd9c498-fb05-4875-8e97-94813f3c8f38'),
(315, 119, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51506_razer_kraken_kitty_quartz_headset_gaming__2_.png?alt=media&token=9f516479-4595-4f74-93a5-85d797df0f13'),
(316, 119, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51506_razer_kraken_kitty_quartz_headset_gaming__1_.png?alt=media&token=164caf0d-4790-4405-a847-2f58e40b198f'),
(317, 120, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51179_tai_nghe_razer_kraken_2019_multi_platform_wired_green_rz04_02830200_r3m1_0000_2.jpg?alt=media&token=59f90c15-644b-49a0-adbf-8a1afd6f45c8'),
(318, 120, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51179_tai_nghe_razer_kraken_2019_multi_platform_wired_green_rz04_02830200_r3m1_0001_1.jpg?alt=media&token=68c152a2-5905-4712-9008-2b08d324af14'),
(319, 120, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51179_tai_nghe_razer_kraken_2019_multi_platform_wired_green_rz04_02830200_r3m1_0002_3.jpg?alt=media&token=f151aa5b-abb0-4938-9404-db8ab1d61ddc'),
(320, 121, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45542_keyboard_fuhlen_s_subverter_rgb_mechanical_blue_switch_black_1.jpg?alt=media&token=31d1b8ac-c2c0-4870-b268-0e9996fa7191'),
(321, 121, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45542_keyboard_fuhlen_s_subverter_rgb_mechanical_blue_switch_black_2.jpg?alt=media&token=faa6ff13-c4ff-44c9-b01f-a66179a98592'),
(322, 121, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45542_keyboard_fuhlen_s_subverter_rgb_mechanical_blue_switch_black.jpg?alt=media&token=c3dbe492-36fe-459f-b157-4cb22814cbbb'),
(323, 122, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F35688_keyboard_eblue_mazer_ekm737_mechanical_blue_switchs.jpg?alt=media&token=f1725aa5-74a3-4667-b08b-5e1c493ff311'),
(324, 123, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51884_goc_trai_ban_phim_co_akko_3084_world_tour_tokyo_blue_switch.jpg?alt=media&token=71f5b858-136b-47a6-bda9-70d995f53871'),
(325, 123, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51884_mat_ngang_ban_phim_co_akko_3084_world_tour_tokyo_blue_switch.jpg?alt=media&token=8b26f409-6032-4a4e-8b26-ab4d59a7ad43'),
(326, 123, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51884_tong_the_ban_phim_co_akko_3084_world_tour_tokyo_blue_switch.jpg?alt=media&token=36878189-f68c-4bb3-8534-6d1177f5481a'),
(327, 123, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51884_mat_trai_ban_phim_co_akko_3084_world_tour_tokyo_blue_switch.jpg?alt=media&token=939f1148-4dfb-4b2e-9b18-d3608840935f'),
(328, 123, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51884_mat_phai_ban_phim_co_akko_3084_world_tour_tokyo_blue_switch.jpg?alt=media&token=74fceb62-a176-4cdf-8616-5efca1eb2fc5'),
(329, 124, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51890_goc_trai_ban_phim_co_akko_3108_v2_osa_grey_parrot_psittacus_gateron_yellow_switch.jpg?alt=media&token=42137dc9-8c72-4837-b763-7ed52da5e37c'),
(330, 124, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51890_mat_ngang_ban_phim_co_akko_3108_v2_osa_grey_parrot_psittacus_gateron_yellow_switch.jpg?alt=media&token=491e1530-92ef-447e-aa3c-a212e0fc9142'),
(331, 124, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51890_mat_phai_ban_phim_co_akko_3108_v2_osa_grey_parrot_psittacus_gateron_yellow_switch.jpg?alt=media&token=6ed9ab62-bdc1-440e-a86b-5674a53466f6'),
(332, 124, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51890_mat_trai_ban_phim_co_akko_3108_v2_osa_grey_parrot_psittacus_gateron_yellow_switch.jpg?alt=media&token=f855c88a-ed8a-4a35-8782-500e63a56227'),
(333, 124, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51890_tong_the_ban_phim_co_akko_3108_v2_osa_grey_parrot_psittacus_gateron_yellow_switch.jpg?alt=media&token=c3c95041-f53f-48fc-9210-7152d66b0fb2'),
(334, 125, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52718_ban_phim_co_e_dra_ek387_pro_pbt_cherry_blue_switch_den_xam_04%20(1).jpg?alt=media&token=ab626905-c264-4120-9e57-8d9ddce176a5'),
(335, 125, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52718_ban_phim_co_e_dra_ek387_pro_pbt_cherry_blue_switch_den_xam_03.jpg?alt=media&token=72d0d001-6bb0-4dc6-9748-25f84ec3fe45'),
(336, 125, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52718_ban_phim_co_e_dra_ek387_pro_pbt_cherry_blue_switch_den_xam_01.jpg?alt=media&token=87325163-1089-4d5b-a2af-a67ad65d484f'),
(337, 125, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52718_ban_phim_co_e_dra_ek387_pro_pbt_cherry_blue_switch_den_xam_02.jpg?alt=media&token=3731ee5e-10de-44c0-9cc7-5668a1447572'),
(338, 126, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45042_keyboard_e_dra_ek307_mechanica_gaming.jpg?alt=media&token=4432b4fa-3143-4c3d-88bc-c260b4fd6d8a'),
(339, 127, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38589_mouse_cougar_revenger_s_rgb_pixart_3360_0000_1.jpg?alt=media&token=7f078ba8-1fbe-40ab-ae14-68678fde7bb7'),
(340, 127, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38589_mouse_cougar_revenger_s_rgb_pixart_3360_0001_2.jpg?alt=media&token=a1429041-ef92-49f8-9c24-af301121df01'),
(341, 128, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54566_chuot_akko_ag325_dragon_ball_super_goku_ssg_0001_2.jpg?alt=media&token=fd716ae6-b15f-4797-801b-db215a779cca'),
(342, 128, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54566_chuot_akko_ag325_dragon_ball_super_goku_ssg_0002_3.jpg?alt=media&token=97b96924-b9a3-4c0b-9fc3-b602dfda548b'),
(343, 128, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54566_chuot_akko_ag325_dragon_ball_super_goku_ssg_0004_5.jpg?alt=media&token=75db5684-0258-44ec-a80f-0a6e243c4478'),
(344, 128, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54566_chuot_akko_ag325_dragon_ball_super_goku_ssg_0003_4.jpg?alt=media&token=d78c8cbe-f95d-4d85-8d21-5c6b2f70af25'),
(345, 128, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F54566_chuot_akko_ag325_dragon_ball_super_goku_ssg_0000_1.jpg?alt=media&token=81e8e79a-0eaa-48c1-af83-4709f58e32bb'),
(346, 129, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51875_thiet_ke_chuot_choi_game_akko_ag325_bilibili.jpg?alt=media&token=8213b430-f716-4e83-ae65-ea312277ac99'),
(347, 129, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51875_pad_chuot_di_kem_chuot_choi_game_akko_ag325_bilibili.jpg?alt=media&token=97941cc7-1c47-4877-a025-c3b9fc6a4a49'),
(348, 130, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41108_mouse_corsair_dark_core_wireless_rgb_se_0003_6.jpg?alt=media&token=62edd2bd-0699-41a5-a5e1-d3ef4e9e4b2f'),
(349, 130, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41108_mouse_corsair_dark_core_wireless_rgb_se_0000_3.jpg?alt=media&token=9c81763b-606a-448c-b9d7-20702680afb8'),
(350, 130, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41108_mouse_corsair_dark_core_wireless_rgb_se_0005_1.jpg?alt=media&token=7b5d5fb7-18c1-473f-a45e-c25cd23643ac'),
(351, 130, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41108_mouse_corsair_dark_core_wireless_rgb_se_0006_2.jpg?alt=media&token=07eebabe-3747-4518-b757-0fcddf33cf59'),
(352, 130, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F41108_mouse_corsair_dark_core_wireless_rgb_se_04.jpg?alt=media&token=c853d3fb-72e2-4957-96ca-c13376e0ca4a'),
(353, 131, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45204_mouse_corsair_m65_rgb_elite_black_0000_1.jpg?alt=media&token=8d9d7c77-c7d1-4cd7-886a-54f5558f4b1a'),
(354, 131, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45204_mouse_corsair_m65_rgb_elite_black_0002_3.jpg?alt=media&token=20b106f5-4b8d-417a-a5fa-33abc7f4ffcd'),
(355, 131, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45204_mouse_corsair_m65_rgb_elite_black_0004_5.jpg?alt=media&token=c7041d65-3381-42c8-83d9-b9a2ee0d9008'),
(356, 131, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45204_mouse_corsair_m65_rgb_elite_black_0005_6.jpg?alt=media&token=27b60077-f7b2-4339-a0e7-479a596a84d5'),
(357, 131, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F45204_mouse_corsair_m65_rgb_elite_black_0001_2.jpg?alt=media&token=8cbb8d03-3c29-4671-afa2-0e4f55ad2052'),
(358, 132, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47021_ssd_adata_gammix_s11p_512gb_m_2_2280_pcie_nvme.jpg?alt=media&token=511e1628-f0d2-4708-b848-edc39b39e9e6'),
(359, 132, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47021_ssd_adata_gammix_s11p_512gb_m_2_2280_pcie_nvme_1.jpg?alt=media&token=2c3cf143-8b0f-4b43-bbaa-9fbdba6662a7'),
(360, 132, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47021_o_cung_ssd_adata_512gb_gammix_s11_pro_pcie_nvme_gen3x4_doc_3500mb_s_ghi_3000mb_s_agammixs11p_512gt_c_11.jpg?alt=media&token=128b3346-ee20-47c9-a3f'),
(361, 133, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53576_____c___ng_ssd_adata_gammix_s11_pro_1tb_m_2_2280_pcie_nvme_gen_3x4.jpg?alt=media&token=e4e5cb2b-c39b-4a59-bd8a-cc56d5dceda2'),
(362, 133, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53576_____c___ng_ssd_adata_gammix_s11_pro_1tb_m_2_2280_pcie_nvme_gen_3x4_1.jpg?alt=media&token=b8b77b01-2807-460a-b79d-ee682cdf236c'),
(363, 133, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53576_o_cung_ssd_adata_gammix_s11_pro_1tb_m_2_2280_pcie_nvme_gen_3x4_11.jpg?alt=media&token=fd0d5dd0-ed52-440b-b6f2-5a18bb2f1b1a'),
(364, 134, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46733_____c___ng_ssd_gigabyte_aorus_rgb_512gb_pcie_nvme_gen_3_0_x_4.jpg?alt=media&token=9564d87d-f308-4a9b-ba73-315ee3f877eb'),
(365, 134, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46733_____c___ng_ssd_gigabyte_aorus_rgb_512gb_pcie_nvme_gen_3_0_x_4_1.jpg?alt=media&token=43d8e44e-cec8-405a-b9bc-aef1eea39d0a'),
(366, 134, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46733_____c___ng_ssd_gigabyte_aorus_rgb_512gb_pcie_nvme_gen_3_0_x_4_4.jpg?alt=media&token=f0814ec3-2b5e-4438-9f0f-933b890941a5'),
(367, 134, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46733_____c___ng_ssd_gigabyte_aorus_rgb_512gb_pcie_nvme_gen_3_0_x_4_2.jpg?alt=media&token=af101ff9-a809-4327-aaea-131c99c9b499'),
(368, 134, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46733_m2_pcie_gigabyte_aorus_rgb_512gb_pcie_gen_3x4doc_3480mbs_ghi_2000mbs_gp_asm2ne2512gttdr_222.jpg?alt=media&token=dade1a2e-d26a-40dc-b4c2-3406e24df2'),
(369, 135, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53260_____c___ng_ssd_gigabyte_512gb_m_2_2280_pcie_nvme_gen_3x4.jpg?alt=media&token=dc07c340-f326-4dfc-b35f-5a152b52178c'),
(370, 135, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53260_o_cung_ssd_gigabyte_512gb_m_2_2280_pcie_nvme_gen_3x4_222.jpg?alt=media&token=7b718a67-374a-44a3-8368-94f28b1de049'),
(371, 135, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53260_o_cung_ssd_gigabyte_512gb_m_2_2280_pcie_nvme_gen_3x4_11.jpg?alt=media&token=3b84ac78-b830-4626-bb03-348676484399'),
(372, 135, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F53260_o_cung_ssd_gigabyte_512gb_m_2_2280_pcie_nvme_gen_3x4_111.jpg?alt=media&token=8eba9fc3-3238-4840-8c11-c8daa5836a15'),
(373, 136, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48301_ssd_kingston_a2000m8_250gb_m_2_2280.jpg?alt=media&token=7508cafc-3f6d-4112-94d0-dae9fdd7df42'),
(374, 136, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48301_ssd_kingston_a2000m8_250gb_m_2_2280_pcie_nvme.jpg?alt=media&token=cf762a02-e8e6-4a5c-9654-f66b84eb29ee'),
(375, 136, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48301_z1973698222101_8e6497318f789bcc55bb39cccaecdb32.jpg?alt=media&token=f7b97714-3817-45e4-9f3b-cd00c7274caf'),
(376, 136, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48301_kingston_a2000m8_250gb_m_2_2280.jpg?alt=media&token=1ae99e02-bf56-49de-af9b-ae96f6ad1e86'),
(377, 137, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38001_z1973698218813_467c7cde1035f5c48042014b4583ad15.jpg?alt=media&token=76b5e3aa-93c2-4226-bf74-4c96cc757303'),
(378, 137, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38001_z1973698219852_976fa78023b93d179ce6322744996b82.jpg?alt=media&token=db860aa5-6d56-4cc5-bf3c-52551888578b'),
(379, 137, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38001_z1973698218814_042549a424754253cb66de4c084f45d7.jpg?alt=media&token=8f7599f6-48ce-4890-aecd-eb23563faf88'),
(380, 138, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44444_hdd_seagate_barracuda_2tb.jpg?alt=media&token=da2974f8-d40a-4cff-a1c6-c99097e2641c'),
(381, 138, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44444_hdd_seagate_barracuda_2tb7200_sata_256mb_35quot___st2000dm008_022.jpg?alt=media&token=290baf2e-9a7e-44fb-8f92-63e54b1b9c6a'),
(382, 138, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44444_hdd_seagate_barracuda_2tb7200_sata_256mb_35quot___st2000dm008_011.jpg?alt=media&token=aff53d14-5ccb-4762-b80b-52910d335c4a'),
(383, 138, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44444_hdd_seagate_barracuda_2tb7200_sata_256mb_35quot___st2000dm008_033.jpg?alt=media&token=7a784cc1-37c0-4fc2-b39c-f82295f381a0'),
(384, 139, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47157_ac_seagate_skyhawk_ai_10tb_us_2.jpg?alt=media&token=02a55015-c274-471f-8d06-02b5ea63051c'),
(385, 139, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47157_o_cung_hdd_seagate_skyhawk_ai_10tb_3_5_7200rpm_sata3_6gb_s_st10000ve0008_022.jpg?alt=media&token=aef00524-ef1a-4c21-a153-ee18e19ce87d'),
(386, 139, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47157_o_cung_hdd_seagate_skyhawk_ai_10tb_3_5_7200rpm_sata3_6gb_s_st10000ve0008_011.jpg?alt=media&token=354465f7-e8a8-41c6-b660-a6396cdbbc23'),
(387, 140, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44288_hdd_toshiba_surveillance_6tb.jpg?alt=media&token=38d63538-61ce-44ae-9d6f-9cb235362b55'),
(388, 141, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44290_hdd_toshiba_surveillance_10tb.jpg?alt=media&token=35ff3f58-ee63-4a12-82bf-4da48a13ecd6'),
(389, 142, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F9192_z2001326005557_d97f3eab1fb3cf814960a93aa294f36e.jpg?alt=media&token=9c30f720-936a-4c72-8351-9d24561947bb'),
(390, 142, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F9192_z2001326007015_b15ba7dd54621c1af654f78dd3a8924d.jpg?alt=media&token=85bb16c0-0c82-4bba-8e3c-b3f8e13d96d9'),
(391, 142, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F9192_hdd_western_caviar_black_1tb_7200rpm_sata3_6gbs_64mb_cache_01.jpg?alt=media&token=206386c0-dba1-4fea-9a7d-c3327da0c329'),
(392, 143, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F34548_hdd_western_caviar_black_4tb.jpg?alt=media&token=c281d816-3224-4773-ba2d-9c2d050b79bf'),
(393, 143, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F34548_hdd_wd_caviar_black_4tb7200_sata3_wd4004fzwx_011.jpg?alt=media&token=d5afc08a-78d3-4e6b-8174-af644426b553'),
(394, 143, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F34548_hdd_wd_caviar_black_4tb7200_sata3_wd4004fzwx_033.jpg?alt=media&token=e3749c3a-0043-4a33-869f-5d649ed4453b'),
(395, 144, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46891_case_corsair_678c_tg_white_0004_1__3_.jpg?alt=media&token=99f1e4b8-625c-4c2a-9c2d-bbecb068f2b2'),
(396, 144, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46891_case_corsair_678c_tg_white_0005_1__2_.jpg?alt=media&token=36bc44c5-d5f7-48b9-9c5a-7b208dd77179'),
(397, 144, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46891_case_corsair_678c_tg_white_0006_1__1_.jpg?alt=media&token=777d4179-95e0-40c2-9bf3-1e460991b5c3'),
(398, 144, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46891_case_corsair_678c_tg_white_0001_1__6_.jpg?alt=media&token=bdcb9ce4-97c6-4745-9314-ae6cb1562c9a'),
(399, 144, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46891_case_corsair_678c_tg_white_0003_1__4_.jpg?alt=media&token=8381b4d4-fb24-41cb-93a1-7c4d1daead99'),
(400, 145, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46892_case_corsair_680x_rgb_tg_black__8_.jpg?alt=media&token=b4f303c5-2ca5-419c-8b0e-8e309c2e5ed5'),
(401, 145, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46892_case_corsair_680x_rgb_tg_black__6_.jpg?alt=media&token=86ea52bb-22ea-4da1-b0a4-f06afc1e6c97'),
(402, 145, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46892_case_corsair_680x_rgb_tg_black__4_.jpg?alt=media&token=a64d98bd-a80d-4761-81a1-3ff49838b98e'),
(403, 145, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46892_case_corsair_680x_rgb_tg_black__7_.jpg?alt=media&token=23732081-4e97-453b-82b6-1abf8ed6e29b'),
(404, 145, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F46892_case_corsair_680x_rgb_tg_black__5_.jpg?alt=media&token=ec8c787f-f5a7-40b5-b9bd-b24af0eb2999'),
(405, 146, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48639_case_phanteks_eclipse_p300_mid_tower_tempered_glass_black_ph_ec300ptg_bk_3.jpg?alt=media&token=86732140-29a6-4a4e-bd6b-def68241f9be'),
(406, 146, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48639_case_phanteks_eclipse_p300_mid_tower_tempered_glass_black_ph_ec300ptg_bk_1.jpg?alt=media&token=39e737d2-9914-4e10-88b6-c6df4f33dc8f'),
(407, 146, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48639_case_phanteks_eclipse_p300_mid_tower_tempered_glass_black_ph_ec300ptg_bk_4.jpg?alt=media&token=82099654-0181-440c-a44b-0be2a7282a85'),
(408, 146, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48639_case_phanteks_eclipse_p300_mid_tower_tempered_glass_black_ph_ec300ptg_bk_6.jpg?alt=media&token=95c0052c-ace8-4c44-99e8-b59aa3ac95a6'),
(409, 146, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48639_case_phanteks_eclipse_p300_mid_tower_tempered_glass_black_ph_ec300ptg_bk_8.jpg?alt=media&token=96d6eb76-4a26-4d8c-9de4-40a458541ae0'),
(410, 147, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48643_case_phanteks_enthoo_evolv_shift_air_itx_case_fabric_mesh_panel_satin_black_ph_es217a_bk_1.jpg?alt=media&token=71c98749-6cb6-49b4-88b4-bba4432f339'),
(411, 147, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48643_case_phanteks_enthoo_evolv_shift_air_itx_case_fabric_mesh_panel_satin_%20(3).jpg?alt=media&token=7396d8d5-5220-4aba-825d-601a9097589e'),
(412, 147, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48643_case_phanteks_enthoo_evolv_shift_air_itx_case_fabric_mesh_panel_satin_%20(2).jpg?alt=media&token=d0f14d2b-9b38-4b11-9853-5c0033942889'),
(413, 147, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48643_case_phanteks_enthoo_evolv_shift_air_itx_case_fabric_mesh_panel_satin_%20(1).jpg?alt=media&token=984ffc91-201a-4e9e-9690-18d0dca70d10'),
(414, 147, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F48643_case_phanteks_enthoo_evolv_shift_air_itx_case_fabric_mesh_panel_satin_blac.jpg?alt=media&token=f465261f-bf69-45c4-b9fa-7d6c5652c9c1'),
(415, 148, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43257_case_thermaltake_view_37_rgb_edition_0000_1__6_.jpg?alt=media&token=c285f7d3-0adf-48ee-8bb3-0da6cefc2595'),
(416, 148, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43257_case_thermaltake_view_37_rgb_edition_0002_1__4_.jpg?alt=media&token=f1e026e1-aa88-49f3-8b22-ed16fff64c91'),
(417, 148, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43257_case_thermaltake_view_37_rgb_edition_0004_1__2_.jpg?alt=media&token=522a54ad-c8d6-4b2a-b9dd-c3c64fc6846e'),
(418, 148, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43257_case_thermaltake_view_37_rgb_edition_0003_1__3_.jpg?alt=media&token=7cb335bb-6d11-453b-8bb2-3d96d89a67c3'),
(419, 148, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43257_case_thermaltake_view_37_rgb_edition_0005_1__1_.jpg?alt=media&token=9382035e-836d-469b-8013-90d470e3b9aa'),
(420, 149, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43987_case_thermaltake_level_20_gt_rgb_plus_edition_0000_1__4_.jpg?alt=media&token=03d1930f-b5ee-4253-be68-f5de3717a060'),
(421, 149, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43987_case_thermaltake_level_20_gt_rgb_plus_edition_0003_1__1_.jpg?alt=media&token=0c809ba7-5deb-44a2-bab3-15a241404d3c'),
(422, 149, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43987_case_thermaltake_level_20_gt_rgb_plus_edition_0002_1__2_.jpg?alt=media&token=2b87533c-604c-4c8e-99c7-cfb47eadb7ec'),
(423, 149, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F43987_case_thermaltake_level_20_gt_rgb_plus_edition_0001_1__3_.jpg?alt=media&token=dddc3903-3cd0-48b8-8242-9158354fae4e'),
(424, 150, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47875_02_vg279q.jpg?alt=media&token=c99b635e-d19f-4f87-9136-8981007d6cb9'),
(425, 150, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47875_05_vg279q.jpg?alt=media&token=68301ded-4876-4536-b1ae-3ae969c3feaa'),
(426, 150, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47875_04_vg279q.jpg?alt=media&token=4a03ccaf-5cd6-4d1e-bfab-edd65a3ac5aa'),
(427, 150, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47875_vg279q.jpg?alt=media&token=4e695746-e228-44b8-b0ae-ebb113d06706'),
(428, 150, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F47875_07_vg279q.jpg?alt=media&token=22f83d4b-169b-4459-99b2-2668c03667a4'),
(429, 151, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38371_07_xg258q.jpg?alt=media&token=25127186-5e11-4ec0-8a29-022b62fc05c1'),
(430, 151, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38371_08_xg258q.jpg?alt=media&token=38d18e9a-baad-459e-9fd9-c894a24d8e33'),
(431, 151, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38371_02_xg258q.jpg?alt=media&token=2ba30860-d11d-48c2-a626-6a5f20b5e952'),
(432, 151, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38371_06_xg258q.jpg?alt=media&token=fdb1babc-504c-403d-9ce6-e76f89da9d13'),
(433, 151, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38371_xg258q.jpg?alt=media&token=55a691c0-a52b-433f-b419-74b01749ae83'),
(434, 152, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F17031_dell_u2414h__3_.png?alt=media&token=124aba0b-eee9-4156-ab4b-300c3b7a873e'),
(435, 152, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F17031_dell_u2414h__1_.png?alt=media&token=dbdd1ea9-7f64-4a33-be1e-b6f7dedcacc8'),
(436, 152, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F17031_dell_u2414h__2_.png?alt=media&token=def16dbe-07b2-4f1a-8eef-770b1775ca0f'),
(437, 152, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F17031_dell_u2414h__4_.png?alt=media&token=df98dc3c-4cdc-4ab3-a577-57c8427d97e9'),
(438, 153, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44883_dell_u2419h__2_.png?alt=media&token=5cacfec5-092e-4122-a2b0-923067223c92'),
(439, 153, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44883_dell_u2419h__1_.png?alt=media&token=30e7ffb9-35ed-4e36-a1b0-fa8070cec635'),
(440, 153, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44883_dell_u2419h__3_.png?alt=media&token=9df34110-ab4a-4b96-9418-8b0ef064a019'),
(441, 153, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44883_dell_u2419h__0_.png?alt=media&token=37669106-eb21-4a0f-b192-31de24dadf8c'),
(442, 154, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33516_samsung_c24f390f__2_.png?alt=media&token=067142cc-ef1b-468c-9c8f-46ac236d4809'),
(443, 154, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33516_samsung_c24f390f__3_.png?alt=media&token=1993d4cd-c472-41b4-9f71-a18f57301944'),
(444, 154, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33516_samsung_c24f390f__1_.png?alt=media&token=a4fe3ffc-4877-492e-a326-3f0d8d68b226'),
(445, 154, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33516_samsung_c24f390f__4_.png?alt=media&token=94856862-a0f4-499e-ae40-cbb891caaa36'),
(446, 155, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33517_samsung_c27f390fh__0.png?alt=media&token=2cb0ce94-15dd-4c4f-9e46-a4f151b2a7bd'),
(447, 155, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F33517_samsung_c27f390fh__3_.png?alt=media&token=505c27dc-fdf8-42d0-b2b8-3be766ce2f81'),
(448, 156, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F8782_loa_logitech_z906_51_0001_2.jpg?alt=media&token=1c6fb2fd-a6d1-4e28-a493-5e83497d124c'),
(449, 156, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F8782_loa_logitech_z906_51_0000_1.jpg?alt=media&token=0248588d-9546-441b-ba41-dd52298aea73'),
(450, 156, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F8782_10343_hanoicomputer_93922_1.jpg?alt=media&token=fa84480a-9565-4300-9491-11ab75344173'),
(451, 156, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F8782_loa_logitech_z906_51_0002_3.jpg?alt=media&token=f79ac457-b789-42e8-a4c6-96806ba2b5cf'),
(452, 157, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F3540_logitech_z313___2_1__2_.jpg?alt=media&token=cfa54754-5733-4fe3-88fc-c95e097a358d'),
(453, 157, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F3540_logitech_z313___2_1.jpg?alt=media&token=b51afd0f-45ff-4abc-88b8-5cebf04b7e8c'),
(454, 157, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F3540_logitech_z313___2_1__3_.jpg?alt=media&token=f8c62db6-c38f-435e-9fd5-768eaad66918'),
(455, 157, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F3540_logitech_z313.png?alt=media&token=129c173b-ba02-44e6-a580-f01c5a79b9c9'),
(456, 158, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F6920_edifier_m1380.png?alt=media&token=b97464db-7357-447f-8d67-4a3ab6031ada'),
(457, 159, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F28286_edifier_r1700bt_2_0__4_.jpg?alt=media&token=8ae4e18e-6e75-422a-87a5-79b36dc5ca49'),
(458, 159, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F28286_edifier_r1700bt_2_0.jpg?alt=media&token=e348272d-c637-43b8-8e7d-478221a6dd07'),
(459, 159, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F28286_edifier_r1700bt_2_0__3_.jpg?alt=media&token=59a67b65-916a-4318-b09c-61a382c095b3'),
(460, 159, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F28286_edifier_r1700bt.png?alt=media&token=57079d0f-429c-4dc0-8028-02418a957b10'),
(461, 159, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F28286_edifier_r1700bt_2_0__6_.jpg?alt=media&token=dcf01121-7b19-40be-a2ed-3739bb1e8704'),
(462, 160, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F1928_loa_soundmax_a4000___4_1_01.jpg?alt=media&token=f6ff468b-379c-4460-addd-f8718f5c956f'),
(463, 160, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F1928_spsm010_.jpg?alt=media&token=1f2f7b89-d93a-405a-8ebb-4da23670663f'),
(464, 160, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F1928_loa_soundmax_a4000___4_1.jpg?alt=media&token=399f4ea7-9bfe-4901-9ce7-887625e6da36'),
(465, 161, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F1910_spsm042_.jpg?alt=media&token=a900bed4-611e-45a3-b86c-f25f5bb59716'),
(466, 161, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F1910_loa_soundmax_a820___2_1.png?alt=media&token=7c001459-88bb-405e-abff-d07ca578b743'),
(467, 162, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55761_ghe_game_corsair_t3_rush_charcoal_0000_1.jpg?alt=media&token=4810a363-b79d-429d-9cda-9e22e333dd2c'),
(468, 162, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55761_ghe_game_corsair_t3_rush_charcoal_0001_2.jpg?alt=media&token=368fb62d-4adf-4e9d-b6d3-ba592812f4d8'),
(469, 162, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55761_ghe_game_corsair_t3_rush_charcoal_0005_6.jpg?alt=media&token=43e448e6-3d04-416e-b962-599c3a50951c'),
(470, 162, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55761_ghe_game_corsair_t3_rush_charcoal_0003_4.jpg?alt=media&token=c2a51bdf-5e0c-4247-8ebb-9923cec8a390'),
(471, 163, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55762_ghe_game_corsair_t3_rush_gray_white_0005_6.jpg?alt=media&token=047047d2-20f4-4c68-a8ce-49cc02750129'),
(472, 163, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55762_ghe_game_corsair_t3_rush_gray_white_0001_2.jpg?alt=media&token=337bdae6-b530-429d-80f6-a06e2b27e177'),
(473, 163, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55762_ghe_game_corsair_t3_rush_gray_white_0004_5.jpg?alt=media&token=218007a5-2543-4241-b01e-baf33fb5a2c6'),
(474, 163, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F55762_ghe_game_corsair_t3_rush_gray_white_0003_4.jpg?alt=media&token=36e7cfde-c922-4faa-87b1-afde41030891'),
(475, 164, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57090_ghe_game_msi_mag_ch120_0001_2.jpg?alt=media&token=908672e2-3792-4b5b-b65b-7d43fa112280'),
(476, 164, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57090_ghe_game_msi_mag_ch120_0002_3.jpg?alt=media&token=98a72974-2218-4439-a31f-591cae2eca88'),
(477, 164, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57090_ghe_game_msi_mag_ch120_0000_1.jpg?alt=media&token=6b058085-1baa-4765-ab68-5698b14a7a1b'),
(478, 165, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57091_ghe_game_msi_mag_ch120x_0005_6.jpg?alt=media&token=25c4f085-e01d-4e61-8d75-7e77accafce6'),
(479, 165, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57091_ghe_game_msi_mag_ch120x_0003_4.jpg?alt=media&token=e6ccf4d2-fea5-4c1a-84c0-3c58e566fd66'),
(480, 165, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F57091_ghe_game_msi_mag_ch120x_0004_5.jpg?alt=media&token=f01f862a-57a6-4ba4-bbe7-d039f75f1bd0'),
(481, 166, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49968_e_dra_citizen_blackblack__egc200__03.jpg?alt=media&token=aa8341c1-81a2-4ca8-baf0-a44e50bae1d7'),
(482, 166, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49968_e_dra_citizen_blackblack__egc200__01.jpg?alt=media&token=47dcaaa4-0dfb-42fb-a620-229b227bdc5f'),
(483, 166, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49968_e_dra_citizen_blackblack__egc200__01%20(1).jpg?alt=media&token=b4859a8b-0de4-4ef7-83cc-5f575e023f8f'),
(484, 166, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F49968_e_dra_citizen_blackblack__egc200__05.jpg?alt=media&token=b71d83ed-9094-4fea-86dd-5591d85c4769'),
(485, 167, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51056_ghe_gamer_e_dra_hercules_egc203_0002.jpg?alt=media&token=77c38803-1425-43cb-b5e1-0ea95dbc04e7'),
(486, 167, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51056_ghe_gamer_e_dra_hercules_egc203_0001.jpg?alt=media&token=65232a21-3d12-4547-a63f-afb93ef5180d'),
(487, 167, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51056_ghe_gamer_e_dra_hercules_egc203_0003.jpg?alt=media&token=a4b02d99-96c6-419d-a737-39e0f2e348ce'),
(488, 167, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51056_ghe_gamer_e_dra_hercules_egc203_0004.jpg?alt=media&token=e9982851-62e9-46fe-bb9d-23b62a7a70ac'),
(489, 168, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52270_fan_case_coolermaster_masterfan_mf120_halo_3in1_0000_1__3_.jpg?alt=media&token=57dd0b8f-12a4-44e5-aae3-4510af684872'),
(490, 168, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52270_fan_case_coolermaster_masterfan_mf120_halo_3in1_1_0000_1__2__copy_2.jpg?alt=media&token=8ab20f15-b6e7-4a11-ad6d-ea407d38d291'),
(491, 168, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52270_inwin_303_ek_0000_1__7_.jpg?alt=media&token=19903053-4392-4a9a-b372-a8b84d901ef5'),
(492, 168, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52270_inwin_303_ek_0004_1__3_.jpg?alt=media&token=9c09a151-71b2-4c91-a0d1-307146354cfb'),
(493, 168, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52270_inwin_303_ek_0005_1__2_.jpg?alt=media&token=6e1f6108-b436-41c8-866d-f077c42db715'),
(494, 169, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52271_fan_case_coolermaster_masterfan_mf120_halo_3in1_0002_1__1_.jpg?alt=media&token=2b5f372d-e512-42e3-a224-0539f6e7ad14'),
(495, 169, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52271_inwin_303_ek_0005_1__2_.jpg?alt=media&token=7c5c225a-cb85-4cee-884f-104c8b2e68ce'),
(496, 169, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52271_inwin_303_ek_1_1_1.jpg?alt=media&token=49ee8b35-8dcc-41a4-a1bf-4a0128c56da5'),
(497, 169, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F52271_inwin_303_ek_0004_1__3_.jpg?alt=media&token=080eeab2-c6a2-42f2-8333-49785952f1f0'),
(498, 170, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38915_fan_case_corsair_ll120_rgb_120mm_dual_light_loop_rgb_led_3.jpg?alt=media&token=8cc5f12f-dab0-4736-8422-4c3ed2c0afbe'),
(499, 170, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38915_fan_case_corsair_ll120_rgb_120mm_dual_light_loop_rgb_led_3_fan.jpg?alt=media&token=ec803bba-89ae-4eb9-907a-709534f883d2'),
(500, 170, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38915_fan_case_corsair_ll120_rgb_120mm_dual_light_loop_rgb_led_3%20(2).jpg?alt=media&token=a9c34a21-d74e-4b8d-b3ea-f9f7d0a527f5'),
(501, 170, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F38915_fan_case_corsair_ll120_rgb_120mm_dual_light_loop_rgb_led_3%20(1).jpg?alt=media&token=f462a9e1-6bf0-42f5-8c38-a40d2bea63c1'),
(502, 171, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51515_bo_3_quat_may_tinh_120mm_corsair_ql120_pro_rgb_kem_node_core_new_co_9050098_ww_10.jpg?alt=media&token=a168388e-24c8-4cad-8c48-213bb7fb8d50');
INSERT INTO `product_image` (`product_image_id`, `product_id`, `image`) VALUES
(503, 171, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51515_bo_3_quat_may_tinh_120mm_corsair_ql120_pro_rgb_kem_node_core_new_co_9050098_ww_8.jpg?alt=media&token=f75eff6a-48f9-4043-b93a-15164a2aa9f5'),
(504, 171, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51515_bo_3_quat_may_tinh_120mm_corsair_ql120_pro_rgb_kem_node_core_n.jpg?alt=media&token=36ca2f77-eeb9-41c5-b022-90458ce9e7c2'),
(505, 171, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51515_bo_3_quat_may_tinh_120mm_corsair_ql120_pro_rgb_kem_node_core_new_co_9050098_ww_7.jpg?alt=media&token=a930bd8b-42bb-4920-ac7e-8d138e6b95ce'),
(506, 172, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44908_ek_furious_vardar_evo_120_bb_750_3000rpm_0005_1__1_.jpg?alt=media&token=0e36e866-be2f-4ff6-aca2-e060ac1550f9'),
(507, 172, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44908_ek_furious_vardar_evo_120_bb_750_3000rpm_0002_1__4_.jpg?alt=media&token=226a8533-6e56-4659-bc2a-e6b401dd3448'),
(508, 172, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F44908_ek_furious_vardar_evo_120_bb_750_3000rpm_0004_1__2_.jpg?alt=media&token=34b94372-b577-402d-9afc-f0c54bb2e31d'),
(509, 173, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51381_1ek_vardar_x3m_120er_d_rgb__500_2200rpm____black_0001_2.jpg?alt=media&token=8325da72-8ac4-40ad-9174-7de77d14a5a5'),
(510, 173, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51381_1ek_vardar_x3m_120er_d_rgb__500_2200rpm____black_0003_4.jpg?alt=media&token=0dd5e2d9-0ea9-4a8c-9754-52c8a8afecc3'),
(511, 173, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51381_1ek_vardar_x3m_120er_d_rgb__500_2200rpm____black_0005_6.jpg?alt=media&token=291655f8-7e84-4261-96b1-21cbe1b4eaec'),
(512, 173, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F51381_ek_x3m_3.jpg?alt=media&token=2aa23ee8-14a7-4c75-90bc-ca85cc06d60f'),
(513, 174, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59067_gigabyte_aorus_water_force_x_360__3_%20(1).jpg?alt=media&token=2dd4d37f-c638-4221-842c-b30d48434c87'),
(514, 174, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59067_gigabyte_aorus_water_force_x_360__7_.jpg?alt=media&token=e5c63355-e640-449e-bdf8-54ec8e8658ec'),
(515, 174, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59067_gigabyte_aorus_water_force_x_360__5_.jpg?alt=media&token=84cf9194-eefb-4858-b4e6-45df94b06e6c'),
(516, 174, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59067_gigabyte_aorus_water_force_x_360__3_.jpg?alt=media&token=69ef1f45-b653-4499-a6fd-0f930e44d1ad'),
(517, 174, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59067_gigabyte_aorus_water_force_x_360__6_.jpg?alt=media&token=fcc98d83-7bf5-4830-8ee1-ff51bed6bc71'),
(518, 175, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59066_aorus_waterforce_x_280__5_.jpg?alt=media&token=5616f2e2-17ff-4ac1-93ec-83a95425f4bd'),
(519, 175, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59066_aorus_waterforce_x_280__1_.jpg?alt=media&token=25dfb0e8-be93-4bf4-aaa5-1dc12ebafb93'),
(520, 175, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59066_aorus_waterforce_x_280__2_.jpg?alt=media&token=9cef7987-3f4b-45fa-aeff-bd422d56b88e'),
(521, 175, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59066_aorus_waterforce_x_280__3_.jpg?alt=media&token=11f83591-276c-4374-b9cd-d49b748c3ae1'),
(522, 176, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58178_asus_strix_lc_360_rgb_gundam_7_file__3_.jpg?alt=media&token=f984e7d7-8e00-40d2-afcc-06b9d50f5db3'),
(523, 176, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58178_asus_strix_lc_360_rgb_gundam_7_file__6_%20(1).jpg?alt=media&token=342c7e95-86c1-49f0-8ce6-e1a801edf49b'),
(524, 176, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58178_asus_strix_lc_360_rgb_gundam_7_file__6_.jpg?alt=media&token=8856b034-dcb2-481b-a0e7-f668c0011ef6'),
(525, 176, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58178_asus_strix_lc_360_rgb_gundam_7_file__1_.jpg?alt=media&token=b3c66451-c319-4f31-8334-474d483d1b36'),
(526, 176, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58178_asus_strix_lc_360_rgb_gundam_7_file__7_.jpg?alt=media&token=c2102e62-3dd4-4df3-b1e1-28307dc9999e'),
(527, 177, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58177_asus_strix_lc_360_rgb_black_10.jpg?alt=media&token=891f930e-e68d-4be8-ad86-fa2b61e98a0b'),
(528, 177, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58177_asus_strix_lc_360_rgb_black_13_edit.jpg?alt=media&token=1e110368-04b0-4878-a375-1909bdaffe76'),
(529, 177, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F58177_asus_strix_lc_360_rgb_black_1.png?alt=media&token=65118198-6b61-4fbd-8fd1-36f398dd539d'),
(530, 178, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59021_corsair_h100i_rgb_platinum_se__4_.jpg?alt=media&token=2c9dcf44-7241-49a9-96da-457dd6e84b56'),
(531, 178, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59021_corsair_h100i_rgb_platinum_se__1_.jpg?alt=media&token=1a0697c6-95e0-4fd7-8ce6-679580f63336'),
(532, 178, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59021_corsair_h100i_rgb_platinum_se__5_.jpg?alt=media&token=25286803-bf3a-477b-8771-88a073839fa9'),
(533, 178, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59021_corsair_h100i_rgb_platinum_se__6_.jpg?alt=media&token=e721bdf3-9a2a-400c-a78d-ed491bbb9160'),
(534, 179, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59020_corsair_h100i_rgb_platinum_1__6_.png?alt=media&token=a228b826-aac7-4f57-a7b6-d5c2179d2e1b'),
(535, 179, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59020_corsair_h100i_rgb_platinum_1__1_.png?alt=media&token=14bf45a8-d2ad-4e60-86f5-a5b5b6fd99db'),
(536, 179, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59020_corsair_h100i_rgb_platinum_1__8_.png?alt=media&token=4469471e-3423-4bfd-8597-1574dbdf3429'),
(537, 179, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59020_corsair_h100i_rgb_platinum_1__4_.png?alt=media&token=60ce52e7-ea7a-4d18-85a8-fe6c4a7e0707'),
(538, 179, 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fproduct%2F59020_corsair_h100i_rgb_platinum_1__1_%20(1).png?alt=media&token=cd13a186-4227-499c-80ed-8c072e673164');

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
(1, 1, 1, 10),
(2, 2, 1, 11),
(3, 3, 1, 10),
(4, 4, 1, 10),
(5, 5, 1, 10);

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
(1, 'RAM', '- Bộ nhớ trong'),
(2, 'SSD', '- Ổ cứng'),
(3, 'Laptop', ' - Máy tính xách tay'),
(8, 'CPU', '- Bộ vi xử lý'),
(9, 'Main', '- Bo mạch chủ'),
(10, 'VGA', '- Card đồ họa'),
(11, 'PSU', '- Nguồn máy tính'),
(12, 'CASE', '- Vỏ cây máy tính'),
(13, 'Headphone', '- Tai nghe'),
(14, 'Keyboard', '- Bàn phím'),
(15, 'Mouse', '- Chuột '),
(16, 'Màn hình', NULL),
(17, 'Loa', '- Loa âm thanh'),
(18, 'Ghế gaming', NULL),
(19, 'Fan Case', '- Quạt làm mát'),
(20, 'Tản nhiệt nước', NULL),
(21, 'HDD', '- Ổ cứng');

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
(1, '2021-05-25');

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
  `hotline` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdBy` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `updatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `supplier_name`, `supplier_address`, `email`, `hotline`, `createdBy`, `created_at`, `updatedBy`, `updatedDate`) VALUES
(1, 'Hà Nội Computer', 'Số  48 Thái Hà - Đống Đa - Hà Nội', 'Hoangphuong@anphatpc.com.vn', '0918.557.001', 2, '2021-05-18 04:20:32', 0, '0000-00-00 00:00:00'),
(5, 'An Phát', 'Hà Nội', 'huy@anphatpc.com.vn', '19000323', 2, '2021-05-18 04:20:32', 0, '0000-00-00 00:00:00'),
(6, 'Phong Vũ', 'số 371/ 20 Hai Bà Trưng, Phường 8, Quận 3, TPHCM', 'hoptac@phongvu.vn', '18006865', 2, '2021-05-18 04:20:32', 2, '2021-05-24 07:56:22'),
(7, 'KCC Shop', 'Số 2, ngõ 43 Cổ Nhuế, Phường Cổ Nhuế 2, Quận Bắc Từ Liêm, Thành phố Hà Nội', 'kccshop@gmail.com', '0912.074.444', 2, '2021-05-18 04:20:32', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trademark`
--

CREATE TABLE `trademark` (
  `trademark_id` int(11) NOT NULL,
  `trademark_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdBy` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `updatedDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `trademark`
--

INSERT INTO `trademark` (`trademark_id`, `trademark_name`, `image`, `createdBy`, `created_at`, `updatedBy`, `updatedDate`) VALUES
(1, 'Dell', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/dell.PNG?alt=media&token=ee683a78-56df-46e4-8441-09598fdcaf5f', 2, '2021-05-18 04:42:37', 2, '2021-05-24 03:01:41'),
(2, 'Asus', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/asus.jpg?alt=media&token=70e92d2d-cfa5-420f-9626-07da6fb2723a', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(3, 'Macbook', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/apple.jpg?alt=media&token=59351197-9d07-4188-bef6-991f0f18683f', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(4, 'LG', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Flg.jpg?alt=media&token=a856e46f-2237-4536-adc0-8573d632f6da', 2, '2021-05-18 04:42:37', 13, '2021-05-29 06:20:16'),
(5, 'Gskill', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/G.Skill.gif?alt=media&token=0a6977b4-7148-441f-bc84-b11380282d13', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(11, 'Micron', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/micron.jpg?alt=media&token=89c22c6a-6b7e-4cf8-950f-c12eb7b6cd17', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(12, 'Kingston', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/kingston.png?alt=media&token=2336f5ab-5a0d-498c-950c-fac8298888df', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(13, 'AXPRO', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/axpro.jpg?alt=media&token=7e1c5618-6a53-4d10-8d73-5d3dd316759f', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(14, 'MSI', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/msi.png?alt=media&token=53189108-b2a0-4f7f-afa5-53825b10d14b', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(15, 'GIGABYTE', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/gigabyte.jpg?alt=media&token=9a85520a-6999-4415-80ec-43054e42d47f', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(16, 'ASRock', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/asrock.jpg?alt=media&token=534b7ccc-b271-441b-a942-cb95ae97d7fe', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(17, 'AMD', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/amd.jpg?alt=media&token=6812eb2f-a064-454b-9c69-f1a32a519c7c', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(18, 'Intel', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/intel.jpg?alt=media&token=97ad12cd-531a-448f-b865-52e46ea74741', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(19, 'Jetek', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/jetek.jpg?alt=media&token=22ee61dc-dfa9-4fc8-884e-d6b830ba1a08', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(20, 'FSP', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/fsp.jpg?alt=media&token=024297e4-abf8-4c88-a513-748146afaeb8', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(21, 'Corsair', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/corsair.jpg?alt=media&token=64d20c4f-bdee-43d4-885c-ab8b5a93a434', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(22, 'Roccat', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/roccat.jpg?alt=media&token=fa2af8b6-ef92-459a-a791-dfad62504688', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(23, 'V-King', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/vking.jpg?alt=media&token=f00cb31d-ee1d-4515-836c-7540c55f46b9', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(24, 'Cougar', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/cougar.jpg?alt=media&token=d7cd5847-7827-44b8-b824-017b596121e8', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(25, 'Zidli', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/zidli.jpg?alt=media&token=29316d2b-d1d8-4d20-b009-0236c6fc0b4d', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(26, 'Logitech', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/logitech.jpg?alt=media&token=27749e09-9aa1-4f79-a3c5-a554783e99ac', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(27, 'Fuhlen', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/fuhlen.jpg?alt=media&token=5a0e2ec1-6504-4863-802a-21139203bdc2', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(28, 'Geezer', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/geezer.jpg?alt=media&token=9e32aee8-b890-4ed5-947b-223d4e844230', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(29, 'Eblue', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/eblue.jpg?alt=media&token=732ea669-a3b6-4993-a4c6-4e1170542624', 2, '2021-05-18 04:42:37', 0, '0000-00-00 00:00:00'),
(42, 'Acer', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Facer.jpg?alt=media&token=297f1de2-e28c-4e12-a22b-f4fb16ca5b88', 2, '2021-05-24 10:47:38', NULL, NULL),
(43, 'Lenovo', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Flenovo.jpg?alt=media&token=707e6ad3-d06a-4743-859f-696ec08a28c4', 2, '2021-05-24 11:23:54', NULL, NULL),
(44, 'Adata', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fadata.jpg?alt=media&token=537fa41f-e092-4c8d-9396-1f7c6f4a5805', 2, '2021-05-25 10:14:35', NULL, NULL),
(45, 'Cooler Master', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fcoolermaster.jpg?alt=media&token=5ba9e06b-684c-4d65-b16a-16443998db31', 2, '2021-05-25 10:47:09', NULL, NULL),
(46, 'LEADTEK', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fleadtek.jpg?alt=media&token=4959c886-25e8-4370-894f-a966d60eaf28', 2, '2021-05-25 10:58:45', NULL, NULL),
(47, 'INNO3D', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Finno3d.jpg?alt=media&token=74e5be40-ef5d-451c-b3d5-c97efb547a6e', 2, '2021-05-25 10:59:37', NULL, NULL),
(48, 'Razer', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Frazer.jpg?alt=media&token=8bdaccbd-9f1a-4e75-b1c4-65bf695c81e7', 2, '2021-05-25 11:15:13', NULL, NULL),
(49, 'AKKO', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fakko.jpg?alt=media&token=98585389-12c1-4ec9-bbcf-ea1d98b7f688', 2, '2021-05-25 11:23:25', NULL, NULL),
(50, 'E-Dra', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fedra.jpg?alt=media&token=5e3297d1-68f0-48d0-9999-cf30a07ff03e', 2, '2021-05-25 11:23:41', NULL, NULL),
(51, 'Seagate', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fseagate.jpg?alt=media&token=14f60eec-0b13-41ec-8173-a56588eacd0f', 2, '2021-05-25 11:54:34', NULL, NULL),
(52, 'Toshiba', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Ftoshiba.jpg?alt=media&token=c4f1fa20-e12e-4f55-ae16-75ce7ce099e5', 2, '2021-05-25 11:54:49', NULL, NULL),
(53, 'Western', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fwesterndigital.jpg?alt=media&token=8a0d11de-c50d-481c-bef0-215578708368', 2, '2021-05-25 11:55:32', NULL, NULL),
(54, 'Thermaltake', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fthermaltake.jpg?alt=media&token=9cb6f966-ba18-4493-ab94-2273bfa8016e', 2, '2021-05-25 12:07:03', NULL, NULL),
(55, 'Phanteks', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fphanteks.jpg?alt=media&token=fc39d60c-518a-4696-86ba-6b5ec5227725', 2, '2021-05-25 12:07:21', NULL, NULL),
(56, 'Samsung', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fsamsung.jpg?alt=media&token=94d76b4e-d2bf-4167-8d3d-89855464470f', 2, '2021-05-25 04:12:35', NULL, NULL),
(57, 'Sony', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fsony.jpg?alt=media&token=4574e6be-8fbd-4095-91a9-85d9a1f18a61', 2, '2021-05-25 04:34:10', NULL, NULL),
(58, 'SoundMax', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fsoundmax.jpg?alt=media&token=6401f1b5-9843-4cf4-b92b-57bac63d6b1e', 2, '2021-05-25 04:34:28', NULL, NULL),
(59, 'Edifier', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fedifier.jpg?alt=media&token=83b09cd4-0505-476f-bae8-d2bbef565767', 2, '2021-05-25 04:38:43', NULL, NULL),
(60, 'EKWB', 'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Ftrademark%2Fekwb.jpg?alt=media&token=50310703-54e2-4225-b68f-fb0dc75dfb3e', 2, '2021-05-25 04:52:51', NULL, NULL);

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
(6, 14, 50);

-- --------------------------------------------------------

--
-- Cấu trúc cho view `inventoryproducts`
--
DROP TABLE IF EXISTS `inventoryproducts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `inventoryproducts`  AS SELECT `product`.`product_id` AS `product_id`, `product`.`product_name` AS `product_name`, `product`.`trademark_id` AS `trademark_id`, `product`.`product_type_id` AS `product_type_id`, `product`.`price` AS `price`, `product`.`amount` AS `amount`, `product`.`warranty` AS `warranty`, `product`.`description` AS `description`, `trademark`.`trademark_name` AS `trademark_name`, `product_type`.`product_type_name` AS `product_type_name` FROM ((`product` join `trademark`) join `product_type`) WHERE `product`.`product_type_id` = `product_type`.`product_type_id` AND `product`.`trademark_id` = `trademark`.`trademark_id` AND `product`.`amount` > 0 ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `products`
--
DROP TABLE IF EXISTS `products`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `products`  AS SELECT `product`.`product_id` AS `product_id`, `product`.`product_name` AS `product_name`, `product`.`trademark_id` AS `trademark_id`, `product`.`product_type_id` AS `product_type_id`, `product`.`price` AS `price`, `product`.`amount` AS `amount`, `product`.`warranty` AS `warranty`, `product`.`description` AS `description`, `trademark`.`trademark_name` AS `trademark_name`, `product_type`.`product_type_name` AS `product_type_name` FROM ((`product` join `trademark`) join `product_type`) WHERE `product`.`product_type_id` = `product_type`.`product_type_id` AND `product`.`trademark_id` = `trademark`.`trademark_id` ;

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
-- Chỉ mục cho bảng `build_pc`
--
ALTER TABLE `build_pc`
  ADD PRIMARY KEY (`build_pc_id`);

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
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `account_type`
--
ALTER TABLE `account_type`
  MODIFY `account_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `bill`
--
ALTER TABLE `bill`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `bill_detail`
--
ALTER TABLE `bill_detail`
  MODIFY `bill_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT cho bảng `build_pc`
--
ALTER TABLE `build_pc`
  MODIFY `build_pc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `comment`
--
ALTER TABLE `comment`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `coupon`
--
ALTER TABLE `coupon`
  MODIFY `coupon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `coupon_detail`
--
ALTER TABLE `coupon_detail`
  MODIFY `coupon_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT cho bảng `news`
--
ALTER TABLE `news`
  MODIFY `news_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT cho bảng `product_image`
--
ALTER TABLE `product_image`
  MODIFY `product_image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=540;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `product_image_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_promotion`
--
ALTER TABLE `product_promotion`
  MODIFY `product_promotion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `product_promotions`
--
ALTER TABLE `product_promotions`
  MODIFY `product_promotion_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_type`
--
ALTER TABLE `product_type`
  MODIFY `product_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `promotion_date`
--
ALTER TABLE `promotion_date`
  MODIFY `promotion_date_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT cho bảng `trademark`
--
ALTER TABLE `trademark`
  MODIFY `trademark_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `voucher`
--
ALTER TABLE `voucher`
  MODIFY `voucher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
