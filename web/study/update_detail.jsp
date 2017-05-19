<%-- 
    Document   : update_detail
    Created on : 2017-4-13, 14:00:45
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
    <%      //从修改超链接传输参数
      String ID = request.getParameter("id");
    %>
    <%
      try
      {
        //根据ID查询数据库，填写表单
        Statement stat = conn.createStatement();
        String sql = "select * from nccp_books where id='" + ID + "'";
        out.println(sql);
        ResultSet rs = stat.executeQuery(sql);
        while ( rs.next() )
        {
    %>
  <center>
    <form  action="update_function.jsp?id=<%=ID%>" name="update_form"  onsubmit="return validate_update_info(this);" method="post">
      书本名称：
      <input type="text" name="name" value="<%=rs.getString("name")%>"/>
      <br>
      书本状态：
      <input type="radio" name="status" value="1" checked="checked"/>在售(1)<input type="radio" name="status" value="0" id="status"/>下架(0)
      <br>
      书本类型：
      <input type="checkbox" name="type" value="武侠"/>武侠&nbsp;
      <input type="checkbox" name="type" value="言情"/>言情&nbsp;
      <input type="checkbox" name="type" value="校园"/>校园&nbsp;
      <input type="checkbox" name="type" value="经典"/>经典
      <br>
      ISBN：
      <input type="text" name="isbn" value="<%=rs.getString("isbn")%>"/>
      <br>
      出版社：
      <input type="text" name="publish" value="<%=rs.getString("publish")%>"/>
      <br>
      书本价格：
      <input type="text" name="price" value="<%=rs.getString("price")%>"/>
      <br>
      作者：
      <input type="text" name="author" value="<%=rs.getString("author")%>"/>
      <br>
      作者性别：
      <select name="author_sex">
        <option   value="">请选择</option>
        <option  value ="m">男</option>
        <option  value ="f">女</option>
      </select>
      <br>
      备注：
      <textarea name="memo" cols=40 rows=4><%=rs.getString("memo")%></textarea>
      <br>
      <input type="submit" name="update" id="update_button" value="确认修改">
      <br><br>
    </form>
    <script type="text/javascript">
      //修改信息表单验证
      function validate_update_info(update_form)
      {
        if (update_form.name.value == "")
        {
          alert("请输入名称");
          return false;
        }
        if (update_form.isbn.value == "")
        {
          alert("请输入ISBN");
          return false;
        }
        if (update_form.publish.value == "")
        {
          alert("请输入出版社");
          return false;
        }
        if (update_form.price.value == "")
        {
          alert("请输入书本价格");
          return false;
        }
        if (!isNumber(update_form.price.value))
        {
          alert("书本价格,请输入数字");
          return false;
        }
        if (update_form.author.value == "")
        {
          alert("请输入作者");
          return false;
        }
        if (update_form.author_sex.value == "")
        {
          alert("请输入作者性别");
          return false;
        }
      }
      function isNumber(str)          // 判断是否为非负整数  
      {
        //验证价钱
        var rx = /^[.0-9]+$/;
        return rx.test(str);
      }
    </script> 
  </center>
  <%
      }
    } catch ( Exception e )
    {
    }
  %>
</body>
</html>
