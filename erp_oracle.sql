CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

CREATE TABLE IF NOT EXISTS `mydb`.`employees` (
  `id_employee` INT(4) NOT NULL,
  `position` NVARCHAR(150) NOT NULL,
  `employment_date` DATE NOT NULL,
  `end_cooperation_data` DATE NOT NULL,
  PRIMARY KEY (`id_employee`));

CREATE TABLE IF NOT EXISTS `mydb`.`measure_units` (
  `id_measure_unit` INT(6) NOT NULL,
  `measure_unit_long_name` NVARCHAR(20) NOT NULL,
  `measure_unit_name` NVARCHAR(5) NOT NULL,
  PRIMARY KEY (`id_measure_unit`),
  UNIQUE INDEX `measure_units__un` (`measure_unit_long_name` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `mydb`.`categories` (
  `id_category` INT(6) NOT NULL,
  `category_name` NVARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id_category`),
  UNIQUE INDEX `categories__un` (`category_name` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `mydb`.`sub_categories` (
  `id_subcategory` INT(7) NOT NULL,
  `id_category` INT(6) NOT NULL,
  `subcategory_name` NVARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id_subcategory`),
  INDEX `sub_categories_categories_fk` (`id_category` ASC) VISIBLE,
  CONSTRAINT `sub_categories_categories_fk`
    FOREIGN KEY (`id_category`)
    REFERENCES `mydb`.`categories` (`id_category`));

CREATE TABLE IF NOT EXISTS `mydb`.`products` (
  `id_product` INT(7) NOT NULL,
  `id_subcategory` INT(7) NOT NULL,
  `product_name` NVARCHAR(60) NOT NULL,
  `availability` INT(6) NOT NULL,
  `introduction_date` DATE NULL DEFAULT NULL,
  `withdraw_date` DATE NULL DEFAULT NULL,
  `dimensions` NVARCHAR(20) NULL DEFAULT NULL,
  `id_measure_unit` INT(6) NOT NULL,
  `description` NVARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`id_product`),
  INDEX `products_measure_units_fk` (`id_measure_unit` ASC) VISIBLE,
  INDEX `products_sub_categories_fk` (`id_subcategory` ASC) VISIBLE,
  CONSTRAINT `products_measure_units_fk`
    FOREIGN KEY (`id_measure_unit`)
    REFERENCES `mydb`.`measure_units` (`id_measure_unit`),
  CONSTRAINT `products_sub_categories_fk`
    FOREIGN KEY (`id_subcategory`)
    REFERENCES `mydb`.`sub_categories` (`id_subcategory`));

CREATE TABLE IF NOT EXISTS `mydb`.`projects` (
  `id_project` INT(6) NOT NULL,
  `id_employee` INT(4) NOT NULL,
  `project_name` NVARCHAR(60) NOT NULL,
  `project_date` DATE NOT NULL,
  `recomended_exploatation_time` NVARCHAR(200) NULL DEFAULT NULL,
  `id_product` INT(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id_project`),
  INDEX `projects_employees_fk` (`id_employee` ASC) VISIBLE,
  INDEX `projects_products_fk` (`id_product` ASC) VISIBLE,
  CONSTRAINT `projects_employees_fk`
    FOREIGN KEY (`id_employee`)
    REFERENCES `mydb`.`employees` (`id_employee`),
  CONSTRAINT `projects_products_fk`
    FOREIGN KEY (`id_product`)
    REFERENCES `mydb`.`products` (`id_product`));

CREATE TABLE IF NOT EXISTS `mydb`.`attached_project_files` (
  `id_url` INT(8) NOT NULL,
  `id_project` INT(6) NOT NULL,
  `outter_link` NVARCHAR(1000) NOT NULL,
  PRIMARY KEY (`id_url`),
  INDEX `attached_project_files_projects_fk` (`id_project` ASC) VISIBLE,
  CONSTRAINT `attached_project_files_projects_fk`
    FOREIGN KEY (`id_project`)
    REFERENCES `mydb`.`projects` (`id_project`));

CREATE TABLE IF NOT EXISTS `mydb`.`clients` (
  `id_client` INT(6) NOT NULL,
  `account_creation_date` DATE NOT NULL,
  `login` NVARCHAR(15) NOT NULL,
  `password` NVARCHAR(15) NOT NULL,
  PRIMARY KEY (`id_client`),
  UNIQUE INDEX `clients__un` (`login` ASC) VISIBLE);

CREATE TABLE IF NOT EXISTS `mydb`.`countries` (
  `id_country` INT(8) NOT NULL,
  `country_name` VARCHAR(100) NULL,
  PRIMARY KEY (`id_country`),
  UNIQUE INDEX `country_name_UNIQUE` (`country_name` ASC) VISIBLE,
  UNIQUE INDEX `id_country_UNIQUE` (`id_country` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`cities` (
  `id_city` INT(9) NOT NULL,
  `city_name` VARCHAR(45) NOT NULL,
  `id_country` INT(8) NOT NULL,
  PRIMARY KEY (`id_city`),
  UNIQUE INDEX `id_city_UNIQUE` (`id_city` ASC) VISIBLE,
  INDEX `cities_countries_fk_idx` (`id_country` ASC) VISIBLE,
  CONSTRAINT `cities_countries_fk`
    FOREIGN KEY (`id_country`)
    REFERENCES `mydb`.`countries` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`clients_addreses` (
  `id_client` INT(6) NOT NULL,
  `id_address` INT(7) NOT NULL,
  `street` NVARCHAR(25) NOT NULL,
  `building` NVARCHAR(12) NULL DEFAULT NULL,
  `id_city` INT(9) NOT NULL,
  PRIMARY KEY (`id_address`),
  INDEX `clients_addreses_clients_fk` (`id_client` ASC) VISIBLE,
  INDEX `clients_addresses_cities_fk_idx` (`id_city` ASC) VISIBLE,
  CONSTRAINT `clients_addreses_clients_fk`
    FOREIGN KEY (`id_client`)
    REFERENCES `mydb`.`clients` (`id_client`),
  CONSTRAINT `clients_addresses_cities_fk`
    FOREIGN KEY (`id_city`)
    REFERENCES `mydb`.`cities` (`id_city`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS `mydb`.`clients_personal_data` (
  `id_client` INT(6) NOT NULL,
  `name` NVARCHAR(15) NULL DEFAULT NULL,
  `last_name` NVARCHAR(25) NULL DEFAULT NULL,
  `birth_data` DATE NULL DEFAULT NULL,
  `email` NVARCHAR(25) NOT NULL,
  `telephone_number` NVARCHAR(12) NULL DEFAULT NULL,
  UNIQUE INDEX `clients_personal_data__un` (`email` ASC) VISIBLE,
  UNIQUE INDEX `clients_personal_data__unv1` (`telephone_number` ASC) VISIBLE,
  INDEX `clients_personal_data_clients_fk` (`id_client` ASC) VISIBLE,
  CONSTRAINT `clients_personal_data_clients_fk`
    FOREIGN KEY (`id_client`)
    REFERENCES `mydb`.`clients` (`id_client`));

CREATE TABLE IF NOT EXISTS `mydb`.`employees_personal_data` (
  `id_employee` INT(4) NOT NULL,
  `name` NVARCHAR(15) NULL DEFAULT NULL,
  `last_name` NVARCHAR(25) NULL DEFAULT NULL,
  `birth_data` DATE NULL DEFAULT NULL,
  `email` NVARCHAR(25) NULL DEFAULT NULL,
  `telephone_number` NVARCHAR(12) NULL DEFAULT NULL,
  `personal_identity_number` NVARCHAR(22) NULL DEFAULT NULL,
  UNIQUE INDEX `employees_personal_data__un` (`personal_identity_number` ASC) VISIBLE,
  INDEX `clients_personal_datav1_employees_fk` (`id_employee` ASC) VISIBLE,
  CONSTRAINT `clients_personal_datav1_employees_fk`
    FOREIGN KEY (`id_employee`)
    REFERENCES `mydb`.`employees` (`id_employee`));

CREATE TABLE IF NOT EXISTS `mydb`.`feedback` (
  `id_client` INT(6) NOT NULL,
  `description` NVARCHAR(1000) NULL DEFAULT NULL,
  `rate` INT(1) NULL DEFAULT NULL,
  `rate_date` DATE NULL DEFAULT NULL,
  `id_product` INT(7) NOT NULL,
  INDEX `feedback_clients_fk` (`id_client` ASC) VISIBLE,
  INDEX `feedback_products_fk` (`id_product` ASC) VISIBLE,
  CONSTRAINT `feedback_clients_fk`
    FOREIGN KEY (`id_client`)
    REFERENCES `mydb`.`clients` (`id_client`),
  CONSTRAINT `feedback_products_fk`
    FOREIGN KEY (`id_product`)
    REFERENCES `mydb`.`products` (`id_product`));



CREATE TABLE IF NOT EXISTS `mydb`.`files_needed_in_production` (
  `id_project` INT(6) NOT NULL,
  `id_url` INT(8) NOT NULL,
  INDEX `files_needed_in_production_attached_project_files_fk` (`id_project` ASC) VISIBLE,
  CONSTRAINT `files_needed_in_production_attached_project_files_fk`
    FOREIGN KEY (`id_project`)
    REFERENCES `mydb`.`attached_project_files` (`id_url`));



CREATE TABLE IF NOT EXISTS `mydb`.`production_harmonograms` (
  `id_harmonogram` INT(3) NOT NULL,
  `harmonogram_introduction_date` DATE NOT NULL,
  `harmonogram_release_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id_harmonogram`));



CREATE TABLE IF NOT EXISTS `mydb`.`harmonogrm_content` (
  `id_harmonogram` INT(3) NOT NULL,
  `id_project` INT(6) NOT NULL,
  `amount` INT(9) NOT NULL,
  INDEX `harmonogrm_content_production_harmonograms_fk` (`id_harmonogram` ASC) VISIBLE,
  INDEX `harmonogrm_content_projects_fk` (`id_project` ASC) VISIBLE,
  CONSTRAINT `harmonogrm_content_production_harmonograms_fk`
    FOREIGN KEY (`id_harmonogram`)
    REFERENCES `mydb`.`production_harmonograms` (`id_harmonogram`),
  CONSTRAINT `harmonogrm_content_projects_fk`
    FOREIGN KEY (`id_project`)
    REFERENCES `mydb`.`projects` (`id_project`));


CREATE TABLE IF NOT EXISTS `mydb`.`currencies` (
  `id_currency` INT(3) NOT NULL,
  `currency_name` VARCHAR(4) NOT NULL,
  `currency_long_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_currency`),
  UNIQUE INDEX `id_currency_UNIQUE` (`id_currency` ASC) VISIBLE,
  UNIQUE INDEX `currency_name_UNIQUE` (`currency_name` ASC) VISIBLE,
  UNIQUE INDEX `currency_long_name_UNIQUE` (`currency_long_name` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `mydb`.`magazine_orders` (
  `id_order` INT(7) NOT NULL,
  `id_employee` INT(4) NOT NULL,
  `order_date` DATE NOT NULL,
  `payment_date` DATE NULL DEFAULT NULL,
  `delivery_date` DATE NULL DEFAULT NULL,
  `amount_to_pay` DECIMAL(6,2) NOT NULL,
  `order_value` DECIMAL(6,2) NOT NULL,
  `delivery_cost` DECIMAL(6,2) NULL DEFAULT NULL,
  `total_amount_of_discounts` DECIMAL(6,2) NULL DEFAULT NULL,
  `id_currency` INT(3) NOT NULL,
  `id_delivery_method` INT(6) NOT NULL,
  `id_payment_method` INT(6) NOT NULL,
  `order_status` NVARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_order`),
  INDEX `magazine_orders_employees_fk` (`id_employee` ASC) VISIBLE,
  INDEX `magazine_orders_currencies_idx` (`id_currency` ASC) VISIBLE,
  CONSTRAINT `magazine_orders_employees_fk`
    FOREIGN KEY (`id_employee`)
    REFERENCES `mydb`.`employees` (`id_employee`),
  CONSTRAINT `magazine_orders_currencies`
    FOREIGN KEY (`id_currency`)
    REFERENCES `mydb`.`currencies` (`id_currency`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `mydb`.`materials_magazine` (
  `id_material` INT(8) NOT NULL,
  `material_name` NVARCHAR(30) NOT NULL,
  `availability` INT(6) NULL DEFAULT NULL,
  `id_measure_unit` INT(6) NOT NULL,
  `dimentions` NVARCHAR(1) NULL DEFAULT NULL,
  `description` NVARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`id_material`),
  UNIQUE INDEX `materials_magazine__un` (`material_name` ASC) VISIBLE,
  INDEX `materials_magazine_measure_units_fk` (`id_measure_unit` ASC) VISIBLE,
  CONSTRAINT `materials_magazine_measure_units_fk`
    FOREIGN KEY (`id_measure_unit`)
    REFERENCES `mydb`.`measure_units` (`id_measure_unit`));


CREATE TABLE IF NOT EXISTS `mydb`.`ordered_materials` (
  `id_order` INT(7) NOT NULL,
  `id_material` INT(8) NOT NULL,
  `amount` FLOAT(6) NOT NULL,
  `procent_of_discount_netto` FLOAT(2) NOT NULL,
  `amount_of_discount` FLOAT(6) NOT NULL,
  `price_netto_after_discount` FLOAT(6) NOT NULL,
  `procent_of_vat` FLOAT(2) NOT NULL,
  `netto_amount` FLOAT(6) NOT NULL,
  `vat_amount` FLOAT(6) NOT NULL,
  `brutto_amount` FLOAT(6) NOT NULL,
  `id_currency` INT(3) NOT NULL,
  INDEX `ordered_materials_magazine_orders_fk` (`id_order` ASC) VISIBLE,
  INDEX `ordered_materials_currencies_fk_idx` (`id_currency` ASC) VISIBLE,
  CONSTRAINT `ordered_materials_magazine_orders_fk`
    FOREIGN KEY (`id_order`)
    REFERENCES `mydb`.`magazine_orders` (`id_order`),
  CONSTRAINT `ordered_materials_currencies_fk`
    FOREIGN KEY (`id_currency`)
    REFERENCES `mydb`.`currencies` (`id_currency`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `mydb`.`orders` (
  `id_order` INT(7) NOT NULL,
  `id_client` INT(6) NOT NULL,
  `order_date` DATE NOT NULL,
  `payment_date` DATE NULL DEFAULT NULL,
  `shipment_date` DATE NULL DEFAULT NULL,
  `amount_to_pay` DECIMAL(6,2) NOT NULL,
  `order_value` DECIMAL(6,2) NOT NULL,
  `delivery_cost` DECIMAL(6,2) NULL DEFAULT NULL,
  `total_amount_of_discounts` DECIMAL(6,2) NULL DEFAULT NULL,
  `id_currency` INT(3) NOT NULL,
  `id_delivery_address` INT(7) NOT NULL,
  `id_delivery_method` INT(6) NOT NULL,
  `id_payment_method` INT(6) NOT NULL,
  `order_status` NVARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_order`),
  INDEX `orders_clients_addreses_fk` (`id_delivery_address` ASC) VISIBLE,
  INDEX `orders_clients_fk` (`id_client` ASC) VISIBLE,
  INDEX `orders_currecies_fk_idx` (`id_currency` ASC) VISIBLE,
  CONSTRAINT `orders_clients_addreses_fk`
    FOREIGN KEY (`id_delivery_address`)
    REFERENCES `mydb`.`clients_addreses` (`id_address`),
  CONSTRAINT `orders_clients_fk`
    FOREIGN KEY (`id_client`)
    REFERENCES `mydb`.`clients` (`id_client`),
  CONSTRAINT `orders_currecies_fk`
    FOREIGN KEY (`id_currency`)
    REFERENCES `mydb`.`currencies` (`id_currency`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE IF NOT EXISTS `mydb`.`ordered_products` (
  `id_order` INT(7) NOT NULL,
  `id_product` INT(7) NOT NULL,
  `amount` DECIMAL(6,2) NOT NULL,
  `procent_of_discount_netto` DECIMAL(2,2) NOT NULL,
  `amount_of_discount` DECIMAL(6,2) NOT NULL,
  `price_netto_after_discount` DECIMAL(6,2) NOT NULL,
  `procent_of_vat` DECIMAL(2,2) NOT NULL,
  `netto_amount` DECIMAL(6,2) NOT NULL,
  `vat_amount` DECIMAL(6,2) NOT NULL,
  `brutto_amount` DECIMAL(6,2) NOT NULL,
  INDEX `ordered_products_orders_fk` (`id_order` ASC) VISIBLE,
  INDEX `ordered_products_products_fk` (`id_product` ASC) VISIBLE,
  CONSTRAINT `ordered_products_orders_fk`
    FOREIGN KEY (`id_order`)
    REFERENCES `mydb`.`orders` (`id_order`),
  CONSTRAINT `ordered_products_products_fk`
    FOREIGN KEY (`id_product`)
    REFERENCES `mydb`.`products` (`id_product`));


CREATE TABLE IF NOT EXISTS `mydb`.`price_lists` (
  `id_price_list` INT(8) NOT NULL,
  `price_list_introduction` DATE NOT NULL,
  `price_list_withdraw` DATE NULL DEFAULT NULL,
  `price_list_status` NVARCHAR(25) NOT NULL,
  PRIMARY KEY (`id_price_list`));


CREATE TABLE IF NOT EXISTS `mydb`.`prices` (
  `id_price_list` INT(8) NOT NULL,
  `id_product` INT(7) NOT NULL,
  `netto_price` DECIMAL(6,2) NOT NULL,
  INDEX `prices_price_lists_fk` (`id_price_list` ASC) VISIBLE,
  INDEX `prices_products_fk` (`id_product` ASC) VISIBLE,
  CONSTRAINT `prices_price_lists_fk`
    FOREIGN KEY (`id_price_list`)
    REFERENCES `mydb`.`price_lists` (`id_price_list`),
  CONSTRAINT `prices_products_fk`
    FOREIGN KEY (`id_product`)
    REFERENCES `mydb`.`products` (`id_product`));


CREATE TABLE IF NOT EXISTS `mydb`.`production_tools` (
  `id_tool` INT(5) NOT NULL,
  `tool_name` NVARCHAR(100) NULL DEFAULT NULL,
  `tool_amount` INT(3) NULL DEFAULT NULL,
  `last_maintenance` DATE NULL DEFAULT NULL,
  `description` NVARCHAR(2000) NULL DEFAULT NULL,
  PRIMARY KEY (`id_tool`));


CREATE TABLE IF NOT EXISTS `mydb`.`project_materials` (
  `id_material` INT(8) NOT NULL,
  `id_project` INT(6) NOT NULL,
  `material_amount` FLOAT(6) NULL DEFAULT NULL,
  INDEX `project_materials_materials_magazine_fk` (`id_material` ASC) VISIBLE,
  INDEX `project_materials_projects_fk` (`id_project` ASC) VISIBLE,
  CONSTRAINT `project_materials_materials_magazine_fk`
    FOREIGN KEY (`id_material`)
    REFERENCES `mydb`.`materials_magazine` (`id_material`),
  CONSTRAINT `project_materials_projects_fk`
    FOREIGN KEY (`id_project`)
    REFERENCES `mydb`.`projects` (`id_project`));


CREATE TABLE IF NOT EXISTS `mydb`.`project_tools` (
  `id_tool` INT(5) NOT NULL,
  `id_project` INT(6) NOT NULL,
  INDEX `project_tools_production_tools_fk` (`id_tool` ASC) VISIBLE,
  INDEX `project_tools_projects_fk` (`id_project` ASC) VISIBLE,
  CONSTRAINT `project_tools_production_tools_fk`
    FOREIGN KEY (`id_tool`)
    REFERENCES `mydb`.`production_tools` (`id_tool`),
  CONSTRAINT `project_tools_projects_fk`
    FOREIGN KEY (`id_project`)
    REFERENCES `mydb`.`projects` (`id_project`));


CREATE TABLE IF NOT EXISTS `mydb`.`countries_currencies` (
  `id_currency` INT(3) NOT NULL,
  `id_country` INT(8) NOT NULL,
  INDEX `country_currencies_counties_fk_idx` (`id_country` ASC) VISIBLE,
  INDEX `country_currencies_currencies_fk_idx` (`id_currency` ASC) VISIBLE,
  CONSTRAINT `country_currencies_counties_fk`
    FOREIGN KEY (`id_country`)
    REFERENCES `mydb`.`countries` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `country_currencies_currencies_fk`
    FOREIGN KEY (`id_currency`)
    REFERENCES `mydb`.`currencies` (`id_currency`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`employees` (`id_employee`, `position`, `employment_date`, `end_cooperation_data`) VALUES (1, 'manager', '19.05.1998', '11.03.2020');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`measure_units` (`id_measure_unit`, `measure_unit_long_name`, `measure_unit_name`) VALUES (1, 'sztuki', 'szt.');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`categories` (`id_category`, `category_name`) VALUES (1, 'sport');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`sub_categories` (`id_subcategory`, `id_category`, `subcategory_name`) VALUES (1, 1, 'buty');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`products` (`id_product`, `id_subcategory`, `product_name`, `availability`, `introduction_date`, `withdraw_date`, `dimensions`, `id_measure_unit`, `description`) VALUES (1, 1, 'buty', 100, '10.02.2020', '10.03.2020', '10x8', 1, NULL);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`projects` (`id_project`, `id_employee`, `project_name`, `project_date`, `recomended_exploatation_time`, `id_product`) VALUES (1, 1, 'SBKDSBKJ', '02.04.2020', 'AAAAAAAAA', 1);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`attached_project_files` (`id_url`, `id_project`, `outter_link`) VALUES (1, 1, 'projekty/projekt1.txt');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`clients` (`id_client`, `account_creation_date`, `login`, `password`) VALUES (1, '12.07.2019', 'fajnytypek19', 'jakistamhasz');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`countries` (`id_country`, `country_name`) VALUES (1, 'Cebulandia');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`cities` (`id_city`, `city_name`, `id_country`) VALUES (1, 'Włodawa', 1);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`clients_addreses` (`id_client`, `id_address`, `street`, `building`, `id_city`) VALUES (1, 1, 'Woronicza', '17', 1);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`employees_personal_data` (`id_employee`, `name`, `last_name`, `birth_data`, `email`, `telephone_number`, `personal_identity_number`) VALUES (1, 'Maciej', 'Jurczuk', '19.05.1998', 'jurczuk.maciej.jan@gmail.pl', '794407678', '1111111111');
INSERT INTO `mydb`.`employees_personal_data` (`id_employee`, `name`, `last_name`, `birth_data`, `email`, `telephone_number`, `personal_identity_number`) VALUES (2, 'Bartosz', 'Kopciuch', '22.06.1998', 'bartekkopciuch@gmail.com', '535095926', '0');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`feedback` (`id_client`, `description`, `rate`, `rate_date`, `id_product`) VALUES (1, 'fajnym produkty macie', 2, '19.11.2020', 1);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`production_harmonograms` (`id_harmonogram`, `harmonogram_introduction_date`, `harmonogram_release_date`) VALUES (1, '20.04.2020', '21.05.2020');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`harmonogrm_content` (`id_harmonogram`, `id_project`, `amount`) VALUES (1, 1, 9001);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`currencies` (`id_currency`, `currency_name`, `currency_long_name`) VALUES (1, 'ceb', 'cebuliony');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`magazine_orders` (`id_order`, `id_employee`, `order_date`, `payment_date`, `delivery_date`, `amount_to_pay`, `order_value`, `delivery_cost`, `total_amount_of_discounts`, `id_currency`, `id_delivery_method`, `id_payment_method`, `order_status`) VALUES (1, 2, '17.09.2020', '16.08.2020', '14.09.1988', 14,00, 15,09, 14, 53,32, 1, 1, 1, 'jade');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`materials_magazine` (`id_material`, `material_name`, `availability`, `id_measure_unit`, `dimentions`, `description`) VALUES (1, 'skóra', 40, 1, NULL, NULL);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`ordered_materials` (`id_order`, `id_material`, `amount`, `procent_of_discount_netto`, `amount_of_discount`, `price_netto_after_discount`, `procent_of_vat`, `netto_amount`, `vat_amount`, `brutto_amount`, `id_currency`) VALUES (1, 1, 10, 20, 50, 80, 10, 120, 23, 21, 1);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`orders` (`id_order`, `id_client`, `order_date`, `payment_date`, `shipment_date`, `amount_to_pay`, `order_value`, `delivery_cost`, `total_amount_of_discounts`, `id_currency`, `id_delivery_address`, `id_delivery_method`, `id_payment_method`, `order_status`) VALUES (1, 1, '20.12.2020', '22.12.2020', '20.12.2020', 13,50, 14, 15, 50, 1, 1, 1, 1, 'idziemy');

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`ordered_products` (`id_order`, `id_product`, `amount`, `procent_of_discount_netto`, `amount_of_discount`, `price_netto_after_discount`, `procent_of_vat`, `netto_amount`, `vat_amount`, `brutto_amount`) VALUES (1, 1, 70, 30, 20.45678, 45.35356, 30, 78.456, 23.127, DEFAULT);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`price_lists` (`id_price_list`, `price_list_introduction`, `price_list_withdraw`, `price_list_status`) VALUES (1, '03.03..2020', '04.04.2020', DEFAULT);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`prices` (`id_price_list`, `id_product`, `netto_price`) VALUES (1, 1, 20,50);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`production_tools` (`id_tool`, `tool_name`, `tool_amount`, `last_maintenance`, `description`) VALUES (1, 'frezarka', 3, '10.02.2020', NULL);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`project_materials` (`id_material`, `id_project`, `material_amount`) VALUES (1, 1, 20.5);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`project_tools` (`id_tool`, `id_project`) VALUES (1, 1);

COMMIT;


START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`countries_currencies` (`id_currency`, `id_country`) VALUES (1, 1);

COMMIT;

