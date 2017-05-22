<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  Connection conn = null;
  try {
   String authorname = request.getParameter("authorname");
    String authorsex = request.getParameter("authorsex");
    String authorage = request.getParameter("authorage");
    String authormemo = request.getParameter("authormemo");
    //连接数据库
    conn = getConnection();
    String sql = "UPDATE nccp_authors ";
    String set = "";
    List<String> param_values = new ArrayList<>();
    String id = request.getParameter("id");
    //拼接SQL语句  true代表取出来是数组，需要另行处理
    String validateresult = formvalidate(request);
    if ( validateresult.trim().length() == 0 ) {
      set = buildUpdateSet(param_values, request, set, "authorname", "name", false);
      if ( authorsex.equals("f") || authorsex.equals("m") ) {
        set = buildUpdateSet(param_values, request, set, "authorsex", "author_sex", false);
      } else {
        throw new Exception("性别不合理");
      }
      set = buildUpdateSet(param_values, request, set, "authorage", "author_age", false);
      set = buildUpdateSet(param_values, request, set, "authormemo", "memo", false);
      System.out.println(set);
      if ( set.length() > 0 ) {
        sql = sql + " SET " + set +" WHERE au_id = '" + id + "'";
      }
      System.out.println("update " + sql);
      //添加参数到list
      int result = execupdate(conn, sql, param_values);
      out.print(result);
    } else {
      out.print(validateresult);
    }
  } catch ( Exception e ) {
    out.print(e.getMessage());
    System.out.println(e.getMessage());
  } finally {
    try { conn.close();} catch ( Exception e ) { }
  }
%>