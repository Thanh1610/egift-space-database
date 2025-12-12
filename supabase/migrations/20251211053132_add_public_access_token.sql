
  create table "public"."public_access_tokens" (
    "code" text not null,
    "path" text not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."public_access_tokens" enable row level security;

CREATE INDEX idx_public_access_tokens_code ON public.public_access_tokens USING btree (code);

CREATE INDEX idx_public_access_tokens_path ON public.public_access_tokens USING btree (path);

CREATE UNIQUE INDEX public_access_tokens_pkey ON public.public_access_tokens USING btree (code);

alter table "public"."public_access_tokens" add constraint "public_access_tokens_pkey" PRIMARY KEY using index "public_access_tokens_pkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_public_access_tokens_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$
;

grant delete on table "public"."public_access_tokens" to "anon";

grant insert on table "public"."public_access_tokens" to "anon";

grant references on table "public"."public_access_tokens" to "anon";

grant select on table "public"."public_access_tokens" to "anon";

grant trigger on table "public"."public_access_tokens" to "anon";

grant truncate on table "public"."public_access_tokens" to "anon";

grant update on table "public"."public_access_tokens" to "anon";

grant delete on table "public"."public_access_tokens" to "authenticated";

grant insert on table "public"."public_access_tokens" to "authenticated";

grant references on table "public"."public_access_tokens" to "authenticated";

grant select on table "public"."public_access_tokens" to "authenticated";

grant trigger on table "public"."public_access_tokens" to "authenticated";

grant truncate on table "public"."public_access_tokens" to "authenticated";

grant update on table "public"."public_access_tokens" to "authenticated";

grant delete on table "public"."public_access_tokens" to "postgres";

grant insert on table "public"."public_access_tokens" to "postgres";

grant references on table "public"."public_access_tokens" to "postgres";

grant select on table "public"."public_access_tokens" to "postgres";

grant trigger on table "public"."public_access_tokens" to "postgres";

grant truncate on table "public"."public_access_tokens" to "postgres";

grant update on table "public"."public_access_tokens" to "postgres";

grant delete on table "public"."public_access_tokens" to "service_role";

grant insert on table "public"."public_access_tokens" to "service_role";

grant references on table "public"."public_access_tokens" to "service_role";

grant select on table "public"."public_access_tokens" to "service_role";

grant trigger on table "public"."public_access_tokens" to "service_role";

grant truncate on table "public"."public_access_tokens" to "service_role";

grant update on table "public"."public_access_tokens" to "service_role";


  create policy "Authenticated users can manage tokens"
  on "public"."public_access_tokens"
  as permissive
  for all
  to authenticated
using (true)
with check (true);



  create policy "Public can read tokens"
  on "public"."public_access_tokens"
  as permissive
  for select
  to public
using (true);


CREATE TRIGGER update_public_access_tokens_updated_at BEFORE UPDATE ON public.public_access_tokens FOR EACH ROW EXECUTE FUNCTION public.update_public_access_tokens_updated_at();


