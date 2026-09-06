-- 007_create_messages_table.sql

SET timezone = 'America/Sao_Paulo';

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recipient_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Contagem de mensagens nao lidas por destinatario
CREATE INDEX idx_messages_recipient_unread ON messages(recipient_id, is_read);

-- Carregamento da conversa entre dois usuarios em ordem cronologica
CREATE INDEX idx_messages_conversation ON messages(sender_id, recipient_id, created_at);
