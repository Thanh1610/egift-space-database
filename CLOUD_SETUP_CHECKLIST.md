# Checklist để fix vấn đề trên Supabase Cloud

## Vấn đề
- Local chạy ổn nhưng cloud không hoạt động đúng
- `full_name` không được lưu khi signup

## Nguyên nhân
1. Database trigger `handle_new_user()` trên cloud chưa được update để lấy `full_name` từ `user_metadata`
2. Migration mới chưa được chạy trên cloud

## Cách fix

### Cách 1: Chạy migration (Khuyến nghị)
1. Vào Supabase Dashboard > Database > Migrations
2. Push migration mới: `20251212120459_update_handle_new_user_with_full_name.sql`
3. Hoặc dùng Supabase CLI:
   ```bash
   cd egift-space-database
   supabase db push
   ```

### Cách 2: Chạy SQL trực tiếp
1. Vào Supabase Dashboard > SQL Editor
2. Copy và chạy nội dung file `fix_cloud_trigger.sql`
3. Verify trigger đã được update:
   ```sql
   SELECT 
     trigger_name, 
     event_manipulation, 
     event_object_table, 
     action_statement
   FROM information_schema.triggers
   WHERE trigger_name = 'on_auth_user_created';
   ```

### Cách 3: Kiểm tra và update thủ công
1. Vào Supabase Dashboard > Database > Functions
2. Tìm function `handle_new_user`
3. Update function với code sau:
   ```sql
   CREATE OR REPLACE FUNCTION public.handle_new_user()
    RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO 'public'
   AS $function$
   begin
     insert into public.profiles (id, email, role, full_name)
     values (
       new.id, 
       new.email, 
       'member',
       COALESCE(
         new.raw_user_meta_data->>'full_name',
         new.raw_user_meta_data->>'name',
         null
       )
     );
   
     return new;
   end;
   $function$;
   ```

## Kiểm tra sau khi fix
1. Test signup với user mới
2. Kiểm tra trong Supabase Dashboard > Table Editor > profiles
3. Verify `full_name` đã được lưu đúng

## Lưu ý
- Trigger chạy với `SECURITY DEFINER` nên có thể bypass RLS
- Trigger tự động chạy khi có user mới được tạo trong `auth.users`
- `full_name` được lấy từ `user_metadata.full_name` hoặc `user_metadata.name`

