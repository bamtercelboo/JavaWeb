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
    String sql = "SELECT a.* ,b.*, a.au_id auhtorid, b.id bookid, a.name author_name, b.name book_name FROM nccp_authors a,nccp_books b WHERE a.au_id = b.author_id AND b.id = ? ";
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

