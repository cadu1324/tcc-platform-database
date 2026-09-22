-- 011_create_refresh_tokens_table.sql

SET timezone = 'America/Sao_Paulo';

-- Refresh tokens do fluxo JWT access+refresh (o login passa a emitir os dois).
-- Guarda apenas o HASH (SHA-256) do token, igual a password_reset_tokens;
-- o valor cru so existe no cliente.
-- Rotacao: cada uso do refresh token marca revoked_at e um novo e emitido.
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    revoked_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_refresh_tokens_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT uq_refresh_tokens_token_hash UNIQUE (token_hash)
);

-- uq_refresh_tokens_token_hash ja cria o indice do lookup por token.
-- user_id: revogar todas as sessoes do usuario (logout geral, troca de senha).
-- expires_at: rotina de limpeza (DELETE WHERE expires_at < now()).
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id
    ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_expires_at
    ON refresh_tokens(expires_at);
