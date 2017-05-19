<%-- 
    Document   : add——detail.jsp
    Created on : 2017-4-12, 15:56:58
    Author     : Administrator
--%>
<%@page import="java.awt.SystemColor"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.text.*"%> 
<!DOCTYPE html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>JSP Page</title>
</head>
<body>
  <%    //获取文本框的值
    String id = request.getParameter("id");
    String name = new String(request.getParameter("name").getBytes("iso-8859-1"), "utf-8");
    String status = request.getParameter("status");
    String[] type = request.getParameterValues("type");
    StringBuffer stype = new StringBuffer();
    String pptype = "";
    if ( type != null ) {
      for ( int i = 0; i < type.length; i++ ) {
        if ( i < type.length - 1 ) {
          stype.append(type[i] + ",");
        } else {
          stype.append(type[i]);
        }
      }
      pptype = new String(stype.toString().getBytes("iso-8859-1"), "utf-8");
    } else {
      pptype = "";
    }
    String isbn = new String(request.getParameter("isbn").getBytes("iso-8859-1"), "utf-8");
    String publish = new String(request.getParameter("publish").getBytes("iso-8859-1"), "utf-8");
    String price = request.getParameter("price");
    String author = new String(request.getParameter("author").getBytes("iso-8859-1"), "utf-8");
    String author_sex = request.getParameter("author_sex");
    String memo = new String(request.getParameter("memo").getBytes("iso-8859-1"), "utf-8");
    if ( memo == null ) {
      memo = "";
    }
    String date_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); //获取系统时间 
    Statement stmt = conn.createStatement();
    StringBuffer sql = new StringBuffer();
    //根据ID执行操作
    sql.append("update nccp_books set name='" + name + "',status='" + status + "',type='" + pptype + "' ,isbn='" + isbn + "' ,publish='" + publish + "'"
            + ",price='" + price + "',author='" + author + "',author_sex='" + author_sex + "',created='" + date_time + "',memo='" + memo + "'  where id = '" + id + "'");;
    try {
      boolean flag = stmt.execute(sql.toString());
      if ( !flag ) {
        out.print("<script>alert('恭喜你，修改成功！');window.location='index.jsp';</script>");
      } else {
        out.print("<script>alert('很抱歉，修改失败！');window.location='index.jsp';</script>");
      }
      stmt.close();
    } catch ( Exception e ) {
      out.print("<script>alert('很抱歉，修改失败！');window.location='index.jsp';</script>");
    }
  %>
</body>



