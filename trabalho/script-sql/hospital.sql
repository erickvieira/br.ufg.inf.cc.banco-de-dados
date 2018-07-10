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
    cpf             VARCHAR(11) NOT NULL,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    cpf_acompanhante    VARCHAR(11),
    gestante            BOOLEAN NOT NULL,

    PRIMARY KEY (cpf),
    FOREIGN KEY (cpf_acompanhante) REFERENCES PESSOA(cpf)
);

CREATE TABLE FUNCIONARIO (
    cpf             VARCHAR(11) NOT NULL PRIMARY KEY,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL
);

CREATE TABLE ENFERMEIRO (
    cpf             VARCHAR(11) NOT NULL PRIMARY KEY,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL
);

CREATE TABLE MEDICO (
    cpf             VARCHAR(11) NOT NULL PRIMARY KEY,
    end_fisico      VARCHAR(50) NOT NULL,
    fone_contato    VARCHAR(12) NOT NULL,
    dt_nasc         DATETIME NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    salario         FLOAT NOT NULL,
    dt_inicio_trab  DATETIME NOT NULL,
    ativo           BOOLEAN NOT NULL
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
    FOREIGN KEY (cpf) REFERENCES MEDICO(cpf),
    FOREIGN KEY (cpf) REFERENCES ENFERMEIRO(cpf),
    FOREIGN KEY (cod) REFERENCES HORARIO(cod),
    PRIMARY KEY (cpf, cod)
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
    gravidade   INT NOT NULL,

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

CREATE TABLE AREA_ATUACAO (
    cod             INT NOT NULL AUTO_INCREMENT,
    cod_macro_area  INT,
    descricao       VARCHAR(50) NOT NULL,

    FOREIGN KEY (cod_macro_area) REFERENCES AREA_ATUACAO (cod),
    PRIMARY KEY (cod)
);

CREATE TABLE FORMADO_EM (
    cod             INT NOT NULL AUTO_INCREMENT,
    cpf             VARCHAR(11) NOT NULL,

    FOREIGN KEY (cpf) REFERENCES MEDICO (cpf),
    PRIMARY KEY (cod)
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
    descricao       VARCHAR(255) NOT NULL,
    dt_vencimento   DATETIME NOT NULL,
    cpf_med         VARCHAR(11) NOT NULL,
    cpf_pct         VARCHAR(11) NOT NULL,
    dt_atend        DATETIME NOT NULL,

    FOREIGN KEY (cpf_med, cpf_pct, dt_atend) REFERENCES CONSULTA(cpf_med, cpf_pct, dt_atend),
    PRIMARY KEY (cod)
);

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


