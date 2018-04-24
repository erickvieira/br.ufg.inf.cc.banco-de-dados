USE empresa;
SELECT	pnome
FROM	projeto
	JOIN trabalha_em 	ON pno = pnumero
	JOIN departamento	ON departamento.dnumero = dnum
        JOIN empregado 		ON dno = dnumero
WHERE	empregado.dno = departamento.dnumero
		AND projeto.dnum = departamento.dnumero
GROUP	BY	pnome
ORDER	BY	pnome;

SELECT	*
FROM	departamento;

SELECT	pnome
FROM	trabalha_em
	JOIN empregado		ON essn = empregado.ssn
        JOIN departamento	ON empregado.dno = departamento.dnumero
        JOIN projeto		ON pno = projeto.pnumero
GROUP	BY	pnome
ORDER	BY	pnome;
        
SELECT	*
FROM	empregado
ORDER	BY	pnome;

SELECT	*
FROM	depto_localizacoes;

SELECT	*
FROM	projeto;
