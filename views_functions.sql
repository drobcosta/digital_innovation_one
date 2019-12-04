CREATE OR REPLACE VIEW vw_bancos AS (
    SELECT numero, nome, ativo
    FROM banco
);

CREATE OR REPLACE VIEW vw_agencias AS (
    SELECT banco_numero, numero, nome, ativo
    FROM agencia
);

CREATE OR REPLACE VIEW vw_bancos_agencias (
    banco_numero,
    banco_nome,
    agencia_numero,
    agencia_nome,
    agencia_ativo
) AS (
    SELECT  banco.numero AS banco_numero,
            banco.nome AS banco_nome,
            agencia.numero AS agencia_numero,
            agencia.nome AS agencia_nome,
            agencia.ativo AS agencia_ativo
    FROM banco
    LEFT JOIN agencia ON agencia.banco_numero = banco.numero
);

CREATE OR REPLACE VIEW vw_cliente AS (
    SELECT numero, nome, email, ativo
    FROM cliente
);

CREATE OR REPLACE VIEW vw_tipo_transacao AS (
    SELECT id, nome
    FROM tipo_transacao
);

CREATE OR REPLACE VIEW vw_conta_corrente AS (
    SELECT  banco_numero,
            agencia_numero,
            numero,
            digito,
            cliente_numero,
            ativo
    FROM conta_corrente
);

CREATE OR REPLACE VIEW cliente_conta_corrente (
    banco_numero,
    banco_nome,
    agencia_numero,
    agencia_nome,
    conta_corrente_numero,
    conta_corrente_digito,
    cliente_numero,
    cliente_nome
) AS (
        SELECT  banco.numero AS banco_numero,
                banco.nome AS banco_nome,
                agencia.numero AS agencia_numero,
                agencia.nome AS agencia_nome,
                conta_corrente.numero AS conta_corrente_numero,
                conta_corrente.digito AS conta_corrente_digito,
                cliente.numero AS cliente_numero,
                cliente.nome AS cliente_nome
        FROM cliente
        JOIN conta_corrente ON conta_corrente.cliente_numero = cliente.numero
        JOIN agencia ON agencia.numero = conta_corrente.agencia_numero
        JOIN banco ON banco.numero = agencia.banco_numero AND banco.numero = conta_corrente.banco_numero
);

CREATE OR REPLACE VIEW vw_cliente_transacoes (
    cliente_numero,
    cliente_nome,
    banco_nome,
    agencia_nome,
    conta_corrente_numero,
    conta_corrente_digito,
    transacao_nome,
    valor
    
) AS (
    SELECT  cliente.numero AS cliente_numero,
            cliente.nome AS cliente_nome,
            banco.nome AS banco_nome,
            agencia.nome AS agencia_nome,
            cliente_transacoes.conta_corrente_numero,
            cliente_transacoes.conta_corrente_digito,
            tipo_transacao.nome AS transacao_nome,
            cliente_transacoes.valor
    FROM cliente
    JOIN cliente_transacoes ON cliente_transacoes.cliente_numero = cliente.numero
    JOIN agencia ON agencia.numero = cliente_transacoes.agencia_numero
    JOIN banco ON banco.numero = cliente_transacoes.banco_numero
    JOIN tipo_transacao ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id
);

CREATE OR REPLACE FUNCTION banco_manage(p_numero INTEGER,p_nome VARCHAR(50),p_ativo BOOLEAN)
RETURNS TABLE (banco_numero INTEGER, banco_nome VARCHAR(50), banco_ativo BOOLEAN)
LANGUAGE PLPGSQL
SECURITY DEFINER
RETURNS NULL ON NULL INPUT
AS $$
BEGIN
    -- O COMANDO ABAIXO VAI REALIZAR O INSERT OU O UPDATE DO BANCO
    -- O COMANDO ON CONFLICT PPODE SER USADO PARA FAZER NADA (DO NOTHING)
    -- OU PARA REALIZAR UM UPDATE NO NOSSO CASO.
    INSERT INTO banco (numero, nome, ativo)
    VALUES (p_numero, p_nome, p_ativo)
    ON CONFLICT (numero) DO UPDATE SET nome = p_nome, ativo = p_ativo;
    
    -- DEVEMOS RETORNAR UMA TABELA
    -- O RETURN NESTE CASO DEVE SER UMA QUERY
    RETURN QUERY
        SELECT numero, nome, ativo
        FROM banco
        WHERE numero = p_numero;
END; $$;

CREATE OR REPLACE FUNCTION agencia_manage(p_banco_numero INTEGER, p_numero INTEGER, p_nome VARCHAR(80), p_ativo BOOLEAN)
RETURNS TABLE (banco_nome VARCHAR, agencia_numero INTEGER, agencia_nome VARCHAR, agencia_ativo BOOLEAN)
LANGUAGE PLPGSQL
SECURITY DEFINER
RETURNS NULL ON NULL INPUT
AS $$
DECLARE variavel_banco_numero INTEGER;
BEGIN
    -- AQUI NÓS VAMOS VALIDAR A EXISTÊNCIA DO BANCO
    -- E PRINCIPALMENTE SE ELE ESTÁ ATIVO
    SELECT INTO variavel_banco_numero numero
    FROM vw_bancos
    WHERE numero = p_banco_numero
    AND ativo IS TRUE;
    
    -- SE OBTIVERMOS O RETORNO DO COMANDO ACIMA
    -- ENTÃO O BANCO EXISTE E ESTÁ ATIVO
    -- E PODEMOS PROSSEGUIR COM O INSERT DA AGÊNCIA
    IF variavel_banco_numero IS NOT NULL THEN
        -- O COMANDO ABAIXO VAI REALIZAR O INSERT OU O UPDATE DO BANCO
        -- O COMANDO ON CONFLICT PPODE SER USADO PARA FAZER NADA (DO NOTHING)
        -- OU PARA REALIZAR UM UPDATE NO NOSSO CASO.
        -- !!! REPAREM QUE O UPDATE SÓ SERÁ REALIZADO NOS CAMPOS NOME E ATIVO DA AGENCIA !!!
        -- !!! DESAFIO : QUE TAL MELHORAR ESSE CÓDIGO PARA SER POSSÍVEL A TROCA DE BANCO DAS AGÊNCIAS ???
        INSERT INTO AGENCIA (banco_numero, numero, nome, ativo)
        VALUES (p_banco_numero, p_numero, p_nome, p_ativo)
        ON CONFLICT (banco_numero, numero) DO UPDATE SET
        nome = p_nome,
        ativo = p_ativo;
    END IF;

    -- DEVEMOS RETORNAR UMA TABELA
    -- O RETURN NESTE CASO DEVE SER UMA QUERY
    RETURN QUERY
        SELECT  banco.nome AS banco_nome, 
                agencia.numero AS agencia_numero, 
                agencia.nome AS agencia_nome, 
                agencia.ativo AS agencia_ativo
        FROM agencia
        JOIN banco ON banco.numero = agencia.numero
        WHERE agencia.banco_numero = p_banco_numero
        AND agencia.numero = p_numero;
END; $$;

CREATE OR REPLACE FUNCTION cliente_manage(p_numero INTEGER, p_nome VARCHAR(120), p_email VARCHAR(250), p_ativo BOOLEAN)
RETURNS BOOLEAN
LANGUAGE PLPGSQL
SECURITY DEFINER
CALLED ON NULL INPUT
AS $$
BEGIN
    -- VAMOS VALIDAR SOMENTE OS PARÂMETROS MAIS IMPORTANTES
    IF p_numero IS NULL OR p_nome IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- FAREMOS O INSERT COM TRATAMENTO DE VALORES NULOS
    INSERT INTO cliente (numero, nome, email, ativo)
    VALUES (p_numero, p_nome, COALESCE(p_email,CONCAT(p_nome,'@sem_email')), COALESCE(p_ativo,TRUE))
    ON CONFLICT (numero) DO UPDATE SET nome = p_nome, email = CONCAT(p_nome,'@sem_email'), ativo = COALESCE(p_ativo,TRUE);
    
    RETURN TRUE;
END; $$;

-- !!! DESAFIO
-- ALTERAR A FUNÇÃO RECÉM CRIADA PARA CADASTRAR CLIENTES COM SUA CONTA CORRENTE
-- A ESTRUTURA DA FUNÇÃO JÁ ESTÁ ABAIXO
-- PRIMEIRO TEMOS QUE APAGAR A FUNÇÃO, POIS A MESMA JÁ EXISTE COM PARÂMETROS DIFERENTES

DROP FUNCTION cliente_manage(p_numero INTEGER, p_nome VARCHAR(120), p_email VARCHAR(250), p_ativo BOOLEAN);

-- AGORA DEVEMOS RECRIAR A FUNÇÃO CONTEMPLANDO TODAS AS VARIÁVEIS POSSÍVEIS
-- NÃO ESQUEÇA DE QUE É IMPORTANTE ATUALIZAR ALGUNS CAMPOS CASO O CLIENTE JÁ EXISTA
CREATE OR REPLACE FUNCTION cliente_manage(
    p_banco_numero INTEGER,
    p_agencia_numero INTEGER,
    p_cliente_numero INTEGER,
    p_cliente_nome VARCHAR(120),
    p_cliente_email VARCHAR(250),
    p_cliente_ativo BOOLEAN,
    p_conta_corrente_numero BIGINT,
    p_conta_corrente_digito SMALLINT,
    p_conta_corrente_ativo BOOLEAN
)
RETURNS TABLE (
    banco_nome VARCHAR,
    agencia_nome VARCHAR,
    cliente_nome VARCHAR,
    conta_corrente_numero BIGINT,
    conta_corrente_digito SMALLINT
)
LANGUAGE PLPGSQL
SECURITY DEFINER
RETURNS NULL ON NULL INPUT
AS $$
BEGIN
    -- SEU CÓDIGO AQUI
END; $$;
