DELIMITER $$

CREATE FUNCTION ClienteFrequente(pNIF VARCHAR(15), pNumMinAlugueres INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM Aluguer
    WHERE ClienteNIF = pNIF
      AND DataHoraInicial >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

    RETURN total >= pNumMinAlugueres;
END$$

DELIMITER ;

