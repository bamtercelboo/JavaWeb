<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>AJAX书本信息</title>
    <script type="text/javascript" src="jquery.min.js"></script>
    <script src="book.js" type="text/javascript"></script>
    <script src="jquery-ui.js" type="text/javascript"></script>
    <link href="book.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    <div>
      <input type="hidden" id="page" name="page" value="1"/>
      名  称 <input type="text" name="name" id="name" style="width:100px;"/>
      价格   <input type="text" name="minprice" id="minprice"  style="width:50px;" />---<input type="text" name="maxprice" id="maxprice"  style="width:50px;" />
      状态   <input type="radio" name="status" id="status" value="1" style="width:30px;"/>在售(1)<input type="radio" name="status" id="status" value="0" style="width:30px;"/>下架(0)
      出版社 <input type="text" name="publish" id="publish" style="width:100px;"/>
      <br/>
      ISBN <input type="text" name="isbn" id="isbn" style="width:100px;" />
      作者 <input type="text" name="author" id="author" style="width:120px;"/>
      作者性别 
      <select name="author_sex" id="author_sex" style="width:98px;">
        <option   value ="">请选择</option>
        <option  value ="m" >男</option>
        <option  value ="f" >女</option></select>
      <input type="button" name="search"  value="search" style="width:100px;" onclick="search();"/>
      <input type="button" name="reset" value="reset" onclick="reset();" style="width:100px;"/>
    </div>
    <div>
      <input type="button" value="Insert" style="width:100px;" id="btn_insert"  />
      <input type="button" value="Delete" onclick="confirmDelete()" style="width:100px;"/>
      <input type="button" value="测试数据" style="width:100px;" id="test_insert"  />
      <table id ="table" border="1" bordercolor="#000000" style="border-collapse:collapse;" cellpadding="5">
        <tr class="title">
          <th><input type="checkbox" id="selectAll" name="selectAll"  onclick="toselectAll();"/></th>
          <th>ID</th>
          <th>书本名称</th>
          <th>书本状态</th>
          <th>类型</th>
          <th>ISBN</th>
          <th>出版社</th>
          <th>书本价格</th>
          <th>作者</th>
          <th>作者性别</th>
          <th>最后修改时间</th>
          <th>创建时间</th>
          <th>备注</th>
          <th>操作</th>
        </tr>
        <tbody id="tbody">
        </tbody>
      </table>
    </div>
    <table>
      <tbody id="tbody1">
      </tbody>
    </table>
    <div id="addbg"></div>
    <div id="adddiv">
      <div class="addtop" id = "addclose">
        <a href="javascript:;"  class="addclose" id = "addclosehref">关闭</a>
      </div>
      <input type="hidden" name="upid" />
      <input type="hidden" name="created" value=""/>
      <table border="1" bordercolor="#000000" style="border-collapse:collapse; width: 250px" cellpadding="5" class="addTable" >
        <tr>
          <th colspan="2">书本信息</th>
        </tr>
        <tr>
          <td>名称：</td>
          <td><input type="text" name="upname" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>状态：</td>
          <td><input type="radio" name="upstatus" value="1" checked="checked"/>在售(1)<input type="radio" name="upstatus" value="0" id="status"/>下架(0)</td>
        </tr>
        <tr>
          <td>类型：</td>
          <td>
            <input type="checkbox" name="uptype" value="武侠"/>武侠&nbsp;
            <input type="checkbox" name="uptype" value="言情"/>言情&nbsp;
            <input type="checkbox" name="uptype" value="校园"/>校园&nbsp;
            <input type="checkbox" name="uptype" value="经典"/>经典
          </td>
        </tr>
        <tr>
          <td>ISBN：</td>
          <td><input type="text" name="upisbn" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>出版社：</td>
          <td><input type="text" name="uppublish" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>价格：</td>
          <td><input type="text" name="upprice" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>作者：</td>
          <td><input type="text" name="upauthor" style="width: 250px"/></td>
        </tr>
        <tr>
          <td>性别：</td>
          <td> 
            <select name="upauthor_sex" class = "upauthor_sex">
              <option   value ="">请选择</option>
              <option  value ="m">男</option>
              <option  value ="f">女</option>
            </select>
          </td>
        </tr>
        <tr>
          <td>备注：</td>
          <td><textarea id = "upmemo" name="upmemo" cols=20 rows=4 style="width: 250px"></textarea></td>
        </tr>
        <tr>
          <td colspan="2" align = "center">
            <input type="button" value="插入" id="add_button" onclick="insert()"  />
            <input type="button" value="测试数据" id="test_button" onclick="test_insert()"  />
            <input type="button" value="修改" id="update_button"  />
          </td>
        </tr>
      </table>
    </div>
  </body>
</html>
