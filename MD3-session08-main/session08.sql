create database ticketFilm;
use ticketFilm;
create table tbl_phim(
	id int primary key auto_increment,
    ten_phim varchar(30),
    loai_phim varchar(25),
    thoi_gian int
);
create table tbl_phong(
	id int primary key auto_increment,
    ten_phong varchar(20),
    trang_thai int
);
create table tbl_ghe(
	id int primary key auto_increment,
    phong_id int,
    so_ghe varchar(10),
    constraint fk_ghe01 foreign key (phong_id) references tbl_phong(id)
);
create table tbl_ve(
	phim_id int,
    ghe_id int,
    ngay_chieu date,
    trang_thai varchar(20),
    constraint fk_ve01 foreign key(phim_id) references tbl_phim(id),
    constraint fk_ve02 foreign key(ghe_id) references tbl_ghe(id)
);

#insert
insert into tbl_phim(ten_phim,loai_phim,thoi_gian) values
('Em bé Hà Nội','Tâm lý',90),('Nhiệm vụ bất khả thi','Hành động',100),
('Dị nhân','Viễn tưởng',90),('Cuốn theo chiều gió','Tình cảm',120);
insert into tbl_phong(ten_phong,trang_thai) values
('Phòng chiếu 1',1),('Phòng chiếu 2',1),('Phòng chiếu 3',0);
insert into tbl_ghe(phong_id,so_ghe) values
(1,'A3'),(1,'B5'),(2,'A7'),(2,'D1'),(3,'T2');
insert into tbl_ve(phim_id,ghe_id,ngay_chieu,trang_thai) values
(1,1,str_to_date('10/20/2008','%c/%d/%Y'),'Đã bán'),
(1,3,str_to_date('11/20/2008','%c/%d/%Y'),'Đã bán'),
(1,4,str_to_date('12/23/2008','%c/%d/%Y'),'Đã bán'),
(2,1,str_to_date('02/14/2009','%c/%d/%Y'),'Đã bán'),
(3,1,str_to_date('02/14/2009','%c/%d/%Y'),'Đã bán'),
(2,5,str_to_date('03/08/2009','%c/%d/%Y'),'Chưa bán'),
(2,3,str_to_date('03/08/2009','%c/%d/%Y'),'Chưa bán');

# Hiển thị danh sách các phim được sắp xếp theo thời gian
select * from tbl_phim order by thoi_gian desc;

# Hiển thị tên phim có thời gian chiếu dài nhất
select ten_phim from tbl_phim where thoi_gian = (select Max(thoi_gian) from tbl_phim);

# Hiển thị tên phim có thời gian chiếu ngắn nhất
select ten_phim from tbl_phim where thoi_gian = (select Min(thoi_gian) from tbl_phim);

# Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
select * from tbl_ghe where so_ghe LIKE 'A%';

# Sửa cột Trang_thai của bảng tblPhong sang kiểu varchar(25)
alter table tbl_phong modify trang_thai varchar(25);

# Cập nhật giá trị cột Trang_thai của bảng tblPhong
delimiter //
create procedure update_status()
begin
	update tbl_phong set trang_thai = CASE 
		WHEN trang_thai = 0 then 'Đang sửa'
		WHEN trang_thai = 1 then 'Đang sử dụng'
		ELSE 'Unknow'
    END;
    select * from tbl_phong;
end//
delimiter ;
call update_status();

# Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự 
select ten_phim from tbl_phim where char_length(ten_phim) > 15 AND char_length(ten_phim) < 25;

# Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
select concat(ten_phong,' ',trang_thai) as 'Trạng thái phòng chiếu' from tbl_phong;

# Tạo view có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
CREATE VIEW tblRank AS
select RANK() OVER (ORDER BY ten_phim ASC) AS STT, ten_phim,thoi_gian from tbl_phim;

# Update tbl phim
alter table tbl_phim add column mo_ta varchar(255);
update tbl_phim set mo_ta = concat('Đây là bộ phim thể loại',' ',loai_phim);
select * from tbl_phim;
update tbl_phim set mo_ta = replace(mo_ta,'bộ phim','film');
select * from tbl_phim;

# Xoá tất cả các khoá ngoại trong các bảng trên
alter table tbl_ghe drop foreign key fk_ghe01;
alter table tbl_ve drop foreign key fk_ve01;
alter table tbl_ve drop foreign key fk_ve02;

# Xoá dữ liệu ở bảng tbl ghế
delete from tbl_ghe;

# Hiển thị ngày giờ hiện chiếu và ngày giờ chiếu cộng thêm 5000 phút trong bảng tblVe
select now() as 'Ngày hiện chiếu',DATE_ADD(ngay_chieu, INTERVAL 5000 MINUTE) AS 'Ngày giờ chiếu' from tbl_ve;
