package com.naturalcenter;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({ "/login", "/registro", "/logout" })
public class AuthServlet extends HttpServlet {
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		if (req.getServletPath().equals("/logout")) {
			req.getSession().invalidate();
			res.sendRedirect("catalogo");
			return;
		}
		req.getRequestDispatcher("/WEB-INF/jsp/" + req.getServletPath().substring(1) + ".jsp").forward(req, res);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String correo = req.getParameter("correo"), clave = req.getParameter("clave");
		String vista = req.getServletPath().substring(1);
		if (vista.equals("registro")) {
			try {
				Db.update(
						"INSERT INTO usuario(nombre,correo,clave_hash,rol,telefono,direccion) VALUES (?,?,?,'CLIENTE',?,?)",
						req.getParameter("nombre"), correo, Db.hash(clave), req.getParameter("telefono"),
						req.getParameter("direccion"));
			} catch (RuntimeException e) {
				req.setAttribute("error", "Ese correo ya está registrado.");
				req.getRequestDispatcher("/WEB-INF/jsp/registro.jsp").forward(req, res);
				return;
			}
		}
		var l = Db.query("SELECT id,nombre,rol,direccion FROM usuario WHERE correo=? AND clave_hash=?", correo,
				Db.hash(clave));
		if (l.isEmpty()) {
			req.setAttribute("error", "Correo o contraseña incorrectos.");
			req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
			return;
		}
		req.getSession().setAttribute("usuario", l.get(0));
		res.sendRedirect("ADMIN".equals(l.get(0).get("rol")) ? "admin" : "catalogo");
	}
