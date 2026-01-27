#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DB_USER="tcc_admin"
DB_PASSWORD="tcc_secret_2024"
DB_NAME="tcc_platform"
DB_HOST="localhost"
DB_PORT="5432"
CONTAINER_NAME="tcc_platform_db"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
log_error() { echo -e "${RED}[ERRO]${NC} $1"; }

check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker não instalado."
        exit 1
    fi
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose não instalado."
        exit 1
    fi
    log_success "Docker OK"
}

start_docker() {
    log_info "Iniciando container..."
    cd "$SCRIPT_DIR"
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d
    else
        docker compose up -d
    fi
    log_success "Container iniciado"
}

wait_for_postgres() {
    log_info "Aguardando PostgreSQL..."
    local max_attempts=30
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        if docker exec "$CONTAINER_NAME" pg_isready -U "$DB_USER" -d "$DB_NAME" &> /dev/null; then
            log_success "PostgreSQL pronto"
            return 0
        fi
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    echo ""
    log_error "PostgreSQL não respondeu."
    exit 1
}

check_if_initialized() {
    local result
    result=$(docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'users';" 2>/dev/null || echo "0")
    [ "$result" = "1" ]
}

run_migrations() {
    log_info "Executando migrations..."
    for migration in $(ls -1 "$SCRIPT_DIR/migrations"/*.sql 2>/dev/null | sort); do
        local filename=$(basename "$migration")
        log_info "  -> $filename"
        docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < "$migration"
    done
    log_success "Migrations executadas"
}

run_seeds() {
    log_info "Inserindo dados de desenvolvimento..."
    for seed in $(ls -1 "$SCRIPT_DIR/seeds"/*.sql 2>/dev/null | sort); do
        local filename=$(basename "$seed")
        log_info "  -> $filename"
        docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < "$seed"
    done
    log_success "Seeds executados"
}

show_connection_info() {
    echo ""
    echo "============================================"
    echo -e "${GREEN}BANCO INICIALIZADO!${NC}"
    echo "============================================"
    echo "Host:     $DB_HOST"
    echo "Porta:    $DB_PORT"
    echo "Database: $DB_NAME"
    echo "Usuário:  $DB_USER"
    echo "Senha:    $DB_PASSWORD"
    echo ""
    echo "Conexão: postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"
    echo "============================================"
}

reset_database() {
    log_warning "Isso irá APAGAR todos os dados!"
    read -p "Continuar? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log_info "Cancelado."
        exit 0
    fi
    cd "$SCRIPT_DIR"
    if command -v docker-compose &> /dev/null; then
        docker-compose down -v
    else
        docker compose down -v
    fi
    log_success "Banco resetado. Execute ./init.sh para reinicializar."
}

main() {
    echo ""
    echo "  TCC Platform - Inicialização do Banco"
    echo ""

    case "${1:-}" in
        --reset)
            check_docker
            reset_database
            exit 0
            ;;
        --help|-h)
            echo "Uso: ./init.sh [--reset | --help]"
            exit 0
            ;;
    esac

    check_docker
    start_docker
    wait_for_postgres

    if check_if_initialized; then
        log_warning "Banco já inicializado. Use --reset para reiniciar."
        show_connection_info
        exit 0
    fi

    run_migrations
    run_seeds
    show_connection_info
}

main "$@"
