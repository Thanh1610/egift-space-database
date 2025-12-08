# egift-space-database

Database migrations và schema cho egift-space project sử dụng Supabase.

## Setup Local Development

1. Cài đặt Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Đăng nhập vào Supabase:
   ```bash
   supabase login
   ```

3. Khởi động local development environment:
   ```bash
   supabase start
   ```

4. Truy cập Supabase Studio tại: http://127.0.0.1:55323

## Database Migrations

- Migrations được lưu trong `supabase/migrations/`
- Tên file phải theo pattern: `<timestamp>_name.sql`

### Apply migrations locally:
```bash
supabase db reset  # Reset và apply tất cả migrations + seed
supabase db push   # Chỉ apply migrations mới
```

### Deploy migrations to cloud:
```bash
supabase db push
```

## CI/CD Setup

Workflow tự động deploy migrations lên Supabase cloud khi push vào branch `main`.

### Cần setup GitHub Secrets:

1. **SUPABASE_ACCESS_TOKEN**: Access token từ Supabase Dashboard
   - Truy cập: https://supabase.com/dashboard/account/tokens
   - Tạo token mới và copy vào GitHub Secrets

2. **SUPABASE_PROJECT_REF**: Project Reference ID (lấy từ Project URL)
   - Trong Supabase Dashboard, tìm "Project URL" (ví dụ: `https://lyjncegjdjhkmt.supabase.co`)
   - Copy phần **trước** `.supabase.co` → đó là project ref (ví dụ: `lyjncegjdjhkmt`)
   - Hoặc vào Settings → General, tìm "Reference ID"

### Setup GitHub Secrets:

1. Vào repository trên GitHub
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Thêm 2 secrets:
   - `SUPABASE_ACCESS_TOKEN`: Token từ Supabase (từ account/tokens)
   - `SUPABASE_PROJECT_REF`: Project ref (phần trước `.supabase.co` trong Project URL, ví dụ: `lyjncegjdjhkmt`)

Sau khi setup xong, mỗi khi push migrations vào branch `main`, workflow sẽ tự động deploy lên cloud.

## Ports Configuration

Local development sử dụng các cổng sau (đã được điều chỉnh để tránh conflict):

- API: `54331`
- Database: `54332`
- Studio: `55323`
- Mailpit: `55324`
- Analytics: `55327`
- Pooler: `55329`
