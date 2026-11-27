<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ include file="header.jspf" %>
<form class="panel narrow" method="post" action="${ctx}/registro">
    <h1>Crear cuenta de cliente</h1>
    <c:if test="${not empty error}">
        <p class="alert">${error}</p>
    </c:if>
    <label>Nombre completo<input name="nombre" required></label>
    <label>Correo<input type="email" name="correo" required></label>
    <label>Contraseña<input type="password" name="clave" minlength="6" required></label>
    <label>Teléfono<input name="telefono"></label>
    <label>Dirección<input name="direccion"></label>
    <button class="btn">Registrarme</button>
</form>
<%@ include file="footer.jspf" %>
