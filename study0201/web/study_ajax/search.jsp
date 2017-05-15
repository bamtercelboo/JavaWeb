<%@page import="net.sf.json.JSONArray"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp" %>
<%  //获取总记录数
  int total_count = 0;
  //每页显示的数量
  int PAGE_SIZE = 5;
  int curr_page = 1;
  String page1 = request.getParameter("page");
  if ( page1 != null ) {
    curr_page = Integer.parseInt(page1);
  }
  Connection conn = null;
  List<Map<String, String>> data = new ArrayList<>();
  try {
    //连接数据库
    conn = getConnection();
    //sql语句
    String sql = "SELECT * FROM nccp_books";
    String sql_count = "SELECT count(*) all_count  FROM nccp_books";
    //拼接sql语句 添加到list中
    List<String> param_values = new ArrayList<>();
    String where = "";
    where = buildQueryWhere(param_values, request, where, "name", "name", "LIKE");
    where = buildQueryWhere(param_values, request, where, "status", "status", "=");
    where = buildQueryWhere(param_values, request, where, "isbn", "isbn", "=");
    where = buildQueryWhere(param_values, request, where, "publish", "publish", "=");
    where = buildQueryWhere(param_values, request, where, "minprice", "price", ">=");
    where = buildQueryWhere(param_values, request, where, "maxprice", "price", "<=");
    where = buildQueryWhere(param_values, request, where, "author", "author", "=");
    where = buildQueryWhere(param_values, request, where, "author_sex", "author_sex", "=");
    if ( where.length() > 0 ) {
      sql = sql + " WHERE " + where;
      sql_count = sql_count + " WHERE " + where;
    }
    sql = sql + "  ORDER BY modified DESC ";
    //获取总记录数
    total_count = queryCount(conn, sql_count, param_values);
    System.out.println("totall_count " + total_count);
    sql = sql + " LIMIT " + (curr_page - 1) * PAGE_SIZE + "," + PAGE_SIZE;
    //执行sql语句，获取返回结果值
    data = query(conn, sql, param_values);
    Map<String, Object> ret = new HashMap<>();
    ret.put("rows", data);
    ret.put("count", total_count);
    out.print(JSONArray.fromObject(ret));
  } catch ( Exception e ) {
    e.printStackTrace();
  } finally {
    try { conn.close(); } catch ( Exception e ) { }
  }
%>