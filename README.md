# Natural Center + Botica — Prototipo web
Java 17 · Servlets/JSP (Jakarta EE 10) · HTML/CSS · PostgreSQL · Maven · Tomcat 10.1

## Puesta en marcha
1. `createdb natural_center` y luego `psql -d natural_center -f sql/schema.sql` (crea tablas y datos de ejemplo).
2. Credenciales de BD por variables de entorno (opcional): `DB_URL`, `DB_USER`, `DB_PASS` (por defecto localhost / postgres / postgres).
3. `mvn clean package` y copia `target/natural-center.war` a `webapps/` de Tomcat 10.1 → http://localhost:8080/natural-center/
   (en NetBeans/IntelliJ: proyecto Maven Web + servidor Tomcat 10.1).

## Cuentas de prueba
- Administrador: admin@naturalcenter.co / admin123
- Cliente: cliente@correo.com / cliente123

## Qué cubre (historia "Consultar catálogo y realizar compras")
Catálogo con búsqueda y categorías · detalle con precio, descuento y existencias por sucursal · carrito · registro/login con
cuentas Cliente y Administrador · confirmación de pedido (descuenta inventario en transacción) · CRUD de productos para el admin.

## Entidades (7)
sucursal, usuario, categoria, producto, inventario, pedido, detalle_pedido.
