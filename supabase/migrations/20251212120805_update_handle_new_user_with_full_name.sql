-- Update handle_new_user trigger to automatically set full_name from user_metadata
-- This ensures full_name is populated when a new user signs up
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

