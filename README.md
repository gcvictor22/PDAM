# Proyecto Full Stack - Red Social

Este es un proyecto Full Stack que incluye un backend desarrollado con Java y Spring, una aplicación móvil para el público desarrollada con Flutter, y una aplicación de administración desarrollada con Angular. Tanto la API como la aplicación Angular están dockerizadas para facilitar la implementación. Al ejecutar el comando `docker-compose up -d`, el usuario podrá acceder directamente a los siguientes puertos:

- Puerto 8080: API backend.
- Puerto 4200: Aplicación Angular.
- Puerto 5050: Aplicación de administración.

## Pasos de configuración

Sigue estos pasos para configurar y ejecutar el proyecto:

1. Clona el repositorio desde GitHub utilizando el siguiente comando:

```shell
git clone https://github.com/gcvictor22/PDAM.git
```
2. Asegúrate de tener Docker instalado en tu máquina.
3. Navega hasta el directorio clonado del proyecto:

```shell
cd PDAM
```

4. Ejecuta el siguiente comando para iniciar los contenedores de Docker:

```shell
docker-compose up -d
```

5. Una vez que los contenedores estén en funcionamiento, podrás acceder a las siguientes aplicaciones:
    - Aplicación móvil: Emula la aplicación móvil para iOS siguiendo estos pasos:
        - Abre el Terminal y escribe el siguiente comando para cargar el emulador de Xcode:

```shell
open -a Simulator
```

- Cuando el emulador haya cargado, ejecuta el siguiente comando para emular la aplicación Flutter:

```shell
flutter run
```

    - Aplicación de administración: Abre tu navegador y ve a http://localhost:5050 para acceder a la aplicación de administración.


## Funcionalidades de usuario
El proyecto incluye las siguientes funcionalidades para los usuarios:
    - Publicar posts: Los usuarios pueden crear y publicar contenido.
    - Interactuar con posts: Los usuarios pueden dar likes y comentar los posts de otros usuarios.
    - Seguir a otros usuarios: Los usuarios pueden seguir a otros perfiles y recibir actualizaciones de sus posts.
    - Ver perfiles: Los usuarios pueden visitar los perfiles de otros usuarios para ver su información y actividad.

## Funcionalidades de administrador
Además, los administradores tienen las siguientes funcionalidades adicionales:
    - Asignar roles: Los administradores pueden otorgar o revocar permisos de administración a otros usuarios.
    - Crear discotecas o festivales: Los administradores pueden crear nuevos eventos y gestionar su información.