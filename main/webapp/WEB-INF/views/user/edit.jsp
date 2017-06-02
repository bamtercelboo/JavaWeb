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
  </head>
  <body>
    <form method="post" action="user/editup/${user.id}">
      <fieldset>
        <legend>修改用户</legend>
        <p>
          <label>姓名:</label>
          <input type="text" name="name" value="${user.name}"/>
        </p>
        <p>
          <label>密码:</label>
          <input type="password" name="password" value="${user.password}"/>
        </p>
        <p>
          <label>性别:</label>
          <input type="radio" name="gender" value="0" <c:if test="${user.gender.index == 0}">checked</c:if> ><label>男</label>
          <input type="radio" name="gender" value="1" <c:if test="${user.gender.index == 1}">checked</c:if> ><label>女</label>
        </p>
        <p>
          <label>生日:</label>
          <input type="text" name="birthday" value="${user.birthday}"/>
        </p>
        <p>
          <label>薪水:</label>
          <input type="text" name="salary" value="${user.salary}"/>
        </p>
        <p>
          <label>备注:</label>
          <textarea name="memo">${user.memo}</textarea>
        </p>
        <p id="buttons">
          <input id="submit" type="submit" value="提交">
        </p>
      </fieldset>
    <form>
  </body>
</html>