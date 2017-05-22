<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  Connection conn = null;
  try {
    //获取文本框的值
    String authorname = request.getParameter("authorname");
    String authorsex = request.getParameter("authorsex");
    String authorage = request.getParameter("authorage");
    String authormemo = request.getParameter("authormemo");
    if ( authormemo == null ) {
      authormemo = "";
    }
    //执行操作
    conn = getConnection();
    String sql = "INSERT INTO nccp_authors (`name`,`author_sex`,`author_age`,`memo`) VALUES (?,?,?,?)";
    //添加参数到list
    String validateresult = formvalidate(request);
    if( validateresult.trim().length() == 0 ){
    List<String> list = new ArrayList<>();
    list.add(authorname);
    if( authorsex.equals("f") || authorsex.equals("m") ){
      list.add(authorsex);
    }else{
      throw new Exception("性别不合理");
    }
    list.add(authorage);
    list.add(authormemo);
    //执行
    int result = execupdate(conn, sql, list);
    out.print(result);
    }else{
      out.print(validateresult);
    }
  } catch ( Exception e ) {
    out.print(e.getMessage());
    System.out.println(e.getMessage());
  } finally {
    try { conn.close();} catch ( Exception e ) { }
  }
%>


