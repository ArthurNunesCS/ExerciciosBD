create database if not exists db_empresa
	character set utf8mb4
	COLLATE utf8mb4_general_ci;
use db_empresa;

create table tb_cliente(
	id_cliente int primary key auto_increment,
    nome varchar(150) not null,
    email varchar(254) unique,
    ativo tinyint default true,
    data_cadastro datetime default current_timestamp
) engine = innoDB;

show tables;
describe tb_cliente;
show index from tb_cliente;

-- Etapa 2 - categoria
create table tb_categoria(
	id_categoria int primary key auto_increment, -- Para facilitar a identificação e permitir o auto_increment
    nome varchar(40) unique not null -- Varchar(40) porque ele não irá preencher espaços vazios nas linhas e o tamanho para categorias com "dois" nomes
) engine = innoDB;

-- Etapa 1 - produto
create table tb_produto(
	id_produto int auto_increment primary key,
	nome varchar(100) not null,
	preco decimal(7,2) check(preco>0),
	qtd_estoque int default 0,
	data_cadastro datetime default current_timestamp
) engine = innoDB;

-- Etapa 3
alter table tb_produto add id_categoria int not null;
alter table tb_produto add constraint fk_produto_categoria foreign key(id_categoria) references tb_categoria(id_categoria) on delete restrict;

/* Etapa 1 - Dúvidas
1- O tipo de dado mais adequado é o Decimal para valores
2- Pois o tipo float arredonda o valor descrito pelo usuário e arredonda-o
3- Os números com casas decimais iriam ser arredondados, o que quebraria o sistema
4- Caso não seja definido um valor padrão para o estoque, poderia haver a possibilidade de não haver nenhum valor dentro do campo
5- Nos SGDBs atuais não é obrigatório definir engine pois, por padrão, ela já é definida no banco. Porém, trata-se de uma boa prática para garantir
o funcionamento correto das transações do banco, garantindo que cada operação seja feita de forma precisa.
*/

/* Etapa 2 - Dúvidas
7 - Para não repetir os nomes de categorias já existentes
8 - Poderia existir duas categorias com o mesmo nome, porém id diferentes
9 - Não será possível relacioná-la com outra tabela e não haverá integridade referencial
*/

/* Etapa 3 - Dúvidas
    10 - Restrict, já que não permite a exclusão de uma categoria que tem relacionamentos
    11 - Quando o negócio deseja que ao apagar um registro, todos os outros que tem relacionamento com tal, sejam excluídos
    12 - Quando o negócio não deseja que ao apagar um registro outros registros que se relacionam com tal sejam excluídos
    13 - Ao apagar um registro pai, os registros filhos que tinham relacionamento com tal, terão NULL no campo da FK
    14 - A regra na aplicação pode permitir a inserção de certo tipo de dado, porém se a regra no banco for diferente, tal dado não será inserido
    */

create table tb_pedido(
	id_pedido int primary key auto_increment,
    id_cliente int not null,
    constraint fk_pedido_cliente 
		foreign key (id_cliente) 
		references tb_cliente (id_cliente) 
        on delete cascade,
	data_pedido datetime default current_timestamp,
    valor_pedido decimal (7,2) check(valor_pedido>0)
)engine=InnoDB;

-- Exercício Evoluindo o Sistema (Itens do Pedido)

create table pedido_item(
	id_item int primary key auto_increment,
    id_pedido int not null,
    id_produto int not null, 
    qtd int check (qtd>0),
    preco_uni decimal(7,2),
    constraint fk_item_pedido
		foreign key (id_pedido)
		references tb_pedido (id_pedido)
		on delete cascade,
	constraint fk_item_produto
		foreign key (id_produto)
        references tb_produto (id_produto)
        on delete restrict
)engine = innoDB;

-- Versionamento controlado(RENAME)
/*
alter table cliente
add column cpf varchar(14) unique;
alter table cliente 
modify column nome varchar(150) not null;
alter table cliente
drop column cpf;

rename table tb_produto to produto_v1;
show tables;
rename table produto_v1 to tb_produto;
show tables;
*/


-- Exercios progressivos 2
-- Exercício 2.1
insert into tb_cliente (nome, email, ativo) 
values
	('Ana Souza', 'ana@email.com', 1),
	('Carla Mendes', 'carla@email.com', 1),
	('Ana Souza', 'ana@gmail.com', 1),
	('Bruno Lima', 'bruno@yahoo.com', 1),
	('Carla Dias', 'carla@gmail.com', 1),
	('Diego Silva', 'diego@outlook.com', 0),
	('Eva Santos', null , 1),
	('Fabio Rocha', 'fabio@gmail.com', 1);
    
-- Exercício 2.2
insert into tb_categoria (nome)
values
	('Informática'),
	('Livros'),
	('Acessórios');
    
-- Exercício 2.3
insert into tb_produto (nome, preco, qtd_estoque, id_categoria)
values
	('Notebook', 4500.00, 10, 1),
	('Mouse Gamer', 150.00, 50, 1),
	('Livro SQL', 90.00, 30, 2),
	('Smartphone', 3200.00, 15, 1);
    
-- Exercício 2.4
insert into tb_pedido(id_cliente, valor_pedido)
values
	(1, 4500.00),
	(1, 150.00),
	(2, 3200.00),
	(3, 90.00),
	(3, 500.00);
    
-- Exercício 2.5
insert into pedido_item (id_pedido, id_produto, qtd, preco_uni)
values
	(1, 1, 1, 4500.00),
	(2, 2, 1, 150.00),
	(3, 4, 1, 3200.00),
	(4, 3, 1, 90.00),
	(5, 3, 5, 100.00);

