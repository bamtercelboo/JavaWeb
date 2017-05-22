<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%  Connection conn = null;
  try {
    //获取文本框的值
    String name = request.getParameter("name");
    String status = request.getParameter("status");
    String pptype = request.getParameter("type");
    String isbn = request.getParameter("isbn");
    String publish = request.getParameter("publish");
    String price = request.getParameter("price");
    String author_id = request.getParameter("author_id");
    String memo = request.getParameter("memo");
    if ( memo == null ) {
      memo = "";
    }
    String date_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); //获取系统时间   
    //执行操作
    conn = getConnection();
    String sql = "INSERT INTO nccp_books (`name`,`status`,`type`,`isbn`,`publish`,`price`,`author_id`,`modified`,`created`,`memo`) VALUES (?,?,?,?,?,?,?,?,?,?)";
    //添加参数到list
    String validateresult = book_formvalidate(request);
    if( validateresult.trim().length() == 0 ){
    List<String> list = new ArrayList<>();
    list.add(name);
    System.out.println("status " + status);
    if( status.equals("1") || status.equals("0") ){
      list.add(status);
    }else{
      throw new Exception("状态不合理");
    }
    list.add(pptype);
    list.add(isbn);
    list.add(publish);
    if( isNumber(price) ){
      list.add(price);
    }else{
      throw new Exception("价格不合理");
    }
    list.add(author_id);
    System.out.println("className.methodName() "+author_id );
    //created 和 modified
    list.add(date_time);
    list.add(date_time);
    list.add(memo);
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


