/*ASSISTENTE DO MEDICO*/
SELECT s.numero
FROM SALA AS s
  JOIN INTERNACAO AS i ON s.numero= i.num_sala
  JOIN CONSULTA AS c ON i.cpf_pct = c.cpf_pct
  JOIN PESSOA AS p ON c.cpf_med = p.cpf
WHERE p.nome = 'Bessie Ramsey'
GROUP BY s.numero
HAVING COUNT(*) > 3;

SELECT nome, cod, descricao, gravidade
FROM SINTOMA_PCT AS sp
  JOIN SINTOMA AS s ON sp.cod_sintoma = s.cod
  JOIN CONSULTA AS c ON sp.cpf_pct = c.cpf_pct
  JOIN PESSOA AS p ON p.cpf = c.cpf_med
WHERE p.nome = 'Elnora Underwood' 
      AND (c.dt_atend = '2018-05-01' OR c.dt_atend = '2018-05-02' OR c.dt_atend = '2018-05-03');

SELECT m.nome
FROM SALA AS s
  JOIN PESSOA AS f ON s.enf_gerente = f.cpf
  JOIN INTERNACAO AS i ON s.numero = i.num_sala
  JOIN CONSULTA AS c ON c.cpf_pct = i.cpf_pct
  JOIN PESSOA AS m ON m.cpf = c.cpf_med
WHERE m.nome = 'Linnie Hunter' AND f.cpf
                                   IN (SELECT e.cpf FROM ENFERMEIRO AS e JOIN TRABALHA_EM AS t ON t.cpf = e.cpf JOIN HORARIO AS h ON h.cod = t.cod
					     WHERE (
                       h.hr_inicial = '13:00' OR
                       h.hr_inicial = '12:00' OR
                       h.hr_inicial = '14:00' OR
                       h.hr_inicial = '15:00' OR
                       h.hr_inicial = "16:00" OR
                       h.hr_inicial = "17:00")
                     AND (
                       h.hr_final = "13:00" OR
                       h.hr_final = "14:00" OR
                       h.hr_final = "15:00" OR
                       h.hr_final = "16:00" OR
                       h.hr_final = "17:00" OR
                       h.hr_final = "18:00"
                     ));

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

SELECT m.descricao FROM MEDICAMENTO AS m 
	JOIN COMBATE_SINTOMA AS c ON c.cod_sintoma = m.cod
WHERE m.preco_unit < 30;

/*SINTOMAS MAIS COMUNS EM PACIENTES POR ORDEM ENTRE NO DIA: 2018-05-01*/
SELECT s.cod_sintoma, COUNT(s.cpf_pct) as cpfs FROM SINTOMA_PCT AS s
  JOIN CONSULTA AS c ON c.cpf_pct = s.cpf_pct
WHERE c.dt_atend = '2018-05-01'
GROUP BY s.cod_sintoma
ORDER BY COUNT(cpfs) DESC;

/*VERIFICAR A DESCRICAO DOS REMEDIOS MAIS RECEITADOS PARA O SINTOMA DOR DE CABEÇA NO MES DE MAIO DE 2018*/
SELECT r.cod_medicamento, m.descricao, COUNT(*) as counter FROM RECEITA AS r
  JOIN MEDICAMENTO AS m ON r.cod_medicamento = m.cod
  JOIN COMBATE_SINTOMA AS cm ON cm.cod_medicamento = m.cod
WHERE m.descricao = 'Dor de cabeça' AND r.dt_atend LIKE '%-05-%'
GROUP BY r.cod_medicamento
ORDER BY COUNT(counter);

/*MOSTRAR SOMA DA GRAVIDADE DOS SINTOMAS DOS PACIENTES DIAGNOSTICADOS COM FEBRE QUE NÃO TENHAM UM SINTOMA GRAVIDADE 1 E QUE SÃO GESTANTES*/
/*REFAZER IDADE*/
SELECT SUM(s.gravidade) FROM PACIENTE AS p
  JOIN PESSOA AS i ON p.cpf = i.cpf
  JOIN SINTOMA_PCT AS c ON c.cpf_PCT = p.cpf
  JOIN SINTOMA AS s ON s.cod = c.cod_sintoma
WHERE s.descricao LIKE '%Febre%' AND NOT EXISTS (SELECT *
						 FROM PACIENTE AS a JOIN SINTOMA_PCT AS b ON a.cpf = b.cpf_pct);

/*DIRETOR*/
/*EXCLUINDO O MENOR SALARIO*/
SELECT AVG(f.salario) FROM ENFERMEIRO AS e
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

SELECT s.numero FROM SALA AS s
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

SELECT i.num_sala, s.gravidade FROM INTERNACAO AS i
  JOIN PACIENTE AS p ON i.cpf_pct = p.cpf
  JOIN SINTOMA_PCT AS sp ON sp.cpf_pct = p.cpf
  JOIN SINTOMA AS s ON sp.cod_sintoma = s.cod
  JOIN PESSOA AS a ON a.cpf = p.cpf
WHERE a.nome LIKE 'JOSÉ%' AND  i.dt_intern = '2018-04-22';

SELECT S.gravidade, COUNT(p.cpf) FROM PACIENTE AS p
  JOIN PESSOA AS a ON a.cpf = p.cpf
  JOIN SINTOMA_PCT AS b ON b.cpf_pct = p.cpf
  JOIN SINTOMA S ON b.cod_sintoma = S.cod
GROUP BY S.gravidade 
HAVING COUNT(p.cpf) >= 1;
