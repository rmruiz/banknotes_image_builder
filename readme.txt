Instrucciones

0. primera ejecución? -> configura tu mac siguiente las instrucciones en config.txt

1. copiar imagenes (jpg) en _step1
las imagenes, al ser ordenadas alfabeticamente deben quedar en pares front/back por billete
Ejemplo: cp _jpg_examples/* _step1/

2. ejecutar el paso 1; esto crea carpetas nuevas y agrega las imagenes de a pares (las mueve a _step2)
cd _step1
./run_step1.sh

3. manualmente renombrar carpetas en _step2, debe usar formato:
PAIS_CIFRA.Moneda_AÑO
Ejemplo: "ALEMANIA_1000.Marcos_1922"

4. verificar si faltan banderas
cd _step2
./check_flags.sh

5. ejecutar el paso 2; esto renombra las imagenes igual que su carpeta (y las mueve a _step3)
cd _step2
./run_step2.sh

6. ejecuta script de creacion de imagenes
cd _step3
./run_step3.sh

las imagenes quedan generadas en ../_FULL e ../_INSTAGRAM

