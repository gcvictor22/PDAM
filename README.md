<p align="center">
  <a href="https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html"><img src="https://img.shields.io/badge/jdk-v17.0.4.1-blue" alt="Versión java" /></a>
  <a href="https://maven.apache.org/download.cgi"><img src="https://img.shields.io/badge/apache--maven-v3.8.6-blue" alt="Versión maven" /></a>
  <a href="https://spring.io/projects/spring-boot"><img src="https://img.shields.io/badge/spring--boot-v2.7.8-green" alt="Versión spring-boot" /></a>
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/dart-v3.0.0-blue" alt="Versión dart" /></a>
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/flutter-3.8.0--13.0.pre.95-blue" alt="Versión flutter" /></a>
  <a href="https://angular.io/"><img src="https://img.shields.io/badge/angular-v14.2-red" alt="Versión angular"></a>
  <a href="https://nodejs.org/es"><img src="https://img.shields.io/badge/node-v16.17.1-yellowgreen" alt="Versión node"></a>
  <a href="https://www.npmjs.com/"><img src="https://img.shields.io/badge/npm-v8.15.0-red" alt="Versión npm"></a>
  <img src="https://img.shields.io/badge/release%20date-february-yellowgreen" alt="Lanzamiento del proyecto" />
  <img src="https://img.shields.io/badge/license-MIT-brightgreen" alt="Licencia" />
</p>

# Proyecto Full Stack - Red Social

Este es un proyecto Full Stack que incluye un backend desarrollado con Java y Spring, una aplicación móvil para el público desarrollada con Flutter, y una aplicación de administración desarrollada con Angular. Tanto la API como la aplicación Angular están dockerizadas para facilitar la implementación. Al ejecutar el comando `docker-compose up -d`, el usuario podrá acceder directamente a los siguientes puertos:

- Puerto 8080: API backend.
- Puerto 4200: Aplicación Angular.
- Puerto 5050: PgAdmin

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