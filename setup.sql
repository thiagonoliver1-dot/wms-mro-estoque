-- ══════════════════════════════════════════════════════════
--  MRO Serviços Logísticos — Setup Supabase
--  Cole este script no SQL Editor do seu projeto Supabase
--  (Dashboard → SQL Editor → New Query → Run)
-- ══════════════════════════════════════════════════════════

create table if not exists usuarios (
  id        bigint generated always as identity primary key,
  nome      text    not null,
  email     text    not null unique,
  senha     text    not null,
  perfil    text    not null default 'solicitante',
  ativo     boolean not null default true,
  "criadoEm" text
);

create table if not exists produtos (
  id        bigint  generated always as identity primary key,
  codigo    text    not null unique,
  nome      text    not null,
  unidade   text    not null default 'UN',
  categoria text,
  gaiola    text,
  preco     numeric not null default 0,
  minimo    numeric not null default 0,
  saldo     numeric not null default 0,
  "criadoEm" text
);
-- Se a tabela já existe:
-- alter table produtos add column if not exists preco numeric not null default 0;

create table if not exists movimentos (
  id            bigint  generated always as identity primary key,
  tipo          text    not null,
  "produtoId"   bigint,
  "produtoNome" text,
  gaiola        text,
  qtd           numeric,
  origem        text,
  destino       text,
  motivo        text,
  obs           text,
  data          text
);

create table if not exists inventarios (
  id              bigint  generated always as identity primary key,
  "produtoId"     bigint,
  "produtoNome"   text,
  gaiola          text,
  "saldoSistema"  numeric,
  "saldoFisico"   numeric,
  divergencia     numeric,
  responsavel     text,
  obs             text,
  data            text
);

create table if not exists pedidos (
  id                  bigint  generated always as identity primary key,
  numero              text,
  solicitante         text,
  "solicitanteEmail"  text,
  setor               text,
  prioridade          text,
  obs                 text,
  status              text    not null default 'Pendente',
  itens               jsonb,
  "criadoEm"          text,
  "atualizadoEm"      text
);

-- Se a tabela já existe, adicione a coluna:
-- alter table pedidos add column if not exists "solicitanteEmail" text;

-- ── Habilita RLS e abre acesso para a chave anon ──────────
-- (o app tem autenticação própria — usuário/senha no banco)

alter table usuarios   enable row level security;
alter table produtos   enable row level security;
alter table movimentos enable row level security;
alter table inventarios enable row level security;
alter table pedidos    enable row level security;

create policy "anon_all" on usuarios   for all to anon using (true) with check (true);
create policy "anon_all" on produtos   for all to anon using (true) with check (true);
create policy "anon_all" on movimentos for all to anon using (true) with check (true);
create policy "anon_all" on inventarios for all to anon using (true) with check (true);
create policy "anon_all" on pedidos    for all to anon using (true) with check (true);
