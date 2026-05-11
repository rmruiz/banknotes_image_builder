# Procesador de Imágenes de Billetes

Este proyecto automatiza el procesamiento, etiquetado y generación de composiciones de imágenes para una colección de billetes, optimizando las dimensiones para visualización completa e Instagram.

## Configuración Inicial
Si es la primera vez que utilizas esta herramienta en tu Mac, es necesario preparar el entorno del sistema.
- Revisa el archivo `config.txt`.
- Sigue las instrucciones detalladas allí para instalar las dependencias necesarias.

---

## Flujo de Trabajo

### Paso 1: Preparación de Imágenes
Copia las imágenes originales en formato `.jpg` dentro de la carpeta `_step1`.
- **Importante:** Las imágenes deben estar ordenadas alfabéticamente para que queden en pares correlativos (cara frontal y cara posterior) por cada billete.

**Ejemplo de comando:**
```bash
cp _jpg_examples/* _step1/
```

### Paso 2: Organización Inicial
Ejecuta el script del primer paso. Esto agrupará las imágenes en pares, las moverá a la carpeta _step2 y creará subcarpetas automáticas para cada par.

```bash
cd _step1
./run_step1.sh
```

### Paso 3: Identificación y Metadatos (Manual)
Debes renombrar manualmente las carpetas generadas en _step2 siguiendo un formato estricto para que el sistema procese correctamente la información:

Formato: PAIS_CIFRA.Moneda_AÑO

Ejemplo: ALEMANIA_1000.Marcos_1922

### Paso 4: Verificación de Recursos
Antes de continuar, verifica si el sistema cuenta con las banderas correspondientes para los países indicados en el paso anterior.

```bash
cd ../_step2
./check_flags.sh
```

### Paso 5: Normalización de Archivos
Una vez renombradas las carpetas y verificadas las banderas, ejecuta el segundo script. Esto renombrará las imágenes internas para que coincidan con el nombre de su carpeta contenedora y las moverá a _step3.

```bash
./run_step2.sh
```

### Paso 6: Generación Final
Ejecuta el script final para crear las composiciones de imagen definitivas.

```bash
cd ../_step3
./run_step3.sh
```

## Resultados
Una vez finalizado el proceso, encontrarás las imágenes generadas en las siguientes ubicaciones:

../_FULL: Imágenes en alta resolución con el diseño completo.

../_INSTAGRAM: Imágenes optimizadas y con el formato adecuado para su publicación en Instagram.

