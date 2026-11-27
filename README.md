#  Natural Center + Botica

Aplicación web para la **exhibición y venta virtual de productos de medicina natural** de Natural Center + Botica, con sucursales en **Andalucía** y **Bugalagrande** (Valle del Cauca).

Proyecto final de la asignatura **Desarrollo de Software I** — Facultad de Ingeniería, 2026.

**Equipo:** 
- Arroyave Isabella - 2459623
- Cocoma Tascon Josue David - 2477087
- Montaño Vergara Juan Diego - 2477334
- Palomino Murcia Kevin Santiago - 2477200
- Polania Navarro Juan Manuel- 2477452


---

## Descripción

El negocio atiende en sus locales y a domicilio, pero no tiene un catálogo digital propio: los precios y la disponibilidad se consultan por mensajería. Este prototipo permite que el cliente consulte un catálogo actualizado, vea precio, descuento y existencias por sucursal, y realice pedidos en línea; y que el administrador mantenga el catálogo vigente.

## Funcionalidades

**Cliente**
- Catálogo con búsqueda por nombre y filtro por categoría.
- Detalle del producto: descripción, presentación, precio, descuento y existencias por sucursal.
- Carrito de compras.
- Registro e inicio de sesión.
- Confirmación de pedido (recoger en sucursal o a domicilio) y consulta de "Mis pedidos".

**Administrador**
- Crear y editar productos (precio, descuento, categoría, imagen opcional).
- Gestionar el stock de cada sucursal.
- "Eliminar" oculta el producto del catálogo sin borrar el historial de pedidos; se puede reactivar.

**Reglas de negocio**
- Al confirmar un pedido se valida y descuenta el inventario de la sucursal elegida en **una sola transacción**: si falta stock, no se guarda nada.
- `/admin` solo es accesible para usuarios con rol `ADMIN`; `/pedido` requiere sesión iniciada.

## Tecnologías

| Capa | Tecnología |
|---|---|
| Lenguaje | Java 17 |
| Backend | Servlets y JSP (Jakarta EE 10), JSTL |
| Frontend | HTML y CSS |
| Base de datos | PostgreSQL (JDBC) |
| Construcción | Maven (empaquetado `.war`) |
| Servidor | Apache Tomcat 10.1 |

> Tomcat debe ser la versión **10.1** (la 9 no funciona, el proyecto usa `jakarta.*`).

## Estructura del proyecto

```
natural-center/
├── pom.xml
├── sql/
│   └── schema.sql              # tablas + datos de ejemplo
└── src/main/
    ├── java/com/naturalcenter/
    │   ├── Db.java             # conexión y utilidades JDBC
    │   ├── AuthFilter.java     # codificación UTF-8 y control de acceso
    │   ├── AuthServlet.java    # login, registro y logout
    │   ├── CatalogoServlet.java# catálogo y detalle de producto
    │   ├── CarritoServlet.java # carrito (en sesión)
    │   ├── PedidoServlet.java  # confirmación y listado de pedidos
    │   └── AdminServlet.java   # CRUD de productos
    └── webapp/
        ├── index.jsp
        ├── css/style.css
        └── WEB-INF/
            ├── web.xml
            └── jsp/            # vistas (catálogo, carrito, admin, etc.)
```

## Modelo de datos

Siete entidades: `sucursal`, `usuario`, `categoria`, `producto`, `inventario`, `pedido` y `detalle_pedido`.

## Requisitos previos

- JDK 17 o superior
- Maven 3.9+
- PostgreSQL
- Apache Tomcat 10.1

## Instalación y ejecución

### 1. Crear la base de datos

```bash
psql -U postgres -c "CREATE DATABASE natural_center ENCODING 'UTF8' TEMPLATE template0 LOCALE_PROVIDER icu ICU_LOCALE 'es-CO';"
psql -U postgres -d natural_center -f sql/schema.sql
```

> En Windows, si ves caracteres raros en la consola, ejecuta antes `set PGCLIENTENCODING=UTF8`.
> Si la creación de la base falla por `LOCALE_PROVIDER`, usa `LC_COLLATE 'C' LC_CTYPE 'C'` en su lugar.

### 2. Configurar la conexión

Por defecto la aplicación se conecta a `localhost:5432`, base `natural_center`, usuario `postgres`. Se cambia con variables de entorno:

| Variable | Valor por defecto |
|---|---|
| `DB_URL` | `jdbc:postgresql://localhost:5432/natural_center` |
| `DB_USER` | `postgres` |
| `DB_PASS` | `postgres` |

Windows (CMD): `set DB_PASS=tu_clave` · Linux/macOS: `export DB_PASS=tu_clave`

### 3. Compilar

```bash
mvn clean package
```

Genera `target/natural-center.war`.

### 4. Desplegar en Tomcat

Windows (CMD):

```bat
set CATALINA_HOME=C:\tomcat
set DB_PASS=tu_clave
copy /y target\natural-center.war C:\tomcat\webapps\
C:\tomcat\bin\startup.bat
```

Linux/macOS:

```bash
export CATALINA_HOME=/opt/tomcat
export DB_PASS=tu_clave
cp target/natural-center.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/startup.sh
```

Abre **http://localhost:8080/natural-center/**

### Redesplegar después de cambiar código

```bat
mvn clean package
C:\tomcat\bin\shutdown.bat
rmdir /s /q C:\tomcat\webapps\natural-center
rmdir /s /q C:\tomcat\work\Catalina\localhost\natural-center
copy /y target\natural-center.war C:\tomcat\webapps\
C:\tomcat\bin\startup.bat
```

Después recarga el navegador con `Ctrl + F5`.

## Cuentas de prueba

| Rol | Correo | Contraseña |
|---|---|---|
| Administrador | `admin@naturalcenter.co` | `admin123` |
| Cliente | `cliente@correo.com` | `cliente123` |

## Solución de problemas

| Problema | Causa probable |
|---|---|
| `CATALINA_HOME environment variable is not defined correctly` | Falta `set CATALINA_HOME=C:\tomcat` en esa terminal. |
| Error 404 | El `.war` no está en `webapps`, Tomcat no terminó de arrancar, o se usa Tomcat 9. |
| Error 500 | Contraseña de base de datos incorrecta (`DB_PASS`) o PostgreSQL apagado. Revisar `logs/` de Tomcat. |
| Tildes o emojis rotos | Versión anterior desplegada: redesplegar borrando `webapps/natural-center` y `work/Catalina/localhost/natural-center`. |
| `mvn` no se reconoce | Maven no está en el `Path`. |

## Alcance del prototipo

Este es un prototipo académico. Queda fuera de su alcance: pasarela de pagos, subida de imágenes (se usa una URL opcional), recuperación de contraseña y reportes. Las contraseñas se almacenan con SHA-256; para un entorno real se recomienda usar un algoritmo con sal como bcrypt.
