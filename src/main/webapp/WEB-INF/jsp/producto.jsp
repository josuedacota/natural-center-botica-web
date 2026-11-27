<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
  <%@ include file="header.jspf" %>
    <a href="${ctx}/catalogo">← Volver al catálogo</a>
    <section class="detalle">
      <div class="img big">
        <c:choose>
          <c:when test="${not empty p.imagen_url}"><img src="${p.imagen_url}" alt="${p.nombre}"></c:when>
          <c:otherwise>${p.icono}</c:otherwise>
        </c:choose>
      </div>
      <div><small>${p.categoria}</small>
        <h1>${p.nombre}</h1>
        <p>${p.descripcion}</p>
        <p class="muted">Presentación: ${p.presentacion}</p>
        <p class="price big">
          <fmt:formatNumber value="${p.precio_final}" type="currency" currencySymbol="$" maxFractionDigits="0" />
          <c:if test="${p.descuento_pct > 0}"><s>
              <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0" />
            </s> <span class="badge s">-${p.descuento_pct}%</span></c:if>
        </p>
        <h3>Existencias por sucursal</h3>
        <ul>
          <c:forEach var="e" items="${existencias}">
            <li>${e.nombre}: <b class="${e.stock > 0 ? 'ok' : 'no'}">${e.stock > 0 ? e.stock.toString().concat('
                unidades') : 'Agotado'}</b></li>
          </c:forEach>
        </ul>
        <c:if test="${p.stock > 0}">
          <form method="post" action="${ctx}/carrito"><input type="hidden" name="accion" value="agregar"><input
              type="hidden" name="id" value="${p.id}">
            <input class="qty" type="number" name="cantidad" value="1" min="1"><button class="btn">Agregar al
              carrito</button>
          </form>
        </c:if>
      </div>
    </section>
    <%@ include file="footer.jspf" %>