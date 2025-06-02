CREATE VIEW vwLimousinesOperacionais AS
	SELECT l.Matricula, l.PrecoHora, l.Cor, l.Capacidade, l.StandLocal AS Stand FROM 
		Limousine l
	WHERE l.Operacional = TRUE;


SELECT * FROM vwLimousinesOperacionais;

GRANT SELECT ON vwLimousinesOperacionais TO 'operador'@'localhost';

CREATE VIEW vwAlugueresAtivos AS
SELECT 
    a.ID as AluguerID,
    l.Matricula,
    c.NIF as ClienteNIF,
    c.Nome as ClienteNome,
    c.Email as ClienteEmail,
    c.Telemovel as ClienteTelemovel,
    a.LocalDeEntrega,
    a.DataHoraInicial,
    a.DataHoraFinal,
    a.PrecoTotal,
    s.Local as StandEntrega,
    f.Nome as FuncionarioResponsavel
FROM Aluguer a
INNER JOIN Limousine l ON a.LimousineMatricula = l.Matricula
INNER JOIN Cliente c ON a.ClienteNIF = c.NIF
INNER JOIN Stand s ON l.StandLocal = s.Local
INNER JOIN Funcionario f ON a.FuncionarioNumero = f.Numero
WHERE a.DataHoraFinal >= CURRENT_TIMESTAMP
  AND a.DataHoraInicial <= CURRENT_TIMESTAMP;
  
SELECT * FROM vwLimousinesOperacionais;
  
CREATE VIEW vwHistorialCliente AS
SELECT 
    c.NIF,
    c.Nome as ClienteNome,
    c.Email,
    c.Morada,
    COUNT(a.ID) as TotalAlugueres,
    SUM(a.PrecoTotal) as ValorTotalGasto,
    MAX(a.DataHoraFinal) as UltimoAluguer,
    MIN(a.DataHoraInicial) as PrimeiroAluguer
FROM Cliente c
LEFT JOIN Aluguer a ON c.NIF = a.ClienteNIF
GROUP BY c.NIF, c.Nome, c.Email, c.Morada;
  
GRANT SELECT ON vwAlugueresAtivos TO 'operador'@'localhost';
GRANT SELECT ON vwHistorialCliente TO 'operador'@'localhost';
