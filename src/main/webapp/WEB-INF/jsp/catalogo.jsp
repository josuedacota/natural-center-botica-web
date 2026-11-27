<%@ include file="header.jspf" %>
<h1>Catálogo de productos</h1>
<form class="filtros" method="get" action="${ctx}/catalogo">
  <input name="q" value="${param.q}" placeholder="Buscar producto...">
  <select name="cat"><option value="">Todas las categorías</option>
    <c:forEach var="k" items="${categorias}"><option value="${k.id}" ${param.cat == k.id ? 'selected' : ''}>${k.icono} ${k.nombre}</option></c:forEach></select>
  <button class="btn">Buscar</button></form>
<c:if test="${empty productos}"><p>No se encontraron productos.</p></c:if>
<div class="grid"><c:forEach var="p" items="${productos}"><article class="card">
  <c:if test="${p.descuento_pct > 0}"><span class="badge">-${p.descuento_pct}%</span></c:if>
  <a href="${ctx}/producto?id=${p.id}"><div class="img"><c:choose><c:when test="${not empty p.imagen_url}"><img src="${p.imagen_url}" alt="${p.nombre}"></c:when><c:otherwise>${p.icono}</c:otherwise></c:choose></div></a>
  <small>${p.categoria}</small><h3>${p.nombre}</h3><p class="muted">${p.presentacion}</p>
  <p class="price"><fmt:formatNumber value="${p.precio_final}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
    <c:if test="${p.descuento_pct > 0}"><s><fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$" maxFractionDigits="0"/></s></c:if></p>
  <p class="${p.stock > 0 ? 'ok' : 'no'}">${p.stock > 0 ? 'Disponible' : 'Agotado'}</p>
  <c:if test="${p.stock > 0}"><form method="post" action="${ctx}/carrito"><input type="hidden" name="accion" value="agregar"><input type="hidden" name="id" value="${p.id}">
    <input class="qty" type="number" name="cantidad" value="1" min="1" max="${p.stock}"><button class="btn">Agregar</button></form></c:if>
</article></c:forEach></div>
<%@ include file="footer.jspf" %>
