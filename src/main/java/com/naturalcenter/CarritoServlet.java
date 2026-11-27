package com.naturalcenter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

/** Carrito en sesión: Map<idProducto, cantidad>. */
@WebServlet("/carrito")
public class CarritoServlet extends HttpServlet {
	@SuppressWarnings("unchecked")
	static Map<Integer, Integer> cart(HttpSession s) {
		Map<Integer, Integer> c = (Map<Integer, Integer>) s.getAttribute("carrito");
		if (c == null)
			s.setAttribute("carrito", c = new LinkedHashMap<>());
		return c;
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		List<Map<String, Object>> items = new ArrayList<>();
		BigDecimal total = BigDecimal.ZERO;
		for (var e : cart(req.getSession()).entrySet()) {
			var l = Db.query(Db.PROD + "WHERE p.id=? AND p.activo", e.getKey());
			if (l.isEmpty())
				continue;
			Map<String, Object> it = l.get(0);
			BigDecimal sub = ((BigDecimal) it.get("precio_final")).multiply(BigDecimal.valueOf(e.getValue()));
			it.put("cantidad", e.getValue());
			it.put("subtotal", sub);
			items.add(it);
			total = total.add(sub);
		}
		req.setAttribute("items", items);
		req.setAttribute("total", total);
		req.setAttribute("sucursales", Db.sucursales());
		req.getRequestDispatcher("/WEB-INF/jsp/carrito.jsp").forward(req, res);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		var c = cart(req.getSession());
		Integer id = Db.toInt(req.getParameter("id"));
		String a = req.getParameter("accion");
		if ("agregar".equals(a) && id != null) {
			Integer n = Db.toInt(req.getParameter("cantidad"));
			c.merge(id, (n == null || n < 1) ? 1 : n, Integer::sum);
		} else if ("quitar".equals(a))
			c.remove(id);
		else if ("vaciar".equals(a))
			c.clear();
		res.sendRedirect("carrito");
	}
