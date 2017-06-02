<%@ page language="java" import="java.util.*, com.nccp.utils.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
  <head>
    <base href="<%=basePath%>">
    <title>用户列表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="/mavenweb/css/book.css" rel="stylesheet" type="text/css"/>
    <script src="/mavenweb/js/jquery-3.2.0.js" type="text/javascript"></script>
    <script src="/mavenweb/js/jquery.min.js" type="text/javascript"></script>
    <script src="/mavenweb/js/jquery-ui.js" type="text/javascript"></script>
    <script src="/mavenweb/js/book.js" type="text/javascript"></script>
  </head>
  <body>
    <h1>用户查询</h1>
    <div id ="search" class="searchparam">
      姓名： <input type="text" name="name" id ="name" value="" style="width: 70px;"/>&nbsp;&nbsp;
      性别：<select name="gender" id ="gender" style="width: 70px;">
        <option value="-" >不限</option>
        <option value="0" >男</option>
        <option value="1" >女</option>
      </select>&nbsp;&nbsp;
      状态：<input type="radio" name="status" id="status" value="1"  style="width:15px;"/>在售(1)
      <input type="radio" name="status" id="status" value="0" style="width:15px;"/>下架(0)&nbsp;&nbsp;
      价格： <input type="text" name="minprice" id="minprice" value="" style="width: 70px;"/> 至 <input type="text" name="maxprice" id="maxprice" value="" style="width: 70px;"/>&nbsp;&nbsp;
      <input type="button" name="search"  value="search" style="width:100px;" onclick="search();"/>
      <input type="button" name="reset" value="reset" onclick="reset();" style="width:100px;"/>
      <input type="button" name="deletemul" value="deletemul" onclick="deletemul();" style="width:100px;"/>
    </div>
    <hr/>
    <table border="1" cellpadding="10" cellspacing="0">
      <tr>
        <th>ID</th>
        <th>书名</th>
        <th>状态</th>
        <th>类型</th>
        <th>ISBN</th>
        <th>出版社</th>
        <th>价格</th>
        <th>作者</th>
        <th>性别</th>
        <th>年龄</th>
        <th>创建时间</th>
        <th>修改时间</th>
        <th>备注</th>
        <th>版本</th>
        <th colspan="2"><input type="button" value="Insert" style="width:100px;" id="btn_insert"  /></th>
      </tr>
      <tbody id="tbody">
      </tbody>
    </table>
    <table>
      <tbody id="tbody1">
      </tbody>
    </table>
     <div id="addbg"></div>
    <div id="adddiv">
      <div class="addtop" id="draggable">
        <a href="javascript:;"  class="addclose"  ><img src="/mavenweb/images/close.png" width="20px" height="20px" id = "addclosehref" /></a>
      </div>
      <form id ="add_form">
      <fieldset style="width:330px; margin:0px auto">
         <legend align="center">增加(修改)信息</legend>
         <input type="hidden" name="bookid" value=""/>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">书名：</label>
          <input type="text" name="name"/>
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">状态：</label>
          <input type="radio" name="status1" value="0" checked >下架
          <input type="radio" name="status1" value="1" >在售
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">类型：</label>
          <input type="checkbox" name="type" value="武侠" checked >武侠
          <input type="checkbox" name="type" value="言情"  >言情
          <input type="checkbox" name="type" value="校园"  >校园
          <input type="checkbox" name="type" value="经典"  >经典
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">ISBN：</label>
          <input type="text" name="isbn"/>
        </p>
        <p>
          <label class="label" float="right" style="display:inline-block;width:70px;text-align:right;">出版社：</label>
          <input type="text" name="publish"/>
        </p>
        <p>
          <label class="label" float="right" style="display:inline-block;width:70px;text-align:right;">价格：</label>
          <input type="text"    name="price" value="" style="width: 80px;" />
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">作者：</label>
          <input type="text" name="authorname"/>
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">年龄：</label>
          <input type="number" name="authorage" value="" style="width: 60px;"/>
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">性别：</label>
          <input type="radio" name="gender" value="0" checked >男
          <input type="radio" name="gender" value="1" >女
        </p>
        <p>
          <label style="display:inline-block;width:70px;text-align:right;">备注：</label>
          <textarea name="memo" class="memo" cols="15" rows="2" style="width: 160px;"></textarea>
        </p>
        <p id="buttons" align="center">
          <input type="button" value="插入" id="add_button" onclick="insert()"  />
          <input type="button" value="修改" id="update_button"  />
        </p>
      </fieldset>
      </form>
    </div>
  </body>
</html>