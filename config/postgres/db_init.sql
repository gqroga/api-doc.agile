-- Verifica se a extensão 'uuid-ossp' já está instalada antes de tentar criar
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_extension
        WHERE extname = 'uuid-ossp'
    ) THEN
        CREATE EXTENSION "uuid-ossp";
    END IF;
END $$;


-- Criar usuário
CREATE USER DOCPULSE_ADM WITH PASSWORD 'DOCPULSE_ADM';

-- Criar banco de dados
CREATE DATABASE GDBDOCPULSE;

-- Conceder permissões ao usuário no banco de dados
GRANT ALL PRIVILEGES ON DATABASE GDBDOCPULSE TO DOCPULSE_ADM;

-- Mudar para o banco de dados recém-criado
\c "GDBDOCPULSE";

-- Criar schema
CREATE SCHEMA docpulse_adm;

-- Conceder permissões ao usuário no schema
GRANT ALL PRIVILEGES ON SCHEMA docpulse_adm TO DOCPULSE_ADM;

-- Definir schema padrão para o usuário
ALTER USER DOCPULSE_ADM SET search_path TO docpulse_adm;