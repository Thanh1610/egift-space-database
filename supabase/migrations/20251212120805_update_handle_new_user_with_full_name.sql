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

-- Add RLS policy to allow trigger to insert profiles
-- This policy allows service_role (used by SECURITY DEFINER functions) to insert profiles
-- Drop existing policy if it exists, then create new one
DROP POLICY IF EXISTS "Allow trigger to insert profiles" ON public.profiles;
CREATE POLICY "Allow trigger to insert profiles"
ON public.profiles
FOR INSERT
TO service_role
WITH CHECK (true);

-- Also allow postgres role (function owner) to insert
DROP POLICY IF EXISTS "Allow postgres to insert profiles" ON public.profiles;
CREATE POLICY "Allow postgres to insert profiles"
ON public.profiles
FOR INSERT
TO postgres
WITH CHECK (true);

