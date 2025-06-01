DELIMITER //



DROP PROCEDURE IF EXISTS CalcularDadosStand //

CREATE PROCEDURE CalcularDadosStand(
    IN p_StandLocal VARCHAR(50)
)
BEGIN
    DECLARE v_Ganhos DECIMAL(18,2) DEFAULT 0;
    DECLARE v_DespesaAluguer DECIMAL(18,2) DEFAULT 0;
    DECLARE v_DespesaFuncionarios DECIMAL(18,2) DEFAULT 0;
    DECLARE v_DespesaTotal DECIMAL(18,2) DEFAULT 0;
    
    -- Cálculo dos Ganhos
    SELECT SUM(PrecoTotal) INTO v_Ganhos
    FROM Aluguer A
    WHERE A.StandLocal = p_StandLocal 
      AND YEAR(NOW()) = YEAR(DataHoraFinal);
    
    -- Cálculo da Despesa de Aluguer
    SELECT SUM(CustoTotal) INTO v_DespesaAluguer
    FROM Aluguer
    WHERE StandLocal = p_StandLocal;
    
    -- Cálculo da Despesa de Funcionários
    SELECT SUM(Salario) INTO v_DespesaFuncionarios
    FROM Funcionario
    WHERE StandLocal = p_StandLocal;
    
    -- Cálculo da Despesa Total
    SET v_DespesaTotal = v_DespesaFuncionarios * 0.4 + v_DespesaAluguer;
    
    
    -- Retornar os resultados
    SELECT 
        p_StandLocal AS Stand,
        v_Ganhos AS Ganhos,
        v_DespesaAluguer AS DespesaAluguer,
        v_DespesaFuncionarios AS DespesaFuncionarios,
        v_DespesaTotal AS DespesaTotal;
        
END//




DROP PROCEDURE IF EXISTS AtualizarManutencao //
CREATE PROCEDURE AtualizarManutencao(
    IN  p_matricula      VARCHAR(10),
    IN  p_data_selo      DATE,
    IN  p_data_vistoria  DATE,
    IN  p_data_seguro    DATE,
    OUT p_resultado      VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 'Falha ao atualizar – transacção anulada';
    END;

    IF NOT EXISTS (
        SELECT 1 FROM Limousine WHERE Matricula = p_matricula
    ) THEN
        SET p_resultado = 'Limousine não encontrada';

    ELSE
        START TRANSACTION;

        UPDATE Limousine
        SET DataSelo     = p_data_selo,
            DataVistoria = p_data_vistoria,
            DataSeguro   = p_data_seguro
        WHERE Matricula  = p_matricula;

        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SET p_resultado = 'Não foi possível atualizar a limousine';
        ELSE
            COMMIT;
            SET p_resultado = CONCAT(
                'Datas de manutenção atualizadas para a limousine ',
                p_matricula
            );
        END IF;
    END IF;
END //

DELIMITER ;

GRANT EXECUTE ON PROCEDURE CalcularDadosStand TO 'administrador'@'localhost';
GRANT EXECUTE ON PROCEDURE CalcularDadosStand TO 'gestor'@'localhost';


CALL CalcularDadosStand('Porto');

-- Exemplo de chamada com datas específicas
CALL AtualizarManutencao(
    'AA-00-AA',                   -- Matrícula
    '2028-12-15',               -- Nova DataSeto
    '2026-06-15',               -- Nova DataVisiona
    '2026-12-15',               -- Nova DataSeguro
    @resultado                  -- Variável de saída
);

-- Verificar resultado
SELECT @resultado;

SELECT * FROM limousine
	WHERE Matricula = 'AA-00-AA';
