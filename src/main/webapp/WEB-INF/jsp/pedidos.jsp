<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
    <%@ include file="header.jspf" %>
        <h1>Mis pedidos</h1>
        <c:if test="${not empty param.ok}">
            <p class="okbox">✅ Pedido #${param.ok} confirmado. ¡Gracias por tu compra!</p>
        </c:if>
        <c:if test="${empty pedidos}">
            <p>Aún no tienes pedidos.</p>
        </c:if>
        <c:if test="${not empty pedidos}">
            <table>
                <tr>
                    <th>#</th>
                    <th>Fecha</th>
                    <th>Sucursal</th>
                    <th>Entrega</th>
                    <th>Estado</th>
                    <th>Total</th>
                </tr>
                <c:forEach var="p" items="${pedidos}">
                    <tr>
                        <td>${p.id}</td>
                        <td>${p.fecha.toString().substring(0,16).replace('T',' ')}</td>
                        <td>${p.sucursal}</td>
                        <td>${p.tipo_entrega}</td>
                        <td>${p.estado}</td>
                        <td>
                            <fmt:formatNumber value="${p.total}" type="currency" currencySymbol="$"
                                maxFractionDigits="0" />
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
        <%@ include file="footer.jspf" %>