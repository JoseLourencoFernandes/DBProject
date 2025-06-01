
INSERT INTO Stand (Local, Dono) VALUES
  ('Porto', 'Hélder Cerqueira'),
  ('Cascais', 'Vítor Cerqueira'),
  ('Vilamoura', 'Eusébio Cerqueira');

INSERT INTO Cliente (NIF, Nome, Morada, Email, Telemovel) VALUES
  ('123456789', 'Ana Silva', 'Rua das Flores, Porto', 'ana.silva@mail.com', '912345678'),
  ('987654321', 'Carlos Gomes', 'Av. Central, Braga', NULL, '913456789'),
  ('192837465', 'Rita Soares', 'Rua do Sol, Cascais', 'rita.soares@mail.com', '914567890');

INSERT INTO Funcionario (Nome, Funcao, Salario, StandLocal) VALUES
  ('Juliana Lopes','Rececionista', 1500.00, 'Porto'),
  ('Francisco Pereira', 'Rececionista', 1300.00, 'Cascais'),
  ('Vasco Palmeirim', 'Rececionista', 1800.00, 'Vilamoura'),
  ('Hélder Cerqueira', 'CEO', 3500.00, 'Porto'),
  ('Vitor Cerqueira', 'Gerente', 2500.00, 'Cascais'),
  ('Eusébio Cerqueira', 'Gerente', 3000.00, 'Vilamoura');

INSERT INTO Limousine (Matricula, CustoHora, PrecoHora, Cor, Capacidade, DataSeguro, 
						DataSelo, DataVistoria, Operacional, StandLocal) VALUES
  ('AA-00-AA', 20.00, 45.00, 'Preto', 5, '2026-01-01', '2026-01-10', '2026-02-01', TRUE, 'Porto'),
  ('BB-11-BB', 22.00, 50.00, 'Branco', 6, '2026-03-01', '2026-03-10', '2026-04-01', TRUE, 'Cascais'),
  ('CC-22-CC', 25.00, 55.00, 'Cinzento', 7, '2025-05-01', '2025-05-10', '2025-06-01', FALSE, 'Vilamoura');

INSERT INTO Aluguer (LocalDeEntrega, CustoTotal, PrecoTotal, DataHoraInicial, DataHoraFinal, 
						FuncionarioNumero, ClienteNIF, StandLocal, LimousineMatricula) VALUES
  ('Hotel PortoBay', 100.00, 225.00, '2025-05-10 10:00:00', '2025-05-10 15:00:00', 1, '123456789', 'Porto', 'AA-00-AA'),
  ('Aeroporto de Lisboa', 110.00, 250.00, '2025-05-12 09:00:00', '2025-05-12 14:00:00', 2, '987654321', 'Cascais', 'BB-11-BB'),
  (NULL, 125.00, 275.00, '2025-05-15 14:00:00', '2025-05-15 19:00:00', 3, '192837465', 'Vilamoura', 'CC-22-CC');
