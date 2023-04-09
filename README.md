# Luatiny

Reduce el tamaño de sus archivos Lua mediante la eliminación de los espacios
innecesarios y la compactación del código fuente.

# Descripción

> Este script fue creado con la motivación de optimizar la configuración de
> Neovim, pero puede ser útil para cualquier proyecto hecho en Lua que busque
> reducir su tamaño.

Luatiny es un script de Bash que utiliza la herramienta **Luamin** para minificar
archivos Lua con el fin de reducir su tamaño a través de la eliminación de todos
los comentarios y los espacios en blanco del código fuente, así como el cambio
de los nombres de las variables locales a una forma más abreviada.

## Requisitos

Para utilizar Luatiny, asegúrese de tener [Luamin](https://github.com/mathiasbynens/luamin) instalado:

```bash
npm install Luamin
```

## Instalación

Siga estos pasos para instalar y configurar Luatiny:

1. Clone este repositorio en su máquina local:

```bash
git clone https://github.com/usuario/Luatiny.git
```

2. Ejecute el archivo `wizard.sh` para instalar Luatiny:

```bash
cd Luatiny
./wizard.sh
```

3. Una vez que haya instalado Luatiny, puede ejecutar el script escribiendo el
siguiente comando y especificando un directorio:

```bash
luatiny [DIRECTORIO]
```

4. Siga las instrucciones en pantalla para minificar sus archivos Lua.


## Licencia

Luatiny se encuentra bajo la licencia MIT. Consulte el archivo `LICENSE` para
obtener más información.
