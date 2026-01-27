-- 003_create_deliveries_table.sql

CREATE TYPE delivery_status_enum AS ENUM ('pending', 'submitted', 'approved', 'rejected');

CREATE TABLE deliveries (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    deadline TIMESTAMP WITH TIME ZONE,
    status delivery_status_enum NOT NULL DEFAULT 'pending',
    file_url VARCHAR(1000),
    submitted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_deliveries_project
        FOREIGN KEY (project_id) REFERENCES projects(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_deliveries_project_id ON deliveries(project_id);
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_deliveries_deadline ON deliveries(deadline);
CREATE INDEX idx_deliveries_project_status ON deliveries(project_id, status);

CREATE TRIGGER trigger_deliveries_updated_at
    BEFORE UPDATE ON deliveries
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
