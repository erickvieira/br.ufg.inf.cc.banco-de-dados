DROP DATABASE hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE PESSOA (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATE NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    sexo            ENUM( 'M', 'F' ),

    PRIMARY KEY (cpf)
);

CREATE TABLE PACIENTE (
    cpf                 VARCHAR(11) NOT NULL,
    cpf_acompanhante    VARCHAR(11),
    gestante            BOOLEAN NOT NULL,

    FOREIGN KEY (cpf) REFERENCES PESSOA(cpf),
    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf_acompanhante) REFERENCES PESSOA(cpf)
);

CREATE TABLE FUNCIONARIO (
    cpf             VARCHAR(11) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATE NOT NULL,
    ativo           BOOLEAN NOT NULL,

    FOREIGN KEY (cpf) REFERENCES PESSOA(cpf),
    PRIMARY KEY (cpf)
);

CREATE TABLE HORARIO (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(25),
    hr_inicial  TIME NOT NULL,
    hr_final    TIME NOT NULL,
    dia_semana  ENUM( 'DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB' ) NOT NULL,

    PRIMARY KEY (cod)
);

CREATE TABLE TRABALHA_EM (
    cpf VARCHAR(11) NOT NULL,
    cod INT NOT NULL,

    FOREIGN KEY (cpf) REFERENCES FUNCIONARIO(cpf),
    FOREIGN KEY (cod) REFERENCES HORARIO(cod),
    PRIMARY KEY (cpf, cod)
);

CREATE TABLE ENFERMEIRO (
    cpf VARCHAR(11) NOT NULL,

    FOREIGN KEY (cpf) REFERENCES FUNCIONARIO(cpf),
    PRIMARY KEY (cpf)
);

CREATE TABLE SALA (
    numero      INT NOT NULL,
    andar       TINYINT,
    num_leitos  TINYINT NOT NULL,
    enf_gerente VARCHAR(11) NOT NULL,

    FOREIGN KEY (enf_gerente) REFERENCES ENFERMEIRO(cpf),
    PRIMARY KEY (numero)
);

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

CREATE TABLE SINTOMA (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(255) NOT NULL,
    gravidade   ENUM('BAIXA', 'MEDIA', 'GRAVE', 'GRAVÍSSIMO') NOT NULL,

    PRIMARY KEY (cod)
);

CREATE TABLE SINTOMA_PCT (
    cod_sintoma     INT NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_triagem      DATETIME NOT NULL,
    
    FOREIGN KEY (cpf_pct, dt_triagem) REFERENCES FICHA_PCT (cpf_pct, dt_triagem),
    FOREIGN KEY (cod_sintoma) REFERENCES SINTOMA (cod),
    PRIMARY KEY (cod_sintoma, cpf_pct, dt_triagem)
);

CREATE TABLE MEDICAMENTO (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(255) NOT NULL,
    preco_unit  FLOAT NOT NULL,
    generico    BOOLEAN NOT NULL,

    PRIMARY KEY (cod)
);

CREATE TABLE COMBATE_SINTOMA (
    cod_medicamento     INT NOT NULL,
    cod_sintoma         INT NOT NULL,
    regularidade_uso    VARCHAR(50),

    FOREIGN KEY (cod_medicamento) REFERENCES MEDICAMENTO (cod),
    FOREIGN KEY (cod_sintoma) REFERENCES SINTOMA (cod),
    PRIMARY KEY (cod_medicamento, cod_sintoma)
);

CREATE TABLE MEDICO (
    cpf VARCHAR(11) NOT NULL,
    crm VARCHAR(20) NOT NULL,

    FOREIGN KEY (cpf) REFERENCES FUNCIONARIO(cpf),
    PRIMARY KEY (cpf)
);

CREATE TABLE AREA_ATUACAO (
    cod             INT NOT NULL AUTO_INCREMENT,
    cod_macro_area  INT,
    descricao       VARCHAR(50) NOT NULL,

    FOREIGN KEY (cod_macro_area) REFERENCES AREA_ATUACAO (cod),
    PRIMARY KEY (cod)
);

CREATE TABLE FORMADO_EM (
    cod INT NOT NULL,
    cpf VARCHAR(11) NOT NULL,

    FOREIGN KEY (cod) REFERENCES AREA_ATUACAO (cod),
    FOREIGN KEY (cpf) REFERENCES MEDICO (cpf),
    PRIMARY KEY (cod, cpf)
);

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

CREATE TABLE ENCAMINHAMENTO (
    cod             INT NOT NULL AUTO_INCREMENT,
    motivo          VARCHAR(255) NOT NULL,
    descricao       VARCHAR(255),
    dt_vencimento   DATETIME NOT NULL,
    cpf_med         VARCHAR(11) NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_atend        DATETIME NOT NULL,

    FOREIGN KEY (cpf_med, cpf_pct, dt_atend) REFERENCES CONSULTA(cpf_med, cpf_pct, dt_atend),
    PRIMARY KEY (cod)
);

CREATE TABLE RECEITA (
    cod_medicamento INT NOT NULL,
    cpf_med         VARCHAR(11) NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_atend        DATETIME NOT NULL,
    dt_vencimento   DATETIME NOT NULL,
    obs             VARCHAR(255),

    FOREIGN KEY (cod_medicamento) REFERENCES MEDICAMENTO (cod),
    FOREIGN KEY (cpf_med, cpf_pct, dt_atend) REFERENCES CONSULTA (cpf_med, cpf_pct, dt_atend),
    PRIMARY KEY (cod_medicamento, cpf_med, cpf_pct, dt_atend)
);

-- INSERÇÃO DOS VALORES INICIAIS

INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('85037528581', 'RUA 33-A', '55452819976', STR_TO_DATE('21-04-1981', '%d-%m-%Y'), 'Bessie Ramsey', null); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('63392999176', 'RUA 10-B', '58952472673', STR_TO_DATE('13-10-1945', '%d-%m-%Y'), 'Dean WoodDaniel', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('63838702267', 'RUA 10-B', '65946401830', STR_TO_DATE('09-08-1999', '%d-%m-%Y'), 'Birdie Patrick', null); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('86468766606', 'RUA 22-F', '41672284496', STR_TO_DATE('31-03-1992', '%d-%m-%Y'), 'May Curtis', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('33781338876', 'RUA 22-A', '17886347936', STR_TO_DATE('31-03-1992', '%d-%m-%Y'), 'Jack Farmer', null); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('80589385421', 'RUA 51-A', '64239278156', STR_TO_DATE('09-11-1981', '%d-%m-%Y'), 'Hannah Fields', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo);
VALUES ('95824797675', 'RUA 09-G', '97399503309', STR_TO_DATE('08-11-2007', '%d-%m-%Y'), 'Julia Curtis', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('48334591197', 'RUA 01-T', '61584726823', STR_TO_DATE('06-02-2012', '%d-%m-%Y'), 'Francis Pittman', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('39488553863', 'RUA 82-N', '31134369687', STR_TO_DATE('27-06-1978', '%d-%m-%Y'), 'Barbara Guerrero', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('68979553587', 'RUA 61-X', '49527336752', STR_TO_DATE('21-12-1982', '%d-%m-%Y'), 'Lilly Smith', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('58890651359', 'RUA 61-X', '91726631640', STR_TO_DATE('08-03-1933', '%d-%m-%Y'), 'Luis Pittman', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('99876173243', 'RUA 22-A', '59669850072', STR_TO_DATE('02-01-1954', '%d-%m-%Y'), 'Elnora Underwood', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('52695183996', 'RUA 22-A', '82968641924', STR_TO_DATE('10-03-1984', '%d-%m-%Y'), 'Eleanor McGuire', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('39755566639', 'RUA 22-A', '19144267439', STR_TO_DATE('09-11-1983', '%d-%m-%Y'), 'Mike Clark', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('83155702995', 'RUA 22-A', '33639432312', STR_TO_DATE('27-05-1975', '%d-%m-%Y'), 'Amelia Lopez', 'F'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('45389849597', 'RUA 22-A', '14621317281', STR_TO_DATE('08-09-1967', '%d-%m-%Y'), 'Corey Oliver', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('81084725304', 'RUA 22-A', '51047675057', STR_TO_DATE('04-09-1978', '%d-%m-%Y'), 'Linnie Hunter', null); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('75369310658', 'RUA 22-A', '60421146792', STR_TO_DATE('18-08-1988', '%d-%m-%Y'), 'Manuel Turner', 'M'); -- 
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo) 
VALUES ('12567794423', 'RUA 22-A', '52789391537', STR_TO_DATE('13-02-1992', '%d-%m-%Y'), 'Minnie Tyler', 'F'); -- 

INSERT INTO PACIENTE (cpf, gestante, cpf_acompanhante) 
VALUES ('95824797675', false, '86468766606');
INSERT INTO PACIENTE (cpf, gestante, cpf_acompanhante) 
VALUES ('68979553587', true, null);
INSERT INTO PACIENTE (cpf, gestante, cpf_acompanhante) 
VALUES ('48334591197', false, '58890651359');
INSERT INTO PACIENTE (cpf, gestante, cpf_acompanhante) 
VALUES ('75369310658', false, null);
INSERT INTO PACIENTE (cpf, gestante, cpf_acompanhante) 
VALUES ('63838702267', true, '85037528581');

INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('85037528581', STR_TO_DATE('21-08-2005', '%d-%m-%Y'), true, 13404.51);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('80589385421', STR_TO_DATE('05-08-2015', '%d-%m-%Y'), true, 7095.00);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('99876173243', STR_TO_DATE('02-07-2012', '%d-%m-%Y'), true, 12524.32);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('81084725304', STR_TO_DATE('30-11-1999', '%d-%m-%Y'), true, 4527.03);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('39488553863', STR_TO_DATE('11-09-2001', '%d-%m-%Y'), false, 9930.69);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('12567794423', STR_TO_DATE('30-05-2017', '%d-%m-%Y'), true, 7522.25);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('45389849597', STR_TO_DATE('23-07-2008', '%d-%m-%Y'), true, 21080.30);

INSERT INTO MEDICO (cpf, crm) 
VALUES ('85037528581', '59206458881963040001');
INSERT INTO MEDICO (cpf, crm) 
VALUES ('80589385421', '77863655532710260002');
INSERT INTO MEDICO (cpf, crm) 
VALUES ('99876173243', '62097496287897230001');
INSERT INTO MEDICO (cpf, crm) 
VALUES ('81084725304', '73397834121715280006');
INSERT INTO MEDICO (cpf, crm) 
VALUES ('39488553863', '45455496117938310001');
INSERT INTO MEDICO (cpf, crm) 
VALUES ('12567794423', '45051803900860250009');
INSERT INTO MEDICO (cpf, crm) 
VALUES ('45389849597', '47034927573986350001');

INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('83155702995', STR_TO_DATE('18-07-2008', '%d-%m-%Y'), false, 1830.22);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('39755566639', STR_TO_DATE('21-03-2010', '%d-%m-%Y'), true, 1830.22);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('52695183996', STR_TO_DATE('09-05-2010', '%d-%m-%Y'), true, 1830.22);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('86468766606', STR_TO_DATE('11-11-2003', '%d-%m-%Y'), true, 1830.22);

INSERT INTO ENFERMEIRO (cpf) 
VALUES ('83155702995');
INSERT INTO ENFERMEIRO (cpf) 
VALUES ('39755566639');
INSERT INTO ENFERMEIRO (cpf) 
VALUES ('52695183996');
INSERT INTO ENFERMEIRO (cpf) 
VALUES ('86468766606');

INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('33781338876', STR_TO_DATE('06-02-1978', '%d-%m-%Y'), true, 103852.01);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('63838702267', STR_TO_DATE('03-11-2017', '%d-%m-%Y'), true, 987.65);
INSERT INTO FUNCIONARIO (cpf, dt_inicio_trab, ativo, salario) 
VALUES ('63392999176', STR_TO_DATE('21-06-2018', '%d-%m-%Y'), true, 1128.08);

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

INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('85037528581', 2);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('85037528581', 8);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('85037528581', 11);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('80589385421', 3);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('80589385421', 7);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('80589385421', 1);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('99876173243', 9);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('99876173243', 4);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('81084725304', 3);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('81084725304', 8);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('81084725304', 28);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('39488553863', 17);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('39488553863', 22);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('12567794423', 20);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('45389849597', 18);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('45389849597', 3);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('45389849597', 21);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('83155702995', 13); 
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('83155702995', 23);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('83155702995', 9);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('83155702995', 19);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('39755566639', 25);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('39755566639', 23);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('39755566639', 1);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('52695183996', 8);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('52695183996', 2);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('52695183996', 4);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('52695183996', 5);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('86468766606', 19);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('86468766606', 26);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('86468766606', 22);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('86468766606', 9);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 2);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 1);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 3);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 20);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 25);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 28);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 10);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('33781338876', 11);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('63838702267', 1);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('63838702267', 8);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('63838702267', 23);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('63392999176', 4);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('63392999176', 13);
INSERT INTO TRABALHA_EM (cpf, cod) 
VALUES ('63392999176', 26);

INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (12, 1, 2, '83155702995');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (13, 1, 2, '83155702995');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (16, 1, 2, '83155702995');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (18, 1, 2, '83155702995');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (21, 2, 5, '39755566639');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (22, 2, 5, '39755566639');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (23, 2, 0, '39755566639');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (33, 3, 10, '39755566639');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (36, 3, 10, '52695183996');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (44, 4, 3, '52695183996');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (45, 4, 3, '52695183996');
INSERT INTO SALA (numero, andar, num_leitos, enf_gerente)
VALUES (46, 4, 3, '52695183996');

INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('56165165165', 21, STR_TO_DATE('19-06-2018', '%d-%m-%Y'), STR_TO_DATE('20-06-2018', '%d-%m-%Y'), 'Suspeita de dengue');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('65465464654', 36, STR_TO_DATE('01-06-2018', '%d-%m-%Y'), STR_TO_DATE('03-06-2018', '%d-%m-%Y'), 'Acidente de trânsito');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('57981681919', 22, STR_TO_DATE('29-06-2018', '%d-%m-%Y'), STR_TO_DATE('03-07-2018', '%d-%m-%Y'), 'Acompanhamento');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('05656515166', 45, STR_TO_DATE('29-06-2018', '%d-%m-%Y'), STR_TO_DATE('02-07-2018', '%d-%m-%Y'), null);
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('05615151895', 12, STR_TO_DATE('30-06-2018', '%d-%m-%Y'), null, null);
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('56165165165', 12, STR_TO_DATE('30-06-2018', '%d-%m-%Y'), null, null);

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

INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Dor de cabeça', 'BAIXA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Febre Baixa', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Febre alta', 'GRAVE');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('Dor de estomago', 'BAIXA');

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

INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 10.99, true);
INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 101.99, true);
INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 120.99, false);
INSERT MEDICAMENTO (descricao, preco_unit, generico) 
VALUES ('descricao', 2.99, false);

INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (1, 1, 'todos os dias');
INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (2, 2, 'de 3 em 3 dias');
INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (3, 1, 'uma vez por semana');
INSERT COMBATE_SINTOMA (cod_medicamento, cod_sintoma, regularidade_uso) 
VALUES (4, 2, '5 vezes por dia');

INSERT INTO FORMADO_EM VALUES (1, '12341234132');
INSERT INTO FORMADO_EM VALUES (2, '23452345244');
INSERT INTO FORMADO_EM VALUES (3, '25113423442');
INSERT INTO FORMADO_EM VALUES (4, '23452345243');
INSERT INTO FORMADO_EM VALUES (5, '35654623432');

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