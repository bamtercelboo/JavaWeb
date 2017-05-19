<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>AJAX_作者信息</title>
    <script type="text/javascript" src="jquery.min.js"></script>
    <script src="author.js" type="text/javascript"></script>
    <script src="jquery-ui.js" type="text/javascript"></script>
    <link href="author.css" rel="stylesheet" type="text/css"/>
  </head>
  <body>
    <div class="authorsearchparam">
      <input type="hidden" id="page" name="page" value="1"/>
      姓名 <input type="text" name="name" id="name" style="width:100px;"/>
      年龄   <input type="text" name="minage" id="minage"  style="width:40px;" />---<input type="text" name="maxage" id="maxage"  style="width:40px;" />
      性别   <input type="radio" name="authorssex" id="authorsex" value="f" style="width:30px;"/>女<input type="radio" name="authorssex" id="authorsex" value="m" style="width:30px;"/>男&nbsp;&nbsp;&nbsp;
      <input type="button" name="search"  value="search" style="width:100px;" onclick="search();"/>
      <input type="button" name="reset" value="reset" onclick="reset();" style="width:100px;"/>
    </div>
    <div>
      <input type="button" value="Insert" style="width:100px;" id="btn_insert"  />
      <input type="button" value="Delete" onclick="confirmDelete()" style="width:100px;"/>
      <table id ="table" border="1" bordercolor="#000000" style="border-collapse:collapse;" cellpadding="5">
        <tr class="title">
          <th  width="1%"><input type="checkbox" id="selectAll" name="selectAll"  onclick="toselectAll();"/></th>
          <th sortcolname="au_id" width="2%">ID</th>
          <th sortcolname="name" width="6%">姓名</th>
          <th sortcolname="author_sex" width="3%">性别</th>
          <th sortcolname="author_age" width="8%">年龄</th>
          <th sortcolname="author_created" width="7%">创建时间</th>
          <th sortcolname="author_modified" width="7%">最后修改时间</th>
          <th sortcolname="memo" width="13%" style="word-wrap:break-word;">备注</th>
          <th width="2%">操作</th>
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
        <a href="javascript:;"  class="addclose" ><img src="/study0201/study_ajax_mul_up/images/title.gif" width="327px" height="25px" id="draggable" class="title"/><img src="/study0201/study_ajax_mul_up/images/close.png" id = "addclosehref" /></a>
      </div>
      <input type="hidden" name="authorid" />
      <table border="1" bordercolor="#000000" style="border-collapse:collapse; width: 325px" cellpadding="5" class="addTable" >
        <tr>
          <th colspan="2">作者信息</th>
        </tr>
        <tr>
          <td align="right">姓名：</td>
          <td><input type="text" name="authorname" style="width: 115px"/></td>
        </tr>
        <tr>
          <td align="right">性别：</td>
          <td><input type="radio" name="authorsex" value="m" checked="checked"/>&nbsp;&nbsp;&nbsp;男&nbsp;&nbsp;<input type="radio" name="authorsex" value="f" id="status"/>&nbsp;&nbsp;女&nbsp;&nbsp;</td>
        </tr>
        <tr>
          <td align="right">年龄：</td>
          <td><input type="text" name="authorage" style="width: 55px"/></td>
        </tr>
        <tr>
          <td align="right">备注：</td>
          <td><textarea id = "authormemo" name="authormemo" cols=20 rows=4 style="width: 250px"></textarea></td>
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
