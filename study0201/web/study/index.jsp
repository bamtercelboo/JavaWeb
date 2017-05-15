<%-- 
    Document   : index_down
    Created on : 2017-4-10, 16:23:05
    Author     : Administrator
--%>
<%@page import="java.math.BigDecimal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="connect_mysql.jsp"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
    <script src="jquery-3.2.0.js"></script>
    <script src="button.js" type="text/javascript"></script>
  </head>
  <body>
    <div border="1">
      <form id="search_form "action="index.jsp" method="post">
        <table align="center">
          <tr><td></td></tr><tr><td></td></tr><tr><td></td></tr>
          <tr><td></td></tr><tr><td></td></tr><tr><td></td></tr>
          <tr>
            <td>书本名称 <input type="text" name="name"/></td>
            <td>书本状态 <input type="radio" name="status" value="1"/>在售(1)<input type="radio" name="status" value="0"/>下架(0)</td>
            <td>ISBN <input type="text" name="isbn" /></td>
            <td>出版社 <input type="text" name="publish" /></td>
            <td>书本价格 <input type="text" name="minprice" />---<input type="text" name="maxprice" /></td>
            <td>作者 <input type="text" name="author" /></td>
            <td>作者性别 <select name="author_sex">
                <option   value ="">请选择</option>
                <option  value ="m">男</option>
                <option  value ="f">女</option>
              </select></td>
          </tr>
          <tr>
            <td colspan="6"><input type="submit" name="search"  value="查询"/></td>
            <td><input type="reset" name="reset" value="重置"/></td>
          </tr>
        </table>
      </form>
    </div>
    <div>
      <form align="right">
        <table align="right">
          <tr>
            <td>
              <input type="button" value="增加" id="btn_insert" />
            </td>
            <td></td><td></td> <td></td> 
            <td>
              <button type="button" value="删除" id="btn_delete"  onclick="delete_data()">删除</button>
            </td>
            <td></td>
          </tr>
        </table>
      </form>
    </div>
    <div border="1">
      <table border="1" align="center" width="100%">
        <tr>
          <td></td>
          <td>ID</td>
          <td>书本名称</td>
          <td>书本状态</td>
          <td>类型</td>
          <td>ISBN</td>
          <td>出版社</td>
          <td>书本价格</td>
          <td>作者</td>
          <td>作者性别</td>
          <td>创建时间</td>
          <td>备注</td>
          <td>操作</td>
        </tr>
        <%!
          //每页显示的数量
          public static final int PAGESIZE = 5;
          //总页数
          int pageCount;
          //设置当前页数
          int curPage = 1;
          // 以当前页未中心左右列出5个页面数  
          final int clickPageList = 5;
        %>
        <% 
          Statement stmt = conn.createStatement();
          StringBuffer sql = new StringBuffer();
          sql.append("select * from nccp_books ");
          //获取条件查询中文本框的值
          String name = request.getParameter("name");
          System.out.println( " name == " + name  );
          String status = request.getParameter("status");
          String isbn = request.getParameter("isbn");
          String publish = request.getParameter("publish");
          String minprice = request.getParameter("minprice");
          String maxprice = request.getParameter("maxprice");
          String author = request.getParameter("author");
          String author_sex = request.getParameter("author_sex");
          //查询出所有记录数
          StringBuffer sql_row = new StringBuffer();
          sql_row.append(" select count(*) allcount  from nccp_books  ");
          //拼接sql 和 sql_row  SQL语句
          int count = 0;
          if ( name != null && !"".equals(name)&& !"null".equals(name))
          {
            count++;
            if ( count > 0 && count == 1 )
            {
              sql.append("where ");
              sql_row.append("where ");
            }
            name = new String(name.toString().getBytes("iso-8859-1"), "utf-8");
            sql.append("   name like'%" + name + "%'");
            sql_row.append(" name like'%" + name + "%'");
          }
          if ( status != null && !"".equals(status) && !"null".equals(status))
          {
            count++;
            if ( count > 0 && count == 1 )
            {
              sql.append("where ");
              sql_row.append("where ");
              sql.append("   status='" + status + "'");
              sql_row.append("   status='" + status + "'");
            } else
            {
              sql.append("  and status='" + status + "'");
              sql_row.append("  and status='" + status + "'");
            }
          }
          if ( isbn != null && !"".equals(isbn) && !"null".equals(isbn) )
          {
            count++;
            if ( count > 0 && count == 1 )
            {
              sql.append("where ");
              sql_row.append("where ");
              isbn = new String(isbn.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("   isbn='" + isbn + "'");
              sql_row.append("   isbn='" + isbn + "'");
            } else
            {
              isbn = new String(isbn.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("  and isbn='" + isbn + "'");
              sql_row.append("  and isbn='" + isbn + "'");
            }
          }
          if ( publish != null && !"".equals(publish) && !"null".equals(publish))
          {
            count++;
            if ( count > 0 && count == 1 )
            {
              sql.append("where ");
              sql_row.append("where ");
              publish = new String(publish.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("   publish='" + publish + "'");
              sql_row.append("   publish='" + publish + "'");
            } else
            {
              publish = new String(publish.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("  and publish='" + publish + "'");
              sql_row.append("  and publish='" + publish + "'");
            }
          }
          if ( author != null && !"".equals(author) && !"null".equals(author))
          {
            count++;
            if ( count > 0 && count == 1 )
            {
              sql.append("where ");
              sql_row.append("where ");
              author = new String(author.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("   author='" + author + "'");
              sql_row.append("   author='" + author + "'");
            } else
            {
              author = new String(author.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("  and author='" + author + "'");
              sql_row.append("  and author='" + author + "'");
            }
          }
          if ( author_sex != null && !"".equals(author_sex) && !"null".equals(author_sex))
          {
            count++;
            if ( count > 0 && count == 1 )
            {
              sql.append("where ");
              sql_row.append("where ");
              author_sex = new String(author_sex.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("   author_sex='" + author_sex + "'");
              sql_row.append("   author_sex='" + author_sex + "'");
            } else
            {
              author_sex = new String(author_sex.toString().getBytes("iso-8859-1"), "utf-8");
              sql.append("  and author_sex='" + author_sex + "'");
              sql_row.append("  and author_sex='" + author_sex + "'");
            }
          }
          try
          {
            if ( minprice != null && !"".equals(minprice) && maxprice != null && !"".equals(maxprice) && !"null".equals(maxprice)&& !"null".equals(minprice))
            {
              count++;
              if ( count > 0 && count == 1 )
              {
                sql.append("where ");
                sql_row.append("where ");
                minprice = new String(minprice.toString().getBytes("iso-8859-1"), "utf-8");
                maxprice = new String(maxprice.toString().getBytes("iso-8859-1"), "utf-8");
                BigDecimal minprice_deci = new BigDecimal(minprice);
                BigDecimal maxprice_deci = new BigDecimal(maxprice);
                sql_row.append("   price between'" + minprice_deci + "'");
                sql_row.append("  and '" + maxprice_deci + "'");
                sql.append("   price between'" + minprice_deci + "'");
                sql.append("  and '" + maxprice_deci + "'");
              } else
              {
                //数值大小比较先进行转换
                minprice = new String(minprice.toString().getBytes("iso-8859-1"), "utf-8");
                maxprice = new String(maxprice.toString().getBytes("iso-8859-1"), "utf-8");
                BigDecimal minprice_deci = new BigDecimal(minprice);
                BigDecimal maxprice_deci = new BigDecimal(maxprice);
                sql_row.append("  and price between'" + minprice_deci + "'");
                sql_row.append("  and '" + maxprice_deci + "'");
                sql.append("  and price between'" + minprice_deci + "'");
                sql.append("  and '" + maxprice_deci + "'");
              }
            }
          } catch ( Exception e )
          {
          }
          //按照创建时间倒叙排序
          sql.append("  order by created desc ");
          //执行查询出所有的记录数
          PreparedStatement ps = conn.prepareStatement(sql_row.toString());
          ResultSet rs_row = ps.executeQuery();
          int row_number = 0;
          if ( rs_row.next() )
          {
            row_number = rs_row.getInt("allcount");
          }
          //根据记录数判断出总页数
          pageCount = (row_number % PAGESIZE == 0) ? (row_number / PAGESIZE) : (row_number / PAGESIZE + 1);
          //没有查询到记录
          if ( pageCount == 0 )
          {
            pageCount = 1;
          }
          //点击超链接的时候会把值带过来
          String tmp = request.getParameter("curPage");
          if ( tmp == null )
          {
            tmp = "1";
          }
          curPage = Integer.parseInt(tmp);
          //当前页不会超过总页数
          if ( curPage >= pageCount )
          {
            curPage = pageCount;
          }
          //limit根据当前记录从几到几显示数据
          sql.append(" limit " + (curPage - 1) * PAGESIZE + "," + PAGESIZE + "");
          out.print(sql + "  ");
          out.print(sql_row);
          try
          {
            ResultSet rs = stmt.executeQuery(sql.toString());
            while ( rs.next() )
            {
        %>
        <tr>
          <td>
            <input type="checkbox" name="checkbox" id="" value="<%=rs.getString("id")%>"/>
          </td>
          <td id="ID"><%=rs.getInt("id")%></td>
          <td><%=rs.getString("name")%></td>
          <td><%=rs.getString("status")=="0"?"下架":"在售"%></td>
          <td><%=rs.getString("type")%></td>
          <td><%=rs.getString("isbn")%></td>
          <td><%=rs.getString("publish")%></td>
          <td><%=rs.getString("price")%></td>
          <td><%=rs.getString("author")%></td>
          <td><%=rs.getString("author_sex")=="f"? "女":"男"%></td>
          <td><%=rs.getString("created")%></td>
          <td><%=rs.getString("memo")%></td>
          <td><a href="update_detail.jsp?id=<%=rs.getString("id")%>"> 修改</a></td>
        </tr>
        <%  }
          } catch ( Exception e )
          {
          }
        %>
      </table>
      <!--首页-->
      <a href = "index.jsp?curPage=1&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" >首页&nbsp;</a>
      <!--上一页-->
      <%
        //当前页是第一页，点击上一页无效
        if ( curPage == 1 )
        {
      %>
      <a href = "index.jsp?curPage=1&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" >上一页&nbsp;</a>
      <%
        }
      %>
      <%
        if ( curPage != 1 )
        {
      %>
      <a href = "index.jsp?curPage=<%=curPage - 1%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" >上一页&nbsp;</a>
      <%
        }
      %>
      <!--显示页数超链接-->
      <%
        if ( pageCount >= clickPageList )
        {//如果总页数大于5页 
          int line = clickPageList / 2;
          if ( curPage >= 1 && curPage <= line + 1 )   //第一种情况
          {//如果当前页数大于等与1并小于等与3（这里表示点击前3页的链接，都显示的是1到5页的链接）
            for ( int i = 1; i <= clickPageList; i++ )
            {
              //如果是当前页，则直接显示页码，不做成超链接
              if ( curPage == i )
              {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "index.jsp?curPage=<%=i%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
        if ( curPage > line + 1 && curPage <= pageCount - line )
        {//如果当前页数大于3，并且小于等与总页数；则循环显示当前页-2，到当前页+2的链接
          for ( int i = curPage - line; i <= curPage + line; i++ )
          {
            //如果是当前页，则直接显示页码，不做成超链接
            if ( curPage == i )
            {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "index.jsp?curPage=<%=i%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
        if ( curPage > pageCount - line && curPage <= pageCount )
        {//如果当前页大于总页数-2，并且小于总页数
          for ( int i = pageCount - line - 2; i <= pageCount; i++ )
          {
            //如果是当前页，则直接显示页码，不做成超链接
            if ( curPage == i )
            {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "index.jsp?curPage=<%=i%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
      } else //总页数小于要显示的页数
      {
        for ( int i = 1; i <= pageCount; i++ )
        {  //如果总页数小于5就直接把所有链接循环输出。
          //如果是当前页，则直接显示页码，不做成超链接
          if ( curPage == i )
          {
      %>
      <%=i%>
      <%
      } else
      {
      %>
      <a href = "index.jsp?curPage=<%=i%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" ><%=i%>&nbsp;</a>
      <%
            }
          }
        }
      %>   
      <a href = "index.jsp?curPage=<%=curPage + 1%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>">下一页&nbsp;</a>  
      <a href = "index.jsp?curPage=<%=pageCount%>&name=<%=name%>&status=<%=status%>&isbn=<%=isbn%>&publish=<%=publish%>&minprice=<%=minprice%>&maxprice=<%=maxprice%>&author=<%=author%>&author_sex=<%=author_sex%>" >尾页&nbsp;</a>  
      第<%=curPage%>页/共<%=pageCount%>页  
    </div>
    <script>
      //删除函数
      function delete_data() {
        var id_value = "";
        var id = document.getElementsByName("checkbox");
        for (var i = 0; i < id.length; i++) {
          if (id[i].checked) {
            id_value += "'" + id[i].value + "',";
          }
        }
        if (id_value.length > 1) {
          id_value = id_value.substring(1, id_value.length - 2);
          //二次确定
          if (confirm("确认删除？")) {
            window.location.href = "delete_function.jsp?id='" + id_value + "'";
          }
        }
      }
    </script>
  </body>
</html>
