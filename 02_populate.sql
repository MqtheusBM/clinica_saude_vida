-- ---------------------------------
-- Arquivo: 02_populate.sql
-- Descrição: Inserção massiva de dados (Exatamente 10.000 consultas)
-- ---------------------------------

-- 1. Inserir Médicos (50 médicos)
INSERT INTO medicos (nome, especialidade)
SELECT
    'Dr(a). ' || 'NomeMedico_' || s,
    (ARRAY['Cardiologia', 'Dermatologia', 'Ortopedia', 'Clínica Geral', 'Neurologia', 'Pediatria'])[floor(random() * 6 + 1)]
FROM generate_series(1, 50) s;

-- 2. Inserir Pacientes (1.000 pacientes)
INSERT INTO pacientes (nome, nascimento, cidade)
SELECT
    'Paciente ' || 'NomePaciente_' || s,
    (NOW() - (floor(random() * 365 * 70 + 18*365) || ' days')::interval)::date, -- Idades entre 18 e 70 anos
    (ARRAY['São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Porto Alegre', 'Boa Vista'])[floor(random() * 5 + 1)]
FROM generate_series(1, 1000) s;

-- 3. Inserir Consultas (Exatamente 10.000 consultas)
-- Assumindo que temos 1000 pacientes (IDs 1-1000) e 50 médicos (IDs 1-50)
INSERT INTO consultas (id_paciente, id_medico, data_consulta, valor)
SELECT
    floor(random() * 1000 + 1)::int,  -- id_paciente (1 a 1000)
    floor(random() * 50 + 1)::int,    -- id_medico (1 a 50)
    (NOW() - (random() * 365 * 3) * '1 day'::interval), -- Consultas nos últimos 3 anos
    floor(random() * 400 + 100)::decimal(10, 2) -- Valor entre R$ 100,00 e R$ 500,00
FROM generate_series(1, 10000) s; -- <-- Alterado para 10.000

-- 4. Inserir Receitas (Aprox. 7.000 receitas)
-- Cerca de 70% das consultas terão receitas
INSERT INTO receitas (id_consulta, medicamento, dosagem)
SELECT
    c.id,
    'Medicamento ' || (ARRAY['Atenolol', 'Dipirona', 'Amoxicilina', 'Sertralina', 'Losartana'])[floor(random() * 5 + 1)],
    (ARRAY['25mg 1x/dia', '500mg 3x/dia', '100mg 1x/dia', '50mg 2x/dia'])[floor(random() * 4 + 1)]
FROM consultas c
WHERE random() < 0.7; -- Seleciona aleatoriamente 70% das consultas