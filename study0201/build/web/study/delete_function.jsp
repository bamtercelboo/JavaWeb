<%-- 
    Document   : delete_function
    Created on : 2017-4-13, 16:05:12
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
  </head>
  <body>
    <%      //获取index传输过来的CheckBox值  checkbox中的value设置成id
      String id = request.getParameter("id");
      Statement stmt = conn.createStatement();
      StringBuffer sql = new StringBuffer();
      //拼接sql语句  id字符串包含了所有的id  
      //sql语句用in
      sql.append("delete from nccp_books where id in( ");
      sql.append(id.toString());
      sql.append(")");
      try
      {
        boolean flag = stmt.execute(sql.toString());
        if ( !flag )
        {
          out.print("<script>alert('恭喜你，删除成功！');window.location='index.jsp';</script>");
        } else
        {
          out.print("<script>alert('很抱歉，删除失败！');window.location='index.jsp';</script>");
        }
        stmt.close();
      } catch ( Exception e )
      {
        out.print("<script>alert('很抱歉，删除失败！');window.location='index.jsp';</script>");
      }
    %>
  </body>
</html>
