DROP TABLE IF EXISTS produto_categoria CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS cliente_endereco CASCADE;
DROP TABLE IF EXISTS cliente_telefone CASCADE;
DROP TABLE IF EXISTS periodo_contato CASCADE;
DROP TABLE IF EXISTS status CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS pedido_produto CASCADE;
DROP TABLE IF EXISTS pedido_status CASCADE;

CREATE TABLE IF NOT EXISTS produto_categoria (
	id SMALLSERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT produto_categoria_pk PRIMARY KEY (id),
	CONSTRAINT produto_categoria_unique_1 UNIQUE (nome)
);

CREATE OR REPLACE VIEW vw_produto_categoria AS (
    SELECT  id,
            nome,
            ativo
    FROM produto_categoria
);

CREATE TABLE IF NOT EXISTS produto (
	numero_serie VARCHAR(50) NOT NULL,
	produto_categoria_id INTEGER NOT NULL,
	nome VARCHAR(100) NOT NULL,
	valor NUMERIC(15,2) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT produto_pk PRIMARY KEY (numero_serie),
	CONSTRAINT produto_categoria_fk_1 FOREIGN KEY (produto_categoria_id) REFERENCES produto_categoria(id),
	CONSTRAINT produto_valor_check_1 CHECK (valor >= 0)
);

CREATE OR REPLACE VIEW vw_produto AS (
    SELECT  numero_serie,
            produto_categoria_id,
            nome,
            valor,
            ativo
    FROM produto
    WHERE valor >= 0
) WITH LOCAL CHECK OPTION;

CREATE TABLE IF NOT EXISTS cliente (
	cpfcnpj VARCHAR(14) NOT NULL,
	nome VARCHAR(150) NOT NULL,
	email VARCHAR(250) NOT NULL,
	senha VARCHAR(50) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT cliente_pk PRIMARY KEY (cpfcnpj),
	CONSTRAINT cliente_email_check_1 UNIQUE (email)
);

CREATE OR REPLACE VIEW vw_cliente AS (
    SELECT  cpfcnpj,
            nome,
            email,
            senha,
            ativo
    FROM cliente
);

CREATE TABLE IF NOT EXISTS cliente_endereco (
	id BIGSERIAL NOT NULL,
	cliente_cpfcnpj VARCHAR(14) NOT NULL,
	cep VARCHAR(8) NOT NULL,
	logradouro VARCHAR(200) NOT NULL,
	numero VARCHAR(10) NOT NULL,
	complemento VARCHAR(50),
	bairro VARCHAR(100) NOT NULL,
	cidade VARCHAR(100) NOT NULL,
	referencia VARCHAR(250),
	entrega BOOLEAN NOT NULL DEFAULT FALSE,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT cliente_endereco_pk PRIMARY KEY (id),
	CONSTRAINT cliente_fk_1 FOREIGN KEY (cliente_cpfcnpj) REFERENCES cliente(cpfcnpj)
);

CREATE OR REPLACE VIEW vw_cliente_endereco AS (
    SELECT  cliente_cpfcnpj,
            cep,
            logradouro,
            numero,
            complemento,
            bairro,
            cidade,
            referencia,
            entrega,
            ativo
    FROM cliente_endereco
);

CREATE TABLE IF NOT EXISTS periodo_contato (
    id SMALLSERIAL NOT NULL,
    nome VARCHAR(15) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT periodo_contato_pk PRIMARY KEY (id),
	CONSTRAINT periodo_contato_unique_1 UNIQUE (nome)
);

CREATE OR REPLACE VIEW vw_periodo_contato AS (
    SELECT  id,
            nome,
            ativo
    FROM periodo_contato
    WHERE ativo IS TRUE
) WITH LOCAL CHECK OPTION;

CREATE TABLE IF NOT EXISTS cliente_telefone (
	id BIGSERIAL NOT NULL,
	cliente_cpfcnpj VARCHAR(14) NOT NULL,
	ddd VARCHAR(2) NOT NULL,
	telefone VARCHAR(10) NOT NULL,
	ramal VARCHAR(10),
	melhor_horario SMALLINT,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT cliente_telefone_pk PRIMARY KEY (id),
	CONSTRAINT cliente_fk_1 FOREIGN KEY (cliente_cpfcnpj) REFERENCES cliente(cpfcnpj),
	CONSTRAINT periodo_contato_fk_1 FOREIGN KEY (melhor_horario) REFERENCES periodo_contato(id),
	CONSTRAINT cliente_telefone_unico UNIQUE (cliente_cpfcnpj,ddd,telefone,ramal)
);

CREATE OR REPLACE VIEW vw_cliente_telefone AS (
    SELECT  cliente_cpfcnpj,
            ddd,
            telefone,
            ramal,
            melhor_horario,
            ativo
    FROM cliente_telefone
);

CREATE TABLE IF NOT EXISTS status (
	id SMALLSERIAL NOT NULL,
	nome VARCHAR(20) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT status_pk PRIMARY KEY (id),
	CONSTRAINT status_unique_1 UNIQUE (nome)
);

CREATE OR REPLACE VIEW vw_status AS (
    SELECT id, nome, ativo
    FROM status
    WHERE ativo IS TRUE
) WITH CASCADED CHECK OPTION;

CREATE TABLE IF NOT EXISTS pedido (
	id BIGSERIAL NOT NULL,
	status_id SMALLINT NOT NULL,
	cliente_cpfcnpj VARCHAR(14) NOT NULL,
	valor NUMERIC(15,2) NOT NULL,
	data_ultima_atualizacao TIMESTAMP WITHOUT TIME ZONE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pedido_pk PRIMARY KEY (id),
	CONSTRAINT status_fk_1 FOREIGN KEY (status_id) REFERENCES status(id),
	CONSTRAINT cliente_fk_1 FOREIGN KEY (cliente_cpfcnpj) REFERENCES cliente(cpfcnpj),
	CONSTRAINT pedido_valor_check_1 CHECK (valor >= 0)
);

CREATE OR REPLACE VIEW vw_pedido AS (
    SELECT  status_id,
            cliente_cpfcnpj,
            valor,
            data_ultima_atualizacao,
            data_criacao
    FROM pedido
);

CREATE TABLE IF NOT EXISTS pedido_produto (
	id BIGSERIAL NOT NULL,
	pedido_id BIGINT NOT NULL,
	produto_numero_serie VARCHAR(50) NOT NULL,
	produto_categoria_id INTEGER NOT NULL,
	produto_nome VARCHAR(100) NOT NULL,
	produto_valor NUMERIC(15,2) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	data_modificacao TIMESTAMP WITHOUT TIME ZONE,
	CONSTRAINT pedido_produto_pk PRIMARY KEY (id),
	CONSTRAINT produto_fk_1 FOREIGN KEY (produto_numero_serie) REFERENCES produto(numero_serie),
	CONSTRAINT produto_categoria_fk_1 FOREIGN KEY (produto_categoria_id) REFERENCES produto_categoria(id),
	CONSTRAINT pedido_produto_produto_valor_check_1 CHECK (produto_valor >= 0)
);

CREATE OR REPLACE VIEW vw_pedido_produto AS (
    SELECT  pedido_id,
            produto_numero_serie,
            produto_categoria_id,
            produto_nome,
            produto_valor,
            ativo,
            data_criacao,
            data_modificacao
    FROM pedido_produto
    WHERE produto_valor >= 0
);

DROP VIEW IF EXISTS vw_pedido;
ALTER TABLE IF EXISTS pedido DROP CONSTRAINT IF EXISTS status_fk_1;
ALTER TABLE IF EXISTS pedido DROP COLUMN IF EXISTS status_id;

CREATE OR REPLACE VIEW vw_pedido AS (
    SELECT  cliente_cpfcnpj,
            valor,
            data_ultima_atualizacao,
            data_criacao
    FROM pedido
);

CREATE TABLE IF NOT EXISTS pedido_status (
	pedido_id BIGINT NOT NULL,
	status_id SMALLINT NOT NULL DEFAULT 1,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pedido_status_pk PRIMARY KEY (pedido_id,status_id),
	CONSTRAINT pedido_fk_1 FOREIGN KEY (pedido_id) REFERENCES pedido(id),
	CONSTRAINT status_fk_1 FOREIGN KEY (status_id) REFERENCES status(id)
);

CREATE OR REPLACE VIEW vw_pedido_status AS (
    SELECT  pedido_id,
            status_id,
            data_criacao
    FROM pedido_status
);

INSERT INTO vw_produto_categoria (nome) VALUES ('Eletrodomésticos') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Celulares') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Informática') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Cama, Mesa e Banho') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Música') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Beleza e Perfumaria') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Livros') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Eletrônicos') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Esportes') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_produto_categoria (nome) VALUES ('Viagens') ON CONFLICT (nome) DO NOTHING;

INSERT INTO vw_status (nome) VALUES ('Inicial') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Em análise') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Em aprovação') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Aprovado') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Em produção') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Pronto para entrega') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Em rota') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Em devolução') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Entregue') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_status (nome) VALUES ('Cancelado') ON CONFLICT (nome) DO NOTHING;

INSERT INTO vw_periodo_contato (nome) VALUES ('Manhã') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_periodo_contato (nome) VALUES ('Tarde') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_periodo_contato (nome) VALUES ('Noite') ON CONFLICT (nome) DO NOTHING;
INSERT INTO vw_periodo_contato (nome) VALUES ('Madrugada') ON CONFLICT (nome) DO NOTHING;
