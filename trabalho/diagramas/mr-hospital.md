## Modelo Relacional:  
---
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
