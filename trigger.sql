use webbangiayphp;
SET SQL_SAFE_UPDATES = 0;

-- phiếu nhập
-- cập nhật số lượng trong bảng sản phẩm sau khi thêm mới chi tiết phiếu nhập
-- cập nhật tổng tiền trong bảng phiếu nhập sau khi thêm chi tiết phiếu nhập
-- cập nhật giá bán trong bảng sản phẩm sau khi thêm chi tiết phiếu nhập
DELIMITER $$
create trigger after_coupon_detail_insert
after insert on webbangiayphp.chi_tiet_phieu_nhaps
for each row
begin
	declare muc1 double(15,2) default 500000.00;
    declare muc2 double(15,2) default 2000000.00;
    declare muc3 double(15,2) default 10000000.00;
    declare muc4 double(15,2) default 20000000.00;
    declare muc5 double(15,2) default 50000000.00;
    declare muc6 double(15,2) default 100000000.00;
	declare masp bigint(20);
    declare mapn bigint(20);
    declare ds_ldt varchar(255);
    declare slpn int(11) default 0;
    declare slsp int(11) default 0;
    declare sldtsp int(11) default -1;
    declare gia_nhap_sp double(15,2) default 0.00;
    declare gia_ban_sp double(15,2) default 0.00;
    declare tong_tien_pn double(15,2) default 0.00;
    
    set mapn = NEW.ma_phieu_nhap;
	set masp = NEW.ma_san_pham;
    set ds_ldt = NEW.danh_sach_loai_dac_trung;
    set slpn = NEW.so_luong;
    set gia_nhap_sp = NEW.gia_nhap;
    set slsp = (select so_luong from webbangiayphp.san_phams where san_phams.ma_san_pham = masp);
    set tong_tien_pn = (select tong_tien from webbangiayphp.phieu_nhaps where phieu_nhaps.ma_phieu_nhap = mapn);
	
    if gia_nhap_sp<=muc1 then
		set gia_ban_sp = (gia_nhap_sp*1.2);
	elseif gia_nhap_sp>muc1 and gia_nhap_sp<=muc2 then
		set gia_ban_sp = (gia_nhap_sp*1.15);
	elseif gia_nhap_sp>muc2 and gia_nhap_sp<=muc3 then
		set gia_ban_sp = (gia_nhap_sp*1.1);
	elseif gia_nhap_sp>muc3 and gia_nhap_sp<=muc4 then
		set gia_ban_sp = (gia_nhap_sp*1.08);
	elseif gia_nhap_sp>muc4 and gia_nhap_sp<=muc5 then
		set gia_ban_sp = (gia_nhap_sp*1.04);
	else
		set gia_ban_sp = (gia_nhap_sp*1.02);
	end if;
        
    set sldtsp = (select so_luong from webbangiayphp.dac_trung_san_phams where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp);
    if sldtsp>=0 then
		update dac_trung_san_phams set dac_trung_san_phams.so_luong = sldtsp + slpn where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp;
	else
		insert into dac_trung_san_phams (danh_sach_loai_dac_trung, ma_san_pham, so_luong, isActive) values (ds_ldt, masp, slpn, 1);
    end if;
    update webbangiayphp.phieu_nhaps set webbangiayphp.phieu_nhaps.tong_tien = (tong_tien_pn + slpn*gia_nhap_sp)
	where webbangiayphp.phieu_nhaps.ma_phieu_nhap = mapn;
    update webbangiayphp.san_phams set webbangiayphp.san_phams.so_luong = (slsp+slpn) where webbangiayphp.san_phams.ma_san_pham = masp;
    update webbangiayphp.san_phams set webbangiayphp.san_phams.gia_ban = gia_ban_sp where webbangiayphp.san_phams.ma_san_pham = masp;
end $$

-- cập nhật số lượng trong bảng sản phẩm sau khi xóa (update isActive) chi tiết phiếu nhập và isActive = false
-- cập nhật tổng tiền trong bảng phiếu nhập sau khi xóa (update isActive) chi tiết phiếu nhập
DELIMITER $$
create trigger after_coupon_detail_delete
after update on webbangiayphp.chi_tiet_phieu_nhaps
for each row
begin
	declare masp bigint(20);
    declare mapn bigint(20);
    declare ds_ldt varchar(255);
    declare slpn int(11) default 0;
    declare slsp int(11) default 0;
    declare sldtsp int(11) default -1;
    declare isActive tinyint(1);
    declare gia_nhap_sp double(15,2);
    declare tong_tien_pn double(15,2);
    
    set masp = NEW.ma_san_pham;
    set mapn = NEW.ma_phieu_nhap;
    set ds_ldt = NEW.danh_sach_loai_dac_trung;
    set slpn = NEW.so_luong;
    set isActive = NEW.isActive;
    set gia_nhap_sp = NEW.gia_nhap;
    
    set tong_tien_pn = (select tong_tien from webbangiayphp.phieu_nhaps where phieu_nhaps.ma_phieu_nhap = mapn);
    set slsp = (select so_luong from webbangiayphp.san_phams where san_phams.ma_san_pham = masp);    
    set sldtsp = (select so_luong from webbangiayphp.dac_trung_san_phams where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp);
    
    if isActive = 0 then
		update webbangiayphp.san_phams set webbangiayphp.san_phams.so_luong = (slsp-slpn) 
		where webbangiayphp.san_phams.ma_san_pham = masp;
        update webbangiayphp.phieu_nhaps set webbangiayphp.phieu_nhaps.tong_tien = (tong_tien - slpn*gia_nhap_sp) 
		where webbangiayphp.phieu_nhaps.ma_phieu_nhap = mapn;
        if sldtsp>=slpn then
			update dac_trung_san_phams set dac_trung_san_phams.so_luong = sldtsp - slpn where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp;
		end if;
    end if;
end $$

-- hóa đơn
-- cập nhật số lượng trong bảng sản phẩm sau khi thêm mới chi tiết hóa đơn và số lượng sản phẩm >= số lượng sản phẩm trong hóa đơn
-- cập nhật tổng tiền trong bảng hóa đơn sau khi thêm chi tiết hóa đơn
-- cập nhật thành tiền trong bảng hóa đơn sau khi thêm chi tiết hóa đơn
DELIMITER $$
create trigger after_bill_detail_insert
after insert on webbangiayphp.chi_tiet_hoa_dons
for each row
begin
	declare masp bigint(20);
    declare mahd bigint(20);
    declare ds_ldt varchar(255);
    declare slhd int(11) default 0;
    declare slsp int(11) default 0;
    declare sldtsp int(11) default -1;
    declare gia_ban_moi double(15,2) default 0;
    declare tong_tien_hd double(15,2) default 0.00;
    declare tt double(15,2) default 0.00;
    declare ma_voucher_hd bigint(20);
    declare muc_voucher_hd int(11) default 0;
    
    set mahd = NEW.ma_hoa_don;
	set masp = NEW.ma_san_pham;    
    set ds_ldt = NEW.danh_sach_loai_dac_trung;
    set gia_ban_moi = NEW.gia_ban;
    set slhd = NEW.so_luong;
    set sldtsp = (select so_luong from webbangiayphp.dac_trung_san_phams where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp);
    
    set tong_tien_hd = (select tong_tien from webbangiayphp.hoa_dons where hoa_dons.ma_hoa_don = mahd);
    set ma_voucher_hd = (select ma_voucher from webbangiayphp.hoa_dons where hoa_dons.ma_hoa_don = mahd);
    set slsp = (select so_luong from webbangiayphp.san_phams where san_phams.ma_san_pham = masp);
    
    if ma_voucher_hd is not null then
		set muc_voucher_hd = (select muc_voucher from webbangiayphp.vouchers where vouchers.ma_voucher = ma_voucher_hd);
    end if;
    
    if slsp >= slhd then
		set tt = (tong_tien_hd + gia_ban_moi*slhd);
		update san_phams set san_phams.so_luong = (slsp-slhd) where san_phams.ma_san_pham = masp;
        if muc_voucher_hd > 0 then
			update hoa_dons set hoa_dons.thanh_tien = tt*(1-muc_voucher_hd/100) where hoa_dons.ma_hoa_don = mahd;
			update hoa_dons set hoa_dons.tong_tien = tt where hoa_dons.ma_hoa_don = mahd;
			
			update vouchers set vouchers.isActive = 0 where vouchers.ma_voucher = ma_voucher_hd;
		else 
			update hoa_dons set hoa_dons.thanh_tien = tt where hoa_dons.ma_hoa_don = mahd;
			update hoa_dons set hoa_dons.tong_tien = tt where hoa_dons.ma_hoa_don = mahd;
		end if;
        if sldtsp>=slhd then
			update dac_trung_san_phams set dac_trung_san_phams.so_luong = sldtsp - slhd where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp;
		end if;
    end if;

end $$

-- cập nhật số lượng trong bảng sản phẩm sau khi xóa (update isActive) chi tiết hóa đơn và isActive = false
-- cập nhật tổng tiền trong bảng hóa đơn sau khi xóa (update isActive) chi tiết hóa đơn
DELIMITER $$
create trigger after_bill_detail_delete
after update on webbangiayphp.chi_tiet_hoa_dons
for each row
begin

    declare masp bigint(20);
    declare mahd bigint(20);
    declare ds_ldt varchar(255);
    declare slhd int(11) default 0;
    declare slsp int(11) default 0;
    declare sldtsp int(11) default -1;
    declare gia_ban_moi double(15,2) default 0;
    declare tong_tien_hd double(15,2) default 0.00;
    declare tt double(15,2) default 0.00;
    declare ma_voucher_hd bigint(20);
    declare muc_voucher_hd int(11) default 0;
    declare isactive tinyint(1);
    
    set mahd = NEW.ma_hoa_don;
	set masp = NEW.ma_san_pham;    
    set ds_ldt = NEW.danh_sach_loai_dac_trung;
    set gia_ban_moi = NEW.gia_ban;
    set slhd = NEW.so_luong;
    set sldtsp = (select so_luong from webbangiayphp.dac_trung_san_phams where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp);
    set isactive = NEW.isActive;
    
    set tong_tien_hd = (select tong_tien from webbangiayphp.hoa_dons where hoa_dons.ma_hoa_don = mahd);
    set ma_voucher_hd = (select ma_voucher from webbangiayphp.hoa_dons where hoa_dons.ma_hoa_don = mahd);
    set slsp = (select so_luong from webbangiayphp.san_phams where san_phams.ma_san_pham = masp);
    
    if ma_voucher_hd is not null then
		set muc_voucher_hd = (select muc_voucher from webbangiayphp.vouchers where vouchers.ma_voucher = ma_voucher_hd);
    end if;
    
    if isactive = 0 then
		set tt = (tong_tien_hd - gia_ban_moi*slhd);
		update san_phams set san_phams.so_luong = (slsp+slhd) where san_phams.ma_san_pham = masp;
        if muc_voucher_hd > 0 then
			update hoa_dons set hoa_dons.thanh_tien = tt*(1-muc_voucher_hd/100) where hoa_dons.ma_hoa_don = mahd;
			update hoa_dons set hoa_dons.tong_tien = tt where hoa_dons.ma_hoa_don = mahd;
			
		else 
			update hoa_dons set hoa_dons.thanh_tien = tt where hoa_dons.ma_hoa_don = mahd;
			update hoa_dons set hoa_dons.tong_tien = tt where hoa_dons.ma_hoa_don = mahd;
		end if;
        update dac_trung_san_phams set dac_trung_san_phams.so_luong = sldtsp + slhd where dac_trung_san_phams.danh_sach_loai_dac_trung = ds_ldt and dac_trung_san_phams.ma_san_pham = masp;
    end if;
end $$

-- voucher
-- tặng voucher sau khi khách hàng tạo tài khoản
DELIMITER $$
create trigger after_account_create
after insert on webbangiayphp.tai_khoans
for each row
begin
    declare makh bigint(20);
    declare loaitk varchar(255);
    set makh = NEW.ma_tai_khoan;
    set loaitk = NEW.loai_tai_khoan;
    if loaitk = 'KH' then
		insert into webbangiayphp.vouchers (ma_khach_hang, muc_voucher) values (makh, 50);
    end if;
end $$

-- tặng voucher cho khách hàng khi có sản phẩm mới
DELIMITER $$
create trigger after_product_insert
after insert on webbangiayphp.san_phams
for each row
begin
    declare makh bigint(20);
    
    declare list_makh cursor for (select ma_tai_khoan from webbangiayphp.tai_khoans where tai_khoans.loai_tai_khoan = 'KH');
    open list_makh;
	fetch list_makh into makh;
        insert into vouchers (ma_khach_hang, muc_voucher) values (makh, 20); 
    close list_makh;
end $$

-- tạo view cho sản phẩm
create view products as
select san_phams.*, ten_thuong_hieu, ten_loai_san_pham, 
(select hinh_anh from hinh_anh_san_phams where hinh_anh_san_phams.ma_san_pham = san_phams.ma_san_pham and hinh_anh is not null and hinh_anh_san_phams.isActive = 1 limit 1) as image
from san_phams, thuong_hieus, loai_san_phams
where san_phams.ma_loai_san_pham = loai_san_phams.ma_loai_san_pham
and san_phams.ma_thuong_hieu = thuong_hieus.ma_thuong_hieu;

-- tạo view cho sản phẩm kết hợp với khuyến mãi
DELIMITER $$
create procedure listProduct(in ngay date)
begin
	select san_phams.*, ten_thuong_hieu, ten_loai_san_pham, 
	(select muc_khuyen_mai from khuyen_mai_san_phams, ngay_khuyen_mais where khuyen_mai_san_phams.ma_ngay_khuyen_mai = ngay_khuyen_mais.ma_ngay_khuyen_mai and ngay_khuyen_mais.ngay_gio = ngay and khuyen_mai_san_phams.ma_san_pham = san_phams.ma_san_pham) as muc_km,
	(select hinh_anh from hinh_anh_san_phams where hinh_anh_san_phams.ma_san_pham = san_phams.ma_san_pham and hinh_anh is not null and hinh_anh_san_phams.isActive = 1 limit 1) as image,
	(gia_ban*(1-(select muc_khuyen_mai from khuyen_mai_san_phams, ngay_khuyen_mais where khuyen_mai_san_phams.ma_ngay_khuyen_mai = ngay_khuyen_mais.ma_ngay_khuyen_mai and ngay_khuyen_mais.ngay_gio = ngay and khuyen_mai_san_phams.ma_san_pham = san_phams.ma_san_pham and ngay_khuyen_mais.ngay_gio is not null)/100)) as gia_moi
	from san_phams, thuong_hieus, loai_san_phams
	where san_phams.ma_loai_san_pham = loai_san_phams.ma_loai_san_pham
	and san_phams.ma_thuong_hieu = thuong_hieus.ma_thuong_hieu;
end $$

call listProduct('2020-10-30');

-- tạo view cho sản phẩm theo id kết hợp với khuyến mãi
DELIMITER $$
create procedure itemProduct(in ngay date, in masp bigint(20))
begin
	select san_phams.*, ten_thuong_hieu, ten_loai_san_pham, 
	(select muc_khuyen_mai from khuyen_mai_san_phams, ngay_khuyen_mais where khuyen_mai_san_phams.ma_ngay_khuyen_mai = ngay_khuyen_mais.ma_ngay_khuyen_mai and ngay_khuyen_mais.ngay_gio = ngay and khuyen_mai_san_phams.ma_san_pham = san_phams.ma_san_pham) as muc_km,
	(select hinh_anh from hinh_anh_san_phams where hinh_anh_san_phams.ma_san_pham = san_phams.ma_san_pham and hinh_anh is not null and hinh_anh_san_phams.isActive = 1 limit 1) as image,
	(gia_ban*(1-(select muc_khuyen_mai from khuyen_mai_san_phams, ngay_khuyen_mais where khuyen_mai_san_phams.ma_ngay_khuyen_mai = ngay_khuyen_mais.ma_ngay_khuyen_mai and ngay_khuyen_mais.ngay_gio = ngay and khuyen_mai_san_phams.ma_san_pham = san_phams.ma_san_pham and ngay_khuyen_mais.ngay_gio is not null)/100)) as gia_moi
	from san_phams, thuong_hieus, loai_san_phams
	where san_phams.ma_loai_san_pham = loai_san_phams.ma_loai_san_pham
	and san_phams.ma_thuong_hieu = thuong_hieus.ma_thuong_hieu and san_phams.ma_san_pham = masp;
end $$

call itemProduct('2020-10-30', 2);

-- xóa khuyến mãi sp khi xóa sản phẩm
DELIMITER $$
create trigger after_product_delete
after update on webbangiayphp.san_phams
for each row
begin
    declare masp bigint(20);
    declare isactive tinyint(1);
    
    set masp = NEW.ma_san_pham;
    set isactive = NEW.isActive;
    if isactive = 0 then
		update khuyen_mai_san_phams set khuyen_mai_san_phams.isActive = 0 where khuyen_mai_san_phams.ma_san_pham = masp;
        update hinh_anh_san_phams set hinh_anh_san_phams.isActive = 0 where hinh_anh_san_phams.ma_san_pham = masp;
        update dac_trung_san_phams set dac_trung_san_phams.isActive = 0 where dac_trung_san_phams.ma_san_pham = masp;
    end if;
end $$

-- xóa voucher kh khi xóa tài khoản
DELIMITER $$
create trigger after_account_delete
after update on webbangiayphp.tai_khoans
for each row
begin
    declare makh bigint(20);
    declare loaitk varchar(255);
    declare isactive tinyint(1);
    
    set makh = NEW.ma_tai_khoan;
    set loaitk = NEW.loai_tai_khoan;
    set isactive = NEW.isActive;
    if loaitk = 'KH' and isactive = 0 then
		update vouchers set vouchers.isActive = 0 where vouchers.ma_khach_hang = makh;
    end if;
end $$

-- reports
-- báo cáo danh sách các sản phẩm tồn kho
create view inventoryProducts as
select san_phams.*, ten_thuong_hieu, ten_loai_san_pham, 
(select hinh_anh from hinh_anh_san_phams where hinh_anh_san_phams.ma_san_pham = san_phams.ma_san_pham and hinh_anh is not null and hinh_anh_san_phams.isActive = 1 limit 1) as image
from san_phams, thuong_hieus, loai_san_phams
where san_phams.ma_loai_san_pham = loai_san_phams.ma_loai_san_pham and san_phams.isActive = 1
and san_phams.ma_thuong_hieu = thuong_hieus.ma_thuong_hieu and san_phams.so_luong > 0;