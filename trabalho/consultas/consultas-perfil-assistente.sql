-- 1
SELECT  COUNT(numero) AS qtd_pacientes, numero
FROM    SALA JOIN INTERNACAO I on SALA.numero = I.num_sala
WHERE   dt_alta IS NULL
GROUP BY numero
HAVING COUNT(numero) > 3;

-- 2
SELECT  P2.nome, S.descricao
FROM    PACIENTE P
  JOIN FICHA_PCT F ON P.cpf = F.cpf_pct
  JOIN CONSULTA C ON F.cpf_pct = C.cpf_pct AND F.dt_triagem = C.dt_triagem
  JOIN SINTOMA_PCT SP ON P.cpf = SP.cpf_pct AND F.dt_triagem = SP.dt_triagem
  JOIN SINTOMA S ON SP.cod_sintoma = S.cod
  JOIN MEDICO M ON M.cpf =  C.cpf_med
  JOIN PESSOA P2 ON P.cpf = P2.cpf
  JOIN PESSOA P3 ON M.cpf = P3.cpf
  JOIN INTERNACAO I on P.cpf = I.cpf_pct
WHERE   P3.nome LIKE 'Elnora%' AND I.dt_alta IS NULL;

--3
SELECT  S.numero, P.nome
FROM    SALA S
  JOIN ENFERMEIRO E ON S.enf_gerente = E.cpf
  JOIN PESSOA P ON P.cpf = E.cpf
  JOIN FICHA_PCT F ON E.cpf = F.cpf_enf
  JOIN CONSULTA C ON F.cpf_pct = C.cpf_pct AND F.dt_triagem = C.dt_triagem
  JOIN MEDICO M ON C.cpf_med = M.cpf
  JOIN PESSOA P2 ON P2.cpf = M.cpf
  JOIN INTERNACAO I ON S.numero = I.num_sala AND I.cpf_pct = F.cpf_pct
WHERE   P2.nome LIKE 'Linnie%' AND I.dt_alta IS NULL;
