# Normalización de la Base de Datos de Torneos de Ciclismo

## Dependencias Funcionales (DFs)
1. `cod_torneo → nombre_torneo`
2. `cod_torneo, cod_corredor → nyap_corredor`
3. `cod_torneo, cod_corredor → cod_bicicleta`
4. `cod_bicicleta → marca_bicicleta`
5. `sponsor → DNI_presidente_sponsor, DNI_medico`
6. `cod_torneo, cod_corredor, sponsor → DNI_presidente_sponsor, DNI_medico`

## Claves Candidatas
1. Para la tabla principal: `(cod_torneo, cod_corredor, cod_bicicleta, sponsor)`
2. Para sponsors: `sponsor`

## Clave Primaria
- Elegimos `(cod_torneo, cod_corredor, cod_bicicleta, sponsor)` como clave primaria en la tabla principal porque es única y representa la estructura jerárquica del modelo.
- Para la tabla de sponsors, usamos `sponsor` como clave primaria.

## Proceso de Normalización
### Primera Forma Normal (1FN)
La tabla inicial cumple con 1FN porque no contiene valores multivaluados ni repetidos.

### Segunda Forma Normal (2FN)
Se eliminaron dependencias parciales:
- `TORNEO(cod_torneo, nombre_torneo)`
- `CORREDOR(cod_torneo, cod_corredor, nyap_corredor)`
- `BICICLETA(cod_bicicleta, marca_bicicleta)`
- `SPONSOR(sponsor, DNI_presidente_sponsor, DNI_medico)`
- `ASIGNACION(cod_torneo, cod_corredor, cod_bicicleta, sponsor)`

### Tercera Forma Normal (3FN)
Se eliminaron dependencias transitivas:
- Las dependencias transitivas ya fueron eliminadas en la descomposición de 2FN.

## Esquema Final
1. `TORNEO(cod_torneo, nombre_torneo)`
2. `CORREDOR(cod_torneo, cod_corredor, nyap_corredor)`
3. `BICICLETA(cod_bicicleta, marca_bicicleta)`
4. `SPONSOR(sponsor, DNI_presidente_sponsor, DNI_medico)`
5. `ASIGNACION(cod_torneo, cod_corredor, cod_bicicleta, sponsor)`

## Diagrama de Tablas
El diagrama de la base de datos fue adjuntado como archivo `.dbml`.
