<%@page import="net.sf.json.JSONArray"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp" %>
<%  //获取总记录数
  int total_count = 0;
  //每页显示的数量
  int PAGE_SIZE = 15;
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
    String sql = "SELECT b.*, a.au_id, a.author_age, a.author_created, a.author_modified, a.author_sex, a.au_id auhtorid, b.id bookid, a.name author_name, b.name book_name, a.memo author_memo, b.memo book_memo FROM nccp_authors a,nccp_books b ";
    //String sql = "SELECT a.* ,b.*, a.au_id auhtorid, b.id bookid, a.name author_name, b.name book_name, a.memo author_memo, b.memo book_memo FROM nccp_authors a,nccp_books b ";
    String sql_count = "SELECT count(*) all_count FROM nccp_authors a,nccp_books b ";
    //拼接sql语句 添加到list中
    List<String> param_values = new ArrayList<>();
    String where = "WHERE a.au_id = b.author_id ";
    where = buildQueryWhere(param_values, request, where, "name", "b.name", "LIKE");
    where = buildQueryWhere(param_values, request, where, "status", "b.status", "=");
    where = buildQueryWhere(param_values, request, where, "isbn", "b.isbn", "=");
    where = buildQueryWhere(param_values, request, where, "publish", "b.publish", "=");
    where = buildQueryWhere(param_values, request, where, "minprice", "b.price", ">=");
    where = buildQueryWhere(param_values, request, where, "maxprice", "b.price", "<=");
    where = buildQueryWhere(param_values, request, where, "author", "a.name", "=");
    where = buildQueryWhere(param_values, request, where, "author_sex", "a.author_sex", "=");
    if ( where.length() > 0 ) {
      sql = sql + where;
      sql_count = sql_count + where;
    }
    String sort = "";
    if( (sortcolname == null) || (sortcolname == "") || (sortkey == null) || (sortkey == "") ){
      sort = " ORDER BY modified DESC ";
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
      sql = "SELECT  t.* FROM ( " + sql + " ORDER BY modified DESC LIMIT " + (curr_page - 1) * PAGE_SIZE + "," + PAGE_SIZE + " )  AS t"+sort;
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