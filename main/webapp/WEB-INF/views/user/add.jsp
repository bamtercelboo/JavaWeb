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
  </head>
  <body>
    <form method="post" action="user/addup">
      <fieldset>
        <legend>添加用户</legend>
        <p>
          <label>姓名:</label>
          <input type="text" name="name"/>
        </p>
        <p>
          <label>密码:</label>
          <input type="password" name="password"/>
        </p>
        <p>
          <label>性别:</label>
          <input type="radio" name="gender" value="0" checked><label>男</label>
          <input type="radio" name="gender" value="1"><label>女</label>
        </p>
        <p>
          <label>生日:</label>
          <input type="text" name="birthday"/>
        </p>
        <p>
          <label>薪水:</label>
          <input type="text" name="salary"/>
        </p>
        <p>
          <label>备注:</label>
          <textarea name="memo"></textarea>
        </p>
        <p id="buttons">
          <input id="reset" type="reset" value="重置">
          <input id="submit" type="submit" value="提交">
        </p>
      </fieldset>
    <form>
  </body>
</html>