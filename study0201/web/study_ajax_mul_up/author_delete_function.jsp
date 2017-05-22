<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  Connection conn = null;
  try {
    //连接数据库
    conn = getConnection();
    String sql = "DELETE FROM nccp_authors WHERE au_id IN(" + request.getParameter("id") + ")";
    System.out.println("删除 " + sql);
    int flag = execupdate(conn, sql);
    out.print(flag);
  } catch ( Exception e ) {
    e.printStackTrace();
  } finally {
    try { conn.close(); } catch ( Exception e ) { }
  }
%>