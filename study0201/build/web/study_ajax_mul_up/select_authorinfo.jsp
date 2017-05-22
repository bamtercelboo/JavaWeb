<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  //从修改超链接传输参数
  String author_name = request.getParameter("author_name");
  Connection conn = null;
   List<Map<String, String>> data = new ArrayList<>();
    try {
    //连接数据库
    conn = getConnection();
    String sql = "SELECT a.*, a.name author_name FROM nccp_authors a";
    String where = "";
    List<String> param_values = new ArrayList<>();
    where = buildQueryWhere(param_values, request, where, "author_name", "name", "LIKE");
     if ( where.length() > 0 ) {
      sql = sql + " WHERE "+where;
     }
    data = query(conn, sql, param_values);
    System.out.println("authorInfo "+data);
    out.print(JSONArray.fromObject(data));
  } catch ( Exception e ) {
    e.printStackTrace();
  } finally {
    try { conn.close(); } catch ( Exception e ) { }
  }
%>

