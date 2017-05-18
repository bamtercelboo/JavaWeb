<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  //从修改超链接传输参数
  String ID = request.getParameter("id");
  Connection conn = null;
  Map<String, String> data = new HashMap<String, String>();
  try {
    //连接数据库
    conn = getConnection();
    String sql = "SELECT * FROM nccp_authors WHERE au_id = ?";
    List<String> list = new ArrayList<>();
    list.add(ID);
    data = querySingleRow(conn, sql, list);
    out.print(JSONArray.fromObject(data));
  } catch ( Exception e ) {
    e.printStackTrace();
  } finally {
    try { conn.close(); } catch ( Exception e ) { }
  }
%>

