-- 014_add_milestone_notification_types.sql

SET timezone = 'America/Sao_Paulo';

-- US14: dois tipos novos de notificacao para marcos (milestones, ver 006):
--   'milestone_due_soon' -> marco perto do prazo (due_date se aproximando)
--   'milestone_overdue'  -> marco atrasado (due_date passou sem conclusao)
--
-- Mesmo padrao da 010: ADD VALUE IF NOT EXISTS torna a migration
-- re-executavel. Em PostgreSQL 12+ (Neon) roda dentro de transacao sem
-- problema porque os valores novos nao sao usados nesta mesma transacao.
ALTER TYPE notification_type_enum ADD VALUE IF NOT EXISTS 'milestone_due_soon';
ALTER TYPE notification_type_enum ADD VALUE IF NOT EXISTS 'milestone_overdue';
