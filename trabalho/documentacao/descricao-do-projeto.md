# Banco de Dados, Ciência da Computação - 2018.1, INF/UFG
## Atividade Avaliativa da Disciplina - Projeto BD para o Hospital X
### Integrantes do Grupo:
- *inserir os nomes dos integrantes aqui*  

### Descrição do Problema:
  Este projeto se dedica a modelar a estrutura de um Banco de Dados que visa atender à demanda de Hospitais e Clínicas que fazem uso do modelo de negócio voltado para **plantões** e **consultas casuais**. Portanto, esse BD não se compromete a cubrir outros pontos da gestão e do dia-a-dia de um hospital que não se encaixe nesse cenário; Mais especificamente, que não esteja relacionado às consultas do plantão ou às internações.

### Definição dos **Perfis de Usuários** (papeis) do banco:
- *ainda a fazer*  

### Consultas:
#### ◯ Em Linguagem Natual
1. Assistente Pessoal do Médico:  
- Mostrar salas com mais de 3 pacientes do Médico "Ricardo"  
- Listar nome e sintoma dos Pacientes do médico "João" que tem retorno marcado para os próximos três dias seguinte a 22.07.2018  
- Mostrar Enfermeiro responsável pela sala dos pacientes do médico "Ricardo" no turno Vespertino  
- Listar nomes e sintomas dos Pacientes do médico "João" na sala 5  
2. Medico:  
- Listar medicamentos fornecidos por "Teuto" com preço abaixo de 30 reais  
- Listar sintomas ordenados crescentemente por quantidade de pacientes  
- Verificar o remédio mais receitado para o sintoma "dor de cabeça"  
- Mostrar a idade média dos pacientes com "Febre"  
3. Diretor:  
- Listar media salarial das enfermeiras do sexo feminino e que trabalham no periodo noturno  
- Mostrar especialidades médicas e suas médias salariais  
- Mostrar nome e quantidade de medicamentos acima de 100 reais receitados para o sintoma "diarreia"  
- Mostrar especialidades com mais de 2 médicos do sexo masculino com mais de 65 anos e que ganham mais de 15 mil reais  
4. Balconista:  
- Mostrar número das salas que ainda possuem leitos disponíveis  
- Mostrar nome e idade dos médicos especialistas em "cardiologia" disponíveis no periodo matutino e ordenados decrescentemente pela idade  
- Mostrar número da sala e estado do paciente "José" que foi internado no dia 22.04.2018  
- mostrar quantidade de pessoas por estado programadas para sairem nos próximos três dias  
---
#### ◯ Em __SQL__
- *ainda a fazer*  

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

FICHA_PCT ( __<ins>cpf_enf, cpf_pct, dt_triagem</ins>__, obs, peso_pct, altura_pct )  
FICHA_PCT ( cpf_enf ) __REFERENCIA__ ENFERMEIRO ( cpf )  
FICHA_PCT ( cpf_pct ) __REFERENCIA__ PACIENTE ( cpf )  

SINTOMA ( __<ins>cod</ins>__, descricao, gravidade )  

SINTOMA_PCT ( __<ins>sintoma, cpf_enf, cpf_pct, dt_triagem</ins>__ )  
SINTOMA_PCT ( cpf_pct, cpf_enf, dt_triagem ) __REFERENCIA__ FICHA_PCT ( cpf_pct, cpf_enf, dt_triagem )  
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

CONSULTA ( __<ins>cpf_med, cpf_pct, dt_atend</ins>__, dt_atend_orig, cpf_enf, dt_triagem )  
CONSULTA ( cpf_med ) __REFERENCIA__ MEDICO ( cpf )  
CONSULTA ( cpf_pct ) __REFERENCIA__ PACIENTE ( cpf )  
CONSULTA ( cpf_pct, cpf_enf, dt_triagem ) __REFERENCIA__ FICHA_PCT ( cpf_pct, cpf_enf, dt_triagem )  

ENCAMINHAMENTO ( __<ins>cod</ins>__, motivo, descricao, dt_vencimento, cpf_med, cpf_pct, dt_atend )  
ENCAMINHAMENTO ( cpf_pct, cpf_enf, dt_atend ) __REFERENCIA__ CONSULTA ( cpf_pct, cpf_enf, dt_atend )  

RECEITA ( __<ins>cod_medicamento, cpf_med, cpf_pct, dt_atend</ins>__, dt_vencimento, obs )  
RECEITA ( cod_medicamento ) __REFERENCIA__ MEDICAMENTO ( cod )  
RECEITA ( cpf_med, cpf_pct, dt_atend ) __REFERENCIA__ CONSULTA ( cpf_med, cpf_pct, dt_atend )  

### Esquema do Banco de Dados:
- *ainda a fazer*  

### Conteúdo das Tabelas:
- *ainda a fazer*  

### Extras:
#### ◯ Bibliografia:
#### ◯ Galeria:
#### ◯ Dicionário:
#### ◯ Considerações Finais:
