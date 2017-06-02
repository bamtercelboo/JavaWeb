<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>修改用户</title>
    <link href="/mavenweb/css/book.css" rel="stylesheet" type="text/css"/>
    <script src="/mavenweb/js/book.js" type="text/javascript"></script>
    <script src="/mavenweb/js/jquery-3.2.0.js" type="text/javascript"></script>
    <script src="/mavenweb/js/jquery.min.js" type="text/javascript"></script>
  </head>
  <body>
    <form method="post" action="book/editup/${book.id}" onsubmit="return validate_info();">
      <fieldset style="width:330px; margin:0px auto">
        <legend align="center">修改用户</legend>
        <p>
          <label align="right">书名：</label>
          <input type="text" name="name" value="${book.name}"/>
        </p>
        <p>
          <label>状态：</label>
          <input type="radio" name="status" value="0" <c:if test="${book.status.index == 0}">checked</c:if> ><label>下架</label>
          <input type="radio" name="status" value="1" <c:if test="${book.status.index == 1}">checked</c:if> ><label>在售</label>
        </p>
        <p>
          <label>类型：</label>
          <input type="checkbox" name="type" value="武侠" <c:if test='${book.type.contains("武侠")}'>checked</c:if> ><label>武侠</label>
          <input type="checkbox" name="type" value="言情" <c:if test='${book.type.contains("言情")}'>checked</c:if> ><label>言情</label>
          <input type="checkbox" name="type" value="校园" <c:if test='${book.type.contains("校园")}'>checked</c:if> ><label>校园</label>
          <input type="checkbox" name="type" value="经典" <c:if test='${book.type.contains("经典")}'>checked</c:if> ><label>经典</label>
        </p>
        <p>
          <label align="right">ISBN：</label>
          <input type="text" name="isbn" value="${book.isbn}"/>
        </p>
        <p>
          <label align="right">出版社：</label>
          <input type="text" name="publish" value="${book.publish}"/>
        </p>
        <p>
          <label>价格：</label>
          <input type="text" name="price" value="${book.price}"/>
        </p>
        <p>
          <label>作者：</label>
          <input type="text" name="author_name" value="${book.authorname}"/>
        </p>
        <p>
          <label>年龄：</label>
          <input type="text" name="author_age" value="${book.authorage}"/>
        </p>
        <p>
          <label>性别：</label>
          <input type="radio" name="gender" value="0" <c:if test="${book.authorsex.index == 0}">checked</c:if> ><label>男</label>
          <input type="radio" name="gender" value="1" <c:if test="${book.authorsex.index == 1}">checked</c:if> ><label>女</label>
        </p>
        <p>
          <label>备注:</label>
          <textarea name="memo" rows="4" cols="15">${book.memo}</textarea>
        </p>
        <p id="buttons" align="center">
          <input id="submit" type="submit" value="提交"/>
        </p>
      </fieldset>
    </form>
  </body>
</html>