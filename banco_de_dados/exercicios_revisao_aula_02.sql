create database aula_02;

-- 1. Escreva uma consulta que retorne o nome do cliente, a soma do valor total das compras e o número total de pedidos feitos por cada cliente, apenas para aqueles que fizeram pelo menos três pedidos. Use um inner join entre as tabelas "clientes" e "pedidos" e agrupe os resultados pelo nome do cliente.

SELECT c.nome, sum(p.valor) as soma_do_valor, count(p.id) as total_pedidos
FROM clientes c
    INNER JOIN pedidos p
        on c.id = p.id_cliente
GROUP BY c.nome
HAVING count(p.id) >= 3;

-- 2. Escreva uma consulta que retorne o nome do produto, a média do preço de venda e a soma total de unidades vendidas por categoria de produto. Use um left join entre as tabelas "produtos" e "vendas" e agrupe os resultados pela categoria do produto.

SELECT p.categoria as categoria, p.nome as produto, avg(v.preco) as media_preco_venda,  sum(v.unidades) as total_unidades_vendidas
FROM produtos p
    LEFT JOIN vendas v ON p.id = v.id_produto
GROUP BY p.categoria, p.nome;

-- 3. Escreva uma consulta que retorne o nome do fornecedor, o nome do produto e o número total de unidades compradas por fornecedor e por produto, apenas para aqueles com mais de 100 unidades compradas. Use um inner join entre as tabelas "fornecedores", "produtos" e "compras" e agrupe os resultados pelo nome do fornecedor e pelo nome do produto.

SELECT f.nome as fornecedor, p.nome as produto, sum(c.unidades) as total_unidades_compradas
FROM fornecedores f
    INNER JOIN produtos p
        on f.id = p.id_fornecedor
    INNER JOIN compras c
        on p.id = c.id_produto
WHERE c.unidades > 100
GROUP BY f.nome, p.nome;

-- 4. Escreva uma consulta que retorne o nome do departamento, o nome do funcionário e a média do salário dos funcionários em cada departamento, apenas para aqueles com uma média de salário superior a R$ 5000. Use um left join entre as tabelas "funcionarios" e "departamentos" e agrupe os resultados pelo nome do departamento e pelo nome do funcionário.

SELECT d.nome as departamento, f.nome as funcionario, avg(d.salario) as media_salarial
FROM funcionarios f
    LEFT JOIN departamentos d
        on f.id = d.id_funcionario
GROUP BY d.nome, f.nome
HAVING avg(d.salario) > 5000;

-- 5. Escreva uma consulta que retorne o nome do cliente, o nome do produto e a soma do valor total das compras feitas por cada cliente para cada produto. Use um right join entre as tabelas "clientes" e "compras" e um inner join entre as tabelas "produtos" e "compras" e agrupe os resultados pelo nome do cliente e pelo nome do produto.

SELECT cli.nome as cliente, p.nome as produto, sum(c.valor) as valor_total
FROM clientes cli
    RIGHT JOIN compras c
        on cli.id = c.id_cliente
    INNER JOIN produtos p
        on p.id = c.id_produto
GROUP BY cli.nome, p.nome;