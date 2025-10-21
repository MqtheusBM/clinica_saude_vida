-- ---------------------------------
-- Arquivo: 03_views.sql
-- Descrição: Criação das Views e Materialized Views
-- ---------------------------------

-- Desafio 1: Criar uma view listando consultas por especialidade.
CREATE OR REPLACE VIEW v_consultas_por_especialidade AS
SELECT
    m.especialidade,
    c.id AS id_consulta,
    c.data_consulta,
    p.nome AS nome_paciente,
    m.nome AS nome_medico,
    c.valor
FROM consultas c
JOIN medicos m ON c.id_medico = m.id
JOIN pacientes p ON c.id_paciente = p.id
ORDER BY m.especialidade, c.data_consulta DESC;


-- Desafio 2: Criar uma materialized view com receita total por médico.
CREATE MATERIALIZED VIEW mv_receita_total_por_medico AS
SELECT
    m.id AS id_medico,
    m.nome AS nome_medico,
    m.especialidade,
    SUM(c.valor) AS receita_total,
    COUNT(c.id) AS total_consultas,
    AVG(c.valor) AS valor_medio_consulta
FROM consultas c
JOIN medicos m ON c.id_medico = m.id
GROUP BY m.id, m.nome, m.especialidade
ORDER BY receita_total DESC;


-- Desafio 4: Criar uma view que mostre os pacientes mais atendidos.
CREATE OR REPLACE VIEW v_pacientes_mais_atendidos AS
SELECT
    p.id AS id_paciente,
    p.nome,
    p.nascimento,
    p.cidade,
    COUNT(c.id) AS total_consultas
FROM pacientes p
JOIN consultas c ON p.id = c.id_paciente
GROUP BY p.id, p.nome, p.nascimento, p.cidade
ORDER BY total_consultas DESC;