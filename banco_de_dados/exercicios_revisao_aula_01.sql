create database aula_01;

-- Considerando a criação das tabelas no banco de dados, existe alguma restrição quanto a ordem de execução? Se existir, defina uma sequência correta para a criação das tabelas do esquema acima.
-- R: A criação deve seguir a seguinte ordem: cidades, filiais, empregados, produtos e, por fim, vende.

CREATE TABLE cidades(
	codigo_cidade int auto_increment primary key,
    nome varchar(100) not null,
    uf char(2)
);

CREATE TABLE filiais(
	codfilial int auto_increment primary key,
    nome varchar(100) not null,
    endereco varchar(250) not null,
    codigo_cidade int not null,
    constraint filial_cidade
		foreign key(codigo_cidade) references cidades(codcid)
        ON DELETE restrict
        ON UPDATE cascade
);


CREATE TABLE empregados(
	codemp int primary key auto_increment,
	nome varchar(100) not null,
	endereco varchar(250) not null,
	salario float default 0,
	rg int not null unique,
	cpf varchar(11) not null unique,
	ct varchar(20) not null,
	codigo_cidade int not null,
    constraint empregado_cidade
		foreign key(codigo_cidade) references cidades(codcid) 
        ON DELETE restrict
        ON UPDATE cascade,
	cod_filial int not null,
    constraint empregado_filial
		foreign key(cod_filial) references filiais(codfilial)
        ON DELETE restrict
        ON UPDATE cascade
);

CREATE TABLE produtos(
	codprod int auto_increment primary key,
    descricao varchar(250),
    preco float default 0,
    nomecategoria varchar(15) not null,
    descricaocategoria varchar(250) not null
);

CREATE TABLE vende(
	cod_produto int not null,
    constraint vende_produto
		foreign key(cod_produto) references produtos(codprod)
        ON DELETE restrict
        ON UPDATE cascade,
    cod_filial int not null,
    constraint vende_filial
		foreign key(cod_filial) references filiais(codfilial)
        ON DELETE restrict
        ON UPDATE cascade
);

-- prenchendo as tabelas
INSERT INTO produtos (descricao, preco, nomecategoria, descricaocategoria)
VALUES ('Notebook Dell Inspiron 15', 4000.00, 'Eletrônicos', 'Notebooks e Laptops'),
('Smartphone Samsung Galaxy S21', 3500.00, 'Eletrônicos', 'Smartphones'),
('Camiseta Polo Ralph Lauren', 250.00, 'Vestuário', 'Camisetas Polo'),
('Tênis Nike Air Max 90', 600.00, 'Calçados', 'Tênis Esportivos'),
('Livro "1984" de George Orwell', 45.00, 'Livros', 'Ficção Científica');

INSERT INTO empregados (nome, endereco, salario, rg, cpf, ct, codigo_cidade, cod_filial)
VALUES ('João Silva', 'Rua A, 123', 3000.00, 123456, '11122233344', 'CLT', 1, 1),
('Maria Santos', 'Rua B, 456', 2500.00, 654321, '44455566677', 'PJ', 2, 2),
('Pedro Souza', 'Rua C, 789', 2800.00, 987654, '88899900011', 'CLT', 3, 3);

INSERT INTO cidades (nome, uf) VALUES ('São Paulo', 'SP'),
('Rio de Janeiro', 'RJ'),
('Belo Horizonte', 'MG'),
('Arroio do Sal', 'RS'),
('Torres', 'RS'),
('Florianopolis', 'SC');

INSERT INTO filiais (nome, endereco, codigo_cidade) VALUES ('Filial 1', 'Av. Paulista, 1000', 1),
('Filial 2', 'Rua do Ouvidor, 50', 2),
('Filial 3', 'Av. Assis Brasil, 23', 3),
('Filial 4', 'Rua Lindoia, 1074', 3),
('Filial 5', 'Rua da ULBRA, 234', 5);

-- listar o valor do produto mais caro
SELECT max(preco) AS valor_mais_alto
FROM produtos;

-- obter a média dos preços dos produtos
SELECT avg(preco) AS media_preco
FROM produtos;

-- listar o nome dos produtos vendidos pela filial “f3”. (joins)
SELECT p.descricao
FROM produtos p
	INNER JOIN vende v
		on p.codprod = v.cod_produto
	INNER JOIN filiais f
		on v.cod_filial = f.codfilial
WHERE f.nome = 'f3';

-- listar os nomes e números de RG dos funcionários que moram no Rio Grande do Sul e tem salário superior a R$ 500,00. (joins)
SELECT e.nome, e.rg
FROM empregados e
    INNER JOIN cidades c
    ON e.codigo_cidade = c.codcid
WHERE c.uf = 'RS' AND salario > 500;


-----------------------------------------------------------------------------------------------------------------------
-- *******DATABASE LIVROS*******
-- Para a resolução dos demais exercícios,  considere o esquema relacional definido abaixo:
-- Livro(codlivro, titulo, codautor, nfolhas, editora, valor, codcat)
-- Categoria (codcat, nome, descrição)
-- Autor(codautor, nome, codcid)
-- Cliente(codcliente, nome, endereço, codcid)
-- Cidade(codcid, nome, UF)
-- Venda (Codlivro, codcliente, quantidade, data)

-- criando todas as tabelas
CREATE TABLE cidades(
    codcid int primary key auto_increment,
    nome varchar(100) not null,
    uf char(2) not null
);

CREATE TABLE autores(
    codautor int primary key auto_increment,
    nome varchar(100) not null,
    cod_cidade int not null,
    constraint autores_cidade
        foreign key (cod_cidade) references cidades(codcid)
        ON DELETE restrict
        ON UPDATE cascade
);

CREATE TABLE clientes(
    codcliente int primary key auto_increment,
    nome varchar(100) not null,
    endereco varchar(250) not null,
    cod_cidade int not null,
    constraint clientes_cod_cidade
        foreign key (cod_cidade) references cidades(codcid)
        ON DELETE restrict
        ON UPDATE cascade
);

CREATE TABLE categorias(
    codcat int primary key auto_increment,
    nome varchar(50) not null,
    descricao varchar(250) not null
);

CREATE TABLE livros(
    codlivro int primary key auto_increment,
    titulo varchar(75) not null,
    nfolhas int not null,
    editora varchar(50) not null, 
    valor float default 0,
    cod_autor int not null,
    constraint livros_cod_autor
        foreign key(cod_autor) references autores(codautor)
        ON DELETE restrict
        ON UPDATE cascade,
    cod_categoria int not null,
    constraint livros_cod_categoria
        foreign key(cod_categoria) references categorias(codcat)
        ON DELETE restrict
        ON UPDATE cascade
);

CREATE TABLE vendas(
    quantidade int not null,
    data_venda date,
    cod_livro int not null,
    constraint vendas_cod_livro
        foreign key(cod_livro) references livros(codlivro)
        ON DELETE restrict
        ON UPDATE cascade,
    cod_cliente int not null,
    constraint vendas_cod_cliente
        foreign key(cod_cliente) references clientes(codcliente)
        ON DELETE restrict
        ON UPDATE cascade
);

-- Defina a sintaxe SQL para a criação das tabelas LIVRO e CATEGORIA. Na criação das tabelas especifique a seguinte restrição: “Quando uma categoria for excluída, todos os livros da categoria em questão também serão excluídos.”

CREATE TABLE categorias(
    codcat int primary key auto_increment,
    nome varchar(50) not null,
    descricao varchar(250) not null
);

CREATE TABLE livros(
    codlivro int primary key auto_increment,
    titulo varchar(75) not null,
    nfolhas int not null,
    editora varchar(50) not null, 
    valor float default 0,
    cod_autor int not null,
    constraint livros_cod_autor
        foreign key(cod_autor) references autores(codautor)
        ON DELETE cascade
        ON UPDATE cascade,
    cod_categoria int not null,
    constraint livros_cod_categoria
        foreign key(cod_categoria) references categorias(codcat)
        ON DELETE restrict
        ON UPDATE cascade
);

-- preenchendo as tabelas
INSERT INTO cidades (nome, uf)
VALUES ('São Paulo', 'SP'),
('Rio de Janeiro', 'RJ');

INSERT INTO autores (nome, cod_cidade) 
VALUES ('Machado de Assis', 1),
('Clarice Lispector', 2);

INSERT INTO clientes (nome, endereco, cod_cidade)
VALUES ('João Silva', 'Rua A, 123', 1),
('Maria Souza', 'Rua B, 456', 2);

INSERT INTO categorias (nome, descricao)
VALUES ('Romance', 'Livros de ficção romântica'), 
('Terror', 'Livros de horror e suspense');

INSERT INTO livros (titulo, nfolhas, editora, valor, cod_autor, cod_categoria)
VALUES ('Dom Casmurro', 200, 'Companhia das Letras', 29.90, 1, 1),
('A Hora da Estrela', 150, 'Rocco', 19.90, 2, 1);

INSERT INTO vendas (quantidade, data_venda, cod_livro, cod_cliente)
VALUES (1, '2022-01-01', 1, 1),
(2, '2022-01-02', 2, 2);

-- Defina a sintaxe SQL para resolver as seguintes consultas: (NÃO ESQUEÇA de usar JOINS nas consultas que envolverem mais de uma tabela)
-- Mostrar o número total de vendas realizadas. 
SELECT count(*) as total
FROM vendas;

-- Listar os títulos e valores dos livros da categoria “banco de Dados’. Mostra também o nome da categoria. 
SELECT l.titulo, l.valor, c.nome
FROM livros l
    INNER JOIN categorias c
        on l.cod_categoria = c.codcat
WHERE c.nome = 'banco de dados'

-- Listar os  títulos e nome dos autores dos livros que custam mais que R$ 300,00.Listar os nomes dos clientes juntamente com o nome da cidade onde moram e UF.
SELECT l.titulo, a.nome as autor, cli.nome as cliente, cid.nome as cidade, cid.uf
FROM livros l
    INNER JOIN autores a
        on l.cod_autor = a.codautor
    INNER JOIN vendas v
        on l.codlivro = v.cod_livro
    INNER JOIN clientes cli
        on v.cod_cliente = cli.codcliente
    INNER JOIN cidades cid
        on cid.codcid = cli.cod_cidade
WHERE valor >= '300.00';

-- Listar os nomes dos clientes juntamente com os nomes de todos os livros comprados por ele.
SELECT cli.nome, l.titulo
FROM clientes cli
    INNER JOIN vendas v
        on cli.codcliente = v.cod_cliente
    INNER JOIN livros l
        on v.cod_livro = l.codlivro

-- Listar o código do livro, o tilulo, o nome do autor, dos livros que foram vendidos no mês de março de 2021. (join)
SELECT l.codlivro as codigo, l.titulo, a.nome
FROM livros l
    INNER JOIN vendas v
        on l.codlivro = v.cod_livro
    INNER JOIN autores a
        on l.cod_autor = a.codautor
WHERE DATE(v.data_venda) LIKE '2021-03-__'

-- Listar o título e o autor dos 5 livros mais vendidos do mês de janeiro.
SELECT l.titulo, a.nome, sum(v.quantidade) as quantidade_vendida
FROM livros l 
    INNER JOIN autores a
        on l.cod_autor = a.codautor
    INNER JOIN vendas v 
        on l.codlivro = v.cod_livro
group by l.codlivro
order by quantidade_vendida DESC
limit 5;

-- Mostrar o nome do cliente que comprou o livro com o título (‘Banco de dados powerful’).
SELECT cli.nome
FROM vendas v
    INNER JOIN clientes cli
        on v.cod_cliente = cli.codcliente
    INNER JOIN livros l
        on v.cod_livro = l.codlivro
where l.titulo = 'Banco de Dados Powerfull';