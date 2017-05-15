<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%
  Connection conn = null;
  try
  {
    //连接数据库
	  conn = getConnection();
    String sql = "UPDATE nccp_books ";
    String where = "";
     List<String> param_values = new ArrayList<>();
     String id = request.getParameter("id");
     //拼接SQL语句  true代表取出来是数组，需要另行处理
    where = buildUpdateSet(param_values,request, where, "name", "name", false);
    where = buildUpdateSet(param_values,request, where, "status", "status", false);
    where = buildUpdateSet(param_values,request, where, "type", "type", true);
    where = buildUpdateSet(param_values,request, where, "isbn", "isbn", false);
    where = buildUpdateSet(param_values,request, where, "publish", "publish", false);
    where = buildUpdateSet(param_values,request, where, "price", "price", false);
    where = buildUpdateSet(param_values,request, where, "author", "author", false);
    where = buildUpdateSet(param_values,request, where, "author_sex", "author_sex", false);
    where = buildUpdateSet(param_values,request, where, "created", "created", false);
    where = buildUpdateSet(param_values,request, where, "memo", "memo", false);
    System.out.println(where);
    if( where.length() > 0 )
    {
      sql = sql + " SET " + where +" WHERE id = '" + id + "'";
    }
    System.out.println("update "+sql);
    //添加参数到list
    int result = execupdate( conn, sql, param_values );
    if( result > 0 )
    {
      response.sendRedirect("index.jsp");
    }
    else
    {
      response.sendRedirect("error.jsp");
    }
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
  finally
  {
    try{ conn.close(); }catch(Exception e){ }
  }
%>