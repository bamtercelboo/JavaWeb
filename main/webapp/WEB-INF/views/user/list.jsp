<%@ page language="java" import="java.util.*, com.nccp.utils.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
  
  int start = (Integer)request.getAttribute( "start" );
  int num = (Integer)request.getAttribute( "num" );
  long total_count = (Long)request.getAttribute( "user_count" );
  
  String name = ParamUtils.getAttribute( request, "name" );
  if( name == null ) name = "";
  String gender = ParamUtils.getAttribute( request, "gender" );
  if( gender == null ) gender = "-";
  String salary_from = ParamUtils.getAttribute( request, "salary_from" );
  if( salary_from == null ) salary_from = "";
  String salary_to = ParamUtils.getAttribute( request, "salary_to" );
  if( salary_to == null ) salary_to = "";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>用户列表</title>
  </head>
  <body>
    <h1>用户查询</h1>
    <form action="book/list" method="post">
      姓名: <input type="text" name="name" value="<%=name%>" style="width: 70px;"/>
      性别: <select name="gender" style="width: 70px;">
        <option value="-" <%=gender.equals("-") ? "selected" : ""%> >不限</option>
        <option value="0" <%=gender.equals("0") ? "selected" : ""%> >男</option>
        <option value="1" <%=gender.equals("1") ? "selected" : ""%> >女</option>
      </select>
      薪水: <input type="text" name="salary_from" value="<%=salary_from%>" style="width: 70px;"/> 至 <input type="text" name="salary_to" value="<%=salary_to%>" style="width: 70px;"/>
      <input type="submit" value="查询"/><input type="reset" value="重置"/>
    </form>
    <hr/>
    <h1>查询到 ${user_count} 个用户, 当前显示 <%=(start+1)%> 至 <%=(start+num)%> 条记录 </h1>
    <table border="1" cellpadding="10" cellspacing="0">
      <tr>
        <th>ID</th>
        <th>姓名</th>
        <th>性别</th>
        <th>生日</th>
        <th>薪水</th>
        <th>备注</th>
        <th>版本</th>
        <th><a href="user/add">添加</a></th>
      </tr>
      <c:forEach items="${users}" var="user">
        <tr>
          <td>${user.id }</td>
          <td>${user.name }</td>
          <td>${user.gender.name }</td>
          <td>${user.birthday }</td>
          <td>${user.salary }</td>
          <td>${user.memo }</td>
          <td>${user.version }</td>
          <td><a href="user/edit/${user.id}">修改</a>&nbsp;&nbsp;<a href="user/delete/${user.id}">删除</a></td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="8" align="center">
          <a href="user/list?start=0&num=<%=num%>">首页</a>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <a href="user/list?start=<%=(start > num) ? (start - num) : 0%>&num=<%=num%>">上一页</a>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <a href="user/list?start=<%=(((start + num) < total_count) ? (start + num) : start )%>&num=<%=num%>">下一页</a>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <a href="user/list?start=<%=( (total_count % num) == 0 ) ? (total_count - num ) : (total_count - (total_count % num))%>&num=<%=num%>">尾页</a>
        </td>
      </tr>
    </table>
  </body>
</html>