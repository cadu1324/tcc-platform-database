-- 004_create_feedbacks_table.sql

CREATE TABLE feedbacks (
    id SERIAL PRIMARY KEY,
    delivery_id INTEGER NOT NULL,
    advisor_id INTEGER NOT NULL,
    comment TEXT NOT NULL,
    grade DECIMAL(4, 2),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_feedbacks_delivery
        FOREIGN KEY (delivery_id) REFERENCES deliveries(id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_feedbacks_advisor
        FOREIGN KEY (advisor_id) REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT chk_feedbacks_grade_range
        CHECK (grade IS NULL OR (grade >= 0 AND grade <= 10))
);

CREATE INDEX idx_feedbacks_delivery_id ON feedbacks(delivery_id);
CREATE INDEX idx_feedbacks_advisor_id ON feedbacks(advisor_id);
CREATE INDEX idx_feedbacks_created_at ON feedbacks(created_at DESC);
