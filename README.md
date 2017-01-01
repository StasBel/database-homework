# database-homework

> SPbAU database course homework

## Table of Contents

- [Description](#description)
- [Postgres 101](#postgres-101)
  * [Scheme](#scheme)
  * [Queries & Optimizing](#queries--optimizing)

## Description
В одном контейнере живет СУБД. В ней на каждое домашнее задание есть отдельный database, прикрепленный к одтельному user-у. Его логин и 
пароль можно посмотреть в файле "./init.sql". Чтоб начать работать с очередным домашним заданием, нужно запустить клиент (psql) от имени, соответствующего 
этому дз. После запуска psql, папка ./src/ будет отображена в папку ./DBsrc/, таким образом можно будет запускать все сохраненные скрипты.

## Postgres 101

### Scheme

#### constraints

```sql
check (in ..., beetween a and b, similar to 'regex')
not-null
unique
primary key (serial)
references
    on delete restrict
    on delete cascade
    on update restrict
    on update cascade
```

#### types

```sql
bytea
bit/boolean
text
int/integer/bigint/smallint
serial (autoincr)
date
time
timestamp
numeric(10, 5)
real/double precision
money
array[3][5]
```

#### many-to-many

```sql
CREATE TABLE product (
  product_id serial PRIMARY KEY,  -- implicit primary key constraint
  product    text NOT NULL,
  price      numeric NOT NULL DEFAULT 0
);

CREATE TABLE bill (
  bill_id  serial PRIMARY KEY,
  bill     text NOT NULL,
  billdate date NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE bill_product (
  bill_id    int REFERENCES bill (bill_id) ON UPDATE CASCADE ON DELETE CASCADE,
  product_id int REFERENCES product (product_id) ON UPDATE CASCADE,
  amount     numeric NOT NULL DEFAULT 1,
  CONSTRAINT bill_product_pkey PRIMARY KEY (bill_id, product_id)  -- explicit pk
);
```

#### many-to-one

```sql
just references
```

#### one-to-one

```sql
primary key references
```

#### pattern-directory
    для финитных типов данных которые будут изменяться создаем отдельную таблицу

#### create-with-drop

```sql
drop table ... if exists;
create table ...(...);
```

#### foreign-key

```sql
foreign key (s_id, d_id) references Supervision(s_id, t_id)
ссылаться надо на ключ
```

#### commons

```sql
ограничивать все по максимуму
не делать serial во внешнем ключе
```

### Queries & Optimizing

#### join

```sql
[join type] on ... using ...
inner join on - берем декартово и оставляем по знач
natural join - автоподбор по одноименным столбцам
cross join - декартово
LEFT OUTER JOIN - inner + заполняем null-нулями для каждой строчки из 1 без подход во 2ой
RIGHT OUTER JOIN
FULL OUTER JOIN - left + right
```

#### agr funcs & windows

```sql
COUNT(DISTINCT ...) / MIN / MAX / AVG
SUM(...) OVER (PARTITION BY ... ORDER BY desc) AS ... -- partition - разделение на группы, функции - row_number(), rank(), dense_rank(), percent_rank(), last/first,nth_value
```

#### syntax

```sql
[WITH with_queries] SELECT select_list FROM table_expression [sort_specification]
WHERE ... IN / NOT IN / IS / IS NOT / NULL / BETWEEN / EXISTS (table) === if table not empty
Planet p - synonum
GroupBy [key] Having ... (тут идет выражение, можно даже с агр функциями)
(SELECT ...) AS cnt
ORDER BY [ASC | DESC] [NULLS {FIRST | LAST}] -- asc, desc, nulls для каждой колонки сортировки отдельно
LIMIT num, OFFSET num
ON .. OR .. AND ...
WITH z1 AS (...), z2 AS (...) ... SELECT
CASE WHEN ... THEN ... ELSE ... END
```

#### tips

```sql
вложенные join ы удобнее вложенных запросов
поле из SELECT может быть числовым запросом
можно везде использовать подзапросы, но нежелательно, ибо нечитаемо
COALESCE(NULL, 0) = 0
таблицы не сохраняют промежуточные результаты сортировки
```

#### recursive:

```sql
WITH RECURSIVE func ...
```

#### view:

```sql
CREATE OR REPLACE VIEW PaxPerFlight AS -- forbidden
объявлять окна после: WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);
```