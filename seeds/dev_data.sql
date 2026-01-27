-- dev_data.sql
-- Dados para desenvolvimento. Senha: "senha123" (bcrypt)

SET timezone = 'America/Sao_Paulo';

-- Usuários
INSERT INTO users (name, email, password_hash, user_type, is_active) VALUES
('Admin Sistema', 'admin@tccplatform.com', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'admin', TRUE),
('Admin Backup', 'admin.backup@tccplatform.com', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'admin', TRUE),
('Prof. Dr. Carlos Silva', 'carlos.silva@universidade.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'advisor', TRUE),
('Profa. Dra. Ana Santos', 'ana.santos@universidade.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'advisor', TRUE),
('Prof. Me. Roberto Lima', 'roberto.lima@universidade.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'advisor', TRUE),
('João Pedro Oliveira', 'joao.oliveira@aluno.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'student', TRUE),
('Maria Clara Souza', 'maria.souza@aluno.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'student', TRUE),
('Lucas Fernandes Costa', 'lucas.costa@aluno.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'student', TRUE),
('Beatriz Almeida', 'beatriz.almeida@aluno.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'student', TRUE),
('Gabriel Rodrigues', 'gabriel.rodrigues@aluno.edu.br', '$2b$10$rQZ8K.Nh5yJvH3WZpMqKqeOxBxBqVnHxJvPqRmJ5qZxMqN8qZ8K.K', 'student', TRUE);

-- Projetos
INSERT INTO projects (title, description, status, start_date, expected_delivery_date, student_id, advisor_id) VALUES
(
    'Sistema de Gestão de Biblioteca Digital',
    'Desenvolvimento de uma plataforma web para gerenciamento de acervo digital de bibliotecas universitárias.',
    'in_progress',
    '2024-02-15',
    '2024-11-30',
    (SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br')
),
(
    'Aplicativo Mobile para Monitoramento de Saúde Mental',
    'Aplicativo móvel com IA para acompanhamento do bem-estar mental de estudantes universitários.',
    'in_progress',
    '2024-03-01',
    '2024-12-15',
    (SELECT id FROM users WHERE email = 'maria.souza@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br')
),
(
    'Análise de Sentimentos em Redes Sociais',
    'Implementação de algoritmos de NLP para análise de sentimentos em postagens do Twitter.',
    'completed',
    '2023-03-01',
    '2023-11-30',
    (SELECT id FROM users WHERE email = 'lucas.costa@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'roberto.lima@universidade.edu.br')
),
(
    'Chatbot Educacional com IA Generativa',
    'Assistente virtual baseado em LLMs para suporte ao aprendizado de programação.',
    'in_progress',
    '2024-02-01',
    '2024-12-01',
    (SELECT id FROM users WHERE email = 'lucas.costa@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br')
),
(
    'Plataforma de E-commerce Sustentável',
    'Marketplace focado em produtos sustentáveis com sistema de pontuação ambiental.',
    'in_progress',
    '2024-01-20',
    '2024-11-15',
    (SELECT id FROM users WHERE email = 'beatriz.almeida@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br')
);

-- Entregas
INSERT INTO deliveries (project_id, title, description, deadline, status, file_url, submitted_at) VALUES
(1, 'Proposta Inicial', 'Documento com escopo, objetivos e justificativa', '2024-03-15 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/1/proposta.pdf', '2024-03-14 18:30:00-03'),
(1, 'Revisão Bibliográfica', 'Levantamento de trabalhos relacionados', '2024-04-30 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/1/revisao.pdf', '2024-04-28 22:15:00-03'),
(1, 'Protótipo de Interface', 'Wireframes e mockups', '2024-06-15 23:59:59-03', 'submitted', 'https://storage.example.com/deliveries/1/prototipo.pdf', '2024-06-14 20:00:00-03'),
(1, 'Implementação Backend', 'API REST documentada', '2024-08-30 23:59:59-03', 'pending', NULL, NULL),
(2, 'Proposta e Cronograma', 'Proposta detalhada com cronograma', '2024-04-01 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/2/proposta.pdf', '2024-03-30 15:45:00-03'),
(2, 'Estudo de Viabilidade', 'Análise de requisitos técnicos', '2024-05-15 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/2/viabilidade.pdf', '2024-05-14 19:20:00-03'),
(2, 'Design do App', 'Protótipo navegável no Figma', '2024-07-01 23:59:59-03', 'rejected', 'https://storage.example.com/deliveries/2/design_v1.pdf', '2024-06-30 23:50:00-03'),
(2, 'Design do App - Revisão', 'Protótipo corrigido', '2024-07-20 23:59:59-03', 'pending', NULL, NULL),
(3, 'TCC Completo', 'Documento final do TCC', '2023-11-15 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/3/tcc_final.pdf', '2023-11-14 21:00:00-03'),
(3, 'Apresentação Final', 'Slides da defesa', '2023-11-25 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/3/apresentacao.pdf', '2023-11-24 10:30:00-03'),
(4, 'Definição de Escopo', 'Especificação do chatbot', '2024-03-15 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/4/escopo.pdf', '2024-03-13 16:00:00-03'),
(4, 'Arquitetura do Sistema', 'Diagrama de arquitetura', '2024-05-01 23:59:59-03', 'submitted', 'https://storage.example.com/deliveries/4/arquitetura.pdf', '2024-04-30 22:30:00-03'),
(5, 'Proposta de Projeto', 'Objetivos e metodologia', '2024-02-28 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/5/proposta.pdf', '2024-02-27 14:20:00-03'),
(5, 'Modelo de Negócios', 'Canvas e análise de mercado', '2024-04-15 23:59:59-03', 'approved', 'https://storage.example.com/deliveries/5/modelo.pdf', '2024-04-14 17:45:00-03'),
(5, 'Protótipo Funcional', 'MVP do marketplace', '2024-07-30 23:59:59-03', 'pending', NULL, NULL);

-- Feedbacks
INSERT INTO feedbacks (delivery_id, advisor_id, comment, grade) VALUES
(1, (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'Excelente proposta! Objetivos bem definidos.', 9.0),
(2, (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'Boa revisão. Incluir mais referências sobre sistemas de recomendação.', 8.5),
(5, (SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br'), 'Proposta bem estruturada. Tema relevante.', 9.5),
(6, (SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br'), 'Análise técnica completa.', 8.0),
(7, (SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br'), 'Design precisa revisão. Navegação confusa.', 5.5),
(9, (SELECT id FROM users WHERE email = 'roberto.lima@universidade.edu.br'), 'Trabalho excelente! Metodologia bem aplicada.', 9.5),
(10, (SELECT id FROM users WHERE email = 'roberto.lima@universidade.edu.br'), 'Apresentação clara e objetiva. Parabéns!', 10.0),
(11, (SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br'), 'Bom escopo definido.', 8.5),
(13, (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'Proposta inovadora! Desenvolver mais a parte técnica.', 8.0),
(14, (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'Modelo de negócios bem estruturado.', 8.5);

-- Notificações
INSERT INTO notifications (user_id, message, is_read) VALUES
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'Sua entrega "Proposta Inicial" foi aprovada.', TRUE),
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'Sua entrega "Revisão Bibliográfica" foi aprovada.', TRUE),
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'Sua entrega "Protótipo de Interface" está em análise.', FALSE),
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'Lembrete: Entrega "Implementação Backend" vence em 30 dias.', FALSE),
((SELECT id FROM users WHERE email = 'maria.souza@aluno.edu.br'), 'Sua entrega "Design do App" foi rejeitada.', FALSE),
((SELECT id FROM users WHERE email = 'maria.souza@aluno.edu.br'), 'Nova entrega criada: "Design do App - Revisão".', FALSE),
((SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'João Pedro enviou "Protótipo de Interface" para avaliação.', FALSE),
((SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br'), 'Lucas enviou "Arquitetura do Sistema" para avaliação.', FALSE),
((SELECT id FROM users WHERE email = 'admin@tccplatform.com'), 'Novo usuário cadastrado: Gabriel Rodrigues.', TRUE),
((SELECT id FROM users WHERE email = 'admin@tccplatform.com'), '5 projetos ativos no sistema.', TRUE);
