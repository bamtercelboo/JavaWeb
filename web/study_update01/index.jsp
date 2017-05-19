<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<%   
  //获取总记录数
  int total_count = 0;
  //每页显示的数量
  int PAGE_SIZE = 5;
  //总页数
  int total_pages = 1;
  int curr_page = 1;
  int clickPageList = 5;
  //获取参数值回填条件查询
  String name = "";
  if( request.getParameter( "name" ) != null )
    name = request.getParameter( "name" );
  String minprice="";
  if( request.getParameter( "minprice" ) != null )
    minprice = request.getParameter( "minprice" );
  String maxprice="";
  if( request.getParameter( "maxprice" ) != null )
    maxprice = request.getParameter( "maxprice" );
  String status="";
  if( request.getParameter( "status" ) != null )
    status = request.getParameter( "status" );
   String publish="";
  if( request.getParameter( "publish" ) != null )
    publish = request.getParameter( "publish" );
   String isbn="";
  if( request.getParameter( "isbn" ) != null )
    isbn = request.getParameter( "isbn" );
  String author="";
  if( request.getParameter( "author" ) != null )
    author = request.getParameter( "author" );
  String author_sex="";
  if( request.getParameter( "author_sex" ) != null )
    author_sex = request.getParameter( "author_sex" );
  
  Connection conn = null;
  List<Map<String, String>> data = new ArrayList<>();
  try
  {
    //连接数据库
    conn = getConnection();
    //sql语句
    String sql = "SELECT * FROM nccp_books";
    String sql_count = "SELECT count(*) all_count  FROM nccp_books";
    //拼接sql语句 添加到list中
    List<String> param_values = new ArrayList<>();
    String where = "";
    where = buildQueryWhere(param_values, request, where, "name", "name", "LIKE");
    where = buildQueryWhere(param_values, request, where, "status", "status", "=");
    where = buildQueryWhere(param_values, request, where, "isbn", "isbn", "=");
    where = buildQueryWhere(param_values, request, where, "publish", "publish", "=");
    where = buildQueryWhere(param_values, request, where, "minprice", "price", ">=");
    where = buildQueryWhere(param_values, request, where, "maxprice", "price", "<=");
    where = buildQueryWhere(param_values, request, where, "author", "author", "=");
    where = buildQueryWhere(param_values, request, where, "author_sex", "author_sex", "=");
    if ( where.length() > 0 )
    {
      sql = sql + " WHERE " + where;
      sql_count = sql_count + " WHERE " + where;
    }
    sql = sql + "  ORDER BY created DESC ";
    sql_count = sql_count + "  ORDER BY created DESC ";
    //获取总记录数
    total_count = queryCount( conn, sql_count, param_values );
    //总页数
    total_pages = ( (total_count % PAGE_SIZE) == 0 ) ? ( total_count / PAGE_SIZE ) : ( ( total_count / PAGE_SIZE) + 1 );
    if( total_pages <=curr_page )
    {
      curr_page = total_pages;
    }
    String param_page = request.getParameter("page");
    if( param_page != null )
      curr_page = Integer.parseInt( param_page ); 
    sql = sql + " LIMIT " + (curr_page - 1) * PAGE_SIZE + "," + PAGE_SIZE;
      //执行sql语句，获取返回结果值
      data = query(conn, sql, param_values);
      if ( total_pages <= curr_page )
      {
        curr_page = total_pages;
      }
    } catch ( Exception e )
    {
    e.printStackTrace();
  } finally
  { 
    try{conn.close();} catch ( Exception e ){}
  }
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP书本信息</title>
    <script type="text/javascript" src="jquery.min.js"></script>
    <script src="button.js" type="text/javascript"></script>
  </head>
  <body>
    <div>
      <form id="search_form" name="search_form" action="index.jsp" method="post">
        <input type="hidden" id="page" name="page" value="1"/>
        名  称 <input type="text" name="name" id="name" value="<%=name%>" style="width:100px;"/>
        价格 <input type="text" name="minprice" id="minprice" value="<%=minprice%>" style="width:50px;" />---<input type="text" name="maxprice" id="maxprice" value="<%=maxprice%>" style="width:50px;" />
        状态 <input type="radio" name="status" id="status" value="1" <%=status.equals("1")? "checked" : ""%> style="width:30px;"/>在售(1)<input type="radio" name="status" id="status" value="0" <%=status.equals("0")? "checked" : ""%> style="width:30px;"/>下架(0)
        出版社 <input type="text" name="publish" id="publish" value="<%=publish%>" style="width:100px;"/>
        <br/>
        ISBN <input type="text" name="isbn" id="isbn" value="<%=isbn%>" style="width:100px;" />
        作者 <input type="text" name="author" id="author" value="<%=author%>" style="width:120px;"/>
        作者性别 <select name="author_sex" id="author_sex" style="width:98px;">
                <option   value ="">请选择</option>
                <option  value ="m" <%=author_sex.equals("m")? "selected" : ""%>>男</option>
                <option  value ="f" <%=author_sex.equals("f")? "selected" : ""%>>女</option>
              </select>
        <input type="submit" name="search"  value="查询" style="width:100px;"/>
        <input type="button" name="reset" value="重置" onclick="window.reset();" style="width:100px;"/>
      </form>
    </div>
    <form action="delete_function.jsp" id="delete_form" method="post">
    <div>
     <input type="button" value="增加" style="width:100px;" id="btn_insert" />
     <input type="button" value="删除" onclick="window.confirmDelete()" style="width:100px;"/>
      <table id ="mouse" border="1" bordercolor="#000000" style="border-collapse:collapse;" cellpadding="5">
        <tr class="title">
          <th>
            <input type="checkbox" id="selectAll" name="selectAll"  onclick="window.selectAll();"/>
          </th>
          <th>ID</th>
          <th>书本名称</th>
          <th>书本状态</th>
          <th>类型</th>
          <th>ISBN</th>
          <th>出版社</th>
          <th>书本价格</th>
          <th>作者</th>
          <th>作者性别</th>
          <th>创建时间</th>
          <th>备注</th>
          <th>操作</th>
        </tr>
          <%for ( Map<String, String> row : data )
            {%>
        <tr class="row" id="row"> 
          <td>
            <input type="checkbox" name="id" value="<%=row.get("id")%>"/>
          </td>
          <td id="ID"><%=row.get("id")%></td>
          <td><%=row.get("name")%></td>
          <td><%=((row.get("status")).equals("0")?"下架":"在售")%></td>
          <td><%=row.get("type")%></td>
          <td><%=row.get("isbn")%></td>
          <td><%=row.get("publish")%></td>
          <td><%=row.get("price")%></td>
          <td><%=row.get("author")%></td>
          <td><%=row.get("author_sex").equals("f")? "女" : "男"%></td>
          <td><%=row.get("created")%></td>
          <td><%=row.get("memo")%></td>
          <td><a href="update_detail.jsp?id=<%=row.get("id")%>"> 修改</a></td>
        </tr>
        <%}%>
      </table>
    </div>
    </form>
      <!--首页-->
      <a href = "javascript:goto(1);" >首页</a>
      <a href = "javascript:goto(<%=( curr_page > 1 ) ? ( curr_page - 1 ) : 1 %>);" >上一页</a>
      <!--显示页数超链接-->
      <%
        if ( total_pages >= clickPageList )
        {//如果总页数大于5页 
          int line = clickPageList / 2;
          if ( curr_page >= 1 && curr_page <= line + 1 )   //第一种情况
          {//如果当前页数大于等与1并小于等与3（这里表示点击前3页的链接，都显示的是1到5页的链接）
            for ( int i = 1; i <= clickPageList; i++ )
            {
              //如果是当前页，则直接显示页码，不做成超链接
              if ( curr_page == i )
              {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "javascript:goto(<%=i%>);" ><%=i%>&nbsp;</a>
      <%
        }
          }
          }
        if ( curr_page > line + 1 && curr_page <= total_pages - line )
        {//如果当前页数大于3，并且小于等与总页数；则循环显示当前页-2，到当前页+2的链接
          for ( int i = curr_page - line; i <= curr_page + line; i++ )
          {
            //如果是当前页，则直接显示页码，不做成超链接
            if ( curr_page == i )
            {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "javascript:goto(<%=i%>);" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
        if ( curr_page > total_pages - line && curr_page <= total_pages )
        {//如果当前页大于总页数-2，并且小于总页数
          for ( int i = total_pages - line - 2; i <= total_pages; i++ )
          {
            //如果是当前页，则直接显示页码，不做成超链接
            if ( curr_page == i )
            {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "javascript:goto(<%=i%>);" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
      } else //总页数小于要显示的页数
      {
        for ( int i = 1; i <= total_pages; i++ )
        {  //如果总页数小于5就直接把所有链接循环输出。
          //如果是当前页，则直接显示页码，不做成超链接
          if ( curr_page == i )
          {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "javascript:goto(<%=i%>);" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
      %>   
      <a href = "javascript:goto(<%=( curr_page < total_pages ) ? ( curr_page + 1 ) : total_pages %>);" >下一页</a>
      <a href = "javascript:goto(<%=total_pages%>);" >末页</a>
      第<%=curr_page%>页/共<%=total_pages%>页  
      
      <script type="text/javascript">
        //页码函数,表单提交
        function goto( page ) 
        {
          $("#page").val( ""+page );
          $("#search_form").submit();
        }
        //重置button
        function reset( ) 
        {
           $("#name").val("");
           $("#minprice").val("");
           $("#maxprice").val("");
           $("input:radio[name='status']").get(1).checked=false;
           $("input:radio[name='status']").get(0).checked=false;
           $("#publish").val("");
           $("#isbn").val("");
           $("#author").val("");
           $("#author_sex").val("");
        }
        //表单信息删除二次确认
        function confirmDelete( )
        {
         if($("input[name='id']:checkbox").attr("checked")) 
          { 
            if( confirm("确认删除？") )
              $("#delete_form").submit();
          }
          else
            alert(" 至少勾选一条删除选项 ！ ");
        }
        //全选、全不选
        function selectAll()
        {   
          if(!($("input[name='selectAll']").attr("checked"))) 
          { 
            $("input[name='id']").removeAttr("checked"); 
          } 
          else
          { 
            $("input[name='id']").attr("checked","true"); 
          } 
        }
         //移动鼠标所在行变色
        $( function(){
          $("tr.row").hover(function(){
            $(this).addClass("tron");
              },function(){
            $(this).removeClass("tron");
          });
        });
      </script>
      <style>
      .tron  {background-color:red};
      </style>
  </body>
</html>
