DELIMITER //

CREATE TRIGGER tr_VerificarAluguer_BI
BEFORE INSERT ON Aluguer
FOR EACH ROW
BEGIN
    -- Verificar validade e operacionalidade da limousine
    IF NOT EXISTS (
        SELECT 1 FROM Limousine
        WHERE Matricula = NEW.LimousineMatricula
          AND operacional = 1
          AND data_vistoria_validade >= NEW.DataHoraFinal
          AND data_selo_validade    >= NEW.DataHoraFinal
          AND data_seguro_validade  >= NEW.DataHoraFinal
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: limousine nao esta apta ate ao final do aluguer.';
    END IF;

    -- Verificar sobreposição de alugueres
    IF EXISTS (
        SELECT 1 FROM Aluguer
        WHERE LimousineMatricula = NEW.LimousineMatricula
          AND (
              NEW.DataHoraInicial BETWEEN DataHoraInicial AND DataHoraFinal
              OR NEW.DataHoraFinal BETWEEN DataHoraInicial AND DataHoraFinal
              OR DataHoraInicial BETWEEN NEW.DataHoraInicial AND NEW.DataHoraFinal
              OR DataHoraFinal BETWEEN NEW.DataHoraInicial AND NEW.DataHoraFinal
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: a limousine ja esta reservada nesse periodo!';
    END IF;
END;
//



CREATE TRIGGER tr_CalcularDespesaAluguer_BI
BEFORE INSERT ON Aluguer
FOR EACH ROW
BEGIN
    DECLARE horas DECIMAL(6,2);
    DECLARE custoLimousine DECIMAL(6,2);

    -- Calcular as horas do aluguer (fração de horas)
    SET horas = TIMESTAMPDIFF(MINUTE, NEW.DataHoraInicial, NEW.DataHoraFinal) / 60.0;

    -- Obter o custo por hora da limousine
    SELECT custoHora INTO custoLimousine
    FROM Limousine
    WHERE Matricula = NEW.LimousineMatricula;

    -- Calcular e definir a despesa (horas * (custoHora + 15))
    SET NEW.CustoTotal = horas * (custoLimousine + 15);
END;
//

CREATE TRIGGER trg_VerificarSobreposicaoAluguer_BI
BEFORE INSERT ON Aluguer
FOR EACH ROW
BEGIN
    DECLARE contagem INT;

    SELECT COUNT(*) INTO contagem
    FROM Aluguer
    WHERE LimousineMatricula = NEW.LimousineMatricula
      AND (
          (NEW.DataHoraInicial BETWEEN DataHoraInicial AND DataHoraFinal) OR
          (NEW.DataHoraFinal BETWEEN DataHoraInicial AND DataHoraFinal) OR
          (DataHoraInicial BETWEEN NEW.DataHoraInicial AND NEW.DataHoraFinal) OR
          (DataHoraFinal BETWEEN NEW.DataHoraInicial AND NEW.DataHoraFinal)
      );

    IF contagem > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Datas de aluguer coincidentes para a mesma limousine.';
    END IF;
END;

DELIMITER ;
