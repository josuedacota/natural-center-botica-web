-- createdb natural_center && psql -d natural_center -f sql/schema.sql
DROP TABLE IF EXISTS detalle_pedido, pedido, inventario, producto, categoria, usuario, sucursal CASCADE;
CREATE TABLE sucursal(id SERIAL PRIMARY KEY, nombre VARCHAR(60) NOT NULL, ciudad VARCHAR(40) NOT NULL, direccion VARCHAR(120), telefono VARCHAR(20));
CREATE TABLE usuario(id SERIAL PRIMARY KEY, nombre VARCHAR(80) NOT NULL, correo VARCHAR(100) UNIQUE NOT NULL, clave_hash CHAR(64) NOT NULL,
  rol VARCHAR(10) NOT NULL CHECK (rol IN ('ADMIN','CLIENTE')), telefono VARCHAR(20), direccion VARCHAR(120));
CREATE TABLE categoria(id SERIAL PRIMARY KEY, nombre VARCHAR(50) NOT NULL, icono VARCHAR(8));
CREATE TABLE producto(id SERIAL PRIMARY KEY, nombre VARCHAR(100) NOT NULL, descripcion TEXT, presentacion VARCHAR(60),
  precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0), descuento_pct INT NOT NULL DEFAULT 0 CHECK (descuento_pct BETWEEN 0 AND 90),
  imagen_url VARCHAR(255), categoria_id INT NOT NULL REFERENCES categoria(id), activo BOOLEAN NOT NULL DEFAULT TRUE);
CREATE TABLE inventario(producto_id INT REFERENCES producto(id) ON DELETE CASCADE, sucursal_id INT REFERENCES sucursal(id),
  stock INT NOT NULL CHECK (stock >= 0), PRIMARY KEY (producto_id, sucursal_id));
CREATE TABLE pedido(id SERIAL PRIMARY KEY, usuario_id INT NOT NULL REFERENCES usuario(id), sucursal_id INT NOT NULL REFERENCES sucursal(id),
  fecha TIMESTAMP NOT NULL DEFAULT now(), tipo_entrega VARCHAR(10) NOT NULL CHECK (tipo_entrega IN ('RECOGER','DOMICILIO')),
  direccion_entrega VARCHAR(120), estado VARCHAR(12) NOT NULL DEFAULT 'PENDIENTE', total NUMERIC(12,2) NOT NULL);
CREATE TABLE detalle_pedido(id SERIAL PRIMARY KEY, pedido_id INT NOT NULL REFERENCES pedido(id) ON DELETE CASCADE,
  producto_id INT NOT NULL REFERENCES producto(id), cantidad INT NOT NULL CHECK (cantidad > 0), precio_unitario NUMERIC(10,2) NOT NULL);

INSERT INTO sucursal(nombre,ciudad,direccion,telefono) VALUES
 ('Natural Center + Botica Andalucía','Andalucía','Centro, Andalucía (V.)','3000000001'),
 ('Natural Center + Botica Bugalagrande','Bugalagrande','Centro, Bugalagrande (V.)','3000000002');
INSERT INTO usuario(nombre,correo,clave_hash,rol) VALUES
 ('Administrador','admin@naturalcenter.co',encode(sha256('admin123'::bytea),'hex'),'ADMIN'),
 ('Cliente Demo','cliente@correo.com',encode(sha256('cliente123'::bytea),'hex'),'CLIENTE');
INSERT INTO categoria(nombre,icono) VALUES ('Plantas medicinales','🌿'),('Suplementos','💊'),('Homeopatía','💧'),('Infusiones','🍵');
INSERT INTO producto(nombre,descripcion,presentacion,precio,descuento_pct,categoria_id) VALUES
 ('Sábila (aloe vera) en gel','Gel de aloe vera para uso externo e hidratación de la piel.','Frasco 250 ml',18000,10,1),
 ('Cúrcuma en polvo','Raíz de cúrcuma molida, uso culinario y como infusión.','Bolsa 100 g',12000,0,1),
 ('Moringa en cápsulas','Suplemento dietario a base de hoja de moringa.','60 cápsulas',35000,15,2),
 ('Omega 3','Suplemento dietario de ácidos grasos omega 3.','90 cápsulas',48000,0,2),
 ('Árnica homeopática','Preparado homeopático de árnica para golpes y moretones.','Gotas 30 ml',22000,0,3),
 ('Caléndula en crema','Crema de caléndula producida en nuestro laboratorio.','Tarro 60 g',16000,5,3),
 ('Té de jengibre y limón','Infusión natural para el bienestar digestivo.','20 sobres',9500,0,4),
 ('Aromática de manzanilla','Infusión relajante de manzanilla seca.','Bolsa 50 g',7000,0,4);
INSERT INTO inventario SELECT p.id, s.id, ((p.id*7 + s.id*5) % 18) FROM producto p CROSS JOIN sucursal s;
