-- Migration: Add share and area fields to resident profiles
-- Run in Supabase SQL Editor

ALTER TABLE public.fixflow_resident_profiles ADD COLUMN IF NOT EXISTS share_units integer;
ALTER TABLE public.fixflow_resident_profiles ADD COLUMN IF NOT EXISTS apartment_area numeric(6,2);
