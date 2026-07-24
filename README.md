# TCC Platform - Database

Repositório de banco de dados da plataforma de gestão de projetos acadêmicos e TCCs.

## Sobre o Projeto

Este repositório contém toda a estrutura do banco de dados PostgreSQL para a **TCC Platform**, uma plataforma web para gestão de projetos acadêmicos que facilita a comunicação entre alunos, orientadores e administradores.

### Tecnologias

- **PostgreSQL 15** - Banco de dados relacional
- **Docker & Docker Compose** - Containerização e orquestração
- **Timezone**: America/Sao_Paulo

## Estrutura do Projeto

```
tcc-platform-database/
├── docker-compose.yml      # Configuração do container PostgreSQL
├── init.sh                 # Script de inicialização automatizada
├── .env.example            # Template de variáveis de ambiente
├── .gitignore              # Arquivos ignorados pelo Git
├── README.md               # Este arquivo
├── migrations/             # Scripts de criação das tabelas
│   ├── 001_create_users_table.sql
│   ├── 002_create_projects_table.sql
│   ├── 003_create_deliveries_table.sql
│   ├── 004_create_feedbacks_table.sql
│   ├── 005_create_notifications_table.sql
│   └── 006_create_milestones_table.sql
└── seeds/                  # Dados de desenvolvimento
    └── dev_data.sql
```

## Modelo de Dados

### Diagrama ER (Entidade-Relacionamento)

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│     USERS       │       │    PROJECTS     │       │   DELIVERIES    │
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ id (PK)         │       │ id (PK)         │       │ id (PK)         │
│ name            │       │ title           │       │ project_id (FK) │
│ email (UNIQUE)  │       │ description     │       │ title           │
│ password_hash   │       │ status          │       │ description     │
│ user_type       │       │ start_date      │       │ deadline        │
│ is_active       │       │ expected_date   │       │ status          │
│ created_at      │       │ student_id (FK) │       │ file_url        │
│ updated_at      │       │ advisor_id (FK) │       │ submitted_at    │
└─────────────────┘       │ created_at      │       │ created_at      │
                           │ updated_at      │       │ updated_at      │
                           └─────────────────┘       └─────────────────┘

┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│   FEEDBACKS     │       │   MILESTONES    │       │  NOTIFICATIONS  │
├─────────────────┤       ├─────────────────┤       ├─────────────────┤
│ id (PK)         │       │ id (PK)         │       │ id (PK)         │
│ delivery_id (FK)│       │ project_id (FK) │       │ user_id (FK)    │
│ advisor_id (FK) │       │ title           │       │ type            │
│ comment         │       │ description     │       │ message         │
│ grade           │       │ due_date        │       │ project_id (FK) │
│ created_at      │       │ status          │       │ is_read         │
└─────────────────┘       │ created_at      │       │ created_at      │
                           │ updated_at      │       │ updated_at      │
                           └─────────────────┘       └─────────────────┘
```

**Relacionamentos (FKs):**

- `projects.student_id` → `users.id`
- `projects.advisor_id` → `users.id` (opcional)
- `deliveries.project_id` → `projects.id`
- `feedbacks.delivery_id` → `deliveries.id`
- `feedbacks.advisor_id` → `users.id`
- `milestones.project_id` → `projects.id`
- `notifications.user_id` → `users.id`
- `notifications.project_id` → `projects.id` (opcional)

### Tabelas

#### users
Armazena todos os usuários do sistema.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | SERIAL | Identificador único |
| name | VARCHAR(255) | Nome completo |
| email | VARCHAR(255) | Email (único, usado para login) |
| password_hash | VARCHAR(255) | Senha criptografada com bcrypt |
| user_type | ENUM | Tipo: `student`, `advisor`, `admin` |
| is_active | BOOLEAN | Flag de soft delete |
| created_at | TIMESTAMPTZ | Data de criação |
| updated_at | TIMESTAMPTZ | Data de atualização |

#### projects
Projetos de TCC/trabalhos acadêmicos.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | SERIAL | Identificador único |
| title | VARCHAR(500) | Título do projeto |
| description | TEXT | Descrição detalhada |
| status | ENUM | Status: `in_progress`, `completed`, `cancelled` |
| start_date | DATE | Data de início |
| expected_delivery_date | DATE | Previsão de entrega |
| student_id | INTEGER | Referência ao aluno (FK) |
| advisor_id | INTEGER | Referência ao orientador (FK, opcional) |
| created_at | TIMESTAMPTZ | Data de criação |
| updated_at | TIMESTAMPTZ | Data de atualização |

> `advisor_id` é nullable no banco: a obrigatoriedade de um projeto ter orientador
> é regra de negócio validada na camada de serviço do backend (mesmo padrão da
> regra de "1 projeto `in_progress` por aluno" descrita abaixo), não uma
> constraint SQL.

#### deliveries
Entregas/marcos do projeto.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | SERIAL | Identificador único |
| project_id | INTEGER | Referência ao projeto (FK) |
| title | VARCHAR(255) | Título da entrega |
| description | TEXT | Descrição do que deve ser entregue |
| deadline | TIMESTAMPTZ | Prazo de entrega |
| status | ENUM | Status: `pending`, `submitted`, `approved`, `rejected` |
| file_url | VARCHAR(1000) | URL do arquivo enviado |
| submitted_at | TIMESTAMPTZ | Data de submissão |
| created_at | TIMESTAMPTZ | Data de criação |
| updated_at | TIMESTAMPTZ | Data de atualização |

#### feedbacks
Avaliações dos orientadores sobre as entregas.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | SERIAL | Identificador único |
| delivery_id | INTEGER | Referência à entrega (FK) |
| advisor_id | INTEGER | Referência ao orientador (FK) |
| comment | TEXT | Comentário do orientador |
| grade | DECIMAL(4,2) | Nota (0.00 a 10.00) |
| created_at | TIMESTAMPTZ | Data de criação |

#### notifications
Notificações/alertas para os usuários.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | SERIAL | Identificador único |
| user_id | INTEGER | Referência ao usuário (FK) |
| type | ENUM | Tipo: `delivery_created`, `feedback_registered`, `milestone_created`, `milestone_updated` |
| message | TEXT | Mensagem da notificação |
| project_id | INTEGER | Referência ao projeto (FK, opcional) |
| is_read | BOOLEAN | Flag de leitura |
| created_at | TIMESTAMPTZ | Data de criação |
| updated_at | TIMESTAMPTZ | Data de atualização |

#### milestones
Marcos/etapas intermediárias do projeto.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| id | SERIAL | Identificador único |
| project_id | INTEGER | Referência ao projeto (FK) |
| title | VARCHAR(255) | Título do marco |
| description | TEXT | Descrição do marco |
| due_date | TIMESTAMPTZ | Prazo previsto |
| status | ENUM | Status: `pending`, `completed` |
| created_at | TIMESTAMPTZ | Data de criação |
| updated_at | TIMESTAMPTZ | Data de atualização |

### Regras de Negócio Importantes

> **Múltiplos Projetos por Aluno**
>
> Um aluno pode ter **múltiplos projetos** no banco de dados (mantendo histórico completo), porém apenas **1 projeto pode estar com status `in_progress`** por vez.
>
> Esta regra é controlada na **camada de serviço do backend**, não via constraint SQL, pelos seguintes motivos:
> 1. Flexibilidade para casos especiais (admin pode precisar ajustar)
> 2. Facilita migrações e correções de dados
> 3. Mensagens de erro mais amigáveis ao usuário via API
> 4. Permite regras de negócio mais complexas no futuro

## Pré-requisitos

- **Docker** (versão 20.10 ou superior)
- **Docker Compose** (versão 2.0 ou superior)
- **Git** (para clonar o repositório)

### Instalação do Docker

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose-v2

# Adicionar usuário ao grupo docker (evita usar sudo)
sudo usermod -aG docker $USER
# Fazer logout e login novamente para aplicar
```

## Início Rápido

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/tcc-platform-database.git
cd tcc-platform-database
```

### 2. Configure as variáveis de ambiente (opcional)

```bash
cp .env.example .env
# Edite o arquivo .env se necessário
```

### 3. Execute o script de inicialização

```bash
chmod +x init.sh
./init.sh
```

O script irá:
- ✅ Verificar se o Docker está instalado
- ✅ Iniciar o container PostgreSQL
- ✅ Aguardar o banco estar pronto
- ✅ Executar todas as migrations
- ✅ Popular com dados de desenvolvimento

### 4. Conecte ao banco

Após a inicialização, você receberá as informações de conexão:

```
Host:     localhost
Porta:    5432
Database: tcc_platform
Usuário:  tcc_admin
Senha:    tcc_secret_2024
```

**String de conexão:**
```
postgresql://tcc_admin:tcc_secret_2024@localhost:5432/tcc_platform
```

## Comandos Úteis

### Gerenciamento do Container

```bash
# Iniciar o banco
docker compose up -d

# Parar o banco
docker compose down

# Ver logs
docker compose logs -f postgres

# Reiniciar
docker compose restart
```

### Acessar o Banco

```bash
# Via Docker
docker exec -it tcc_platform_db psql -U tcc_admin -d tcc_platform

# Via psql local (se instalado)
psql -h localhost -p 5432 -U tcc_admin -d tcc_platform
```

### Reset do Banco (APAGA TODOS OS DADOS)

```bash
./init.sh --reset
./init.sh  # Reinicializa do zero
```

### Executar SQL manualmente

```bash
# Executar um arquivo SQL
docker exec -i tcc_platform_db psql -U tcc_admin -d tcc_platform < arquivo.sql

# Executar um comando SQL
docker exec -it tcc_platform_db psql -U tcc_admin -d tcc_platform -c "SELECT * FROM users;"
```

## Dados de Desenvolvimento

O seed `dev_data.sql` popula o banco com os seguintes dados:

### Usuários (senha: `senha123` para todos)

| Email | Tipo | Nome |
|-------|------|------|
| admin@tccplatform.com | Admin | Admin Sistema |
| admin.backup@tccplatform.com | Admin | Admin Backup |
| carlos.silva@universidade.edu.br | Advisor | Prof. Dr. Carlos Silva |
| ana.santos@universidade.edu.br | Advisor | Profa. Dra. Ana Santos |
| roberto.lima@universidade.edu.br | Advisor | Prof. Me. Roberto Lima |
| joao.oliveira@aluno.edu.br | Student | João Pedro Oliveira |
| maria.souza@aluno.edu.br | Student | Maria Clara Souza |
| lucas.costa@aluno.edu.br | Student | Lucas Fernandes Costa |
| beatriz.almeida@aluno.edu.br | Student | Beatriz Almeida |
| gabriel.rodrigues@aluno.edu.br | Student | Gabriel Rodrigues |

### Projetos

- 4 projetos com status `in_progress`
- 1 projeto com status `completed`
- Diversas entregas em diferentes estados
- Feedbacks de orientadores
- Marcos (milestones) em diferentes status
- Notificações de exemplo (delivery_created, feedback_registered, milestone_created, milestone_updated)

## Estrutura das Migrations

As migrations são executadas em ordem numérica:

1. **001_create_users_table.sql**
   - Cria o ENUM `user_type_enum`
   - Cria a tabela `users`
   - Cria índices para email, user_type e is_active
   - Cria função `update_updated_at_column()` (reutilizada pelas outras tabelas)
   - Cria trigger para atualização automática de `updated_at`

2. **002_create_projects_table.sql**
   - Cria o ENUM `project_status_enum`
   - Cria a tabela `projects` com FKs para users (`advisor_id` é nullable —
     a obrigatoriedade é validada no backend, não via constraint SQL)
   - Cria índices para student_id, advisor_id e status

3. **003_create_deliveries_table.sql**
   - Cria o ENUM `delivery_status_enum`
   - Cria a tabela `deliveries` com FK para projects
   - Cria índices para project_id, status e deadline

4. **004_create_feedbacks_table.sql**
   - Cria a tabela `feedbacks` com FKs para deliveries e users
   - Inclui constraint para validar nota (0-10)
   - Cria índices para delivery_id, advisor_id e created_at

5. **005_create_notifications_table.sql**
   - Cria o ENUM `notification_type_enum` (`delivery_created`,
     `feedback_registered`, `milestone_created`, `milestone_updated`)
   - Cria a tabela `notifications` com FKs para users e, opcionalmente,
     para projects
   - Cria índice parcial para notificações não lidas
   - Cria trigger para atualização automática de `updated_at`

6. **006_create_milestones_table.sql**
   - Cria o ENUM `milestone_status_enum`
   - Cria a tabela `milestones` com FK para projects
   - Cria índices para project_id, status e due_date
   - Cria trigger para atualização automática de `updated_at`

## Próximas Etapas do Projeto

Este repositório faz parte de um projeto maior composto por 3 repositórios:

- [x] **Etapa 1: Database** - Scripts SQL e migrations (este repositório)
- [ ] **Etapa 2: Backend** - Sistema de autenticação (JWT com access token)
- [ ] **Etapa 3: Backend** - CRUD de usuários
- [ ] **Etapa 4: Backend** - CRUD de projetos (com validação: aluno só pode ter 1 projeto ativo)
- [ ] **Etapa 5: Backend** - CRUD de entregas e feedbacks
- [ ] **Etapa 6: Frontend** - Autenticação e rotas protegidas
- [ ] **Etapa 7: Frontend** - Dashboards por tipo de usuário
- [ ] **Etapa 8: Frontend** - Gestão de projetos e entregas

### Repositórios Relacionados

- `tcc-platform-backend` - API REST com Express + TypeScript
- `tcc-platform-frontend` - Interface com React + Vite + TypeScript

## Hospedagem em Produção

Este projeto foi desenhado para ser facilmente migrado para serviços de banco de dados gerenciados:

- **Supabase** - PostgreSQL gerenciado com APIs extras
- **Neon** - PostgreSQL serverless
- **Railway** - Deploy simplificado
- **Render** - PostgreSQL gerenciado

Para migrar, exporte os scripts das pastas `migrations/` e `seeds/` e execute na ordem no serviço escolhido.

## Troubleshooting

### Porta 5432 já em uso

```bash
# Verificar o que está usando a porta
sudo lsof -i :5432

# Ou mude a porta no docker-compose.yml:
# ports:
#   - "5433:5432"
```

### Permissão negada no Docker

```bash
# Adicione seu usuário ao grupo docker
sudo usermod -aG docker $USER
# Faça logout e login novamente
```

### Container não inicia

```bash
# Verifique os logs
docker compose logs postgres

# Remova volumes antigos e tente novamente
docker compose down -v
docker compose up -d
```

## Contribuindo

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto é desenvolvido como Trabalho de Conclusão de Curso (TCC) e está disponível para fins educacionais.

---

**Desenvolvido com dedicacao para o TCC** | 2026
