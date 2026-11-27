package com.naturalcenter;

import java.sql.*;
import java.util.*;

/**
 * Acceso a PostgreSQL. Cada fila se devuelve como Map para usarla directo en
 * JSTL (${p.nombre}).
 */
public class Db {
	static final String URL = System.getenv().getOrDefault("DB_URL", "jdbc:postgresql://localhost:5432/natural_center");
	static final String USER = System.getenv().getOrDefault("DB_USER", "postgres");
	static final String PASS = System.getenv().getOrDefault("DB_PASS", "postgres");
	static {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	public static final String PROD = "SELECT p.*, c.nombre categoria, c.icono, ROUND(p.precio*(100-p.descuento_pct)/100.0,0) precio_final, "
			+ "COALESCE((SELECT SUM(stock) FROM inventario i WHERE i.producto_id=p.id),0) stock FROM producto p JOIN categoria c ON c.id=p.categoria_id ";

	public static Connection conn() throws SQLException {
		return DriverManager.getConnection(URL, USER, PASS);
	}

	static void bind(PreparedStatement ps, Object[] p) throws SQLException {
		for (int i = 0; i < p.length; i++)
			ps.setObject(i + 1, p[i]);
	}

	public static List<Map<String, Object>> query(Connection c, String sql, Object... p) throws SQLException {
		try (PreparedStatement ps = c.prepareStatement(sql)) {
			bind(ps, p);
			ResultSet rs = ps.executeQuery();
			ResultSetMetaData m = rs.getMetaData();
			List<Map<String, Object>> out = new ArrayList<>();
			while (rs.next()) {
				Map<String, Object> r = new LinkedHashMap<>();
				for (int i = 1; i <= m.getColumnCount(); i++)
					r.put(m.getColumnLabel(i), rs.getObject(i));
				out.add(r);
			}
			return out;
		}
	}

	public static int update(Connection c, String sql, Object... p) throws SQLException {
		try (PreparedStatement ps = c.prepareStatement(sql)) {
			bind(ps, p);
			return ps.executeUpdate();
		}
	}

	public static List<Map<String, Object>> query(String sql, Object... p) {
		try (Connection c = conn()) {
			return query(c, sql, p);
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	public static int update(String sql, Object... p) {
		try (Connection c = conn()) {
			return update(c, sql, p);
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	public static List<Map<String, Object>> sucursales() {
		return query("SELECT * FROM sucursal ORDER BY id");
	}

	public static Integer toInt(String s) {
		try {
			return (s == null || s.isBlank()) ? null : Integer.valueOf(s.trim());
		} catch (NumberFormatException e) {
			return null;
		}
	}

	public static String hash(String s) {
		try {
			return HexFormat.of()
					.formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8")));
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
