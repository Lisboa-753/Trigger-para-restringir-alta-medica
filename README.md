# Trigger para restringir alta médica.

Este projeto contém uma trigger (função no banco de dados Oracle) que restringe altas médicas feita para os pacientes.

## Objetivo

O objetivo principal desta trigger é **restringir a alta médica apenas para os médicos no sistema**. Esse gatilho verifica:

- Se o usuário logado possui um prestador do tipo médico;
- Se o usuário logado possui prestador
- Caso não encontre o usuário/prestador no banco de dados, irá ser retornado um erro tratado nos exceptions com o RAISE_APPLICATION_ERROR.

## Como funciona

A trigger irá ser disparada no momento em que o usuário tentar preencher uma alta médica, ante de atualizar a tabela TABELAATENDIMENTO, onde fica registrado a alta do médico.

Tudo isso é feito de forma automática diretamente no banco de dados.

## Tecnologias utilizadas

- Oracle PL/SQL
- Banco de dados relacional

## Uso

Esta trigger pode ser útil para sistemas que:

- Registram atendimentos de pacientes;
- Precisam restringir alta a apenas médicos;

---

> ⚠️ Atenção: este código é genérico e não utiliza dados reais de pacientes/médicos ou qualquer instituição. Foi adaptado para fins de exemplo e estudos

## Autor

Desenvolvido por Gabriel Lisboa 👨‍💻
