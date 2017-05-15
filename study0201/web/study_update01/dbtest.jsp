<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,
                 java.util.*"%>
<%@include file="db_comm.jsp" %>
<%
  Connection conn = null;
  List<Map<String, String>> data = new ArrayList<>();
  try
  {
	  conn = getConnection();
    String sql = "SELECT * FROM nccp_books";
    String sql_row = "SELECT count(*) all_count  FROM nccp_books";
    String where = "";
    where = buildQueryWhere( request, where, "?", "name", "LIKE" );
    //where = buildQueryWhere( request, where, "?", "price", ">=" );
   // where = buildQueryWhere( request, where, "param_price_upper", "price", "<=" );
    if( where.length() > 0 )
    {
      sql = sql + " WHERE " + where;
      sql_row = sql_row + " WHERE " + where;
    }
    List<String> list = new ArrayList<>();
    list.add("%5%");//模糊查询用到占位符需要在参数里面写%%
   // list.add("23.20");
    data = query( conn, sql, list );
    int count = queryCount(conn, sql_row, list);
    System.out.println("count "+count);
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  finally
  {
    try{ conn.close(); }catch(Exception e){}
  }
%>
<html>
  <body>
    <table>
      <tr>
        <th>名称</th>
        <th>价格</th>
      </tr>
      <%for( Map<String, String> row : data ){%>
      <tr>
        <td><%=row.get("name")%></td>
        <td><%=row.get("price")%></td>
      </tr>
      <%}%>
    </table>
  </body>
</html>