<%@page import="net.sf.json.JSONArray"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp" %>
<%  //获取总记录数
  int total_count = 0;
  //每页显示的数量
  int PAGE_SIZE = 6;
  int curr_page = 1;
  String page1 = request.getParameter("page");
  if ( page1 != null ) {
    curr_page = Integer.parseInt(page1);
  }
  //标题排序字段
  String sortcolname = request.getParameter("sortcolname");
  String sortkey = request.getParameter("sortkey");
  System.out.println("className.methodName()  "+sortkey+" "+sortcolname);
  Connection conn = null;
  List<Map<String, String>> data = new ArrayList<>();
  try {
    //连接数据库
    conn = getConnection();
    //sql语句
    String sql = "SELECT * FROM nccp_authors ";
    String sql_count = "SELECT count(*) all_count FROM nccp_authors ";
    //拼接sql语句 添加到list中
    List<String> param_values = new ArrayList<>();
    String where = "";
    where = buildQueryWhere(param_values, request, where, "name", "name", "LIKE");
    where = buildQueryWhere(param_values, request, where, "minage", "author_age", ">=");
    where = buildQueryWhere(param_values, request, where, "maxage", "author_age", "<=");
    where = buildQueryWhere(param_values, request, where, "authorsex", "author_sex", "=");
    if ( where.length() > 0 ) {
      sql = sql + " WHERE " + where;
      sql_count = sql_count + " WHERE " + where;
    }
    String sort = "";
    if( (sortcolname == null) || (sortcolname == "") || (sortkey == null) || (sortkey == "") ){
      sort = " ORDER BY author_modified DESC ";
      sql = sql + sort;
    } else {
      sort = " ORDER BY "+sortcolname+" "+sortkey;
    }
    //获取总记录数
    total_count = queryCount(conn, sql_count, param_values);
    System.out.println("totall_count " + total_count);
    if( (sortcolname == null) || (sortcolname == "") || (sortkey == null) || (sortkey == "") ){
      sql = sql + " LIMIT " + (curr_page - 1) * PAGE_SIZE + "," + PAGE_SIZE;
    } else {
      sql = "SELECT  t.* FROM ( " + sql + " ORDER BY author_modified DESC LIMIT " + (curr_page - 1) * PAGE_SIZE + "," + PAGE_SIZE + " )  AS t"+sort;
    }
    //执行sql语句，获取返回结果值
    data = query(conn, sql, param_values);
    System.out.println("data "+data);
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