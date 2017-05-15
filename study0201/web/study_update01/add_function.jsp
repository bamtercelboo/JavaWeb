<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%
  Connection conn = null;
  try
  {
    //获取文本框的值
    String name = request.getParameter("name");
    String status = request.getParameter("status");
    String[] type = request.getParameterValues("type");
    StringBuffer stype = new StringBuffer();
    String pptype = "";
    if ( type != null )
    {
      for ( int i = 0; i < type.length; i++ )
      {
        if ( i < type.length - 1 )
        {
          stype.append(type[i] + ",");
        } else
        {
          stype.append(type[i]);
        }
      }
      pptype = stype.toString();
    } else
    {
      pptype = "";
    }
    String isbn = request.getParameter("isbn");
    String publish = request.getParameter("publish");
    String price = request.getParameter("price");
    String author = request.getParameter("author");
    String author_sex = request.getParameter("author_sex");
    String memo = request.getParameter("memo");
    if ( memo == null )
    {
      memo = "";
    }
    String date_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime()); //获取系统时间   
    //执行操作
	  conn = getConnection();
    String sql = "INSERT INTO nccp_books (`name`,`status`,`type`,`isbn`,`publish`,`price`,`author`,`author_sex`,`created`,`memo`) VALUES (?,?,?,?,?,?,?,?,?,?)";
    //添加参数到list
    List<String> list = new ArrayList<>();
    list.add(name);
    list.add(status);
    list.add(pptype);
    list.add(isbn);
    list.add(publish);
    list.add(price);
    list.add(author);
    list.add(author_sex);
    list.add(date_time);
    list.add(memo);
    //执行
    int result = execupdate(conn, sql, list );
    if( result > 0 ){
      response.sendRedirect("index.jsp");
    }
    else{
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
 

