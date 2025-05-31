USE PrestigeLimousines;

-- Tabelas sem dependências

CREATE TABLE Stand(
  Local VARCHAR(100) NOT NULL,
  Dono VARCHAR(200) NOT NULL,
	PRIMARY KEY (Local)
);

CREATE TABLE Cliente(
  NIF VARCHAR(15) NOT NULL CHECK (LENGTH(NIF) = 9),
  Nome VARCHAR(200) NOT NULL,
  Morada VARCHAR(200) NOT NULL,
  Email VARCHAR(255) NULL UNIQUE,
  Telemovel VARCHAR(15) NOT NULL UNIQUE,
	PRIMARY KEY (NIF)
);

-- Tabelas com dependências

CREATE TABLE Funcionario(
  Numero INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(200) NOT NULL,
  Funcao VARCHAR(75) NOT NULL,
  Salario DECIMAL(6,2) NOT NULL CHECK (Salario >= 0),
  StandLocal VARCHAR(100) NOT NULL,
	PRIMARY KEY (Numero),
	FOREIGN KEY (StandLocal) 
		REFERENCES Stand(Local)
);

CREATE TABLE Limousine(
  Matricula VARCHAR(10) NOT NULL CHECK (LENGTH(Matricula) = 8),
  CustoHora DECIMAL(6,2) NOT NULL CHECK (CustoHora >= 0),
  PrecoHora DECIMAL(6,2) NOT NULL CHECK (PrecoHora >= 0),
  Cor VARCHAR(45) NOT NULL,
  Capacidade INT NOT NULL CHECK (Capacidade >= 0),
  DataSeguro DATE NOT NULL,
  DataSelo DATE NOT NULL,
  DataVistoria DATE NOT NULL,
  Operacional BOOLEAN NOT NULL,
  StandLocal VARCHAR(100),
	PRIMARY KEY (Matricula),
	FOREIGN KEY (StandLocal) 
		REFERENCES Stand(Local)
);

CREATE TABLE Aluguer(
  Id INT NOT NULL AUTO_INCREMENT,
  LocalDeEntrega VARCHAR(200) NULL,
  CustoTotal DECIMAL(6,2) NOT NULL CHECK (CustoTotal >= 0),
  PrecoTotal DECIMAL(6,2) NOT NULL CHECK (PrecoTotal >= 0),
  DataHoraInicial DATETIME NOT NULL,
  DataHoraFinal DATETIME NOT NULL,
  FuncionarioNumero INT NOT NULL,
  ClienteNIF VARCHAR(15) NOT NULL,
  StandLocal VARCHAR(100) NOT NULL,
  LimousineMatricula VARCHAR(10) NOT NULL,
	PRIMARY KEY (Id),
	FOREIGN KEY (FuncionarioNumero) 
		REFERENCES Funcionario(Numero),
	FOREIGN KEY (ClienteNIF) 
		REFERENCES Cliente(NIF),
	FOREIGN KEY (StandLocal) 
		REFERENCES Stand(Local),
	FOREIGN KEY (LimousineMatricula) 
		REFERENCES Limousine(Matricula)
);





    