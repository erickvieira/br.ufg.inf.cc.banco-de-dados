/*ASSISTENTE DO MEDICO*/
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

/*MEDICO*/
/*DESCRIÇÃO DOS REMEDIOS QUE COMBATAM O SINTOMA FEBRE BAIXA ABAIXO DE 30 REAIS*/

SELECT m.descricao
FROM MEDICAMENTO AS m
  JOIN COMBATE_SINTOMA AS c ON c.cod_medicamento = m.cod
  JOIN SINTOMA AS s ON s.cod = c.cod_sintoma
WHERE m.preco_unit < 30 AND s.cod = 3
GROUP BY m.descricao;

/*SINTOMAS MAIS COMUNS EM PACIENTES POR ORDEM ENTRE NO DIA: 2018-05-01*/
SELECT s.cod_sintoma, COUNT(s.cpf_pct) as cpfs
FROM SINTOMA_PCT AS s
  JOIN CONSULTA AS c ON c.cpf_pct = s.cpf_pct
WHERE c.dt_atend = '2018-05-01'
GROUP BY s.cod_sintoma
ORDER BY COUNT(cpfs) DESC;

/*VERIFICAR A DESCRICAO DOS REMEDIOS MAIS RECEITADOS PARA O SINTOMA DOR DE CABEÇA NO MES DE MAIO DE 2018*/
SELECT r.cod_medicamento, m.descricao, COUNT(*) as counter
FROM RECEITA AS r
  JOIN MEDICAMENTO AS m ON r.cod_medicamento = m.cod
  JOIN COMBATE_SINTOMA AS cm ON cm.cod_medicamento = m.cod
WHERE m.descricao = 'Dor de cabeça' AND r.dt_atend LIKE '%-05-%'
GROUP BY r.cod_medicamento
ORDER BY COUNT(counter);

/*MOSTRAR SOMA DA GRAVIDADE DOS SINTOMAS DOS PACIENTES DIAGNOSTICADOS COM FEBRE QUE NÃO TENHAM UM SINTOMA GRAVIDADE 1 E QUE SÃO GESTANTES*/
/*REFAZER IDADE*/
SELECT SUM(s.gravidade)
FROM PACIENTE AS p
  JOIN PESSOA AS i ON p.cpf = i.cpf
  JOIN SINTOMA_PCT AS c ON c.cpf_PCT = p.cpf
  JOIN SINTOMA AS s ON s.cod = c.cod_sintoma
WHERE s.descricao LIKE '%Febre%' AND NOT EXISTS (SELECT *
  FROM PACIENTE AS a JOIN SINTOMA_PCT AS b ON a.cpf = b.cpf_pct);

/*DIRETOR*/
/*EXCLUINDO O MENOR SALARIO*/
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

/*BALCONISTA*/

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
HAVING COUNT(p.cpf) >= 1;
