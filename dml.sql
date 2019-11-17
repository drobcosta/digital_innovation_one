INSERT INTO banco (numero, nome) VALUES (341, 'Itaú Unibanco S.A.');
INSERT INTO banco (numero, nome) VALUES (237, 'Banco Bradesco S.A.');
INSERT INTO banco (numero, nome) VALUES (001, 'Banco do Brasil S.A.');
INSERT INTO banco (numero, nome) VALUES (033, 'Banco Santander (Brasil) S.A.');
INSERT INTO banco (numero, nome) VALUES (104, 'Caixa Econômica Federal');

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

INSERT INTO cliente (nome, email) VALUES ('Pato Donald','donald@disney.com');
INSERT INTO cliente (nome, email) VALUES ('José Colméia','colmeia@floresta.com');
INSERT INTO cliente (nome, email) VALUES ('Chaves','chaves@vila.com.mx');
INSERT INTO cliente (nome, email) VALUES ('Capitão América','c_america@marvel.com.su');
INSERT INTO cliente (nome, email) VALUES ('Homem de Ferro','iron@man.com.su');
INSERT INTO cliente (nome, email) VALUES ('Airton Senna','senna@mf1.com.br');
INSERT INTO cliente (nome, email) VALUES ('Silvio Santos','silviosantos@sbt.com.br');

INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (341,1,1,1,1);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (341,2,2,1,2);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (237,1,1,1,3);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (033,1,1,1,4);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (033,2,2,1,5);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (104,1,1,1,6);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (104,1,2,1,6);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (341,3,2,2,7);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (237,2,1,2,7);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (033,2,3,3,7);
INSERT INTO conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero) VALUES (104,1,3,1,7);

INSERT INTO tipo_transacao (nome) VALUES ('Débito');
INSERT INTO tipo_transacao (nome) VALUES ('Crédito');
INSERT INTO tipo_transacao (nome) VALUES ('Transferência');
INSERT INTO tipo_transacao (nome) VALUES ('Empréstimo');
