<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
    <%@ include file="header.jspf" %>
        <h1>Administración de productos</h1>
        <form class="panel" method="post" action="${ctx}/admin">
            <h3>${empty ed ? 'Nuevo producto' : 'Editar producto #'.concat(ed.id)}</h3>
            <input type="hidden" name="accion" value="guardar"><input type="hidden" name="id" value="${ed.id}">
            <label>Nombre<input name="nombre" value="${ed.nombre}" required></label>
            <label>Descripción<textarea name="descripcion" rows="2">${ed.descripcion}</textarea></label>
            <div class="row"><label>Presentación<input name="presentacion" value="${ed.presentacion}"></label>
                <label>Categoría<select name="categoria_id">
                        <c:forEach var="k" items="${categorias}">
                            <option value="${k.id}" ${ed.categoria_id==k.id ? 'selected' : '' }>${k.nombre}</option>
                        </c:forEach>
                    </select></label>
            </div>
            <div class="row"><label>Precio (COP)<input type="number" step="100" min="0" name="precio"
                        value="${ed.precio}" required></label>
                <label>Descuento %<input type="number" min="0" max="90" name="descuento"
                        value="${empty ed ? 0 : ed.descuento_pct}"></label>
            </div>
            <label>URL de imagen (opcional)<input name="imagen_url" value="${ed.imagen_url}"></label>
            <div class="row">
                <c:forEach var="s" items="${sucursales}"><label>Stock ${s.ciudad}<input type="number" min="0"
                            name="stock_${s.id}" value="${empty ed ? 0 : stocks[s.id]}"></label></c:forEach>
            </div>
            <button class="btn">Guardar</button>
            <c:if test="${not empty ed}"><a href="${ctx}/admin">Cancelar</a></c:if>
        </form>
        <table>
            <tr>
                <th>#</th>
                <th>Producto</th>
                <th>Precio</th>
                <th>Desc.</th>
                <th>Stock total</th>
                <th>Estado</th>
                <th></th>
            </tr>
            <c:forEach var="p" items="${productos}">
                <tr class="${p.activo ? '' : 'off'}">
                    <td>${p.id}</td>
                    <td>${p.nombre}</td>
                    <td>
                        <fmt:formatNumber value="${p.precio}" type="currency" currencySymbol="$"
                            maxFractionDigits="0" />
                    </td>
                    <td>${p.descuento_pct}%</td>
                    <td>${p.stock}</td>
                    <td>${p.activo ? 'Visible' : 'Oculto'}</td>
                    <td><a href="${ctx}/admin?editar=${p.id}">Editar</a>
                        <form class="inline" method="post" action="${ctx}/admin"><input type="hidden" name="id"
                                value="${p.id}"><input type="hidden" name="accion"
                                value="${p.activo ? 'ocultar' : 'activar'}"><button class="link">${p.activo ? 'Eliminar'
                                : 'Reactivar'}</button></form>
                    </td>
                </tr>
            </c:forEach>
        </table>
        <%@ include file="footer.jspf" %>