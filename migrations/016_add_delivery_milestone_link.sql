-- 016_add_delivery_milestone_link.sql

SET timezone = 'America/Sao_Paulo';

-- Vinculo da entrega com o marco (milestone, ver 006). O artigo (Secao 5.3
-- e Quadro 7) descreve a entrega como criada pelo aluno a partir da pagina
-- do marco correspondente ("upload de arquivo vinculado a marco").
--
-- NULLABLE e ON DELETE SET NULL de proposito: entregas seedadas/antigas
-- ficam sem marco (sem perder historico), e excluir um marco no futuro nao
-- pode apagar as entregas junto. Exigir milestone_id ao CRIAR uma entrega
-- nova (e que o marco seja do mesmo projeto) e regra de negocio no backend.
ALTER TABLE deliveries ADD COLUMN IF NOT EXISTS milestone_id INTEGER;

-- ADD CONSTRAINT nao aceita IF NOT EXISTS; o bloco DO verifica antes para
-- manter a migration reaplicavel (o runner reexecuta todos os arquivos).
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'fk_deliveries_milestone'
          AND conrelid = 'deliveries'::regclass
    ) THEN
        ALTER TABLE deliveries
            ADD CONSTRAINT fk_deliveries_milestone
            FOREIGN KEY (milestone_id) REFERENCES milestones(id)
            ON DELETE SET NULL ON UPDATE CASCADE;
    END IF;
END
$$;

-- O Postgres nao cria indice para FK automaticamente. Este cobre a listagem
-- de entregas de um marco e o SET NULL ao excluir um marco.
CREATE INDEX IF NOT EXISTS idx_deliveries_milestone_id
    ON deliveries(milestone_id);
