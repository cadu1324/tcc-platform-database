-- dev_data.sql
-- Dados para desenvolvimento. Senha: "senha123" (bcrypt)

SET timezone = 'America/Sao_Paulo';

-- Usuários
INSERT INTO users (name, email, password_hash, user_type, is_active) VALUES
('Admin Sistema', 'admin@tccplatform.com', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'admin', TRUE),
('Admin Backup', 'admin.backup@tccplatform.com', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'admin', TRUE),
('Prof. Dr. Carlos Silva', 'carlos.silva@universidade.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'advisor', TRUE),
('Profa. Dra. Ana Santos', 'ana.santos@universidade.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'advisor', TRUE),
('Prof. Me. Roberto Lima', 'roberto.lima@universidade.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'advisor', TRUE),
('João Pedro Oliveira', 'joao.oliveira@aluno.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'student', TRUE),
('Maria Clara Souza', 'maria.souza@aluno.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'student', TRUE),
('Lucas Fernandes Costa', 'lucas.costa@aluno.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'student', TRUE),
('Beatriz Almeida', 'beatriz.almeida@aluno.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'student', TRUE),
('Gabriel Rodrigues', 'gabriel.rodrigues@aluno.edu.br', '$2b$10$/DwoGtIgZAVtlcvQKZIb2.0DpnIzEYfXdRCeKV4XDPyRGfDPe5Erm', 'student', TRUE);

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

-- Marcos (milestones)
INSERT INTO milestones (project_id, title, description, due_date, status) VALUES
(1, 'Definição de Escopo e Requisitos', 'Levantamento e formalização dos requisitos do sistema', '2024-03-01 23:59:59-03', 'completed'),
(1, 'Entrega da Revisão Bibliográfica', 'Consolidação do referencial teórico', '2024-04-30 23:59:59-03', 'completed'),
(1, 'Apresentação de Progresso', 'Apresentação parcial do desenvolvimento para banca', '2024-09-15 23:59:59-03', 'pending'),
(2, 'Validação do Protótipo com Usuários', 'Testes de usabilidade com estudantes voluntários', '2024-08-01 23:59:59-03', 'pending'),
(2, 'Entrega Final do MVP', 'Versão mínima viável do aplicativo', '2024-12-01 23:59:59-03', 'pending'),
(3, 'Defesa do TCC', 'Apresentação final para a banca avaliadora', '2023-11-25 23:59:59-03', 'completed'),
(4, 'Definição da Arquitetura', 'Escolha de stack e desenho da arquitetura do chatbot', '2024-05-01 23:59:59-03', 'completed'),
(4, 'Testes de Integração com LLM', 'Validação da integração com o modelo de linguagem', '2024-09-30 23:59:59-03', 'pending'),
(5, 'Validação do Modelo de Negócios', 'Revisão do canvas com base em feedback do orientador', '2024-04-15 23:59:59-03', 'completed'),
(5, 'Lançamento do MVP', 'Publicação da versão inicial do marketplace', '2024-08-15 23:59:59-03', 'pending');

-- Notificações
INSERT INTO notifications (user_id, type, message, project_id, is_read) VALUES
((SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'delivery_created', 'Novo envio: "Protótipo de Interface" foi enviado para avaliação no projeto "Sistema de Gestão de Biblioteca Digital".', 1, FALSE),
((SELECT id FROM users WHERE email = 'ana.santos@universidade.edu.br'), 'delivery_created', 'Novo envio: "Arquitetura do Sistema" foi enviado para avaliação no projeto "Chatbot Educacional com IA Generativa".', 4, FALSE),
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'feedback_registered', 'Você recebeu um novo feedback na entrega "Proposta Inicial".', 1, TRUE),
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'feedback_registered', 'Você recebeu um novo feedback na entrega "Revisão Bibliográfica".', 1, TRUE),
((SELECT id FROM users WHERE email = 'beatriz.almeida@aluno.edu.br'), 'feedback_registered', 'Você recebeu um novo feedback na entrega "Proposta de Projeto".', 5, TRUE),
((SELECT id FROM users WHERE email = 'beatriz.almeida@aluno.edu.br'), 'feedback_registered', 'Você recebeu um novo feedback na entrega "Modelo de Negócios".', 5, FALSE),
((SELECT id FROM users WHERE email = 'maria.souza@aluno.edu.br'), 'feedback_registered', 'Você recebeu um novo feedback na entrega "Proposta e Cronograma".', 2, TRUE),
((SELECT id FROM users WHERE email = 'maria.souza@aluno.edu.br'), 'feedback_registered', 'Você recebeu um novo feedback na entrega "Design do App".', 2, FALSE),
((SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'), 'milestone_created', 'Novo marco adicionado ao projeto "Sistema de Gestão de Biblioteca Digital": "Apresentação de Progresso".', 1, FALSE),
((SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'milestone_created', 'Novo marco adicionado ao projeto "Sistema de Gestão de Biblioteca Digital": "Apresentação de Progresso".', 1, FALSE),
((SELECT id FROM users WHERE email = 'beatriz.almeida@aluno.edu.br'), 'milestone_updated', 'O marco "Validação do Modelo de Negócios" foi atualizado para "completed".', 5, TRUE),
((SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'), 'milestone_updated', 'O marco "Validação do Modelo de Negócios" foi atualizado para "completed".', 5, FALSE);

-- Mensagens 1:1 (João Pedro Oliveira <-> Prof. Dr. Carlos Silva, projeto "Sistema de Gestão de Biblioteca Digital")
INSERT INTO messages (sender_id, recipient_id, content, is_read) VALUES
(
    (SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'),
    'Professor, enviei o protótipo de interface. Poderia revisar quando possível?',
    TRUE
),
(
    (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'),
    (SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'),
    'Recebi, João. Vou analisar até quinta e trago comentários na nossa reunião.',
    TRUE
),
(
    (SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'),
    (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'),
    'Perfeito, obrigado! Já comecei a implementação do backend em paralelo.',
    FALSE
),
(
    (SELECT id FROM users WHERE email = 'carlos.silva@universidade.edu.br'),
    (SELECT id FROM users WHERE email = 'joao.oliveira@aluno.edu.br'),
    'Ótimo. Lembre-se de documentar a API REST desde já para facilitar a próxima entrega.',
    FALSE
);
