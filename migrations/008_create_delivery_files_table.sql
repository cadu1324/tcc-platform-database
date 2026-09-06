-- 008_create_delivery_files_table.sql

SET timezone = 'America/Sao_Paulo';

-- Coluna denormalizada em deliveries para exibir o nome do arquivo
-- sem precisar baixar o conteudo (BYTEA) da tabela delivery_files.
ALTER TABLE deliveries ADD COLUMN IF NOT EXISTS file_name VARCHAR(255);

-- Armazena o binario da entrega dentro do proprio Postgres (BYTEA).
-- 1 arquivo por entrega (delivery_id UNIQUE); o reenvio faz UPSERT.
CREATE TABLE IF NOT EXISTS delivery_files (
    id SERIAL PRIMARY KEY,
    delivery_id INTEGER NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    size_bytes INTEGER NOT NULL,
    content BYTEA NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_delivery_files_delivery
        FOREIGN KEY (delivery_id) REFERENCES deliveries(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT uq_delivery_files_delivery_id UNIQUE (delivery_id),

    CONSTRAINT chk_delivery_files_size_positive
        CHECK (size_bytes > 0)
);

-- uq_delivery_files_delivery_id ja cria o indice usado nas buscas por delivery_id.

-- CREATE OR REPLACE mantem a migration reaplicavel (o runner reexecuta
-- todos os arquivos; nao ha tabela de controle de versao).
CREATE OR REPLACE TRIGGER trigger_delivery_files_updated_at
    BEFORE UPDATE ON delivery_files
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
