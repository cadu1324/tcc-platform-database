-- 002_create_projects_table.sql

CREATE TYPE project_status_enum AS ENUM ('in_progress', 'completed', 'cancelled');

-- REGRA DE NEGÓCIO: aluno pode ter múltiplos projetos (histórico),
-- mas apenas 1 com status 'in_progress' por vez.
-- Validação feita no backend para maior flexibilidade.

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    status project_status_enum NOT NULL DEFAULT 'in_progress',
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expected_delivery_date DATE,
    student_id INTEGER NOT NULL,
    advisor_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_projects_student
        FOREIGN KEY (student_id) REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_projects_advisor
        FOREIGN KEY (advisor_id) REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_projects_student_id ON projects(student_id);
CREATE INDEX idx_projects_advisor_id ON projects(advisor_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_student_status ON projects(student_id, status);

CREATE TRIGGER trigger_projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
