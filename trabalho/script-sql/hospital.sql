DROP DATABASE hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE PESSOA (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    sexo            ENUM('m', 'f') NOT NULL,

    PRIMARY KEY (cpf)
);

INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('01234567891', 'RUA 10-A', '62981110000', '1993-05-21', 'Raphael', 'm');
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('01234567892', 'RUA 10-A', '62981110000', '1963-05-21', 'Daniel', 'm');
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('01234567893', 'RUA 10-A', '62981110000', '1983-05-21', 'Marco', 'm');
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('01234567894', 'RUA 10-A', '62981110000', '1973-05-21', 'Paula', 'f');
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('01234567895', 'RUA 10-A', '62981110000', '1963-05-21', 'Raphael', 'm');

CREATE TABLE PACIENTE (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    cpf_acompanhante    VARCHAR(11),
    gestante            BOOLEAN NOT NULL,
    sexo            ENUM('m', 'f') NOT NULL,

    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf_acompanhante) REFERENCES PESSOA(cpf)
);

INSERT INTO PACIENTE (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, gestante, cpf_acompanhante) 
VALUES ('65465464654', 'RUA 10-A', '62981110000', '1993-05-21', 'Raphael', 'm', false, null);
INSERT INTO PACIENTE (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, gestante, cpf_acompanhante) 
VALUES ('56165165165', 'RUA 10-A', '62981110000', '1963-05-21', 'Daniel', 'm', false, null);
INSERT INTO PACIENTE (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, gestante, cpf_acompanhante) 
VALUES ('57981681919', 'RUA 10-A', '62981110000', '1983-05-21', 'Marco', 'm', false, null);
INSERT INTO PACIENTE (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, gestante, cpf_acompanhante) 
VALUES ('05656515166', 'RUA 10-A', '62981110000', '1973-05-21', 'Paula', 'f', true, '01234567892');
INSERT INTO PACIENTE (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, gestante, cpf_acompanhante) 
VALUES ('05615151895', 'RUA 10-A', '62981110000', '1963-05-21', 'Raphael', 'm', false, '01234567895');

CREATE TABLE FUNCIONARIO (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL,
    sexo            ENUM('m', 'f') NOT NULL,

    PRIMARY KEY (cpf)
);

INSERT INTO FUNCIONARIO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('24345346456', 'RUA 10-A', '62981110000', '1993-05-21', 'Raphael', 'm', '2015-05-21', true, 1400.50);
INSERT INTO FUNCIONARIO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('12323556567', 'RUA 10-A', '62981110000', '1963-05-21', 'Daniel', 'm', '2012-05-21', true, 900.50);
INSERT INTO FUNCIONARIO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('45623424324', 'RUA 10-A', '62981110000', '1983-05-21', 'Marco', 'm', '2012-05-21', true, 900.50);
INSERT INTO FUNCIONARIO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('76873523434', 'RUA 10-A', '62981110000', '1973-05-21', 'Paula', 'f', '2012-05-21', true, 900.50);
INSERT INTO FUNCIONARIO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('24547567324', 'RUA 10-A', '62981110000', '1963-05-21', 'Raphael', 'm', '2012-05-21', true, 900.50);

CREATE TABLE ENFERMEIRO (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL,
    sexo            ENUM('m', 'f') NOT NULL,

    PRIMARY KEY (cpf)
);

INSERT INTO ENFERMEIRO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('12356675673', 'RUA 10-A', '62981110000', '1993-05-21', 'Raphael', 'm', '2015-05-21', true, 3444.50);
INSERT INTO ENFERMEIRO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('54624234344', 'RUA 10-A', '62981110000', '1963-05-21', 'Daniel', 'm', '2012-05-21', false, 3444.50);
INSERT INTO ENFERMEIRO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('65453453454', 'RUA 10-A', '62981110000', '1983-05-21', 'Marco', 'm', '2012-05-21', true, 3444.50);
INSERT INTO ENFERMEIRO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('76575232345', 'RUA 10-A', '62981110000', '1973-05-21', 'Paula', 'f', '2012-05-21', true, 3444.50);
INSERT INTO ENFERMEIRO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('25662343534', 'RUA 10-A', '62981110000', '1963-05-21', 'Raphael', 'm', '2012-05-21', true, 3444.50);

CREATE TABLE MEDICO (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL,
    sexo            ENUM('m', 'f') NOT NULL,

    PRIMARY KEY (cpf)
);

INSERT INTO MEDICO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('12341234132', 'RUA 10-A', '62981110000', '1993-05-21', 'Raphael', 'm', '2015-05-21', true, 13444.50);
INSERT INTO MEDICO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('23452345244', 'RUA 10-A', '62981110000', '1963-05-21', 'Daniel', 'm', '2012-05-21', false, 13444.50);
INSERT INTO MEDICO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('25113423442', 'RUA 10-A', '62981110000', '1983-05-21', 'Marco', 'm', '2012-05-21', true, 13444.50);
INSERT INTO MEDICO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('23452345243', 'RUA 10-A', '62981110000', '1973-05-21', 'Paula', 'f', '2012-05-21', true, 13444.50);
INSERT INTO MEDICO (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo, dt_inicio_trab, ativo, salario) 
VALUES ('35654623432', 'RUA 10-A', '62981110000', '1963-05-21', 'Raphael', 'm', '2012-05-21', true, 23444.50);

CREATE TABLE HORARIO (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(25),
    hr_inicial  TIME NOT NULL,
    hr_final    TIME NOT NULL,
    dia_semana  ENUM('SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB', 'DOM') NOT NULL,

    PRIMARY KEY (cod)
);

INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('segunda de manha', '07:00', '12:00', 'SEG');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('segunda de tarde', '13:00', '18:00', 'SEG');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('segunda de noite', '19:00', '00:00', 'SEG');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('segunda de madrugada', '01:00', '06:00', 'SEG');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('terça de manha', '07:00', '12:00', 'TER');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('terça de tarde', '13:00', '18:00', 'TER');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('terça de noite', '19:00', '00:00', 'TER');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('terça de madrugada', '01:00', '06:00', 'TER');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quarta de manha', '07:00', '12:00', 'QUA');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quarta de tarde', '13:00', '18:00', 'QUA');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quarta de noite', '19:00', '00:00', 'QUA');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quarta de madrugada', '01:00', '06:00', 'QUA');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quinta de manha', '07:00', '12:00', 'QUI');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quinta de tarde', '13:00', '18:00', 'QUI');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quinta de noite', '19:00', '00:00', 'QUI');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('quinta de madrugada', '01:00', '06:00', 'QUI');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sexta de manha', '07:00', '12:00', 'SEX');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sexta de tarde', '13:00', '18:00', 'SEX');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sexta de noite', '19:00', '00:00', 'SEX');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sabado de madrugada', '01:00', '06:00', 'SAB');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sabado de manha', '07:00', '12:00', 'SAB');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sabado de tarde', '13:00', '18:00', 'SAB');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sabado de noite', '19:00', '00:00', 'SAB');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('sabado de madrugada', '01:00', '06:00', 'SAB');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('domingo de manha', '07:00', '12:00', 'DOM');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('domingo de tarde', '13:00', '18:00', 'DOM');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('domingo de noite', '19:00', '00:00', 'DOM');
INSERT INTO HORARIO (descricao, hr_inicial, hr_final, dia_semana) 
VALUES ('domingo de madrugada', '01:00', '06:00', 'DOM');

CREATE TABLE TRABALHA_EM (
    cpf VARCHAR(11) NOT NULL,
    cpf_med VARCHAR(11),
    cpf_fun VARCHAR(11),
    cpf_enf VARCHAR(11),
    cod INT NOT NULL,

    FOREIGN KEY (cpf_fun) REFERENCES FUNCIONARIO(cpf),
    FOREIGN KEY (cpf_med) REFERENCES MEDICO(cpf),
    FOREIGN KEY (cpf_enf) REFERENCES ENFERMEIRO(cpf),
    FOREIGN KEY (cod) REFERENCES HORARIO(cod),
    PRIMARY KEY (cpf, cod)
);

INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 1);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 2);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 3);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 2);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 3);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 4);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 7);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 8);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 9);
INSERT INTO TRABALHA_EM (cpf, cpf_med, cod)
VALUES ('12341234132', '12341234132', 10);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 4);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 5);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 7);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 9);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 12);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 13);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 14);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 16);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 17);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 19);
INSERT INTO TRABALHA_EM (cpf, cpf_fun, cod)
VALUES ('24345346456', '24345346456', 20);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('12356675673', '12356675673', 2);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('12356675673', '12356675673', 3);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('12356675673', '12356675673', 4);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('12356675673', '12356675673', 10);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('54624234344', '54624234344', 5);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('54624234344', '54624234344', 9);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('54624234344', '54624234344', 13);
INSERT INTO TRABALHA_EM (cpf, cpf_enf, cod)
VALUES ('54624234344', '54624234344', 28);

CREATE TABLE SALA (
    numero      INT NOT NULL,
    andar       TINYINT,
    num_leitos  TINYINT NOT NULL,
    enf_gerente VARCHAR(11) NOT NULL,

    FOREIGN KEY (enf_gerente) REFERENCES ENFERMEIRO(cpf),
    PRIMARY KEY (numero)
);

INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (1, 2, 5, '54624234344');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (2, 1, 2, '54624234344');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (3, 4, 3, '12356675673');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (4, 5, 6, '54624234344');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (5, 3, 10, '12356675673');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (6, 2, 0, '12356675673');

CREATE TABLE INTERNACAO (
    cpf_pct     VARCHAR(11) NOT NULL,
    num_sala    INT NOT NULL,
    dt_intern   DATETIME NOT NULL,
    dt_alta     DATETIME,
    motivo      VARCHAR(50),

    FOREIGN KEY (cpf_pct) REFERENCES PACIENTE(cpf),
    FOREIGN KEY (num_sala) REFERENCES SALA(numero),
    PRIMARY KEY (cpf_pct, num_sala)
);

INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('56165165165', 4, '2018-05-21', '2018-05-22', 'Internacao');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('65465464654', 2, '2018-03-21', '2018-04-04', 'Internacao');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('57981681919', 1, '2018-02-21', '2018-03-01', 'Internacao');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('05656515166', 3, '2018-04-21', '2018-04-30', 'Internacao');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('05615151895', 5, '2018-06-21', null, null);
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('56165165165', 6, '2018-06-21', null, 'Internacao');

CREATE TABLE FICHA_PCT (
    cpf_pct     VARCHAR(11) NOT NULL,
    dt_triagem  DATETIME NOT NULL,
    obs         VARCHAR(255),
    peso_pct    FLOAT NOT NULL,
    altura_pct  FLOAT NOT NULL,
    cpf_enf     VARCHAR(11) NOT NULL,

    FOREIGN KEY (cpf_enf) REFERENCES ENFERMEIRO(cpf),
    FOREIGN KEY (cpf_pct) REFERENCES PACIENTE(cpf),
    PRIMARY KEY (cpf_pct, dt_triagem)
);

INSERT INTO FICHA_PCT
VALUES ('56165165165', '2018-05-21', 'Observacao', 50.50, 1.80, '12356675673');
INSERT INTO FICHA_PCT
VALUES ('05615151895', '2018-06-21', 'Observacao', 50.50, 1.80, '12356675673');
INSERT INTO FICHA_PCT
VALUES ('57981681919', '2018-03-21', 'Observacao', 50.50, 1.80, '12356675673');
INSERT INTO FICHA_PCT
VALUES ('65465464654', '2018-04-21', 'Observacao', 50.50, 1.80, '12356675673');
INSERT INTO FICHA_PCT
VALUES ('56165165165', '2018-02-21', 'Observacao', 50.50, 1.80, '12356675673');
INSERT INTO FICHA_PCT
VALUES ('56165165165', '2018-01-21', 'Observacao', 50.50, 1.80, '12356675673');

CREATE TABLE SINTOMA (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(255) NOT NULL,
    gravidade   ENUM('BAIXA', 'MEDIA', 'GRAVE') NOT NULL,

    PRIMARY KEY (cod)
);

INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Dor de cabeça', 'BAIXA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Febre Baixa', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Febre alta', 'GRAVE');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Dor de estomago', 'BAIXA');

CREATE TABLE SINTOMA_PCT (
    cod_sintoma     INT NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_triagem      DATETIME NOT NULL,
    
    FOREIGN KEY (cpf_pct, dt_triagem) REFERENCES FICHA_PCT (cpf_pct, dt_triagem),
    FOREIGN KEY (cod_sintoma) REFERENCES SINTOMA (cod),
    PRIMARY KEY (cod_sintoma, cpf_pct, dt_triagem)
);

INSERT INTO SINTOMA_PCT 
VALUES (1, '05615151895', '2018-06-21');
INSERT INTO SINTOMA_PCT 
VALUES (2, '57981681919', '2018-03-21');
INSERT INTO SINTOMA_PCT 
VALUES (4, '05615151895', '2018-06-21');
INSERT INTO SINTOMA_PCT 
VALUES (3, '65465464654', '2018-04-21');
INSERT INTO SINTOMA_PCT 
VALUES (2, '65465464654', '2018-04-21');
INSERT INTO SINTOMA_PCT 
VALUES (4, '56165165165', '2018-05-21');

CREATE TABLE MEDICAMENTO (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(255) NOT NULL,
    preco_unit  FLOAT NOT NULL,
    generico    BOOLEAN NOT NULL,

    PRIMARY KEY (cod)
);

INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 10.99, true);
INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 101.99, true);
INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 120.99, false);
INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 2.99, false);

CREATE TABLE COMBATE_SINTOMA (
    cod_medicamento     INT NOT NULL,
    cod_sintoma         INT NOT NULL,
    regularidade_uso    VARCHAR(50),

    FOREIGN KEY (cod_medicamento) REFERENCES MEDICAMENTO (cod),
    FOREIGN KEY (cod_sintoma) REFERENCES SINTOMA (cod),
    PRIMARY KEY (cod_medicamento, cod_sintoma)
);

INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (1, 1, 'todos os dias');
INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (2, 2, 'de 3 em 3 dias');
INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (3, 1, 'uma vez por semana');
INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (4, 2, '5 vezes por dia');

CREATE TABLE AREA_ATUACAO (
    cod             INT NOT NULL AUTO_INCREMENT,
    cod_macro_area  INT,
    descricao       VARCHAR(50) NOT NULL,

    FOREIGN KEY (cod_macro_area) REFERENCES AREA_ATUACAO (cod),
    PRIMARY KEY (cod)
);

INSERT INTO AREA_ATUACAO (cod_macro_area, descricao)
VALUES (null, 'Neurologia');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao)
VALUES (null, 'Pediatria');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao)
VALUES (null, 'Cardiologia');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao)
VALUES (3, 'Cirurgiao');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao)
VALUES (1, 'Cirurgiao');

CREATE TABLE FORMADO_EM (
    cod             INT NOT NULL AUTO_INCREMENT,
    cpf             VARCHAR(11) NOT NULL,

    FOREIGN KEY (cpf) REFERENCES MEDICO (cpf),
    PRIMARY KEY (cod)
);

INSERT INTO FORMADO_EM VALUES (1, '12341234132');
INSERT INTO FORMADO_EM VALUES (2, '23452345244');
INSERT INTO FORMADO_EM VALUES (3, '25113423442');
INSERT INTO FORMADO_EM VALUES (4, '23452345243');
INSERT INTO FORMADO_EM VALUES (5, '35654623432');

CREATE TABLE CONSULTA (
    cpf_med         VARCHAR(11) NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_atend        DATETIME NOT NULL,
    dt_atend_orig   DATETIME,
    dt_triagem      DATETIME NOT NULL,

    FOREIGN KEY (cpf_med) REFERENCES MEDICO (cpf),
    FOREIGN KEY (cpf_pct) REFERENCES PACIENTE (cpf),
    FOREIGN KEY (cpf_pct, dt_triagem) REFERENCES FICHA_PCT(cpf_pct, dt_triagem),
    PRIMARY KEY (cpf_med, cpf_pct, dt_atend)
);

INSERT INTO CONSULTA 
VALUES ('12341234132', '65465464654', '2018-05-01', null, '2018-04-21');
INSERT INTO CONSULTA 
VALUES ('23452345244', '56165165165', '2018-06-01', null, '2018-05-21');
INSERT INTO CONSULTA 
VALUES ('23452345243', '57981681919', '2018-04-01', null, '2018-03-21');
INSERT INTO CONSULTA 
VALUES ('25113423442', '57981681919', '2018-04-01', null, '2018-03-21');
INSERT INTO CONSULTA 
VALUES ('35654623432', '05615151895', '2018-07-01', null, '2018-06-21');
INSERT INTO CONSULTA 
VALUES ('35654623432', '65465464654', '2018-05-01', '2018-04-20', '2018-04-21');

CREATE TABLE ENCAMINHAMENTO (
    cod             INT NOT NULL AUTO_INCREMENT,
    motivo          VARCHAR(255) NOT NULL,
    descricao       VARCHAR(255) NOT NULL,
    dt_vencimento   DATETIME NOT NULL,
    cpf_med         VARCHAR(11) NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_atend        DATETIME NOT NULL,

    FOREIGN KEY (cpf_med, cpf_pct, dt_atend) REFERENCES CONSULTA(cpf_med, cpf_pct, dt_atend),
    PRIMARY KEY (cod)
);

INSERT INTO ENCAMINHAMENTO (motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend)
VALUES ('motivo', 'descricao', '2019-01-01', '12341234132', '65465464654', '2018-05-01');
INSERT INTO ENCAMINHAMENTO (motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend)
VALUES ('motivo', 'descricao', '2019-01-01', '35654623432', '65465464654', '2018-05-01');
INSERT INTO ENCAMINHAMENTO (motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend)
VALUES ('motivo', 'descricao', '2019-01-01', '35654623432', '05615151895', '2018-07-01');
INSERT INTO ENCAMINHAMENTO (motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend)
VALUES ('motivo', 'descricao', '2019-01-01', '25113423442', '57981681919', '2018-04-01');
INSERT INTO ENCAMINHAMENTO (motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend)
VALUES ('motivo', 'descricao', '2019-01-01', '23452345243', '57981681919', '2018-04-01');

CREATE TABLE RECEITA (
    cod_medicamento   INT NOT NULL,
    cpf_med         VARCHAR(11) NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_atend        DATETIME NOT NULL,
    dt_vencimento   DATETIME NOT NULL,
    obs             VARCHAR(255),

    FOREIGN KEY (cod_medicamento) REFERENCES MEDICAMENTO (cod),
    FOREIGN KEY (cpf_med, cpf_pct, dt_atend) REFERENCES CONSULTA (cpf_med, cpf_pct, dt_atend),
    PRIMARY KEY (cod_medicamento, cpf_med, cpf_pct, dt_atend)
);

INSERT INTO RECEITA 
VALUES (1, '35654623432', '65465464654', '2018-05-01', '2019-01-01', 'observacao');
INSERT INTO RECEITA 
VALUES (2, '12341234132', '65465464654', '2018-05-01', '2019-01-01', 'observacao');
INSERT INTO RECEITA 
VALUES (3, '35654623432', '65465464654', '2018-05-01', '2019-01-01', 'observacao');
INSERT INTO RECEITA 
VALUES (1, '25113423442', '57981681919', '2018-04-01', '2019-01-01', 'observacao');
INSERT INTO RECEITA 
VALUES (2, '23452345243', '57981681919', '2018-04-01', '2019-01-01', 'observacao');
