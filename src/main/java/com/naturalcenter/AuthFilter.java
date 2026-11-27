package com.naturalcenter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

/** UTF-8 + control de acceso: /admin/* solo ADMIN, /pedido requiere sesión. */
@WebFilter("/*")
public class AuthFilter implements Filter {
	@SuppressWarnings("unchecked")
	public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain ch) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) rq;
		HttpServletResponse res = (HttpServletResponse) rs;
		req.setCharacterEncoding("UTF-8");
		String path = req.getServletPath();
		Map<String, Object> u = (Map<String, Object>) req.getSession().getAttribute("usuario");
		boolean admin = path.startsWith("/admin");
		if ((admin || path.equals("/pedido")) && (u == null || (admin && !"ADMIN".equals(u.get("rol"))))) {
			res.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		ch.doFilter(rq, rs);
	}

