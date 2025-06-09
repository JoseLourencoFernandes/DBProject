DELIMITER //
-- DROP TRIGGER tr_VerificarAluguer_BI;
CREATE TRIGGER tr_VerificarAluguer_BI
BEFORE INSERT ON Aluguer
FOR EACH ROW
BEGIN
    -- Verificar validade e operacionalidade da limousine
    
    DECLARE duracaoMinutos INT;
    
    IF NOT EXISTS (
        SELECT 1 FROM Limousine
        WHERE Matricula = NEW.LimousineMatricula
          AND operacional = 1
          AND dataVistoria >= NEW.DataHoraFinal
          AND dataSelo >= NEW.DataHoraFinal
          AND dataSeguro  >= NEW.DataHoraFinal
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: limousine nao esta apta ate ao final do aluguer.';
    END IF;

    SET duracaoMinutos = TIMESTAMPDIFF(MINUTE, NEW.DataHoraInicial, NEW.DataHoraFinal);

    IF duracaoMinutos < 60 OR duracaoMinutos > 960 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: a duracao do aluguer deve ser entre 1 hora e 16 horas.';
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
-- Erro: colisao
INSERT INTO Aluguer (LocalDeEntrega, CustoTotal, PrecoTotal, DataHoraInicial, DataHoraFinal, 
						FuncionarioNumero, ClienteNIF, StandLocal, LimousineMatricula) VALUES
  ('Hotel PortoBay', 100.00, 225.00, '2025-05-10 13:00:00', '2025-05-10 16:00:00', 1, '123456789', 'Porto', 'AA-00-AA');
 -- Inserir
INSERT INTO Aluguer (LocalDeEntrega, CustoTotal, PrecoTotal, DataHoraInicial, DataHoraFinal, 
						FuncionarioNumero, ClienteNIF, StandLocal, LimousineMatricula) VALUES
  ('Hotel PortoBay', 100.00, 225.00, '2025-05-10 21:00:00', '2025-05-11 03:00:00', 1, '123456789', 'Porto', 'AA-00-AA');

-- Erro nao apto
INSERT INTO Aluguer (LocalDeEntrega, CustoTotal, PrecoTotal, DataHoraInicial, DataHoraFinal, 
						FuncionarioNumero, ClienteNIF, StandLocal, LimousineMatricula) VALUES
  ('Hotel PortoBay', 100.00, 225.00, '2030-05-10 21:00:00', '2030-05-11 03:00:00', 1, '123456789', 'Porto', 'AA-00-AA');

-- Erro: duraçao
INSERT INTO Aluguer (LocalDeEntrega, PrecoTotal, DataHoraInicial, DataHoraFinal, 
						FuncionarioNumero, ClienteNIF, StandLocal, LimousineMatricula) VALUES
  ('Hotel PortoBay', 225.00, '2025-06-15 08:00:00', '2025-06-17 04:00:00', 1, '123456789', 'Porto', 'AA-00-AA');
  
  
SELECT * FROM Aluguer;

DELIMITER //
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

INSERT INTO Aluguer (LocalDeEntrega, PrecoTotal, DataHoraInicial, DataHoraFinal, 
						FuncionarioNumero, ClienteNIF, StandLocal, LimousineMatricula) VALUES
  ('Hotel PortoBay', 225.00, '2025-06-10 21:00:00', '2025-06-11 03:00:00', 1, '123456789', 'Porto', 'AA-00-AA');
  
