-- RM4
PREPARE ListarAlugueres FROM
    'SELECT * FROM Aluguer
    WHERE (
        ? IS NULL OR
        (? = ''semana'' AND DataHoraInicial BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 WEEK)) OR
        (? = ''mes'' AND DataHoraInicial BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 MONTH)) OR
        (? = ''ano'' AND DataHoraInicial BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 YEAR))
    )
    ORDER BY DataHoraInicial;
    ';

SET @intervalo = 'semana';

EXECUTE ListarAlugueres USING @intervalo, @intervalo, @intervalo, @intervalo;
DEALLOCATE PREPARE ListarAlugueres;


-- RM5
PREPARE ListarLimousines FROM
    'SELECT * FROM Limousine
    WHERE (Cor = ? or ? IS NULL)
    AND (Capacidade = ? or ? IS NULL)';

SET @CorParam = 'Preto';
SET @CorNullCheck = @CorParam;
SET @CapacidadeParam = 5;
SET @CapacidadeNullCheck = @CapacidadeParam;

EXECUTE ListarLimousines USING @CorParam, @CorNullCheck, @CapacidadeParam, @CapacidadeNullCheck;
DEALLOCATE PREPARE ListarLimousines;


-- RM8
SELECT 
    Cliente.NIF,
    Cliente.Nome,
    Cliente.Email,
    Cliente.Telemovel,
    Cliente.Morada,
    Aluguer.ID AS AluguerID,
    Aluguer.LocalDeEntrega,
    Aluguer.CustoTotal,
    Aluguer.PrecoTotal,
    Aluguer.DataHoraInicial,
    Aluguer.DataHoraFinal
FROM Cliente
JOIN Aluguer ON Cliente.NIF = Aluguer.ClienteNIF
WHERE Cliente.NIF = '123456789';


-- Interrogação extra I
-- Listar as limousines com manutenção próxima (selo, seguro ou vistoria a expirar)
SELECT *
FROM Limousine
WHERE
    DataSelo < DATE_ADD(CURDATE(), INTERVAL 30 DAY) OR
    DataSeguro < DATE_ADD(CURDATE(), INTERVAL 30 DAY) OR
    DataVistoria < DATE_ADD(CURDATE(), INTERVAL 30 DAY);


-- Interrogação extra II
-- Listar as limousines mais lucrativas
SELECT
    A.LimousineMatricula,
    SUM(A.PrecoTotal - A.CustoTotal) AS LucroTotal
FROM Aluguer A
GROUP BY A.LimousineMatricula
ORDER BY LucroTotal DESC
LIMIT 5;

-- Interrogação extra III
-- Listar o funcionário com mais alugueres realizados no mês anterior
SELECT
    F.Numero,
    F.Nome,
    COUNT(A.ID) as NumAlugueres
FROM
    Funcionario F
JOIN
    Aluguer A ON F.Numero = A.FuncionarioNumero
WHERE
    A.DataHoraInicial >= DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01')
    AND A.DataHoraFinal < DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY
    F.Numero, F.Nome
ORDER BY
    NumAlugueres DESC
LIMIT 1;
