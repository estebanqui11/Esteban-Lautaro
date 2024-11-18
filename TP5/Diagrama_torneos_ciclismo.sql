CREATE TABLE `TORNEO` (
  `cod_torneo` INT PRIMARY KEY,
  `nombre_torneo` VARCHAR
);

CREATE TABLE `CORREDOR` (
  `cod_torneo` INT,
  `cod_corredor` INT,
  `nyap_corredor` VARCHAR,
  `primary` key(cod_torneo,cod_corredor)
);

CREATE TABLE `BICICLETA` (
  `cod_torneo` INT,
  `cod_corredor` INT,
  `cod_bicicleta` INT,
  `marca_bicicleta` VARCHAR,
  `primary` key(cod_torneo,cod_corredor,cod_bicicleta)
);

CREATE TABLE `SPONSOR` (
  `sponsor` VARCHAR PRIMARY KEY,
  `DNI_presidente_sponsor` VARCHAR,
  `DNI_medico` VARCHAR
);

ALTER TABLE `CORREDOR` ADD FOREIGN KEY (`cod_torneo`) REFERENCES `TORNEO` (`cod_torneo`);

ALTER TABLE `BICICLETA` ADD FOREIGN KEY (`cod_torneo`) REFERENCES `TORNEO` (`cod_torneo`);

ALTER TABLE `BICICLETA` ADD FOREIGN KEY (`cod_corredor`) REFERENCES `CORREDOR` (`cod_corredor`);
