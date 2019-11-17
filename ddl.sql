CREATE TABLE banco (
        numero INTEGER NOT NULL,
        nome VARCHAR(50) NOT NULL,
        ativo BOOLEAN NOT NULL DEFAULT true,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (numero)
);

INSERT INTO banco (numero, nome) VALUES (341, 'Itaú Unibanco S.A.');
INSERT INTO banco (numero, nome) VALUES (237, 'Banco Bradesco S.A.');
INSERT INTO banco (numero, nome) VALUES (001, 'Banco do Brasil S.A.');
INSERT INTO banco (numero, nome) VALUES (033, 'Banco Santander (Brasil) S.A.');
INSERT INTO banco (numero, nome) VALUES (104, 'Caixa Econômica Federal');

CREATE TABLE agencia (
        banco_numero INTEGER NOT NULL,
        numero INTEGER NOT NULL,
        nome VARCHAR(80) NOT NULL,
        ativo BOOLEAN NOT NULL DEFAULT TRUE,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (banco_numero, numero),
        FOREIGN KEY (banco_numero) REFERENCES banco
);

INSERT INTO agencia (banco_numero, numero, nome) VALUES (341,1,'Centro da cidade');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (341,2,'Primeiro bairro da cidade');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (341,3,'Posto de gasolina');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (237,1,'Centro da cidade');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (237,2,'Monumento');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (237,3,'Praça da matriz');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (001,1,'Camara Municipal');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (001,2,'Jardins da Camara Municipal');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (001,3,'Posto policial');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (033,1,'Escola de Música');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (033,2,'Faculdade de Medicina');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (104,1,'Agencia do shopping');

CREATE TABLE cliente (
        numero BIGSERIAL NOT NULL PRIMARY KEY,
        nome VARCHAR (100) NOT NULL,
        email VARCHAR(250) NOT NULL,
        ativo BOOLEAN NOT NULL DEFAULT TRUE,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cliente (nome, email) VALUES ('Pato Donald','donald@disney.com');
INSERT INTO cliente (nome, email) VALUES ('José Colméia','colmeia@floresta.com');
INSERT INTO cliente (nome, email) VALUES ('Chaves','chaves@vila.com.mx');
INSERT INTO cliente (nome, email) VALUES ('Capitão América','c_america@marvel.com.su');
INSERT INTO cliente (nome, email) VALUES ('Homem de Ferro','iron@man.com.su');
INSERT INTO cliente (nome, email) VALUES ('Airton Senna','senna@mf1.com.br');
INSERT INTO cliente (nome, email) VALUES ('Silvio Santos','silviosantos@sbt.com.br');

CREATE TABLE conta_corrente (
        banco_numero INTEGER NOT NULL,
        agencia_numero INTEGER NOT NULL,
        numero BIGINT NOT NULL,
        digito SMALLINT NOT NULL,
        ativo BOOLEAN NOT NULL DEFAULT TRUE,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (banco_numero, agencia_numero, numero, digito),
        FOREIGN KEY (banco_numero, agencia_numero) REFERENCES agencia (banco_numero,numero)
);

INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (341,1,1,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (341,2,2,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (237,1,1,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (033,1,1,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (033,2,2,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (104,1,1,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (104,1,2,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (341,3,2,2);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (237,2,1,2);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (033,2,3,3);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito) VALUES (104,1,3,1);

CREATE TABLE cliente_dados_bancarios (
        banco_numero INTEGER NOT NULL,
        agencia_numero INTEGER NOT NULL,
        conta_corrente_numero BIGINT NOT NULL,
        conta_corrente_digito SMALLINT NOT NULL,
        cliente_numero BIGINT NOT NULL,
        ativo BOOLEAN NOT NULL DEFAULT TRUE,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero),
        FOREIGN KEY (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito) REFERENCES conta_corrente (banco_numero, agencia_numero, numero, digito),
        FOREIGN KEY (cliente_numero) REFERENCES cliente (numero)
);

INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (341,1,1,1,1);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (341,2,2,1,2);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (237,1,1,1,3);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (033,1,1,1,4);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (033,2,2,1,5);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (104,1,1,1,6);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (104,1,2,1,6);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (341,3,2,2,7);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (237,2,1,2,7);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (033,2,3,3,7);
INSERT INTO cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) VALUES (104,1,3,1,7);

CREATE TABLE tipo_transacao (
        id SMALLSERIAL NOT NULL PRIMARY KEY,
        nome VARCHAR(50) NOT NULL,
        ativo BOOLEAN NOT NULL DEFAULT TRUE,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tipo_transacao (nome) VALUES ('Débito');
INSERT INTO tipo_transacao (nome) VALUES ('Crédito');
INSERT INTO tipo_transacao (nome) VALUES ('Transferência');
INSERT INTO tipo_transacao (nome) VALUES ('Empréstimo');

CREATE TABLE cliente_transacao (
        id BIGSERIAL NOT NULL PRIMARY KEY,
        banco_numero INTEGER NOT NULL,
        agencia_numero INTEGER NOT NULL,
        conta_corrente_numero BIGINT NOT NULL,
        conta_corrente_digito SMALLINT NOT NULL,
        cliente_numero BIGINT NOT NULL,
        tipo_transacao_id SMALLINT NOT NULL,
        valor NUMERIC(15,2) NOT NULL,
        FOREIGN KEY (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) REFERENCES cliente_dados_bancarios (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero)
);
