<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
    <%@ include file="header.jspf" %>
        <form class="panel narrow" method="post" action="${ctx}/login">
            <h1>Iniciar sesión</h1>
            <c:if test="${not empty error}">
                <p class="alert">${error}</p>
            </c:if><label>Correo<input type="email" name="correo" required></label><label>Contraseña<input
                    type="password" name="clave" required></label><button class="btn">Ingresar</button>
            <p>¿No tienes cuenta? <a href="${ctx}/registro">Regístrate</a></p>
        </form>
        <%@ include file="footer.jspf" %>