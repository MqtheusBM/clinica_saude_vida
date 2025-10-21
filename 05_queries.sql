-- ---------------------------------
-- Arquivo: 05_queries.sql
-- Descrição: Consultas, testes de trigger e análise de performance (EXPLAIN ANALYZE)
-- ---------------------------------

-- 1. Consultas usando as Views (Desafios 1 e 4)

-- Consultando Desafio 1 (View Simples)
SELECT * FROM v_consultas_por_especialidade
WHERE especialidade = 'Cardiologia'
LIMIT 10;

-- Consultando Desafio 4 (View Simples)
SELECT * FROM v_pacientes_mais_atendidos
LIMIT 10;


-- 2. Testando os Triggers (Desafio 3 e Bônus)

-- Teste Bônus (Espera-se um ERRO)
INSERT INTO consultas (id_paciente, id_medico, data_consulta, valor)
VALUES (1, 1, '2020-01-01', 250.00);
-- Deverá retornar: "ERROR: Não é permitido agendar consultas em datas passadas. (Data informada: 2020-01-01)"


-- Teste Bônus (Sucesso)
INSERT INTO consultas (id_paciente, id_medico, data_consulta, valor)
VALUES (1, 1, '2025-12-25 10:00:00', 250.00);


-- Teste Desafio 3 (Auditoria - UPDATE)
UPDATE consultas
SET valor = valor + 50.00
WHERE id = 1;

-- Verificando o log de auditoria
SELECT * FROM auditoria_consultas WHERE acao_realizada = 'UPDATE' ORDER BY data_alteracao DESC LIMIT 1;


-- 3. Análise de Performance (Comparação MV vs Query Real-Time)

-- ---
-- Medição 1: Receita total por médico (Query sem view)
-- (Agrupamento em tempo real)
-- ---
EXPLAIN ANALYZE
SELECT
    m.nome AS nome_medico,
    m.especialidade,
    SUM(c.valor) AS receita_total
FROM consultas c
JOIN medicos m ON c.id_medico = m.id
GROUP BY m.id, m.nome, m.especialidade;


-- ---
-- Medição 2: Receita total por médico (Materialized View)
-- ---

-- Passo A: Atualizar a MV (necessário após novas inserções)
-- O tempo deste REFRESH é o "custo de manutenção" da view.
REFRESH MATERIALIZED VIEW mv_receita_total_por_medico;

-- Passo B: Consultar a MV
-- (Leitura direta dos dados pré-calculados)
EXPLAIN ANALYZE
SELECT nome_medico, especialidade, receita_total
FROM mv_receita_total_por_medico;