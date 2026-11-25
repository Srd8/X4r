create table if not exists public.bot_state (
  id text primary key,
  pooled_stars bigint not null default 0,
  updated_at timestamptz not null default now()
);

insert into public.bot_state (id, pooled_stars)
values ('main', 0)
on conflict (id) do nothing;

create table if not exists public.minted_gifts (
  id bigserial primary key,
  recipient_id text not null,
  gift_id text not null,
  gift_title text,
  mode text not null,
  stars_used bigint not null default 0,
  wallet_address text,
  image_url text,
  bundle_items jsonb,
  tx_status text not null default 'SENT_AND_UPGRADED_NFT',
  created_at timestamptz not null default now()
);

create table if not exists public.custom_bundles (
  id bigserial primary key,
  creator_id text not null,
  bundle_name text not null,
  items jsonb not null,
  total_stars bigint not null default 0,
  created_at timestamptz not null default now()
);

alter table public.bot_state enable row level security;
alter table public.minted_gifts enable row level security;
alter table public.custom_bundles enable row level security;

drop policy if exists "allow_all_bot_state" on public.bot_state;
drop policy if exists "allow_all_minted_gifts" on public.minted_gifts;
drop policy if exists "allow_all_custom_bundles" on public.custom_bundles;

create policy "allow_all_bot_state" on public.bot_state for all using (true) with check (true);
create policy "allow_all_minted_gifts" on public.minted_gifts for all using (true) with check (true);
create policy "allow_all_custom_bundles" on public.custom_bundles for all using (true) with check (true);
