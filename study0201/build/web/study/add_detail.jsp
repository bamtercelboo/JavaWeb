<%-- 
    Document   : add_detail
    Created on : 2017-4-12, 18:47:56
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
  </head>
  <body>
  <center>
    <form  action="add_function.jsp" name="add_form"  onsubmit="return validate_add_info(this);" method="post">
      书本名称：
      <input type="text" name="name"/>
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
      <input type="text" name="isbn"/>
      <br>
      出版社：
      <input type="text" name="publish"/>
      <br>
      书本价格：
      <input type="text" name="price"/>
      <br>
      作者：
      <input type="text" name="author"/>
      <br>
      作者性别：
      <select name="author_sex">
        <option   value ="">请选择</option>
        <option  value ="m">男</option>
        <option  value ="f">女</option>
      </select>
      <br>
      备注：
      <textarea name="memo" cols=40 rows=4></textarea>
      <br>
      <input type="submit" name="add" id="add_button" value="插入">
      <br><br>
    </form>
    <script type="text/javascript">
      //添加信息表单验证
      function validate_add_info(add_form)
      {
        if (add_form.name.value == "")
        {
          alert("请输入名称");
          return false;
        }
        if (add_form.isbn.value == "")
        {
          alert("请输入ISBN");
          return false;
        }
        if (add_form.publish.value == "")
        {
          alert("请输入出版社");
          return false;
        }
        if (add_form.price.value == "")
        {
          alert("请输入书本价格");
          return false;
        }
        if (!isNumber(add_form.price.value))
        {
          alert("书本价格,请输入数字");
          return false;
        }
        if (add_form.author.value == "")
        {
          alert("请输入作者");
          return false;
        }
        if (add_form.author_sex.value == "")
        {
          alert("请输入作者性别");
          return false;
        }
      }
      function isNumber(str)          // 判断是否为非负整数  
      {
        var rx = /^[.0-9]+$/;
        return rx.test(str);
      }
    </script> 
  </center>
</body>
</html>
