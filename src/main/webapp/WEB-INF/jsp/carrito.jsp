<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
    <%@ include file="header.jspf" %>
        <h1>Carrito de compras</h1>
        <c:if test="${not empty error}">
            <p class="alert">${error}</p>
        </c:if>
        <c:choose>
            <c:when test="${empty items}">
                <p>Tu carrito está vacío. <a href="${ctx}/catalogo">Ver catálogo</a></p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>Producto</th>
                        <th>Precio</th>
                        <th>Cant.</th>
                        <th>Subtotal</th>
                        <th></th>
                    </tr>
                    <c:forEach var="i" items="${items}">
                        <tr>
                            <td>${i.nombre}</td>
                            <td>
                                <fmt:formatNumber value="${i.precio_final}" type="currency" currencySymbol="$"
                                    maxFractionDigits="0" />
                            </td>
                            <td>${i.cantidad}</td>
                            <td>
                                <fmt:formatNumber value="${i.subtotal}" type="currency" currencySymbol="$"
                                    maxFractionDigits="0" />
                            </td>
                            <td>
                                <form method="post" action="${ctx}/carrito"><input type="hidden" name="accion"
                                        value="quitar"><input type="hidden" name="id" value="${i.id}"><button
                                        class="link">Quitar</button></form>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr class="tot">
                        <td colspan="3">Total</td>
                        <td colspan="2">
                            <fmt:formatNumber value="${total}" type="currency" currencySymbol="$"
                                maxFractionDigits="0" />
                        </td>
                    </tr>
                </table>
                <c:choose>
                    <c:when test="${empty sessionScope.usuario}">
                        <p class="alert">Para confirmar tu pedido <a href="${ctx}/login">inicia sesión</a> o <a
                                href="${ctx}/registro">regístrate</a>.</p>
                    </c:when>
                    <c:otherwise>
                        <form class="panel" method="post" action="${ctx}/pedido">
                            <h3>Confirmar pedido</h3>
                            <label>Sucursal<select name="sucursal">
                                    <c:forEach var="s" items="${sucursales}">
                                        <option value="${s.id}">${s.nombre}</option>
                                    </c:forEach>
                                </select></label>
                            <label>Entrega<select name="tipo">
                                    <option value="RECOGER">Recoger en sucursal</option>
                                    <option value="DOMICILIO">Domicilio</option>
                                </select></label>
                            <label>Dirección (si es domicilio)<input name="direccion"
                                    value="${sessionScope.usuario.direccion}"></label><button class="btn">Confirmar
                                pedido</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
        <%@ include file="footer.jspf" %>