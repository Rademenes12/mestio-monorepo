-- Migration: Add Security role support
-- Description: Adds 'security' as a valid role in the system

-- Add comment explaining the role
COMMENT ON TABLE fixflow_user_estates IS 'User-estate membership with roles: resident, admin, technician, security';

-- No enum to modify (role is stored as TEXT), but we document valid values:
-- Valid roles: 'resident', 'admin', 'technician', 'security'

-- Security role has same permissions as resident + can set priority
-- This is enforced in application layer, RLS policies remain the same
