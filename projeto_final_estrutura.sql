CREATE TABLE IF NOT EXISTS produto_categoria (
	id SMALLSERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT produto_categoria_pk PRIMARY KEY (id),
	CONSTRAINT produto_categoria_unique_1 UNIQUE (nome)
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
	CONSTRAINT produto_valor_check_1 CHECK (valor > 0)
);

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
	CONSTRAINT cliente_telefone_unico UNIQUE (cliente_cpfcnpj,ddd,telefone,ramal)
);

CREATE TABLE IF NOT EXISTS status (
	id SMALLSERIAL NOT NULL,
	nome VARCHAR(20) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT status_pk PRIMARY KEY (id),
	CONSTRAINT status_unique_1 UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS pedido (
	id BIGSERIAL NOT NULL,
	status_id SMALLINT NOT NULL,
	cliente_cpfcnpj VARCHAR(14) NOT NULL,
	valor NUMERIC(15,2) NOT NULL,
	data_ultima_atualizadao TIMESTAMP WITHOUT TIME ZONE,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pedido_pk PRIMARY KEY (id),
	CONSTRAINT status_fk_1 FOREIGN KEY (status_id) REFERENCES status(id),
	CONSTRAINT cliente_fk_1 FOREIGN KEY (cliente_cpfcnpj) REFERENCES cliente(cpfcnpj),
	CONSTRAINT pedido_valor_check_1 CHECK (valor > 0)
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
	CONSTRAINT pedido_produto_produto_valor_check_1 CHECK (produto_valor > 0)
);

ALTER TABLE IF EXISTS pedido DROP CONSTRAINT status_fk_1;
ALTER TABLE IF EXISTS pedido DROP COLUMN IF EXISTS status_id;

CREATE TABLE IF NOT EXISTS pedido_status (
	pedido_id BIGINT NOT NULL,
	status_id SMALLINT NOT NULL,
	data_criacao TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pedido_status_pk PRIMARY KEY (pedido_id,status_id),
	CONSTRAINT pedido_fk_1 FOREIGN KEY (pedido_id) REFERENCES pedido(id),
	CONSTRAINT status_fk_1 FOREIGN KEY (status_id) REFERENCES status(id)
);

INSERT INTO produto_categoria (nome) VALUES ('Eletrodomésticos');
INSERT INTO produto_categoria (nome) VALUES ('Celulares');
INSERT INTO produto_categoria (nome) VALUES ('Informática');
INSERT INTO produto_categoria (nome) VALUES ('Cama, Mesa e Banho');
INSERT INTO produto_categoria (nome) VALUES ('Música');
INSERT INTO produto_categoria (nome) VALUES ('Beleza e Perfumaria');
INSERT INTO produto_categoria (nome) VALUES ('Livros');
INSERT INTO produto_categoria (nome) VALUES ('Eletrônicos');
INSERT INTO produto_categoria (nome) VALUES ('Esportes');
INSERT INTO produto_categoria (nome) VALUES ('Viagens');

INSERT INTO status (nome) VALUES ('Inicial');
INSERT INTO status (nome) VALUES ('Em análise');
INSERT INTO status (nome) VALUES ('Em aprovação');
INSERT INTO status (nome) VALUES ('Aprovado');
INSERT INTO status (nome) VALUES ('Em produção');
INSERT INTO status (nome) VALUES ('Pronto para entrega');
INSERT INTO status (nome) VALUES ('Em rota');
INSERT INTO status (nome) VALUES ('Em devolução');
INSERT INTO status (nome) VALUES ('Entregue');
INSERT INTO status (nome) VALUES ('Cancelado');

/*
DROP TABLE IF EXISTS produto_categoria CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS cliente_endereco CASCADE;
DROP TABLE IF EXISTS cliente_telefone CASCADE;
DROP TABLE IF EXISTS status CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS pedido_produto CASCADE;
DROP TABLE IF EXISTS pedido_status CASCADE;
*/
