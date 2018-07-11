/*ASSISTENTE DO MEDICO*/
SELECT s.numero
FROM (((SALA AS s JOIN INTERNACAO AS i ON s.numero= i.numero) JOIN CONSULTA AS c ON i.cpf_pct = c.cpf_pct) JOIN PESSOA AS p ON c.cpf_med = p.cpf)
WHERE p.nome = 'Bessie Ramsey' 
GROUP BY s.numero  
HAVING COUNT(*) > 3

SELECT nome, cod, descricao, gravidade /* PACIENTES E SINTOMAS ATENDIDOS NOS ULTIMOS TRES DIAS */
FROM (((SINTOMA_PCT AS sp JOIN SINTOMA AS s ON sp.sintoma = s.cod) JOIN CONSULTA AS c ON sp.cpf = c.cpf_pct) JOIN PESSOA AS p ON p.cpf = c.cpf_med)
WHERE p.nome = 'Elnora Underwood' AND (c.dt_atend = '2018-05-01' OR c.dt_atend = '2018-05-02' OR c.dt_atend = '2018-05-03')

SELECT p.nome
FROM ((((SALA AS s JOIN PESSOA AS f ON s.enf_gerente = f.cpf) JOIN INTERNACAO AS i ON s.numero = i.numero) JOIN CONSULTA AS c ON c.cpf_pct = i.cpf_pct) JOIN PESSOA AS m ON m.cpf = c.cpf_med)
WHERE m.nome = 'Linnie Hunter' AND f.cpf IN (SELECT e.cpf
					     FROM ((ENFERMEIRO AS e JOIN TRABALHA_EM AS t 						     ON t.cpf = e.cpf) JOIN HORARIO AS h ON h.cod = 					             t.cod)  
					     WHERE (h.hr_inicial = '13:00' OR h.hr_inicial 						     = '12:00' OR h.hr_inicial = '14:00'              						     OR h.hr_inicial = '15:00' OR h.hr_inicial = "16:00"   						     OR h.hr_inicial = "17:00") AND (h.hr_final = "13:00" OR 					             h.hr_final = "14:00" OR h.hr_final = "15:00" OR h.hr_final 					     = "16:00" OR h.hr_final = "17:00" OR h.hr_final = "18:00")

SELECT d.nome, s.cod, s.descricao, s.gravidade
FROM (((SIMTOMA_PCT AS sp JOIN SINTOMA AS s ON sp.simtoma = s.cod) JOIN CONSULTA AS c ON s.cpf = c.cpf_pct) JOIN INTERNACAO AS i ON i.cpf = s.cpf) JOIN PESSOA AS m ON m.cpf = s.cpf) JOIN PESSOA AS d ON d.cpf = sp.cpf)
WHERE m.nome = 'Minnie Tyler' AND i.numero = 5

/*MEDICO*/
/*DESCRIÇÃO DOS REMEDIOS QUE COMBATAM O SINTOMA FEBRE BAIXA ABAIXO DE 30 REAIS*/

SELECT m.descrição
FROM (MEDICAMENTO AS m JOIN COMBATE_SINTOMA AS c ON c.cod = m.cod)
WHERE m.preco_unit < 30

/*SINTOMAS MAIS COMUNS EM PACIENTES POR ORDEM ENTRE NO DIA: 2018-05-01*/
SELECT s.sintoma, COUNT(cpf)
FROM SINTOMA_PCT AS s JOIN CONSULTA AS c ON c.cpf_pct = cpf
WHERE c.dt_atend = '2018-05-01'
GROUP BY sintoma
ORDER BY DESC COUNT(cpf)

/*VERIFICAR A DESCRICAO DOS REMEDIOS MAIS RECEITADOS PARA O SINTOMA DOR DE CABEÇA NO MES DE MAIO DE 2018*/
SELECT r.cod_medicamento, m.descricao, COUNT(*) 
FROM ((RECEITA AS r JOIN MEDICAMENTO AS m ON r.cod_medicamento = m.cod) JOIN COMBATE_SINTOMA AS c.cod_medicamento = m.cod)
WHERE c.descricao = 'Dor de cabeça' AND r.dt_atend LIKE '%-05-%'
GROUP BY r.cod_medicamento 
ORDER BY COUNT(cpf)

/*MOSTRAR SOMA DA GRAVIDADE DOS SINTOMAS DOS PACIENTES DIAGNOSTICADOS COM FEBRE QUE NÃO TENHAM UM SINTOMA GRAVIDADE 1 E QUE SÃO GESTANTES*/
/*REFAZER IDADE*/
SELECT SUM(s.gravidade)
FROM (((PACIENTE AS p JOIN PESSOA AS i ON p.cpf = i.cpf) JOIN SINTOMA_PCT AS c ON c.cpf_PCT = p.cpf) JOIN SINTOMA AS s ON s.cod = c.sintoma)
WHERE s.descricao LIKE '%Febre%' AND NOT EXISTS (SELECT *
						 FROM PACIENTE AS a JOIN SINTOMA_PCT AS b ON a.cpf = b.cpf_pct
						 WHERE a.gravidade <> 1 AND /*TERMINAR*/ 
/*DIRETOR*/
/*EXCLUINDO O MENOR SALARIO*/
SELECT AVG(f.salario)
FROM (((ENFERMEIRO AS e JOIN FUNCIONARIO AS f ON e.cpf = f.cpf) JOIN PESSOA AS p ON p.cpf = e.cpf) JOIN TRABALHA_EM AS t ON t.cpf = e.cpf) JOIN HORARIO AS h ON h.cod = t.cod) 
WHERE f.sexo = 'M' AND h.descricao LIKE '%noite%' AND f.salario > ANY (SELECT n.salario 
								       FROM FUNCIONARIO AS n JOIN 									       ENFERMEIRO AS d) ON n.cpf = d.cpf)

SELECT m.descricao
FROM ((MEDICAMENTO AS m JOIN RECEITA AS r ON m.cod = r.cod_medicamento) JOIN SINTOMA_PCT AS s ON s.cpf = r.cpf_pct)
GROUP BY 
WHERE m.preco_unit < 100 AND r.sintoma = 1

Mostrar especialidades com mais de 4 médicos, sexo masculino e que não exista outro dessa mesma especialidade area
SELECT a.id_macro_area
FROM ((FORMADO_EM AS f JOIN MEDICO AS m ON m.cpf = f.cpf) JOIN AREA_ATUACAO AS a ON a.id_area = f.id_area)
WHERE sexo = 'H' AND NOT EXISTS (SELECT *
				 FROM AREA_ATUACAO AS b
				 WHERE a.macro_area = a.macro_area)
GROUP BY f.macro_area 
HAVING COUNT(*) > 4 

/*BALCONISTA*/

SELECT s.numero
FROM ((SALA AS s JOIN INTERNACAO AS i ON i.num_sala = s.numero) JOIN PACIENTE AS p ON p.cpf = i.cpf_pct)
GROUP BY s.numero 
HAVING COUNT(p.cpf) < s.num_leitos

SELECT p.nome, h.hr_inicial, h.hr_final 
FROM ((((MEDICO AS m JOIN FORMADO_EM AS a ON a.cpf = m.cpf) JOIN TRABALHA_EM AS t ON t.cpf = m.cpf) JOIN HORARIO AS h ON h.cod = t.cod) JOIN PESSOA AS p ON p.cpf = m.cpf)
WHERE h.descricao LIKE '%matutino%'
ORDER BY p.nome

SELECT i.num_sala, s.gravidade
FROM (INTERNACAO AS i JOIN PACIENTE AS p ON i.cpf_pct = p.cpf) JOIN SINTOMA_PCT AS s ON s.cpf_pct = p.cpf) JOIN PESSOA AS a ON a.cpf = p.cpf_pct)
WHERE a.nome LIKE 'JOSÉ%' AND  i.dt_intetn = '2018-04-22'

SELECT gravidade, COUNT(p.cpf)
FROM ((PACIENTE AS p JOIN PESSOA AS a ON a.cpf = p.cpf) JOIN SINTOMA_PCT AS b ON b.cpf_pct = p.cpf)
GROUP BY p.gravidade 
HAVING COUNT(p.cpf) >= 1
