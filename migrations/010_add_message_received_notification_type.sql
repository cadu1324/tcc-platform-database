-- 010_add_message_received_notification_type.sql

SET timezone = 'America/Sao_Paulo';

-- Novo tipo de notificacao: aviso de "mensagem nova" no sino.
-- Emitido pelo backend (messageService.create -> notifyRecipient) depois de
-- persistir a mensagem 1:1 da migration 007. A notificacao e best-effort e
-- coalesce: so cria uma nova enquanto o destinatario nao tiver nenhuma
-- 'message_received' nao lida.
--
-- ADD VALUE IF NOT EXISTS torna a migration re-executavel. Em PostgreSQL 12+
-- (Neon) roda dentro de transacao sem problema porque o valor novo nao e
-- usado nesta mesma transacao.
ALTER TYPE notification_type_enum ADD VALUE IF NOT EXISTS 'message_received';
