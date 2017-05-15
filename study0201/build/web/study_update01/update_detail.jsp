<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%
  //从修改超链接传输参数
  String ID = request.getParameter("id");
  Connection conn = null;
  Map<String, String> data = new HashMap<String, String> ();
  try
  {
    //连接数据库
	  conn = getConnection();
    String sql = "SELECT * FROM nccp_books WHERE id = ?";
    List<String> list = new ArrayList<>();
    list.add(ID);
    data = querySingleRow(conn, sql, list );
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
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>修改书本信息</title>
    <script src="jquery-3.2.0.js"></script>
    <script src="button.js" type="text/javascript"></script>
  </head>
  <body>
  <center>
    <form  action="update_function.jsp?id=<%=ID%>" name="update_form"  onsubmit="return validate_info();" method="post">
      <input type="hidden" name="created" value="<%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime())%>"/>
      <table border="1" bordercolor="#000000" style="border-collapse:collapse;" cellpadding="5">
        <tr>
           <th colspan="2">书本信息</th>
        </tr>
        <tr>
          <td>名称：</td> 
          <td><input type="text" name="name" value="<%=data.get("name")%>" style="width:250px;"/></td>
        </tr>
        <tr>
          <td>状态：</td>
          <td><input type="radio" name="status" value="1" <%=data.get("status").equals("1")?"checked":""%>/>在售(1)<input type="radio" name="status" value="0"<%=data.get("status").equals("0")?"checked":""%> />下架(0)</td>
        </tr>
        <tr>
      <td>类型：</td>
      <td id="type"> 
       <input type="checkbox" name="type" value="武侠" <%=data.get("type").contains("武侠")?"checked":""%>>武侠&nbsp;
      <input type="checkbox" name="type" value="言情" <%=data.get("type").contains("言情")?"checked":""%>>言情&nbsp;
      <input type="checkbox" name="type" value="校园" <%=data.get("type").contains("校园")?"checked":""%>>校园&nbsp;
      <input type="checkbox" name="type" value="经典" <%=data.get("type").contains("经典")?"checked":""%>/>经典
      </td>
      </tr>
      <tr>
        <td>ISBN：</td>
        <td><input type="text" name="isbn" value="<%=data.get("isbn")%>" style="width:250px;"/></td>
      </tr>
      <tr>
      <td>出版社：</td>
      <td><input type="text" name="publish" value="<%=data.get("publish")%>" style="width:250px;"/></td>
      </tr>
      <tr>
        <td>价格：</td>
        <td><input type="text" name="price" value="<%=data.get("price")%>" style="width:250px;"/></td>
      </tr>
      <tr>
        <td>作者：</td>
        <td><input type="text" name="author" value="<%=data.get("author")%>" style="width:250px;"/></td>
      </tr>
      <tr>
        <td>性别：</td>
        <td><select name="author_sex">
        <option   value="">请选择</option>
        <option  value ="m" <%=data.get("author_sex").equals("m")?"selected":""%>>男</option>
        <option  value ="f" <%=data.get("author_sex").equals("f")?"selected":""%>>女</option>
      </select>
        </td>
      </tr>
      <tr>
        <td>备注：</td>
        <td><textarea name="memo" cols=40 rows=4 style="width:250px;" wrap="physical"><%=data.get("memo")%></textarea></td>
      </tr>
      <tr>
        <td colspan="2" align = "center">
          <input type="submit" name="update" id="update_button" value="确认修改">
        </td>
      </tr>
      </table>
    </form>
  </center>
</body>
</html>
