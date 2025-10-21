-- ---------------------------------
-- Arquivo: 04_triggers.sql
-- Descrição: Criação de Triggers de Auditoria e Integridade
-- ---------------------------------

-- 1. Desafio Bônus: Impedir consultas em datas passadas.

CREATE OR REPLACE FUNCTION fn_checar_data_consulta()
RETURNS TRIGGER AS $$
BEGIN
    -- Permite alterações em registros antigos, mas impede novos agendamentos no passado
    IF (TG_OP = 'INSERT' AND NEW.data_consulta < CURRENT_DATE) THEN
        RAISE EXCEPTION 'Não é permitido agendar consultas em datas passadas. (Data informada: %)', NEW.data_consulta::date;
    END IF;

    -- Se for um UPDATE, só barra se estiverem alterando a data para o passado
    IF (TG_OP = 'UPDATE' AND NEW.data_consulta IS DISTINCT FROM OLD.data_consulta AND NEW.data_consulta < CURRENT_DATE) THEN
         RAISE EXCEPTION 'Não é permitido reagendar consultas para datas passadas. (Data informada: %)', NEW.data_consulta::date;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Binda o trigger na tabela consultas
CREATE TRIGGER trg_checar_data_consulta
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW
EXECUTE FUNCTION fn_checar_data_consulta();


-- 2. Desafio 3: Trigger de auditoria para alterações em 'consultas'.

CREATE OR REPLACE FUNCTION fn_auditar_alteracao_consulta()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        -- Insere na auditoria se o valor ou a data da consulta mudarem
        INSERT INTO auditoria_consultas (id_consulta_alterada, usuario_db, acao_realizada, valor_antigo, valor_novo, data_consulta_antiga, data_consulta_nova)
        VALUES (
            NEW.id,
            current_user,
            'UPDATE',
            OLD.valor,
            NEW.valor,
            OLD.data_consulta,
            NEW.data_consulta
        );
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        -- Registra a deleção
        INSERT INTO auditoria_consultas (id_consulta_alterada, usuario_db, acao_realizada, valor_antigo, data_consulta_antiga)
        VALUES (
            OLD.id,
            current_user,
            'DELETE',
            OLD.valor,
            OLD.data_consulta
        );
        RETURN OLD;
    END IF;

    RETURN NULL; -- Resultado é ignorado em triggers AFTER
END;
$$ LANGUAGE plpgsql;

-- Binda o trigger na tabela consultas
CREATE TRIGGER trg_auditar_consulta
AFTER UPDATE OR DELETE ON consultas
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_alteracao_consulta();