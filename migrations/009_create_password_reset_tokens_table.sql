-- 009_create_password_reset_tokens_table.sql

SET timezone = 'America/Sao_Paulo';

-- Tokens de redefinicao de senha (fluxo "esqueci minha senha").
-- Guarda apenas o HASH do token; o valor cru so existe no link do e-mail.
-- Uso unico: consumido marcando used_at. Expira em ~1h (definido no backend).
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_password_reset_tokens_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT uq_password_reset_tokens_token_hash UNIQUE (token_hash)
);

-- uq_password_reset_tokens_token_hash ja cria o indice do lookup por token.
-- user_id: invalidar tokens anteriores ao gerar um novo.
-- expires_at: rotina de limpeza (DELETE WHERE expires_at < now()).
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_user_id
    ON password_reset_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_expires_at
    ON password_reset_tokens(expires_at);
