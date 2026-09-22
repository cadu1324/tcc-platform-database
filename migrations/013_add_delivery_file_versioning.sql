-- 013_add_delivery_file_versioning.sql

SET timezone = 'America/Sao_Paulo';

-- US16: historico de versoes das entregas.
-- Ate aqui delivery_files tinha UNIQUE(delivery_id) e o reenvio fazia UPSERT,
-- sobrescrevendo o arquivo anterior (ver 008). Agora cada submissao vira uma
-- NOVA linha com numero de versao incremental (calculado no backend como
-- MAX(version) + 1 da entrega). Linhas ja existentes ficam como versao 1.
ALTER TABLE delivery_files
    DROP CONSTRAINT IF EXISTS uq_delivery_files_delivery_id;

ALTER TABLE delivery_files
    ADD COLUMN IF NOT EXISTS version INTEGER NOT NULL DEFAULT 1;

-- ADD CONSTRAINT nao aceita IF NOT EXISTS; o bloco DO verifica antes para
-- manter a migration reaplicavel (o runner reexecuta todos os arquivos).
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'uq_delivery_files_delivery_version'
          AND conrelid = 'delivery_files'::regclass
    ) THEN
        ALTER TABLE delivery_files
            ADD CONSTRAINT uq_delivery_files_delivery_version
            UNIQUE (delivery_id, version);
    END IF;
END
$$;

-- A UNIQUE antiga cobria a busca por delivery_id como indice; como ela sai,
-- o indice fica explicito aqui.
CREATE INDEX IF NOT EXISTS idx_delivery_files_delivery_id
    ON delivery_files(delivery_id);
