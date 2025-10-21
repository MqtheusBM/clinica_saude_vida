Projeto de Banco de Dados: Clínica Saúde & Vida
Este projeto implementa o esquema de banco de dados para a "Clínica Saúde & Vida", um sistema de gerenciamento para pacientes, médicos, consultas e receitas. O foco é demonstrar o uso de recursos avançados de PostgreSQL, como Views, Materialized Views e Triggers, para garantir performance, integridade e auditoria.

Tecnologias Utilizadas
Banco de Dados: PostgreSQL (v12 ou superior)

Estrutura dos Arquivos
O projeto está dividido em scripts SQL numerados que devem ser executados em ordem:

01_create_tables.sql

Contém o DDL (Data Definition Language) para a criação de todas as tabelas:

pacientes

medicos

consultas

receitas

auditoria_consultas (tabela de log para a trigger)

Define todas as chaves primárias (PK), chaves estrangeiras (FK), constraints e índices.

02_populate.sql

Contém scripts DML (Data Manipulation Language) para inserção massiva de dados.

Utiliza generate_series e random() para popular o banco com:

50 Médicos

1.000 Pacientes

10.000 Consultas

03_views.sql

Cria as views solicitadas para abstração de dados:

v_consultas_por_especialidade (View Simples): Lista consultas detalhadas, juntando médicos e pacientes, ordenadas por especialidade.

v_pacientes_mais_atendidos (View Simples): Agrupa pacientes para mostrar os que mais realizaram consultas.

mv_receita_total_por_medico (Materialized View): Pré-calcula e armazena a receita total (SUM) por médico, otimizada para relatórios rápidos.

04_triggers.sql

Define as funções e triggers para automação e integridade:

fn_auditar_alteracao_consulta() (Trigger AFTER): Registra qualquer UPDATE ou DELETE na tabela consultas dentro da tabela auditoria_consultas.

fn_checar_data_consulta() (Trigger BEFORE): Impede que novas consultas sejam inseridas com uma data_consulta no passado (desafio bônus de integridade).

05_queries.sql

Script final para demonstração e análise.

Contém consultas de teste para as views e triggers.

Inclui os comandos EXPLAIN ANALYZE usados para gerar a tabela comparativa de performance (Query Padrão vs. Materialized View).
