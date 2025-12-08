
  create table "public"."story_likes" (
    "id" uuid not null default gen_random_uuid(),
    "story_slug" text not null,
    "user_id" uuid not null,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."story_likes" enable row level security;

alter table "public"."profiles" enable row level security;

CREATE INDEX idx_story_likes_slug ON public.story_likes USING btree (story_slug);

CREATE INDEX idx_story_likes_slug_user ON public.story_likes USING btree (story_slug, user_id);

CREATE INDEX idx_story_likes_user ON public.story_likes USING btree (user_id);

CREATE UNIQUE INDEX story_likes_pkey ON public.story_likes USING btree (id);

CREATE UNIQUE INDEX story_likes_story_slug_user_id_key ON public.story_likes USING btree (story_slug, user_id);

alter table "public"."story_likes" add constraint "story_likes_pkey" PRIMARY KEY using index "story_likes_pkey";

alter table "public"."story_likes" add constraint "story_likes_story_slug_user_id_key" UNIQUE using index "story_likes_story_slug_user_id_key";

alter table "public"."story_likes" add constraint "story_likes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."story_likes" validate constraint "story_likes_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  insert into public.profiles (id, email, role)
  values (new.id, new.email, 'member');

  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.update_story_stats_updated_at()
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

grant delete on table "public"."profiles" to "postgres";

grant insert on table "public"."profiles" to "postgres";

grant references on table "public"."profiles" to "postgres";

grant select on table "public"."profiles" to "postgres";

grant trigger on table "public"."profiles" to "postgres";

grant truncate on table "public"."profiles" to "postgres";

grant update on table "public"."profiles" to "postgres";

grant delete on table "public"."story_likes" to "anon";

grant insert on table "public"."story_likes" to "anon";

grant references on table "public"."story_likes" to "anon";

grant select on table "public"."story_likes" to "anon";

grant trigger on table "public"."story_likes" to "anon";

grant truncate on table "public"."story_likes" to "anon";

grant update on table "public"."story_likes" to "anon";

grant delete on table "public"."story_likes" to "authenticated";

grant insert on table "public"."story_likes" to "authenticated";

grant references on table "public"."story_likes" to "authenticated";

grant select on table "public"."story_likes" to "authenticated";

grant trigger on table "public"."story_likes" to "authenticated";

grant truncate on table "public"."story_likes" to "authenticated";

grant update on table "public"."story_likes" to "authenticated";

grant delete on table "public"."story_likes" to "postgres";

grant insert on table "public"."story_likes" to "postgres";

grant references on table "public"."story_likes" to "postgres";

grant select on table "public"."story_likes" to "postgres";

grant trigger on table "public"."story_likes" to "postgres";

grant truncate on table "public"."story_likes" to "postgres";

grant update on table "public"."story_likes" to "postgres";

grant delete on table "public"."story_likes" to "service_role";

grant insert on table "public"."story_likes" to "service_role";

grant references on table "public"."story_likes" to "service_role";

grant select on table "public"."story_likes" to "service_role";

grant trigger on table "public"."story_likes" to "service_role";

grant truncate on table "public"."story_likes" to "service_role";

grant update on table "public"."story_likes" to "service_role";

grant delete on table "public"."story_stats" to "postgres";

grant insert on table "public"."story_stats" to "postgres";

grant references on table "public"."story_stats" to "postgres";

grant select on table "public"."story_stats" to "postgres";

grant trigger on table "public"."story_stats" to "postgres";

grant truncate on table "public"."story_stats" to "postgres";

grant update on table "public"."story_stats" to "postgres";


  create policy "Users can insert own profile"
  on "public"."profiles"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = id));



  create policy "Users can update own profile"
  on "public"."profiles"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = id))
with check ((( SELECT auth.uid() AS uid) = id));



  create policy "Users can view all profiles"
  on "public"."profiles"
  as permissive
  for select
  to public
using (true);



  create policy "Anyone can read story likes"
  on "public"."story_likes"
  as permissive
  for select
  to public
using (true);



  create policy "Authenticated users can insert story likes"
  on "public"."story_likes"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can delete their own likes"
  on "public"."story_likes"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



