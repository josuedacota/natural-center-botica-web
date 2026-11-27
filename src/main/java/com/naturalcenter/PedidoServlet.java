package com.naturalcenter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

@WebServlet("/pedido")
public class PedidoServlet extends HttpServlet {
	@SuppressWarnings("unchecked")
	static int uid(HttpServletRequest r) {
		return (Integer) ((Map<String, Object>) r.getSession().getAttribute("usuario")).get("id");
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		req.setAttribute("pedidos", Db.query(
				"SELECT p.*, s.nombre sucursal FROM pedido p JOIN sucursal s ON s.id=p.sucursal_id WHERE p.usuario_id=? ORDER BY p.id DESC",
				uid(req)));
		req.getRequestDispatcher("/WEB-INF/jsp/pedidos.jsp").forward(req, res);
	}

	/**
	 * Confirma el pedido en UNA transacción: valida y descuenta existencias de la
	 * sucursal elegida.
	 */
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		var cart = CarritoServlet.cart(req.getSession());
		Integer suc = Db.toInt(req.getParameter("sucursal"));
		String tipo = "DOMICILIO".equals(req.getParameter("tipo")) ? "DOMICILIO" : "RECOGER";
		if (cart.isEmpty() || suc == null) {
			res.sendRedirect("carrito");
			return;
		}
		try (Connection c = Db.conn()) {
			c.setAutoCommit(false);
			try {
				BigDecimal total = BigDecimal.ZERO;
				Map<Integer, BigDecimal> precios = new LinkedHashMap<>();
				for (var e : cart.entrySet()) {
					BigDecimal pf = (BigDecimal) Db.query(c, Db.PROD + "WHERE p.id=? AND p.activo", e.getKey()).get(0)
							.get("precio_final");
					precios.put(e.getKey(), pf);
					total = total.add(pf.multiply(BigDecimal.valueOf(e.getValue())));
					if (Db.update(c,
							"UPDATE inventario SET stock=stock-? WHERE producto_id=? AND sucursal_id=? AND stock>=?",
							e.getValue(), e.getKey(), suc, e.getValue()) == 0)
						throw new IllegalStateException(
								"No hay existencias suficientes en la sucursal elegida para uno de los productos.");
				}
				int pid = (Integer) Db.query(c,
						"INSERT INTO pedido(usuario_id,sucursal_id,tipo_entrega,direccion_entrega,total) VALUES (?,?,?,?,?) RETURNING id",
						uid(req), suc, tipo, req.getParameter("direccion"), total).get(0).get("id");
				for (var e : cart.entrySet())
					Db.update(c,
							"INSERT INTO detalle_pedido(pedido_id,producto_id,cantidad,precio_unitario) VALUES (?,?,?,?)",
							pid, e.getKey(), e.getValue(), precios.get(e.getKey()));
				c.commit();
				cart.clear();
				res.sendRedirect("pedido?ok=" + pid);
			} catch (Exception ex) {
				c.rollback();
				req.setAttribute("error", ex.getMessage());
				req.getRequestDispatcher("/carrito").forward(req, res);
			}
		} catch (SQLException e) {
			throw new ServletException(e);
		}
	}
}
