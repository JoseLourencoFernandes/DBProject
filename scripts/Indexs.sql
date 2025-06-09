CREATE INDEX idx_disponibilidade_temporal ON Aluguer(DataHoraInicial, DataHoraFinal);

CREATE INDEX idx_historico_cliente ON Aluguer(ClienteNIF);
