package com.naturalcenter;
import jakarta.servlet.*; import jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*; import java.io.IOException; import java.util.*;
/** CRUD de productos (solo ADMIN). "Eliminar" = ocultar (activo=false) para no romper pedidos históricos. */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
  protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    req.setAttribute("productos", Db.query(Db.PROD + "ORDER BY p.id"));
    req.setAttribute("categorias", Db.query("SELECT * FROM categoria ORDER BY id")); req.setAttribute("sucursales", Db.sucursales());
    Integer ed = Db.toInt(req.getParameter("editar"));
    if (ed != null) {
      var l = Db.query("SELECT * FROM producto WHERE id=?", ed); if (!l.isEmpty()) req.setAttribute("ed", l.get(0));
      Map<Integer,Object> st = new HashMap<>(); for (var r : Db.query("SELECT sucursal_id, stock FROM inventario WHERE producto_id=?", ed)) st.put((Integer) r.get("sucursal_id"), r.get("stock"));
      req.setAttribute("stocks", st);
    }
    req.getRequestDispatcher("/WEB-INF/jsp/admin.jsp").forward(req, res);
  }
  protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
    String a = req.getParameter("accion"); Integer id = Db.toInt(req.getParameter("id"));
    if ("ocultar".equals(a)) Db.update("UPDATE producto SET activo=false WHERE id=?", id);
    else if ("activar".equals(a)) Db.update("UPDATE producto SET activo=true WHERE id=?", id);
    else if ("guardar".equals(a)) {
      Object[] f = { req.getParameter("nombre"), req.getParameter("descripcion"), req.getParameter("presentacion"), new java.math.BigDecimal(req.getParameter("precio")),
                     Db.toInt(req.getParameter("descuento")) == null ? 0 : Db.toInt(req.getParameter("descuento")), req.getParameter("imagen_url"), Db.toInt(req.getParameter("categoria_id")) };
      if (id == null) id = (Integer) Db.query("INSERT INTO producto(nombre,descripcion,presentacion,precio,descuento_pct,imagen_url,categoria_id) VALUES (?,?,?,?,?,?,?) RETURNING id", f).get(0).get("id");
      else { Object[] g = Arrays.copyOf(f, 8); g[7] = id; Db.update("UPDATE producto SET nombre=?,descripcion=?,presentacion=?,precio=?,descuento_pct=?,imagen_url=?,categoria_id=? WHERE id=?", g); }
      for (var s : Db.sucursales()) { Integer n = Db.toInt(req.getParameter("stock_" + s.get("id")));
        Db.update("INSERT INTO inventario(producto_id,sucursal_id,stock) VALUES (?,?,?) ON CONFLICT (producto_id,sucursal_id) DO UPDATE SET stock=EXCLUDED.stock", id, s.get("id"), n == null ? 0 : n); }
    }
    res.sendRedirect("admin");
  }
}
