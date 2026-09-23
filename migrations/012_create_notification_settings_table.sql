-- 012_create_notification_settings_table.sql

SET timezone = 'America/Sao_Paulo';

-- US15: configuracao GLOBAL de notificacoes, controlada pelo admin
-- (Figura 17 do artigo: 3 toggles de evento + copia por e-mail + frequencia
-- do resumo). Nao e por usuario, entao a tabela e singleton: uma unica linha
-- com id fixo = 1, garantida pela CHECK abaixo.
CREATE TABLE IF NOT EXISTS notification_settings (
    id SMALLINT PRIMARY KEY DEFAULT 1,
    notify_student_on_feedback BOOLEAN NOT NULL DEFAULT TRUE,
    notify_advisor_on_delivery_submitted BOOLEAN NOT NULL DEFAULT TRUE,
    notify_admin_on_milestone_overdue BOOLEAN NOT NULL DEFAULT TRUE,
    email_copy_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    email_digest_frequency VARCHAR(10) NOT NULL DEFAULT 'daily',
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_notification_settings_singleton
        CHECK (id = 1),

    CONSTRAINT chk_notification_settings_digest_frequency
        CHECK (email_digest_frequency IN ('daily', 'weekly'))
);

-- Sem indices extras: a tabela tem 1 linha e e lida sempre pela PK.

-- CREATE OR REPLACE mantem a migration reaplicavel (o runner reexecuta
-- todos os arquivos; nao ha tabela de controle de versao).
CREATE OR REPLACE TRIGGER trigger_notification_settings_updated_at
    BEFORE UPDATE ON notification_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Semeia a linha unica com os defaults. Fica na migration (e nao em seeds/)
-- porque o backend depende dela existir em qualquer ambiente, inclusive
-- producao. ON CONFLICT DO NOTHING preserva o que o admin ja alterou.
INSERT INTO notification_settings (id) VALUES (1)
    ON CONFLICT (id) DO NOTHING;
