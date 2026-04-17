USE Northwind;
GO
/* Consulta 1: Análisis de Trazabilidad de Ventas.
   Propósito: RRHH y Ventas necesitan identificar qué empleado gestionó cada orden 
   y para qué cliente corporativo, para evaluar el desempeño comercial. */
select 
    O.OrderID as 'ID Orden',
    E.FirstName + ' ' + E.LastName as 'Nombre Empleado',
    C.CompanyName as 'Nombre Cliente',
    O.OrderDate as 'Fecha Orden'
from Orders O
inner join Employees E on O.EmployeeID = E.EmployeeID
inner join Customers C on O.CustomerID = C.CustomerID
order by O.OrderDate desc;

/* Consulta 2: Auditoría de Inventario y Proveedores.
   Propósito: El departamento de compras requiere un catálogo claro de productos 
   activos (que no estén descontinuados), sabiendo quién los provee y su categoría. */
select 
    P.ProductName as 'Producto',
    C.CategoryName as 'Categoria',
    S.CompanyName as 'Proveedor',
    P.UnitPrice as 'Precio Unitario'
from Products P
inner join Categories C on P.CategoryID = C.CategoryID
inner join Suppliers S on P.SupplierID = S.SupplierID
where P.Discontinued = 0
order by C.CategoryName, P.ProductName;

/* Consulta 3: Detalle Financiero de Órdenes.
   Propósito: Finanzas necesita revisar el detalle exacto de los productos vendidos 
   en cada orden, con cantidades y precios cobrados, para proyectar ingresos. */
select 
    O.OrderID as 'ID Orden',
    O.OrderDate as 'Fecha Orden',
    P.ProductName as 'Producto Vendido',
    OD.UnitPrice as 'Precio Facturado',
    OD.Quantity as 'Cantidad Vendida',
    (OD.UnitPrice * OD.Quantity) as 'Total Ingreso Linea'
from [Order Details] OD
inner join Orders O on OD.OrderID = O.OrderID
inner join Products P on OD.ProductID = P.ProductID
order by O.OrderID;

/* Consulta 4: Análisis de Logística y Envíos.
   Propósito: Evaluar qué empresa de transporte (Shipper) está manejando 
   qué órdenes, para auditar la carga de trabajo de los proveedores de envíos. */
select 
    O.OrderID as 'ID Orden',
    C.CompanyName as 'Cliente',
    S.CompanyName as 'Transportista',
    O.ShippedDate as 'Fecha Envio'
from Orders O
inner join Customers C on O.CustomerID = C.CustomerID
inner join Shippers S on O.ShipVia = S.ShipperID
order by S.CompanyName;

/* Consulta 5: Alerta de Reabastecimiento Crítico.
   Propósito: Compras necesita saber qué productos están por debajo del nivel 
   de reorden, incluyendo la categoría, para solicitar más stock de inmediato. */
select 
    P.ProductName as 'Producto',
    C.CategoryName as 'Categoria',
    P.UnitsInStock as 'Stock Actual',
    P.ReorderLevel as 'Nivel Reorden'
from Products P
inner join Categories C on P.CategoryID = C.CategoryID
where P.UnitsInStock <= P.ReorderLevel and P.Discontinued = 0;

/* Consulta 6: Mapa de Fuerza de Ventas.
   Propósito: La gerencia comercial necesita visualizar la asignación de territorios 
   por cada empleado para planificar expansiones o detectar zonas sin cobertura. */
select 
    E.FirstName + ' ' + E.LastName as 'Vendedor',
    E.Title as 'Cargo',
    T.TerritoryDescription as 'Territorio'
from Employees E
inner join EmployeeTerritories ET on E.EmployeeID = ET.EmployeeID
inner join Territories T on ET.TerritoryID = T.TerritoryID
order by E.FirstName;

/* Consulta 7: Directorio Estratégico de Proveedores.
   Propósito: El equipo de marketing necesita un directorio de proveedores 
   filtrado por categoría de producto para coordinar campañas promocionales. */
select 
    C.CategoryName as 'Categoria',
    P.ProductName as 'Producto',
    S.CompanyName as 'Proveedor',
    S.ContactName as 'Contacto Principal',
    S.Phone as 'Telefono'
from Products P
inner join Categories C on P.CategoryID = C.CategoryID
inner join Suppliers S on P.SupplierID = S.SupplierID;

/* Consulta 8: Estructura Organizacional.
   Propósito: Recursos Humanos requiere un reporte claro de la jerarquía, 
   mostrando a cada empleado junto con el nombre de su supervisor directo. */
select 
    E.FirstName + ' ' + E.LastName as 'Empleado',
    E.Title as 'Cargo',
    J.FirstName + ' ' + J.LastName as 'Reporta A'
from Employees E
inner join Employees J on E.ReportsTo = J.EmployeeID;

/* Consulta 9: Identificación de Clientes Inactivos (LEFT JOIN).
   Propósito: El equipo de retención necesita encontrar clientes registrados 
   que nunca han realizado una compra para lanzarles una campaña de reactivación. */
select 
    C.CustomerID as 'ID Cliente',
    C.CompanyName as 'Cliente Inactivo',
    C.ContactName as 'Contacto',
    O.OrderID as 'ID Orden'
from Customers C
left join Orders O on C.CustomerID = O.CustomerID
where O.OrderID is null;

/* Consulta 10: Auditoría de Productos sin Salida (RIGHT JOIN).
   Propósito: Identificar si existe algún producto en el catálogo que 
   jamás se ha vendido (no aparece en el detalle de órdenes) para liquidarlo. */
select 
    OD.OrderID as 'ID Orden',
    P.ProductID as 'ID Producto',
    P.ProductName as 'Producto Sin Ventas',
    P.UnitPrice as 'Precio'
from [Order Details] OD
right join Products P on OD.ProductID = P.ProductID
where OD.OrderID is null;