# Database Setup Guide

## Hướng dẫn cài đặt Database

### Yêu cầu
- SQL Server 2019 hoặc cao hơn
- SQL Server Express (instance: `.\SQLEXPRESS`)

### Cách chạy Script

**Quan trọng:** File `database.sql` sử dụng encoding UTF-8 cho tiếng Việt. Cần chạy với tham số `-f 65001` để đảm bảo hiển thị đúng.

#### Cách 1: Sử dụng PowerShell (Khuyến nghị)
```powershell
sqlcmd -S .\SQLEXPRESS -E -i "database.sql" -f 65001
```

#### Cách 2: Sử dụng SQL Server Management Studio (SSMS)
1. Mở SSMS và kết nối với SQL Server
2. Mở file `database.sql`
3. Đảm bảo file encoding là **UTF-8**
4. Nhấn F5 để chạy script

### Thông tin Database

- **Database name:** `StudentManagement`
- **Connection string:** `Data Source=.\SQLEXPRESS;Initial Catalog=StudentManagement;Integrated Security=True`

### Tài khoản Test

**Admin:**
- Username: `admin`
- Password: `admin`

**Giáo viên:**
- Username: `teacher01` đến `teacher06`
- Password: `admin`

**Sinh viên:**
- Username: `3121411078`, `3121411222`, `3121411150`, `3121410001` đến `3121410012`
- Password: `admin`

### Lưu ý
- Script sẽ tự động xóa database cũ nếu đã tồn tại
- Dữ liệu mẫu bao gồm: 5 Khoa, 4 Hình thức đào tạo, 6 Học kỳ, 12 Môn học, 5 Lớp môn học, và 22 người dùng
