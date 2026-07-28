-- Estate Buildings & Units
-- Rozszerza zarządzanie osiedlami o budynki, lokale i przypisanie mieszkańców

-- Budynki w osiedlu
create table if not exists estate_buildings (
  id uuid primary key default gen_random_uuid(),
  estate_id uuid not null references estates(id) on delete cascade,
  name text not null,
  address text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table estate_buildings enable row level security;

create policy estate_buildings_select on estate_buildings for select
  using (true);

-- Lokale/mieszkania
create table if not exists estate_units (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references estate_buildings(id) on delete cascade,
  estate_id uuid not null references estates(id) on delete cascade,
  unit_number text not null,
  floor integer,
  area_sqm numeric(8,2),
  rooms integer,
  status text not null default 'vacant'
    check (status in ('vacant', 'occupied', 'maintenance', 'reserved')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table estate_units enable row level security;

create policy estate_units_select on estate_units for select
  using (true);

-- Mieszkańcy przypisani do lokali
create table if not exists estate_tenants (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references estate_units(id) on delete cascade,
  user_id uuid references auth.users(id) on delete set null,
  full_name text not null,
  email text,
  phone text,
  is_owner boolean default false,
  is_primary boolean default false,
  move_in_date date,
  move_out_date date,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table estate_tenants enable row level security;

create policy estate_tenants_select on estate_tenants for select
  using (true);

-- Indeksy
create index if not exists idx_estate_buildings_estate on estate_buildings(estate_id);
create index if not exists idx_estate_units_building on estate_units(building_id);
create index if not exists idx_estate_units_estate on estate_units(estate_id);
create index if not exists idx_estate_tenants_unit on estate_tenants(unit_id);
