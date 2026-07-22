# Supabase Schema — Wspólny Backend dla Mestio
# Używany przez wszystkie aplikacje: web, crm-owner, crm-client, mobile

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profile użytkowników (wspólne)
CREATE TABLE shared_users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  first_name TEXT,
  last_name TEXT,
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  role TEXT CHECK (role IN ('resident', 'board', 'admin', 'technician', 'owner')),
  estate_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Osiedla
CREATE TABLE estates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  address TEXT,
  logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Nieruchomości
CREATE TABLE properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  estate_id UUID REFERENCES estates(id),
  name TEXT NOT NULL,
  address TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Jednostki (mieszkania/lokale)
CREATE TABLE units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID REFERENCES properties(id),
  unit_number TEXT NOT NULL,
  floor INTEGER,
  area DECIMAL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Mieszkańcy
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id),
  user_id UUID REFERENCES shared_users(id),
  is_owner BOOLEAN DEFAULT FALSE,
  move_in_date DATE,
  move_out_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Zgłoszenia (tickets)
CREATE TABLE fixflow_tickets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  estate_id UUID REFERENCES estates(id),
  created_by UUID REFERENCES shared_users(id),
  assigned_to UUID REFERENCES shared_users(id),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT CHECK (category IN ('plumbing', 'electrical', 'hvac', 'general', 'other')),
  priority TEXT CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  status TEXT CHECK (status IN ('new', 'in_progress', 'rejected', 'resolved', 'closed')),
  photos TEXT[],
  location TEXT,
  unit_id UUID REFERENCES units(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

-- Notatki wewnętrzne (widoczne tylko dla admin/board)
CREATE TABLE fixflow_board_notes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_id UUID REFERENCES fixflow_tickets(id),
  author_id UUID REFERENCES shared_users(id),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Zadania
CREATE TABLE fixflow_tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  estate_id UUID REFERENCES estates(id),
  ticket_id UUID REFERENCES fixflow_tickets(id),
  assigned_to UUID REFERENCES shared_users(id),
  title TEXT NOT NULL,
  description TEXT,
  status TEXT CHECK (status IN ('todo', 'in_progress', 'done')),
  due_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ogłoszenia
CREATE TABLE fixflow_announcements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  estate_id UUID REFERENCES estates(id),
  author_id UUID REFERENCES shared_users(id),
  title TEXT NOT NULL,
  content TEXT,
  published_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  is_pinned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Płatności
CREATE TABLE fixflow_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  estate_id UUID REFERENCES estates(id),
  user_id UUID REFERENCES shared_users(id),
  amount DECIMAL NOT NULL,
  currency TEXT DEFAULT 'PLN',
  status TEXT CHECK (status IN ('pending', 'paid', 'failed', 'refunded')),
  stripe_payment_id TEXT,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Wiadomości
CREATE TABLE fixflow_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  estate_id UUID REFERENCES estates(id),
  sender_id UUID REFERENCES shared_users(id),
  recipient_id UUID REFERENCES shared_users(id),
  subject TEXT,
  content TEXT NOT NULL,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS Policies
ALTER TABLE shared_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE estates ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixflow_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixflow_board_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixflow_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixflow_announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixflow_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixflow_messages ENABLE ROW LEVEL SECURITY;

-- Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE fixflow_tickets;
ALTER PUBLICATION supabase_realtime ADD TABLE fixflow_tasks;
ALTER PUBLICATION supabase_realtime ADD TABLE fixflow_announcements;
ALTER PUBLICATION supabase_realtime ADD TABLE fixflow_messages;
