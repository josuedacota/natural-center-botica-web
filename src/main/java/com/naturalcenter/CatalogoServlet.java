package com.naturalcenter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({ "/catalogo", "/producto" })
public class CatalogoServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		if (req.getServletPath().equals("/producto")) {
			var l = Db.query(Db.PROD + "WHERE p.id=? AND p.activo", Db.toInt(req.getParameter("id")));
			if (l.isEmpty()) {
				res.sendRedirect("catalogo");
				return;
			}
			req.setAttribute("p", l.get(0));
			req.setAttribute("existencias", Db.query(
					"SELECT s.nombre, i.stock FROM inventario i JOIN sucursal s ON s.id=i.sucursal_id WHERE i.producto_id=? ORDER BY s.id",
					Db.toInt(req.getParameter("id"))));
			req.getRequestDispatcher("/WEB-INF/jsp/producto.jsp").forward(req, res);
			return;
		}
		String q = req.getParameter("q");
		if (q != null && q.isBlank())
			q = null;
		Integer cat = Db.toInt(req.getParameter("cat"));
		req.setAttribute("productos", Db.query(Db.PROD
				+ "WHERE p.activo AND (?::text IS NULL OR p.nombre ILIKE '%'||?||'%') AND (?::int IS NULL OR p.categoria_id=?) ORDER BY p.nombre",
				q, q, cat, cat));
		req.setAttribute("categorias", Db.query("SELECT * FROM categoria ORDER BY id"));
		req.getRequestDispatcher("/WEB-INF/jsp/catalogo.jsp").forward(req, res);
	}

