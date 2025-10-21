-- ---------------------------------
-- Arquivo: 01_create_tables.sql
-- Descrição: DDL de criação das tabelas da Clínica Saúde & Vida
-- ---------------------------------

-- Limpar tabelas existentes (para facilitar testes)
DROP TABLE IF EXISTS receitas CASCADE;
DROP TABLE IF EXISTS consultas CASCADE;
DROP TABLE IF EXISTS pacientes CASCADE;
DROP TABLE IF EXISTS medicos CASCADE;
DROP TABLE IF EXISTS auditoria_consultas CASCADE; -- Tabela de auditoria

-- Tabela de Pacientes
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nascimento DATE NOT NULL,
    cidade VARCHAR(100)
);

-- Tabela de Médicos
CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    especialidade VARCHAR(100) NOT NULL
);

-- Tabela de Consultas
CREATE TABLE consultas (
    id SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_consulta TIMESTAMP NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,

    CONSTRAINT fk_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    CONSTRAINT fk_medico FOREIGN KEY (id_medico) REFERENCES medicos(id)
);

-- Tabela de Receitas
CREATE TABLE receitas (
    id SERIAL PRIMARY KEY,
    id_consulta INT NOT NULL,
    medicamento VARCHAR(200) NOT NULL,
    dosagem VARCHAR(100),

    CONSTRAINT fk_consulta FOREIGN KEY (id_consulta) REFERENCES consultas(id)
);

-- Tabela de Auditoria (Para Desafio 3)
CREATE TABLE auditoria_consultas (
    id SERIAL PRIMARY KEY,
    id_consulta_alterada INT NOT NULL,
    data_alteracao TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_db TEXT NOT NULL,
    acao_realizada VARCHAR(10) NOT NULL, -- UPDATE, DELETE
    valor_antigo DECIMAL(10, 2),
    valor_novo DECIMAL(10, 2),
    data_consulta_antiga TIMESTAMP,
    data_consulta_nova TIMESTAMP
);

-- --- Índices para Otimização ---

-- Índice para buscar consultas por médico ou paciente
CREATE INDEX idx_consultas_id_medico ON consultas(id_medico);
CREATE INDEX idx_consultas_id_paciente ON consultas(id_paciente);

-- Índice para buscar médicos por especialidade
CREATE INDEX idx_medicos_especialidade ON medicos(especialidade);

-- Índice para buscar receitas pela consulta
CREATE INDEX idx_receitas_id_consulta ON receitas(id_consulta);