USE PrestigeLimousines;

-- Definir os papeis da empresa

-- DROP ROLE IF EXISTS
-- 'rececionista'@'localhost',
-- 'ceo'@'localhost',
-- 'socio'@'localhost';

CREATE ROLE
'operador'@'localhost',

'administrador'@'localhost',

'gestor'@'localhost';


-- RC1/RM11 -> Os rececionistas devem ter permissão para adicionar, remover e atualizar registos de clientes na base de dados.

GRANT SELECT, INSERT, UPDATE, DELETE ON Cliente TO 'operador'@'localhost';

-- RC2/RM13 -> Os rececionistas devem ter permissão para adicionar, remover e atualizar registos de alugueres na base de dados.

GRANT SELECT, INSERT, UPDATE, DELETE ON Aluguer TO 'operador'@'localhost';


-- RC3/RM10 -> Os sócios devem ter permissão para adicionar e atualizar registos de limousines na base de dados.
GRANT SELECT, INSERT, UPDATE ON Limousines TO 'gestor'@'localhost';

-- RC4/RM14 -> Apenas o CEO e os sócios devem ter permissão para visualizar a despesa e os ganhos anuais dos stands.
-- Apenas iermos definir as respetivas permissoes quando criarmos a Procedures/Funçao/View que faz isto. 

-- RC5 -> O CEO deve ter permissão para aceder e modificar todos os dados do sistema, sem restrições.

GRANT ALL PRIVILEGES ON PrestigeLimousines.* TO 'administrador'@'localhost';


-- CRIAR UTILIZADORES

DROP USER IF EXISTS
'helder.cerqueira'@'localhost',
'vitor.cerqueia'@'localhost',
'eusebio.cerqueira'@'localhost',
'juliana.lopes'@'localhost',
'francisco.pereira'@'localhost',
'vasco.palmeirim'@'localhost';

CREATE USER
'helder.cerqueira'@'localhost' IDENTIFIED BY 'root',
'vitor.cerqueia'@'localhost' IDENTIFIED BY 'root',
'eusebio.cerqueira'@'localhost' IDENTIFIED BY 'root',
'juliana.lopes'@'localhost' IDENTIFIED BY 'root',
'francisco.pereira'@'localhost' IDENTIFIED BY 'root',
'vasco.palmeirim'@'localhost' IDENTIFIED BY 'root';


GRANT 'operador'@'localhost' TO 'juliana.lopes'@'localhost';
SET DEFAULT ROLE 'operador'@'localhost' TO 'juliana.lopes'@'localhost';

GRANT 'operador'@'localhost' TO 'francisco.pereira'@'localhost';
SET DEFAULT ROLE 'operador'@'localhost' TO 'francisco.pereira'@'localhost';

GRANT 'operador'@'localhost' TO 'vasco.palmeirim'@'localhost';
SET DEFAULT ROLE 'operador'@'localhost' TO 'vasco.palmeirim'@'localhost';

GRANT 'gestor'@'localhost' TO 'eusebio.cerqueira'@'localhost';
SET DEFAULT ROLE 'gestor'@'localhost' TO 'eusebio.cerqueira'@'localhost';

GRANT 'gestor'@'localhost' TO 'vitor.cerqueira'@'localhost';
SET DEFAULT ROLE 'gestor'@'localhost' TO 'vitor.cerqueira'@'localhost';

GRANT 'administrador'@'localhost' TO 'helder.cerqueira'@'localhost';
SET DEFAULT ROLE 'administrador'@'localhost' TO 'helder.cerqueira'@'localhost';




















