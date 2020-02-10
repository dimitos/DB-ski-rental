/* 
База данных пункта проката горнолыжного оборудования (или любого спортивного) 
*/

DROP DATABASE IF EXISTS ski_rental;
CREATE DATABASE ski_rental;
USE ski_rental;

-- ---------- КАТЕГОРИИ ----------------------------------------------------------------------------------

DROP TABLE IF EXISTS categories_age;   
CREATE TABLE categories_age (
	id SERIAL PRIMARY KEY,    
    age CHAR(3)                               -- возраст (взр, дет)    
) COMMENT 'Категории возраста';               -- учитывать в складких позициях

DROP TABLE IF EXISTS categories_gender;   
CREATE TABLE categories_gender (
	id SERIAL PRIMARY KEY,    
    gender CHAR(3)                            -- пол (муж, жен, уни)    
) COMMENT 'Категории пола';                   -- учитывать в профайле сотрудников или клиентов, и в складких позициях

DROP TABLE IF EXISTS prof_categories;   
CREATE TABLE prof_categories (
	id SERIAL PRIMARY KEY,    
    prof_level VARCHAR(50)                     -- УРОВЕНЬ: Junior - дет, Comfort - нач < 90кг, Premium - нач > 90кг, Race - профи подготовленные трассы, Extreme - фрирайд  
) COMMENT 'Уровень профессионализма';          -- учитывать в складких позициях, влияет на цену

DROP TABLE IF EXISTS sport_categories;   
CREATE TABLE sport_categories (
	id SERIAL PRIMARY KEY,    
    sport VARCHAR(100)                         -- СПОРТ: горные лыжи, сноуборд, беговые лыжи, санки, тюбинг, коньки и др.  
) COMMENT 'Виды спорта';          -- учитывать в складких позициях

-- таблица размеров можно сделать отдельно

-- ---------- ЛЮДИ --------------------------------------------------------------------------------------

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	id SERIAL PRIMARY KEY,                    -- id сотрудника
    lastname VARCHAR(100),                    -- Фамилия
	firstname VARCHAR(100),                   -- Имя 
    patronymic VARCHAR(100),                  -- Отчество 	
    login VARCHAR(100),                       -- Логин
	password_hash VARCHAR(255)                -- Пароль    
) COMMENT 'Сотрудники';

DROP TABLE IF EXISTS profiles_employees;
CREATE TABLE profiles_employees (
	profiles_employees_id SERIAL PRIMARY KEY,    
    birthday DATE,                            -- дата рождения
    gender BIGINT UNSIGNED NOT NULL,          -- пол
    email VARCHAR(100) UNIQUE,                -- email уникальный 
    phone VARCHAR(100),                       -- телефон
    hometown VARCHAR(100),                    -- город проживания
    homestreet VARCHAR(100),                  -- улица проживания
    homehouse VARCHAR(100),                   -- дом проживания
    homeapartment VARCHAR(100),               -- квартира проживания    
    position VARCHAR(100),                    -- должность сотрудника
    created_at DATETIME DEFAULT NOW(),        -- дата приема на работу 
    deleted_at DATETIME DEFAULT NULL,         -- дата увольнения 
        
    FOREIGN KEY (profiles_employees_id) REFERENCES employees(id),
	FOREIGN KEY (gender) REFERENCES categories_gender(id)
) COMMENT 'Профайлы сотрудников';

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
	id SERIAL PRIMARY KEY,                    -- id клиента
    lastname VARCHAR(100),                    -- Фамилия
	firstname VARCHAR(100),                   -- Имя 
    patronymic VARCHAR(100)                   -- Отчество 	
) COMMENT 'Клиенты';

DROP TABLE IF EXISTS profiles_clients;
CREATE TABLE profiles_clients (
	profiles_clients_id SERIAL PRIMARY KEY,    
    birthday DATE,                            -- дата рождения
    gender BIGINT UNSIGNED NOT NULL,          -- пол
    email VARCHAR(100) UNIQUE,                -- email уникальный 
    phone VARCHAR(100),                       -- телефон
    hometown VARCHAR(100),                    -- город прописки
    homestreet VARCHAR(100),                  -- улица прописки
    homehouse VARCHAR(100),                   -- дом прописки
    homeapartment VARCHAR(100),               -- квартира прописки
    
    FOREIGN KEY (profiles_clients_id) REFERENCES clients(id),
	FOREIGN KEY (gender) REFERENCES categories_gender(id)
) COMMENT 'Профайлы клиентов';


-- ---------- СКЛАД --------------------------------------------------------------------------------------

-- горные лыжи, горнолыжные палки, горнолыжные ботинки, горнолыжный шлем, сноуборд, ботинки для сноуборда, 
   -- горнолыжные очки, рюкзак, перчатки, куртки, брюки, комбинезон, толстовки 
   
DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,    
    `name` VARCHAR(255),                      -- наименование оборудования
    sport_id BIGINT UNSIGNED NOT NULL,        -- категории оборудования вид спорта  ссылка
    prof_id BIGINT UNSIGNED NOT NULL,         -- категория оборудования профи   ссылка
    gender_id BIGINT UNSIGNED NOT NULL,       -- пол   ссылка
    age_id BIGINT UNSIGNED NOT NULL,          -- возраст  ссылка
    size VARCHAR(10),                         -- размер (42, XXL, рост 185 и т.д.)
    price INT UNSIGNED NOT NULL,              -- прайс (цена проката за один день)    
    photo VARCHAR(255),                       -- относительный путь к файлу в файлохранилище  
    status_id SET('+', '-'),                  -- статус есть-"+" на руках"-"
    
    FOREIGN KEY (sport_id) REFERENCES sport_categories(id),
	FOREIGN KEY (gender_id) REFERENCES categories_gender(id),
    FOREIGN KEY (age_id) REFERENCES categories_age(id)    
) COMMENT 'Товары';

DROP TABLE IF EXISTS card_product;
CREATE TABLE card_product (
	card_product_id SERIAL PRIMARY KEY, 
    date_issue DATETIME,                      -- дата выдачи
    return_date DATETIME DEFAULT NULL,        -- дата возврата 
    count_rental_day INT UNSIGNED,            -- количество дней проката  
    
    FOREIGN KEY (card_product_id) REFERENCES products(id) 
) COMMENT 'карточка товара'; 
   
-- ---------- ЗАКАЗ --------------------------------------------------------------------------------------

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY, 
    data_open DATETIME,
    data_close DATETIME,    
    client_id BIGINT UNSIGNED NOT NULL,
    identity_document VARCHAR(50),            -- документ удостоверяющий личность    
    pledge INT DEFAULT NULL,                  -- сумма залога 
    deposit INT UNSIGNED NOT NULL             -- сумма депозита           
) COMMENT 'Заказы';

DROP TABLE IF EXISTS order_card;
CREATE TABLE order_card (
	card_id SERIAL PRIMARY KEY, 
    product_id BIGINT UNSIGNED NOT NULL,        -- выбранное оборудование    
	
    FOREIGN KEY	(card_id) REFERENCES orders(id),
    FOREIGN KEY	(product_id) REFERENCES products(id)        
) COMMENT 'Карточка заказа, что выбрал клиент';


   

   



