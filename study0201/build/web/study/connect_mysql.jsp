<%-- 
    Document   : connect_mysql
    Created on : 2017-4-11, 9:11:11
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.*" %>
<%@page import="java.sql.DriverManager" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
  </head>
  <body>
    <%
      request.setCharacterEncoding("UTF-8");
      String driverClass = "com.mysql.jdbc.Driver";
      String url = "jdbc:mysql://localhost:3306/study02";
      String user = "root";
      String password = "mysql";
      Connection conn;
      Class.forName(driverClass);
      conn = DriverManager.getConnection(url, user, password);
    %>
  </body>
</html>
