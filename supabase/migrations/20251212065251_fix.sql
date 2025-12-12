create extension if not exists "pg_net" with schema "extensions";


  create policy "Allow postgres to insert profiles"
  on "public"."profiles"
  as permissive
  for insert
  to postgres
with check (true);



  create policy "Allow trigger to insert profiles"
  on "public"."profiles"
  as permissive
  for insert
  to service_role
with check (true);



