
  create table "public"."story_stats" (
    "id" uuid not null default gen_random_uuid(),
    "story_slug" text not null,
    "likes" integer not null default 0,
    "bookmarks" integer not null default 0,
    "reads" integer not null default 0,
    "listen_time" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."story_stats" enable row level security;

CREATE INDEX idx_story_stats_slug ON public.story_stats USING btree (story_slug);

CREATE UNIQUE INDEX story_stats_pkey ON public.story_stats USING btree (id);

CREATE UNIQUE INDEX story_stats_story_slug_key ON public.story_stats USING btree (story_slug);

alter table "public"."story_stats" add constraint "story_stats_pkey" PRIMARY KEY using index "story_stats_pkey";

alter table "public"."story_stats" add constraint "story_stats_story_slug_key" UNIQUE using index "story_stats_story_slug_key";

set check_function_bodies = off;

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

grant delete on table "public"."story_stats" to "anon";

grant insert on table "public"."story_stats" to "anon";

grant references on table "public"."story_stats" to "anon";

grant select on table "public"."story_stats" to "anon";

grant trigger on table "public"."story_stats" to "anon";

grant truncate on table "public"."story_stats" to "anon";

grant update on table "public"."story_stats" to "anon";

grant delete on table "public"."story_stats" to "authenticated";

grant insert on table "public"."story_stats" to "authenticated";

grant references on table "public"."story_stats" to "authenticated";

grant select on table "public"."story_stats" to "authenticated";

grant trigger on table "public"."story_stats" to "authenticated";

grant truncate on table "public"."story_stats" to "authenticated";

grant update on table "public"."story_stats" to "authenticated";

grant delete on table "public"."story_stats" to "postgres";

grant insert on table "public"."story_stats" to "postgres";

grant references on table "public"."story_stats" to "postgres";

grant select on table "public"."story_stats" to "postgres";

grant trigger on table "public"."story_stats" to "postgres";

grant truncate on table "public"."story_stats" to "postgres";

grant update on table "public"."story_stats" to "postgres";

grant delete on table "public"."story_stats" to "service_role";

grant insert on table "public"."story_stats" to "service_role";

grant references on table "public"."story_stats" to "service_role";

grant select on table "public"."story_stats" to "service_role";

grant trigger on table "public"."story_stats" to "service_role";

grant truncate on table "public"."story_stats" to "service_role";

grant update on table "public"."story_stats" to "service_role";


  create policy "Anyone can insert story stats"
  on "public"."story_stats"
  as permissive
  for insert
  to public
with check (true);



  create policy "Anyone can read story stats"
  on "public"."story_stats"
  as permissive
  for select
  to public
using (true);



  create policy "Anyone can update story stats"
  on "public"."story_stats"
  as permissive
  for update
  to public
using (true)
with check (true);


CREATE TRIGGER update_story_stats_updated_at BEFORE UPDATE ON public.story_stats FOR EACH ROW EXECUTE FUNCTION public.update_story_stats_updated_at();