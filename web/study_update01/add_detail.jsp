<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>增加书本信息</title>
    <script src="jquery-3.2.0.js"></script>
    <script src="button.js" type="text/javascript"></script>
  </head>
  <body>
  <center>
    <form  action="add_function.jsp" name="add_form" method="post" id="form" onsubmit="return validate_info();">
      <input type="hidden" name="created" value="<%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime())%>"/>
      <table border="1" bordercolor="#000000" style="border-collapse:collapse;" cellpadding="5">
         <tr>
           <th colspan="2">书本信息</th>
        </tr>
        <tr>
          <td>名称：</td>
          <td><input type="text" name="name" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>状态：</td>
          <td><input type="radio" name="status" value="1" checked="checked"/>在售(1)<input type="radio" name="status" value="0" id="status"/>下架(0)</td>
        </tr>
        <tr>
          <td>类型：</td>
          <td><input type="checkbox" name="type" value="武侠"/>武侠&nbsp;
            <input type="checkbox" name="type" value="言情"/>言情&nbsp;
            <input type="checkbox" name="type" value="校园"/>校园&nbsp;
            <input type="checkbox" name="type" value="经典"/>经典
          </td>
        </tr>
        <tr>
          <td>ISBN：</td>
          <td><input type="text" name="isbn" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>出版社：</td>
          <td><input type="text" name="publish" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>价格：</td>
          <td><input type="text" name="price" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>作者：</td>
          <td><input type="text" name="author" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>性别：</td>
          <td> <select name="author_sex">
              <option   value ="">请选择</option>
              <option  value ="m">男</option>
              <option  value ="f">女</option>
            </select>
          </td>
        </tr>
        <tr>
          <td>备注：</td>
          <td><textarea name="memo" cols=20 rows=4 style="width: 250px"></textarea></td>
        </tr>
        <tr>
          <td colspan="2" align = "center">
            <input type="submit" value="插入" id="add_button"  />
          </td>
        </tr>
      </table>
    </form>
  </center>
</body>
</html>
