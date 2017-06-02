<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>添加用户</title>
    <link href="/mavenweb/css/book.css" rel="stylesheet" type="text/css"/>
    <script src="/mavenweb/js/book.js" type="text/javascript"></script>
    <script src="/mavenweb/js/jquery-3.2.0.js" type="text/javascript"></script>
    <script src="/mavenweb/js/jquery.min.js" type="text/javascript"></script>
  </head>
  <body>
    <form method="post" action="book/addup" onsubmit="return validate_info();">
       <fieldset style="width:330px; margin:0px auto">
         <legend align="center">增加用户</legend>
        <p>
          <label>书名：</label>
          <input type="text" name="name"/>
        </p>
        <p>
          <label>状态：</label>
          <input type="radio" name="status" value="0" checked >下架
          <input type="radio" name="status" value="1" >在售
        </p>
        <p>
          <label>类型：</label>
          <input type="checkbox" name="type" value="武侠" checked >武侠
          <input type="checkbox" name="type" value="言情"  >言情
          <input type="checkbox" name="type" value="校园"  >校园
          <input type="checkbox" name="type" value="经典"  >经典
        </p>
        <p>
          <label>ISBN：</label>
          <input type="text" name="isbn"/>
        </p>
        <p>
          <label class="label" float="right">出版社：</label>
          <input type="text" name="publish"/>
        </p>
        <p>
          <label class="label" float="right">价格：</label>
          <input type="text" name="price"/>
        </p>
        <p>
          <label>作者：</label>
          <input type="text" name="author_name"/>
        </p>
        <p>
          <label>年龄：</label>
          <input type="text" name="author_age"/>
        </p>
        <p>
          <label>性别：</label>
          <input type="radio" name="gender" value="0" checked >男
          <input type="radio" name="gender" value="1" >女
        </p>
        <p>
          <label>备注：</label>
          <textarea name="memo"></textarea>
        </p>
        <p id="buttons" align="center">
          <input id="submit" type="submit" value="提交">
          <input id="reset" type="reset" value="清空">
        </p>
      </fieldset>
    </form>
  </body>
</html>