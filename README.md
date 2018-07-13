# Banco de Dados, Ciência da Computação - 2018.1, INF/UFG
## Atividade Avaliativa da Disciplina - Projeto BD para o Hospital X
### Integrantes do Grupo:
- [Erick Vieira](github.com/erickvieira) - 201515568  
- [Matheus Henrique](github.com/Matheushbp) - 201407356  
- [Raphael Ferreira](github.com/FerreiraRaphael) - 201400171  

### Repositório:
Para maiores informações a respeito do desenvolvimento do projeto, disponibilizamos o mesmo no GitHub, onde estão todos os arquivos produzidos pelo grupo:  
[https://github.com/erickvieira/br.ufg.inf.cc.banco-de-dados/](https://github.com/erickvieira/br.ufg.inf.cc.banco-de-dados/)

### Descrição do Problema:
  Este projeto se dedica a modelar a estrutura de um Banco de Dados que visa atender à demanda de Hospitais e Clínicas que fazem uso do modelo de negócio voltado para **plantões** e **consultas casuais**. Portanto, esse BD não se compromete a cubrir outros pontos da gestão e do dia-a-dia de um hospital que não se encaixe nesse cenário; Mais especificamente, que não esteja relacionado às consultas do plantão ou às internações.

### Definição dos **Perfis de Usuários** (papeis) do banco:
1. Assistente Pessoal do Médico: uma espécie de secretário(a) de cada médico; geralmente tem interesse em saber os dados dos pacientes que o mesmo atende.  
2. Médico: aquele que de fato realizará as consultas; poderá querer saber dados dos pacientes e de seus sintomas e medicamentos que podem combatê-los.  
3. Diretor do Hospital: está interessado em dados administrativos e de rendimento dos médicos, como, por exemplo: a quantidade de pacientes atendidos durante um plantão ou o valor dos medicamentos receitados pelo médico para cada paciente.  
4. Balconista: o primeiro atendente do paciente; está mais preocupado em buscar os dados do paciente, caso este já tenha efetuado cadastro e pode querer saber a quantidade de pacientes aguardando por uma consulta.  

### Consultas:
#### ◯ Em Linguagem Natual
1. Assistente Pessoal do Médico:  
- Mostrar salas com mais de 1 paciente  
- Listar nome e sintoma dos Pacientes do médico "Elnora Underwood"  
- Mostrar número da sala e nome do enfermeiro responsavel onde há pacientes da médica "Hannah Fields" no turno Vespertino  
- Listar nomes e sintomas dos Pacientes do médico "Minnie Tyler" na sala 5  

2. Médico:  
- Descrição dos medicamentos que combatam febre abaixo de 30 reais  
- Sintomas mais comuns em pacientes por ordem decrescente no dia: 2018-05-01  
- Verificar a descrição dos remédios mais receitados para o sintoma "Dengue" no mês de Maio de 2018  
- Mostrar soma da gravidade dos sintomas dos pacientes diagnosticados com febre.  

3. Diretor:  
- Listar media salarial das enfermeiras do sexo feminino e que trabalham no periodo noturno excluindo o menor salario  
- Mostrar descrição dos medicamentos que combatem o sintoma dengue  
- Mostrar especialidades com mais de 4 médicos, sexo masculino e que não exista outro dessa especialidade na mesma área  
- Mostrar especialidades médicas e suas médias salariais  

4. Balconista:  
- Mostrar número das salas que ainda possuem leitos disponíveis  
- Mostrar nome dos médicos especialistas em "cardiologia" disponíveis no periodo matutino e ordenados decrescentemente pela idade  
- Mostrar número da sala e estado dos pacientes "Smith" que foi internado no dia 22.04.2018  
- Mostar quantidade de pessoas por gravidade de sintomas  

---
#### ◯ Em __SQL__
<pre><code>-- ASSISTENTE DO MEDICO
SELECT COUNT(numero) AS qtd_pacientes, numero
FROM SALA JOIN INTERNACAO I on SALA.numero = I.num_sala
WHERE   dt_alta IS NULL
GROUP BY numero
HAVING COUNT(numero) > 1;

SELECT P2.nome, S.descricao
FROM PACIENTE P
  JOIN FICHA_PCT F ON P.cpf = F.cpf_pct
  JOIN CONSULTA C ON F.cpf_pct = C.cpf_pct AND F.dt_triagem = C.dt_triagem
  JOIN SINTOMA_PCT SP ON P.cpf = SP.cpf_pct AND F.dt_triagem = SP.dt_triagem
  JOIN SINTOMA S ON SP.cod_sintoma = S.cod
  JOIN MEDICO M ON M.cpf =  C.cpf_med
  JOIN PESSOA P2 ON P.cpf = P2.cpf
  JOIN PESSOA P3 ON M.cpf = P3.cpf
  JOIN INTERNACAO I on P.cpf = I.cpf_pct
WHERE   P3.nome LIKE 'Elnora%' AND I.dt_alta IS NULL;

SELECT m.nome
FROM SALA AS s
  JOIN PESSOA AS f ON s.enf_gerente = f.cpf
  JOIN INTERNACAO AS i ON s.numero = i.num_sala
  JOIN CONSULTA AS c ON c.cpf_pct = i.cpf_pct
  JOIN PESSOA AS m ON m.cpf = c.cpf_med
WHERE m.nome LIKE '%a%' AND f.cpf IN (
  SELECT e.cpf
  FROM ENFERMEIRO AS e 
    JOIN TRABALHA_EM AS t ON t.cpf = e.cpf 
    JOIN HORARIO AS h ON h.cod = t.cod
  WHERE h.hr_inicial BETWEEN '12:01' AND '17:59'
  AND h.hr_final BETWEEN '12:01' AND '17:59'
);

SELECT d.nome, s.cod, s.descricao, s.gravidade
FROM SINTOMA_PCT AS sp
  JOIN SINTOMA AS s ON sp.cod_sintoma = s.cod
  JOIN CONSULTA AS c ON c.cpf_pct = sp.cpf_pct
  JOIN INTERNACAO AS i ON i.cpf_pct = sp.cpf_pct
  JOIN PESSOA AS m ON m.cpf = sp.cpf_pct
  JOIN PESSOA AS d ON d.cpf = sp.cpf_pct
WHERE m.nome = 'Minnie Tyler' AND i.num_sala = 5;

-- MEDICO
-- DESCRIÇÃO DOS REMEDIOS QUE COMBATAM O SINTOMA FEBRE BAIXA ABAIXO DE 30 REAIS
SELECT m.descricao
FROM MEDICAMENTO AS m
  JOIN COMBATE_SINTOMA AS c ON c.cod_medicamento = m.cod
  JOIN SINTOMA AS s ON s.cod = c.cod_sintoma
WHERE m.preco_unit < 30 AND s.cod = 3
GROUP BY m.descricao;

-- SINTOMAS MAIS COMUNS EM PACIENTES POR ORDEM ENTRE NO DIA: 2018-05-01
SELECT s.cod_sintoma, COUNT(s.cpf_pct) as cpfs
FROM SINTOMA_PCT AS s
  JOIN CONSULTA AS c ON c.cpf_pct = s.cpf_pct
WHERE c.dt_atend = '2018-05-01'
GROUP BY s.cod_sintoma
ORDER BY COUNT(cpfs) DESC;

-- VERIFICAR A DESCRICAO DOS REMEDIOS MAIS RECEITADOS PARA O SINTOMA DOR DE CABEÇA NO MES DE MAIO DE 2018
SELECT r.cod_medicamento, m.descricao, COUNT(*) as counter
FROM RECEITA AS r
  JOIN MEDICAMENTO AS m ON r.cod_medicamento = m.cod
  JOIN COMBATE_SINTOMA AS cm ON cm.cod_medicamento = m.cod
WHERE m.descricao = 'Dor de cabeça' AND r.dt_atend LIKE '%-05-%'
GROUP BY r.cod_medicamento
ORDER BY COUNT(counter);

-- MOSTRAR SOMA DA GRAVIDADE DOS SINTOMAS DOS PACIENTES DIAGNOSTICADOS COM FEBRE QUE NÃO TENHAM UM SINTOMA GRAVIDADE 1 E QUE SÃO GESTANTES
-- REFAZER IDADE
SELECT SUM(s.gravidade)
FROM PACIENTE AS p
  JOIN PESSOA AS i ON p.cpf = i.cpf
  JOIN SINTOMA_PCT AS c ON c.cpf_PCT = p.cpf
  JOIN SINTOMA AS s ON s.cod = c.cod_sintoma
WHERE s.descricao LIKE '%Febre%' AND NOT EXISTS (SELECT *
  FROM PACIENTE AS a JOIN SINTOMA_PCT AS b ON a.cpf = b.cpf_pct);

-- DIRETOR
-- EXCLUINDO O MENOR SALARIO
SELECT AVG(f.salario)
FROM ENFERMEIRO AS e
  JOIN FUNCIONARIO AS f ON e.cpf = f.cpf
  JOIN PESSOA AS p ON p.cpf = e.cpf
  JOIN TRABALHA_EM AS t ON t.cpf = e.cpf
  JOIN HORARIO AS h ON h.cod = t.cod
WHERE p.sexo = 'M' AND h.descricao LIKE '%noite%' AND f.salario > ANY (SELECT n.salario
  FROM FUNCIONARIO AS n JOIN ENFERMEIRO AS d ON n.cpf = d.cpf);

SELECT m.descricao
FROM MEDICAMENTO AS m
  JOIN RECEITA AS r ON m.cod = r.cod_medicamento
  JOIN SINTOMA_PCT AS s ON s.cpf_pct = r.cpf_pct
WHERE m.preco_unit < 100 AND s.cod_sintoma = 1;

-- Mostrar especialidades com mais de 4 médicos, sexo masculino e que não exista outro dessa mesma especialidade area
SELECT a.cod_macro_area
FROM FORMADO_EM AS f JOIN MEDICO AS m ON m.cpf = f.cpf
  JOIN PESSOA AS p ON m.cpf = p.cpf
  JOIN AREA_ATUACAO AS a ON a.cod = f.cod
WHERE p.sexo = 'H' AND NOT EXISTS (SELECT *
  FROM AREA_ATUACAO AS b
  WHERE a.cod_macro_area = b.cod_macro_area)
GROUP BY a.cod_macro_area
HAVING COUNT(*) > 4;

-- BALCONISTA
SELECT s.numero
FROM SALA AS s
  JOIN INTERNACAO AS i ON i.num_sala = s.numero
  JOIN PACIENTE AS p ON p.cpf = i.cpf_pct
GROUP BY s.numero;

SELECT p.nome, h.hr_inicial, h.hr_final
FROM MEDICO AS m
  JOIN FORMADO_EM AS a ON a.cpf = m.cpf
  JOIN TRABALHA_EM AS t ON t.cpf = m.cpf
  JOIN HORARIO AS h ON h.cod = t.cod
  JOIN PESSOA AS p ON p.cpf = m.cpf
WHERE h.descricao LIKE '%matutino%'
ORDER BY p.nome;

SELECT i.num_sala, s.gravidade
FROM INTERNACAO AS i
  JOIN PACIENTE AS p ON i.cpf_pct = p.cpf
  JOIN SINTOMA_PCT AS sp ON sp.cpf_pct = p.cpf
  JOIN SINTOMA AS s ON sp.cod_sintoma = s.cod
  JOIN PESSOA AS a ON a.cpf = p.cpf
WHERE a.nome LIKE 'JOSÉ%' AND i.dt_intern = '2018-04-22';

SELECT S.gravidade, COUNT(p.cpf)
FROM PACIENTE AS p
  JOIN PESSOA AS a ON a.cpf = p.cpf
  JOIN SINTOMA_PCT AS b ON b.cpf_pct = p.cpf
  JOIN SINTOMA S ON b.cod_sintoma = S.cod
GROUP BY S.gravidade
HAVING COUNT(p.cpf) >= 1;</code></pre>

### Diagrama Entidade Relacionamento:
![Diagrama Entidade Relacionamento](https://github.com/erickvieira/br.ufg.inf.cc.banco-de-dados/blob/master/trabalho/galeria/der.png?raw=true)

### Modelo Relacional:
PESSOA ( __<ins>cpf</ins>__, end_fisico, fone_contato, dt_nasc, sexo, nome )  

PACIENTE ( __<ins>cpf</ins>__, cpf_acompanhante, gestante )  
PACIENTE ( cpf ) __REFERENCIA__ PESSOA ( cpf )  
PACIENTE ( cpf_acompanhante ) __REFERENCIA__ PESSOA ( cpf )  

FUNCIONARIO ( __<ins>cpf</ins>__, salario, dt_inicio_trab, ativo )  
FUNCIONARIO ( cpf ) __REFERENCIA__ PESSOA ( cpf )  

HORARIO ( __<ins>cod</ins>__, descricao, hr_inicial, hr_final, dia_semana )  

TRABALHA_EM ( __<ins>cpf, cod</ins>__ )  
TRABALHA_EM ( cpf ) __REFERENCIA__ FUNCIONARIO( cpf )  
TRABALHA_EM ( cod ) __REFERENCIA__ HORARIO ( cpf )  

ENFERMEIRO ( __<ins>cpf</ins>__ )  
ENFERMEIRO ( cpf ) __REFERENCIA__ FUNCIONARIO ( cpf )  

SALA ( __<ins>numero</ins>__, andar, apelido, num_leitos, enf_gerente )  
SALA ( enf_gerente ) __REFERENCIA__ ENFERMEIRO ( cpf )  

INTERNACAO ( __<ins>cpf_pct, num_sala</ins>__, dt_intetn, dt_alta, motivo )  
INTERNACAO ( cpf_pct ) __REFERENCIA__ PACIENTE ( cpf )  
INTERNACAO ( num_sala ) __REFERENCIA__ SALA ( numero )  

FICHA_PCT ( __<ins>cpf_pct, dt_triagem</ins>__, obs, peso_pct, altura_pct, cpf_enf )  
FICHA_PCT ( cpf_enf ) __REFERENCIA__ ENFERMEIRO ( cpf )  
FICHA_PCT ( cpf_pct ) __REFERENCIA__ PACIENTE ( cpf )  

SINTOMA ( __<ins>cod</ins>__, descricao, gravidade )  

SINTOMA_PCT ( __<ins>sintoma, cpf_pct, dt_triagem</ins>__ )  
SINTOMA_PCT ( cpf_pct, dt_triagem ) __REFERENCIA__ FICHA_PCT ( cpf_pct, dt_triagem )  
SINTOMA_PCT ( sintoma ) __REFERENCIA__ SINTOMA ( cod )  

MEDICAMENTO ( __<ins>cod</ins>__, descricao, preco_unit, generico )  

COMBATE_SINTOMA ( __<ins>cod_medicamento, cod_sintoma</ins>__, regularidade_uso )  
COMBATE_SINTOMA ( cod_medicamento ) __REFERENCIA__ MEDICAMENTO ( cod )  
COMBATE_SINTOMA ( cod_sintoma ) __REFERENCIA__ SINTOMA ( cod )  

MEDICO ( __<ins>cpf</ins>__, crm )  
MEDICO ( cpf ) __REFERENCIA__ FUNCIONARIO ( cpf )  

AREA_ATUACAO ( __<ins>id_area</ins>__, id_macro_area, descricao )  
AREA_ATUACAO ( id_macro_area ) __REFERENCIA__ AREA_ATUACAO ( id_area )  

FORMADO_EM ( __<ins>cpf, id_area</ins>__ )  
FORMADO_EM ( cpf ) __REFERENCIA__ MEDICO ( cpf )  
FORMADO_EM ( id_area ) __REFERENCIA__ AREA_ATUACAO ( id_area )  

CONSULTA ( __<ins>cpf_med, cpf_pct, dt_atend</ins>__, dt_atend_orig, dt_triagem )  
CONSULTA ( cpf_med ) __REFERENCIA__ MEDICO ( cpf )  
CONSULTA ( cpf_pct ) __REFERENCIA__ PACIENTE ( cpf )  
CONSULTA ( cpf_pct, dt_triagem ) __REFERENCIA__ FICHA_PCT ( cpf_pct, dt_triagem )  

ENCAMINHAMENTO ( __<ins>cod</ins>__, motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend )  
ENCAMINHAMENTO ( cpf_pct, dt_atend ) __REFERENCIA__ CONSULTA ( cpf_pct, dt_atend )  

RECEITA ( __<ins>cod_medicamento, cpf_med, cpf_pct, dt_atend</ins>__, dt_vencimento, obs )  
RECEITA ( cod_medicamento ) __REFERENCIA__ MEDICAMENTO ( cod )  
RECEITA ( cpf_med, cpf_pct, dt_atend ) __REFERENCIA__ CONSULTA ( cpf_med, cpf_pct, dt_atend )  

### Esquema do Banco de Dados:
<pre><code>
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
    gravidade   ENUM('BAIXA', 'MEDIA', 'ALTA', 'MUITO_ALTA') NOT NULL,

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
INSERT INTO PESSOA (cpf, end_fisico, fone_contato, dt_nasc, nome, sexo)
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

INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('DOR_DE_CABECA', 'BAIXA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('DOR_NO_CORPO', 'BAIXA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('FEBRE_BAIXA', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('FEBRE_ALTA', 'ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('TRAUMATISMO', 'MUITO_ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('LESAO_POR_ESFORCO_REPETITIVO', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('DOR_DE_ESTOMAGO', 'BAIXA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('NAUSEA', 'BAIXA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('VOMITO', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('ALERGIA', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('HEMORRAGIA', 'ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('HEMORRAGIA_INTERNA', 'MUITO_ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('HEMATOMA', 'ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('FRATURA', 'MUITO_ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('ERUPCOES', 'MUITO_ALTA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('DOR_LOMBAR', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('TONTURA', 'MEDIA');
INSERT INTO SINTOMA (descricao, gravidade)
VALUES ('MAL_ESTAR_GERAL', 'MEDIA');

INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('95824797675', 21, '2018-06-19 09:07:21', '2018-06-20 18:17:01', 'Suspeita de dengue');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('68979553587', 36, '2018-06-01 13:37:41', '2018-06-03 21:58:00', 'Acidente de trânsito');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('48334591197', 22, '2018-06-29 08:41:23', '2018-07-03 11:00:28', 'Alergia a ovo');
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('75369310658', 45, '2018-06-29 21:12:47', '2018-07-02 12:56:41', null);
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('95824797675', 12, '2018-06-30 21:15:31', null, null);
INSERT INTO INTERNACAO (cpf_pct, num_sala, dt_intern, dt_alta, motivo)
VALUES ('63838702267', 12, '2018-06-30 18:30:58', null, null);

INSERT INTO FICHA_PCT (cpf_pct, dt_triagem, obs, peso_pct, altura_pct, cpf_enf) 
VALUES ('95824797675', '2018-06-19 07:21:13', null, 32.614, 1.488, '39755566639');
INSERT INTO FICHA_PCT (cpf_pct, dt_triagem, obs, peso_pct, altura_pct, cpf_enf) 
VALUES ('68979553587', '2018-06-01 13:29:07', 'URGENTE: FRATURA EXPOSTA / GESTANTE', 70.522, 1.58, '52695183996');
INSERT INTO FICHA_PCT (cpf_pct, dt_triagem, obs, peso_pct, altura_pct, cpf_enf) 
VALUES ('48334591197', '2018-06-29 07:20:47', null, 24.502, 1.125, '83155702995');
INSERT INTO FICHA_PCT (cpf_pct, dt_triagem, obs, peso_pct, altura_pct, cpf_enf) 
VALUES ('75369310658', '2018-06-29 19:21:54', null, 81.558, 1.834, '83155702995');
INSERT INTO FICHA_PCT (cpf_pct, dt_triagem, obs, peso_pct, altura_pct, cpf_enf) 
VALUES ('95824797675', '2018-06-30 20:47:06', null, 30.987, 1.488, '52695183996');
INSERT INTO FICHA_PCT (cpf_pct, dt_triagem, obs, peso_pct, altura_pct, cpf_enf) 
VALUES ('63838702267', '2018-06-30 18:02:08', 'GESTANTE', 62.857, 1.704, '86468766606');

INSERT INTO CONSULTA 
VALUES ('80589385421', '95824797675', '2018-06-19 08:54:53', null, '2018-06-19 07:21:13');
INSERT INTO CONSULTA 
VALUES ('45389849597', '68979553587', '2018-06-01 13:34:22', null, '2018-06-01 13:29:07');
INSERT INTO CONSULTA 
VALUES ('81084725304', '48334591197', '2018-06-29 08:30:05', null, '2018-06-29 07:20:47');
INSERT INTO CONSULTA 
VALUES ('12567794423', '75369310658', '2018-06-29 18:58:24', null, '2018-06-29 19:21:54');
INSERT INTO CONSULTA 
VALUES ('80589385421', '95824797675', '2018-06-30 20:58:47', '2018-06-19 08:54:53', '2018-06-30 20:47:06');
INSERT INTO CONSULTA 
VALUES ('99876173243', '63838702267', '2018-06-30 18:17:27', null, '2018-06-30 18:02:08');

INSERT INTO ENCAMINHAMENTO
VALUES (null, 'Sinais de miopia se desenvolvendo', 'Encaminhar para o Dr. Joseph Iyonovic no Hospital X.', '2018-07-30', '12567794423', '75369310658', '2018-06-29 18:58:24');

INSERT INTO SINTOMA_PCT VALUES (2, '63838702267', '2018-06-30 18:02:08');
INSERT INTO SINTOMA_PCT VALUES (9, '63838702267', '2018-06-30 18:02:08');
INSERT INTO SINTOMA_PCT VALUES (17, '63838702267', '2018-06-30 18:02:08');
--
INSERT INTO SINTOMA_PCT VALUES (12, '95824797675', '2018-06-30 20:47:06');
INSERT INTO SINTOMA_PCT VALUES (15, '95824797675', '2018-06-30 20:47:06');
INSERT INTO SINTOMA_PCT VALUES (9, '95824797675', '2018-06-30 20:47:06');
INSERT INTO SINTOMA_PCT VALUES (4, '95824797675', '2018-06-30 20:47:06');
INSERT INTO SINTOMA_PCT VALUES (18, '95824797675', '2018-06-30 20:47:06');
--
INSERT INTO SINTOMA_PCT VALUES (8, '75369310658', '2018-06-29 19:21:54');
INSERT INTO SINTOMA_PCT VALUES (1, '75369310658', '2018-06-29 19:21:54');
INSERT INTO SINTOMA_PCT VALUES (17, '75369310658', '2018-06-29 19:21:54');
INSERT INTO SINTOMA_PCT VALUES (3, '75369310658', '2018-06-29 19:21:54');
--
INSERT INTO SINTOMA_PCT VALUES (1, '95824797675', '2018-06-19 07:21:13');
INSERT INTO SINTOMA_PCT VALUES (18, '95824797675', '2018-06-19 07:21:13');
INSERT INTO SINTOMA_PCT VALUES (9, '95824797675', '2018-06-19 07:21:13');
INSERT INTO SINTOMA_PCT VALUES (4, '95824797675', '2018-06-19 07:21:13');
INSERT INTO SINTOMA_PCT VALUES (16, '95824797675', '2018-06-19 07:21:13');
INSERT INTO SINTOMA_PCT VALUES (7, '95824797675', '2018-06-19 07:21:13');
INSERT INTO SINTOMA_PCT VALUES (2, '95824797675', '2018-06-19 07:21:13');
--
INSERT INTO SINTOMA_PCT VALUES (14, '68979553587', '2018-06-01 13:29:07');
INSERT INTO SINTOMA_PCT VALUES (11, '68979553587', '2018-06-01 13:29:07');
INSERT INTO SINTOMA_PCT VALUES (12, '68979553587', '2018-06-01 13:29:07');
INSERT INTO SINTOMA_PCT VALUES (5, '68979553587', '2018-06-01 13:29:07');
--
INSERT INTO SINTOMA_PCT VALUES (3, '48334591197', '2018-06-29 07:20:47');
INSERT INTO SINTOMA_PCT VALUES (18, '48334591197', '2018-06-29 07:20:47');
INSERT INTO SINTOMA_PCT VALUES (15, '48334591197', '2018-06-29 07:20:47');
INSERT INTO SINTOMA_PCT VALUES (10, '48334591197', '2018-06-29 07:20:47');
--

INSERT MEDICAMENTO VALUES (null, 'DIPIRONA_GENERICA', 9.99, true);
INSERT MEDICAMENTO VALUES (null, 'DIPIRONA', 22.99, false);
INSERT MEDICAMENTO VALUES (null, 'DORFLEX', 34.99, false);
INSERT MEDICAMENTO VALUES (null, 'DRAMIN', 21.99, false);
INSERT MEDICAMENTO VALUES (null, 'DRAMIN_GENERICO', 8.99, true);
INSERT MEDICAMENTO VALUES (null, 'ADIVIL', 1.99, true);
INSERT MEDICAMENTO VALUES (null, 'HISTAMIN', 14.99, false);
INSERT MEDICAMENTO VALUES (null, 'HISTAMIN_GENERICO', 5.99, true);
INSERT MEDICAMENTO VALUES (null, 'NEOPIRIDIN', 19.99, true);
INSERT MEDICAMENTO VALUES (null, 'BEZOTACIL', 0, true);
INSERT MEDICAMENTO VALUES (null, 'BUSCOPAN', 12.45, false);
INSERT MEDICAMENTO VALUES (null, 'OMEPRAZOL', 35.21, false);

INSERT INTO RECEITA
VALUES (4, '81084725304', '48334591197', '2018-06-29 08:30:05', '2018-07-08', 'Em caso de vomito constante');
INSERT INTO RECEITA
VALUES (8, '81084725304', '48334591197', '2018-06-29 08:30:05', '2018-07-08', null);
INSERT INTO RECEITA
VALUES (2, '12567794423', '75369310658', '2018-06-29 18:58:24', '2018-07-08', null);
INSERT INTO RECEITA
VALUES (6, '12567794423', '75369310658', '2018-06-29 18:58:24', '2018-07-08', 'Durante pelo menos 2 dias');
INSERT INTO RECEITA
VALUES (3, '12567794423', '75369310658', '2018-06-29 18:58:24', '2018-07-08', null);
INSERT INTO RECEITA
VALUES (4, '12567794423', '75369310658', '2018-06-29 18:58:24', '2018-07-08', 'Apenas em caso de vomito');

INSERT COMBATE_SINTOMA VALUES (1, 1, '6 EM 6 HORAS');
INSERT COMBATE_SINTOMA VALUES (1, 2, '8 EM 8 HORAS');
INSERT COMBATE_SINTOMA VALUES (1, 18, '8 EM 8 HORAS');
INSERT COMBATE_SINTOMA VALUES (1, 17, '8 EM 8 HORAS');
INSERT COMBATE_SINTOMA VALUES (1, 16, '8 EM 8 HORAS');
INSERT COMBATE_SINTOMA VALUES (2, 1, '4 EM 4 HORAS');
INSERT COMBATE_SINTOMA VALUES (2, 2, '6 EM 6 HORAS');
INSERT COMBATE_SINTOMA VALUES (2, 18, '6 EM 6 HORAS');
INSERT COMBATE_SINTOMA VALUES (2, 17, '6 EM 6 HORAS');
INSERT COMBATE_SINTOMA VALUES (2, 16, '6 EM 6 HORAS');
INSERT COMBATE_SINTOMA VALUES (3, 1, '3 EM 3 HORAS');
INSERT COMBATE_SINTOMA VALUES (3, 2, '3 EM 3 HORAS');
INSERT COMBATE_SINTOMA VALUES (3, 18, '3 EM 3 HORAS');
INSERT COMBATE_SINTOMA VALUES (3, 16, '3 EM 3 HORAS');
INSERT COMBATE_SINTOMA VALUES (3, 13, '3 EM 3 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (4, 8, '2 EM 2 HORAS');
INSERT COMBATE_SINTOMA VALUES (4, 9, '2 EM 2 HORAS');
INSERT COMBATE_SINTOMA VALUES (5, 8, '2 EM 2 HORAS');
INSERT COMBATE_SINTOMA VALUES (5, 9, '3 EM 3 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (6, 18, '5 EM 5 HORAS');
INSERT COMBATE_SINTOMA VALUES (6, 6, '6 EM 6 HORAS');
INSERT COMBATE_SINTOMA VALUES (6, 2, '3 EM 3 HORAS');
INSERT COMBATE_SINTOMA VALUES (6, 3, '6 EM 6 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (7, 10, '6 EM 6 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (8, 10, '8 EM 8 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (9, 10, '4 EM 4 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (10, 4, '24 EM 24 HORAS');
INSERT COMBATE_SINTOMA VALUES (10, 18, '24 EM 24 HORAS');
INSERT COMBATE_SINTOMA VALUES (10, 17, '24 EM 24 HORAS');
INSERT COMBATE_SINTOMA VALUES (10, 1, '24 EM 24 HORAS');
INSERT COMBATE_SINTOMA VALUES (10, 9, '24 EM 24 HORAS');
INSERT COMBATE_SINTOMA VALUES (10, 2, '24 EM 24 HORAS');
INSERT COMBATE_SINTOMA VALUES (10, 7, '24 EM 24 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (11, 18, '8 EM 8 HORAS');
INSERT COMBATE_SINTOMA VALUES (11, 7, '8 EM 8 HORAS');
--
INSERT COMBATE_SINTOMA VALUES (12, 7, '12 EM 12 HORAS');

INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'PEDIATRIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'CLINICO_GERAL');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'ORTOPEDIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'GINECOLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (4, 'OBSTETRICIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'NEUROLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (6, 'NEURO_CIRURGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (3, 'FISIO_TERAPIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'OTORRINOFARINGOLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'ENDOCRINOLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'GASTROENTEROLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'ONCOLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (12, 'MASTOLOGIA');
INSERT INTO AREA_ATUACAO (cod_macro_area, descricao) 
VALUES (null, 'OFTALMOLOGIA');

INSERT INTO FORMADO_EM VALUES (7, '45389849597');
INSERT INTO FORMADO_EM VALUES (6, '45389849597');
INSERT INTO FORMADO_EM VALUES (2, '45389849597');
INSERT INTO FORMADO_EM VALUES (2, '12567794423');
INSERT INTO FORMADO_EM VALUES (3, '12567794423');
INSERT INTO FORMADO_EM VALUES (2, '39488553863');
INSERT INTO FORMADO_EM VALUES (5, '39488553863');
INSERT INTO FORMADO_EM VALUES (4, '39488553863');
INSERT INTO FORMADO_EM VALUES (2, '80589385421');
INSERT INTO FORMADO_EM VALUES (1, '80589385421');
INSERT INTO FORMADO_EM VALUES (2, '81084725304');
INSERT INTO FORMADO_EM VALUES (10, '81084725304');
INSERT INTO FORMADO_EM VALUES (11, '81084725304');
INSERT INTO FORMADO_EM VALUES (12, '81084725304');
INSERT INTO FORMADO_EM VALUES (13, '81084725304');
INSERT INTO FORMADO_EM VALUES (2, '85037528581');
INSERT INTO FORMADO_EM VALUES (8, '85037528581');
INSERT INTO FORMADO_EM VALUES (2, '99876173243');
INSERT INTO FORMADO_EM VALUES (5, '99876173243');
INSERT INTO FORMADO_EM VALUES (4, '99876173243');

</code></pre>

### Conteúdo das Tabelas:
#### PESSOA  
| cpf | end_fisico | fone_contato | dt_nasc | nome | sexo |
| ----- | ----- | ----- | ----- | ----- | ----- |
| 12567794423 | RUA 22-A | 52789391537 | 1992-02-13 | Minnie Tyler | F |
| 33781338876 | RUA 22-A | 17886347936 | 1992-03-31 | Jack Farmer | NULL |
| 39488553863 | RUA 82-N | 31134369687 | 1978-06-27 | Barbara Guerrero | F |
| 39755566639 | RUA 22-A | 19144267439 | 1983-11-09 | Mike Clark | M |
| 45389849597 | RUA 22-A | 14621317281 | 1967-09-08 | Corey Oliver | M |
| 48334591197 | RUA 01-T | 61584726823 | 2012-02-06 | Francis Pittman | M |
| 52695183996 | RUA 22-A | 82968641924 | 1984-03-10 | Eleanor McGuire | F |
| 58890651359 | RUA 61-X | 91726631640 | 1933-03-08 | Luis Pittman | M |
| 63392999176 | RUA 10-B | 58952472673 | 1945-10-13 | Dean WoodDaniel | M |
| 63838702267 | RUA 10-B | 65946401830 | 1999-08-09 | Birdie Patrick | NULL |
| 68979553587 | RUA 61-X | 49527336752 | 1982-12-21 | Lilly Smith | F |
| 75369310658 | RUA 22-A | 60421146792 | 1988-08-18 | Manuel Turner | M |
| 80589385421 | RUA 51-A | 64239278156 | 1981-11-09 | Hannah Fields | F |
| 81084725304 | RUA 22-A | 51047675057 | 1978-09-04 | Linnie Hunter | NULL |
| 83155702995 | RUA 22-A | 33639432312 | 1975-05-27 | Amelia Lopez | F |
| 85037528581 | RUA 33-A | 55452819976 | 1981-04-21 | Bessie Ramsey | NULL |
| 86468766606 | RUA 22-F | 41672284496 | 1992-03-31 | May Curtis | F |
| 95824797675 | RUA 09-G | 97399503309 | 2007-11-08 | Julia Curtis | F |
| 99876173243 | RUA 22-A | 59669850072 | 1954-01-02 | Elnora Underwood | M |
---
#### FUNCIONARIO  
| cpf | salario | dt_inicio_trab | ativo |
| ----- | ----- | ----- | ----- |
| 12567794423 | 7522.25 | 2017-05-30 | 1 |
| 33781338876 | 103852 | 1978-02-06 | 1 |
| 39488553863 | 9930.69 | 2001-09-11 | 0 |
| 39755566639 | 1830.22 | 2010-03-21 | 1 |
| 45389849597 | 21080.3 | 2008-07-23 | 1 |
| 52695183996 | 1830.22 | 2010-05-09 | 1 |
| 63392999176 | 1128.08 | 2018-06-21 | 1 |
| 63838702267 | 987.65 | 2017-11-03 | 1 |
| 80589385421 | 7095 | 2015-08-05 | 1 |
| 81084725304 | 4527.03 | 1999-11-30 | 1 |
| 83155702995 | 1830.22 | 2008-07-18 | 0 |
| 85037528581 | 13404.5 | 2005-08-21 | 1 |
| 86468766606 | 1830.22 | 2003-11-11 | 1 |
| 99876173243 | 12524.3 | 2012-07-02 | 1 |
---
#### PACIENTE  
| cpf | cpf_acompanhante | gestante |
| ----- | ----- | ----- |
| 48334591197 | 58890651359 | 0 |
| 63838702267 | 85037528581 | 1 |
| 68979553587 | NULL | 1 |
| 75369310658 | NULL | 0 |
| 95824797675 | 86468766606 | 0 |
---
#### ENFERMEIRO  
| cpf |
| ----- |
| 39755566639 |
| 52695183996 |
| 83155702995 |
| 86468766606 |
---
#### MEDICO  
| cpf | crm |
| ----- | ----- |
| 12567794423 | 45051803900860250009 |
| 39488553863 | 45455496117938310001 |
| 45389849597 | 47034927573986350001 |
| 80589385421 | 77863655532710260002 |
| 81084725304 | 73397834121715280006 |
| 85037528581 | 59206458881963040001 |
| 99876173243 | 62097496287897230001 |
---
#### AREA_ATUACAO  
| cod | cod_macro_area | descricao |
| ----- | ----- | ----- |
| 1 | NULL | PEDIATRIA |
| 2 | NULL | CLINICO_GERAL |
| 3 | NULL | ORTOPEDIA |
| 4 | NULL | GINECOLOGIA |
| 5 | 4 | OBSTETRICIA |
| 6 | NULL | NEUROLOGIA |
| 7 | 6 | NEURO_CIRURGIA |
| 8 | 3 | FISIO_TERAPIA |
| 9 | NULL | OTORRINOFARINGOLOGIA |
| 10 | NULL | ENDOCRINOLOGIA |
| 11 | NULL | GASTROENTEROLOGIA |
| 12 | NULL | ONCOLOGIA |
| 13 | 12 | MASTOLOGIA |
| 14 | NULL | OFTALMOLOGIA |
---
#### FORMADO_EM  
| cod | cpf |
| ----- | ----- |
| 2 | 12567794423 |
| 3 | 12567794423 |
| 2 | 39488553863 |
| 4 | 39488553863 |
| 5 | 39488553863 |
| 2 | 45389849597 |
| 6 | 45389849597 |
| 7 | 45389849597 |
| 1 | 80589385421 |
| 2 | 80589385421 |
| 2 | 81084725304 |
| 10 | 81084725304 |
| 11 | 81084725304 |
| 12 | 81084725304 |
| 13 | 81084725304 |
| 2 | 85037528581 |
| 8 | 85037528581 |
| 2 | 99876173243 |
| 4 | 99876173243 |
| 5 | 99876173243 |
---
#### HORARIO  
| cod | descricao | hr_inicial | hr_final | dia_semana |
| ----- | ----- | ----- | ----- | ----- |
| 1 | segunda de manha | 07:00:00 | 12:00:00 | SEG |
| 2 | segunda de tarde | 13:00:00 | 18:00:00 | SEG |
| 3 | segunda de noite | 19:00:00 | 00:00:00 | SEG |
| 4 | segunda de madrugada | 01:00:00 | 06:00:00 | SEG |
| 5 | terça de manha | 07:00:00 | 12:00:00 | TER |
| 6 | terça de tarde | 13:00:00 | 18:00:00 | TER |
| 7 | terça de noite | 19:00:00 | 00:00:00 | TER |
| 8 | terça de madrugada | 01:00:00 | 06:00:00 | TER |
| 9 | quarta de manha | 07:00:00 | 12:00:00 | QUA |
| 10 | quarta de tarde | 13:00:00 | 18:00:00 | QUA |
| 11 | quarta de noite | 19:00:00 | 00:00:00 | QUA |
| 12 | quarta de madrugada | 01:00:00 | 06:00:00 | QUA |
| 13 | quinta de manha | 07:00:00 | 12:00:00 | QUI |
| 14 | quinta de tarde | 13:00:00 | 18:00:00 | QUI |
| 15 | quinta de noite | 19:00:00 | 00:00:00 | QUI |
| 16 | quinta de madrugada | 01:00:00 | 06:00:00 | QUI |
| 17 | sexta de manha | 07:00:00 | 12:00:00 | SEX |
| 18 | sexta de tarde | 13:00:00 | 18:00:00 | SEX |
| 19 | sexta de noite | 19:00:00 | 00:00:00 | SEX |
| 20 | sabado de madrugada | 01:00:00 | 06:00:00 | SAB |
| 21 | sabado de manha | 07:00:00 | 12:00:00 | SAB |
| 22 | sabado de tarde | 13:00:00 | 18:00:00 | SAB |
| 23 | sabado de noite | 19:00:00 | 00:00:00 | SAB |
| 24 | sabado de madrugada | 01:00:00 | 06:00:00 | SAB |
| 25 | domingo de manha | 07:00:00 | 12:00:00 | DOM |
| 26 | domingo de tarde | 13:00:00 | 18:00:00 | DOM |
| 27 | domingo de noite | 19:00:00 | 00:00:00 | DOM |
| 28 | domingo de madrugada | 01:00:00 | 06:00:00 | DOM |
---
#### TRABALHA_EM  
| cpf | cod |
| ----- | ----- |
| 33781338876 | 1 |
| 39755566639 | 1 |
| 63838702267 | 1 |
| 80589385421 | 1 |
| 33781338876 | 2 |
| 52695183996 | 2 |
| 85037528581 | 2 |
| 33781338876 | 3 |
| 45389849597 | 3 |
| 80589385421 | 3 |
| 81084725304 | 3 |
| 52695183996 | 4 |
| 63392999176 | 4 |
| 99876173243 | 4 |
| 52695183996 | 5 |
| 80589385421 | 7 |
| 52695183996 | 8 |
| 63838702267 | 8 |
| 81084725304 | 8 |
| 85037528581 | 8 |
| 83155702995 | 9 |
| 86468766606 | 9 |
| 99876173243 | 9 |
| 33781338876 | 10 |
| 33781338876 | 11 |
| 85037528581 | 11 |
| 63392999176 | 13 |
| 83155702995 | 13 |
| 39488553863 | 17 |
| 45389849597 | 18 |
| 83155702995 | 19 |
| 86468766606 | 19 |
| 12567794423 | 20 |
| 33781338876 | 20 |
| 45389849597 | 21 |
| 39488553863 | 22 |
| 86468766606 | 22 |
| 39755566639 | 23 |
| 63838702267 | 23 |
| 83155702995 | 23 |
| 33781338876 | 25 |
| 39755566639 | 25 |
| 63392999176 | 26 |
| 86468766606 | 26 |
| 33781338876 | 28 |
| 81084725304 | 28 |
---
#### MEDICAMENTO  
| cod | descricao | preco_unit | generico |
| ----- | ----- | ----- | ----- |
| 1 | DIPIRONA_GENERICA | 9.99 | 1 |
| 2 | DIPIRONA | 22.99 | 0 |
| 3 | DORFLEX | 34.99 | 0 |
| 4 | DRAMIN | 21.99 | 0 |
| 5 | DRAMIN_GENERICO | 8.99 | 1 |
| 6 | ADIVIL | 1.99 | 1 |
| 7 | HISTAMIN | 14.99 | 0 |
| 8 | HISTAMIN_GENERICO | 5.99 | 1 |
| 9 | NEOPIRIDIN | 19.99 | 1 |
| 10 | BEZOTACIL | 0 | 1 |
| 11 | BUSCOPAN | 12.45 | 0 |
| 12 | OMEPRAZOL | 35.21 | 0 |
---
#### SINTOMA  
| cod | descricao | gravidade |
| ----- | ----- | ----- |
| 1 | DOR_DE_CABECA | BAIXA |
| 2 | DOR_NO_CORPO | BAIXA |
| 3 | FEBRE_BAIXA | MEDIA |
| 4 | FEBRE_ALTA | ALTA |
| 5 | TRAUMATISMO | MUITO_ALTA |
| 6 | LESAO_POR_ESFORCO_REPETITIVO | MEDIA |
| 7 | DOR_DE_ESTOMAGO | BAIXA |
| 8 | NAUSEA | BAIXA |
| 9 | VOMITO | MEDIA |
| 10 | ALERGIA | MEDIA |
| 11 | HEMORRAGIA | ALTA |
| 12 | HEMORRAGIA_INTERNA | MUITO_ALTA |
| 13 | HEMATOMA | ALTA |
| 14 | FRATURA | MUITO_ALTA |
| 15 | ERUPCOES | MUITO_ALTA |
| 16 | DOR_LOMBAR | MEDIA |
| 17 | TONTURA | MEDIA |
| 18 | MAL_ESTAR_GERAL | MEDIA |
---
#### COMBATE_SINTOMA  
| cod_medicamento | cod_sintoma | regularidade_uso |
| ----- | ----- | ----- |
| 1 | 1 | 6 EM 6 HORAS |
| 1 | 2 | 8 EM 8 HORAS |
| 1 | 16 | 8 EM 8 HORAS |
| 1 | 17 | 8 EM 8 HORAS |
| 1 | 18 | 8 EM 8 HORAS |
| 2 | 1 | 4 EM 4 HORAS |
| 2 | 2 | 6 EM 6 HORAS |
| 2 | 16 | 6 EM 6 HORAS |
| 2 | 17 | 6 EM 6 HORAS |
| 2 | 18 | 6 EM 6 HORAS |
| 3 | 1 | 3 EM 3 HORAS |
| 3 | 2 | 3 EM 3 HORAS |
| 3 | 13 | 3 EM 3 HORAS |
| 3 | 16 | 3 EM 3 HORAS |
| 3 | 18 | 3 EM 3 HORAS |
| 4 | 8 | 2 EM 2 HORAS |
| 4 | 9 | 2 EM 2 HORAS |
| 5 | 8 | 2 EM 2 HORAS |
| 5 | 9 | 3 EM 3 HORAS |
| 6 | 2 | 3 EM 3 HORAS |
| 6 | 3 | 6 EM 6 HORAS |
| 6 | 6 | 6 EM 6 HORAS |
| 6 | 18 | 5 EM 5 HORAS |
| 7 | 10 | 6 EM 6 HORAS |
| 8 | 10 | 8 EM 8 HORAS |
| 9 | 10 | 4 EM 4 HORAS |
| 10 | 1 | 24 EM 24 HORAS |
| 10 | 2 | 24 EM 24 HORAS |
| 10 | 4 | 24 EM 24 HORAS |
| 10 | 7 | 24 EM 24 HORAS |
| 10 | 9 | 24 EM 24 HORAS |
| 10 | 17 | 24 EM 24 HORAS |
| 10 | 18 | 24 EM 24 HORAS |
| 11 | 7 | 8 EM 8 HORAS |
| 11 | 18 | 8 EM 8 HORAS |
| 12 | 7 | 12 EM 12 HORAS |
---
#### SALA  
| numero | andar | num_leitos | enf_gerente |
| ----- | ----- | ----- | ----- |
| 12 | 1 | 2 | 83155702995 |
| 13 | 1 | 2 | 83155702995 |
| 16 | 1 | 2 | 83155702995 |
| 18 | 1 | 2 | 83155702995 |
| 21 | 2 | 5 | 39755566639 |
| 22 | 2 | 5 | 39755566639 |
| 23 | 2 | 0 | 39755566639 |
| 33 | 3 | 10 | 39755566639 |
| 36 | 3 | 10 | 52695183996 |
| 44 | 4 | 3 | 52695183996 |
| 45 | 4 | 3 | 52695183996 |
| 46 | 4 | 3 | 52695183996 |
---
#### INTERNACAO  
| cpf_pct | num_sala | dt_intern | dt_alta | motivo |
| ----- | ----- | ----- | ----- | ----- |
| 48334591197 | 22 | 2018-06-29 08:41:23 | 2018-07-03 11:00:28 | Alergia a ovo |
| 63838702267 | 12 | 2018-06-30 18:30:58 | NULL | NULL |
| 68979553587 | 36 | 2018-06-01 13:37:41 | 2018-06-03 21:58:00 | Acidente de trânsito |
| 75369310658 | 45 | 2018-06-29 21:12:47 | 2018-07-02 12:56:41 | NULL |
| 95824797675 | 12 | 2018-06-30 21:15:31 | NULL | NULL |
| 95824797675 | 21 | 2018-06-19 09:07:21 | 2018-06-20 18:17:01 | Suspeita de dengue |
---
#### FICHA_PCT  
| cpf_pct | dt_triagem | obs | peso_pct | altura_pct | cpf_enf |
| ----- | ----- | ----- | ----- | ----- | ----- |
| 48334591197 | 2018-06-29 07:20:47 | NULL | 24.502 | 1.125 | 83155702995 |
| 63838702267 | 2018-06-30 18:02:08 | GESTANTE | 62.857 | 1.704 | 86468766606 |
| 68979553587 | 2018-06-01 13:29:07 | URGENTE: FRATURA EXPOSTA / GESTANTE | 70.522 | 1.58 | 52695183996 |
| 75369310658 | 2018-06-29 19:21:54 | NULL | 81.558 | 1.834 | 83155702995 |
| 95824797675 | 2018-06-19 07:21:13 | NULL | 32.614 | 1.488 | 39755566639 |
| 95824797675 | 2018-06-30 20:47:06 | NULL | 30.987 | 1.488 | 52695183996 |
---
#### CONSULTA  
| cpf_med | cpf_pct | dt_atend | dt_atend_orig | dt_triagem |
| ----- | ----- | ----- | ----- | ----- |
| 12567794423 | 75369310658 | 2018-06-29 18:58:24 | NULL | 2018-06-29 19:21:54 |
| 45389849597 | 68979553587 | 2018-06-01 13:34:22 | NULL | 2018-06-01 13:29:07 |
| 80589385421 | 95824797675 | 2018-06-19 08:54:53 | NULL | 2018-06-19 07:21:13 |
| 80589385421 | 95824797675 | 2018-06-30 20:58:47 | 2018-06-19 08:54:53 | 2018-06-30 20:47:06 |
| 81084725304 | 48334591197 | 2018-06-29 08:30:05 | NULL | 2018-06-29 07:20:47 |
| 99876173243 | 63838702267 | 2018-06-30 18:17:27 | NULL | 2018-06-30 18:02:08 |
---
#### RECEITA  
| cod_medicamento | cpf_med | cpf_pct | dt_atend | dt_vencimento | obs |
| ----- | ----- | ----- | ----- | ----- | ----- |
| 2 | 12567794423 | 75369310658 | 2018-06-29 18:58:24 | 2018-07-08 00:00:00 | NULL |
| 3 | 12567794423 | 75369310658 | 2018-06-29 18:58:24 | 2018-07-08 00:00:00 | NULL |
| 4 | 12567794423 | 75369310658 | 2018-06-29 18:58:24 | 2018-07-08 00:00:00 | Apenas em caso de vomito |
| 4 | 81084725304 | 48334591197 | 2018-06-29 08:30:05 | 2018-07-08 00:00:00 | Em caso de vomito constante |
| 6 | 12567794423 | 75369310658 | 2018-06-29 18:58:24 | 2018-07-08 00:00:00 | Durante pelo menos 2 dias |
| 8 | 81084725304 | 48334591197 | 2018-06-29 08:30:05 | 2018-07-08 00:00:00 | NULL |
---
#### ENCAMINHAMENTO  
| cod | motivo | descricao | dt_vencimento | cpf_med | cpf_pct | dt_atend |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| 1 | Sinais de miopia se desenvolvendo | Encaminhar para o Dr. Joseph Iyonovic no Hospital X. | 2018-07-30 00:00:00 | 12567794423 | 75369310658 | 2018-06-29 18:58:24 |
---
#### SINTOMA_PCT  
| cod_sintoma | cpf_pct | dt_triagem |
| ----- | ----- | ----- |
| 3 | 48334591197 | 2018-06-29 07:20:47 |
| 10 | 48334591197 | 2018-06-29 07:20:47 |
| 15 | 48334591197 | 2018-06-29 07:20:47 |
| 18 | 48334591197 | 2018-06-29 07:20:47 |
| 2 | 63838702267 | 2018-06-30 18:02:08 |
| 9 | 63838702267 | 2018-06-30 18:02:08 |
| 17 | 63838702267 | 2018-06-30 18:02:08 |
| 5 | 68979553587 | 2018-06-01 13:29:07 |
| 11 | 68979553587 | 2018-06-01 13:29:07 |
| 12 | 68979553587 | 2018-06-01 13:29:07 |
| 14 | 68979553587 | 2018-06-01 13:29:07 |
| 1 | 75369310658 | 2018-06-29 19:21:54 |
| 3 | 75369310658 | 2018-06-29 19:21:54 |
| 8 | 75369310658 | 2018-06-29 19:21:54 |
| 17 | 75369310658 | 2018-06-29 19:21:54 |
| 1 | 95824797675 | 2018-06-19 07:21:13 |
| 2 | 95824797675 | 2018-06-19 07:21:13 |
| 4 | 95824797675 | 2018-06-19 07:21:13 |
| 7 | 95824797675 | 2018-06-19 07:21:13 |
| 9 | 95824797675 | 2018-06-19 07:21:13 |
| 16 | 95824797675 | 2018-06-19 07:21:13 |
| 18 | 95824797675 | 2018-06-19 07:21:13 |
| 4 | 95824797675 | 2018-06-30 20:47:06 |
| 9 | 95824797675 | 2018-06-30 20:47:06 |
| 12 | 95824797675 | 2018-06-30 20:47:06 |
| 15 | 95824797675 | 2018-06-30 20:47:06 |
| 18 | 95824797675 | 2018-06-30 20:47:06 |
