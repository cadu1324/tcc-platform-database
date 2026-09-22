-- 015_add_project_knowledge_area.sql

SET timezone = 'America/Sao_Paulo';

-- Area de conhecimento do projeto. O formulario de criacao de projeto
-- descrito no artigo (Secao 5.2) tem esse campo, mas a coluna nunca existiu.
--
-- NULLABLE de proposito: projetos antigos nao tem valor. A obrigatoriedade
-- para projetos novos e validada na camada de aplicacao, nao no schema.
ALTER TABLE projects ADD COLUMN IF NOT EXISTS knowledge_area VARCHAR(150);
