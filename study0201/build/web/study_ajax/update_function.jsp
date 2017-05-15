<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  Connection conn = null;
  try {
    String status = request.getParameter("status");
    String author_sex = request.getParameter("author_sex");
    String price = request.getParameter("price");
    //连接数据库
    conn = getConnection();
    String sql = "UPDATE nccp_books ";
    String set = "";
    List<String> param_values = new ArrayList<>();
    String id = request.getParameter("id");
    String date_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); //获取系统时间   
    //拼接SQL语句  true代表取出来是数组，需要另行处理
    String validateresult = formvalidate(request);
    if ( validateresult.trim().length() == 0 ) {
      set = buildUpdateSet(param_values, request, set, "name", "name", false);
      if ( status.equals("1") || status.equals("0") ) {
        set = buildUpdateSet(param_values, request, set, "status", "status", false);
      } else {
        throw new Exception("状态只能是0或者1");
      }
      set = buildUpdateSet(param_values, request, set, "type", "type", true);
      set = buildUpdateSet(param_values, request, set, "isbn", "isbn", false);
      set = buildUpdateSet(param_values, request, set, "publish", "publish", false);
      if ( isNumber(price) ) {
        set = buildUpdateSet(param_values, request, set, "price", "price", false);
      } else {
        throw new Exception("价格不合理");
      }
      set = buildUpdateSet(param_values, request, set, "author", "author", false);
      if ( author_sex.equals("f") || author_sex.equals("m") ) {
        set = buildUpdateSet(param_values, request, set, "author_sex", "author_sex", false);
      } else {
        throw new Exception("作者性别不合理");
      }
      set = buildUpdateSet(param_values, request, set, "memo", "memo", false);
      System.out.println(set);
      if ( set.length() > 0 ) {
        sql = sql + " SET " + set + " ,modified = '" + date_time + "' WHERE id = '" + id + "'";
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