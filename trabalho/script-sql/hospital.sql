DROP DATABASE hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE PESSOA (
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,

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
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL,

    FOREIGN KEY (cpf) REFERENCES PESSOA(cpf),
    PRIMARY KEY (cpf),
);

CREATE TABLE HORARIO (
    cod         INT NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(25),
    hr_inicial  VARCHAR(5) NOT NULL,
    hr_final    VARCHAR(5) NOT NULL,
    dia_semana  VARCHAR(3) NOT NULL,

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
    num_sala    TINYINT NOT NULL,
    dt_intern   DATETIME NOT NULL,
    dt_alta     DATETIME,
    motivo      VARCHAR(50),

    FOREIGN KEY (cpf_pct) REFERENCES PACIENTE(cpf),
    FOREIGN KEY (num_sala) REFERENCES SALA(numero),
    PRIMARY KEY (cpf_pct, num_sala)
);

-- CONTINUAR DAQUI...
