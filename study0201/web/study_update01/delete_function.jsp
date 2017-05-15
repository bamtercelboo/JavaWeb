<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  
  Connection conn = null;
  try
  {
    String id[] = request.getParameterValues("id");
    System.out.println("id " + id);
    String id_value = "";
    if ( id != null && !(id.equals("null")) )
    {
      for ( int i = 0; i < id.length; i++ )
      {
        id_value += "'" + id[i] + "',";
      }
      if ( id_value.length() > 1 )
      {
        id_value = id_value.substring(0, id_value.length() - 1);
      }
      //连接数据库
      conn = getConnection();
      String sql = "DELETE FROM nccp_books WHERE id IN(" + id_value + ")";
      System.out.println("删除 " + sql);
      int flag = execupdate(conn, sql);
      if ( flag > 0 )
      {
        response.sendRedirect("index.jsp");
      }
    } 
    else
    {
      response.sendRedirect("index.jsp");
    }
  } catch ( Exception e )
  {
    e.printStackTrace();
  } 
  finally
  { 
    try{ conn.close(); } catch ( Exception e ){ }
  }
%>