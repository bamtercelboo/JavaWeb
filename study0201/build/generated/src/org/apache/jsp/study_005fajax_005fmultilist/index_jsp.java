package org.apache.jsp.study_005fajax_005fmultilist;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


  /**
   * 连接mysql数据库
   */
  private Connection getConnection() throws Exception
  {
    String url = "jdbc:mysql://localhost:3306/study02";
    String user_name = "root";
    String password = "mysql";
    Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection(url, user_name, password);
    return conn;
  }

  /**
   * 把Result结果集封装成Map<String,String>
   */
  public Map<String, String> mapFromRS( ResultSet rs )
  {
    Map<String, String> object = new HashMap<>();
    try {
      // ResultSetMetaData有关 ResultSet 中列的名称和类型的信息
      ResultSetMetaData rsmd = rs.getMetaData();
      //获取列数
      int count = rsmd.getColumnCount();
      for ( int i = 1; i <= count; i++ ) {
        String name = rsmd.getColumnName(i).toLowerCase();//获得列名的小写形式
        String key = rsmd.getColumnName(i);//获得列名
        String key_alias = rsmd.getColumnLabel(i);//获取列明别名
        if ( key.equals("ROWNUM_") ) {
          continue;
        }
        //Character Large Object
        if ( rsmd.getColumnType(i) == Types.CLOB ) {
          continue;
        }
        //BLOB (binary large object)，二进制大对象，是一个可以存储二进制文件的容器
        if ( rsmd.getColumnType(i) == Types.BLOB ) {
          continue;
        }
        String value = rs.getString(key);//字段对应的值
        String value_alias = rs.getString(key_alias);
        object.put(key, value);
        object.put(key_alias, value_alias);
      }
    } catch ( Exception e ) {
    }
    return object;
  }

  /**
   * 根据条件查询，查询数据库
   */
  private List<Map<String, String>> query( Connection conn, String sql, List<String> params ) throws Exception
  {
    List<Map<String, String>> data = new ArrayList<>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
      System.out.println(sql);
      pstmt = conn.prepareStatement(sql);
      int parameterIndex = 1;
      System.out.println(params);
      for ( String param : params ) {
        pstmt.setString(parameterIndex, param);
        parameterIndex++;
      }
      rs = pstmt.executeQuery();
      while ( rs.next() ) {
        Map<String, String> row = mapFromRS(rs);
        System.out.println("row data "+row);
        data.add(row);
      }
    } finally {
      try { rs.close(); } catch ( Exception e ) { }
      try { pstmt.close(); } catch ( Exception e ) { }
    }
    return data;
  }

  public int execupdate( Connection conn, String sql ) throws Exception
  {
    return execupdate(conn, sql, null);
  }

  /**
   * 执行update，insert sql语句，返回Int结果
   */
  public int execupdate( Connection conn, String sql, List<String> params ) throws Exception
  {
    //具体实现
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int result = 0;
    try {
      System.out.println(sql);
      pstmt = conn.prepareStatement(sql);
      if ( params != null ) {
        int parameterIndex = 1;
        System.out.println(params);
        for ( String param : params ) {
          pstmt.setString(parameterIndex++, param);
        }
      }
      result = pstmt.executeUpdate();
    } finally {
      try { rs.close(); } catch ( Exception e ) { }
      try { pstmt.close(); } catch ( Exception e ) { }
    }
    return result;
  }

  /**
   * 查询单条记录
   */
  public Map<String, String> querySingleRow( Connection conn, String sql, List<String> params ) throws Exception
  {
    //具体实现
    Map<String, String> row = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
      System.out.println(sql);
      pstmt = conn.prepareStatement(sql);
      int parameterIndex = 0;
      System.out.println(params);
      for ( String param : params ) {
        pstmt.setString(++parameterIndex, param);
      }
      rs = pstmt.executeQuery();
      if ( rs.next() ) {
        row = mapFromRS(rs);
      }
    } finally {
      try { rs.close(); } catch ( Exception e ) { }
      try { pstmt.close(); } catch ( Exception e ) { }
    }
    return row;
  }

  /**
   * 查询数据总量
   */
  public int queryCount( Connection conn, String sql, List<String> params ) throws Exception
  {
    //具体实现
    int count = 0;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
      System.out.println(sql);
      pstmt = conn.prepareStatement(sql);
      int parameterIndex = 0;
      System.out.println(params);
      for ( String param : params ) {
        pstmt.setString(++parameterIndex, param);
      }
      rs = pstmt.executeQuery();
      if ( rs.next() ) {
        count = rs.getInt("all_count");
      }
    } finally {
      try { rs.close(); } catch ( Exception e ) { }
      try { pstmt.close(); } catch ( Exception e ) { }
    }
    return count;
  }

  /**
   * 拼接查询的sql语句
   */
  public String buildQueryWhere( List<String> param_values, HttpServletRequest request, String old_where, String param_name, String column_name, String sql_operator )
  {
    String param_value = request.getParameter(param_name);
    if ( param_value == null || param_value.trim().length() == 0 ) {
      return old_where;
    }
    StringBuilder new_where = new StringBuilder(old_where);
    if ( old_where.length() > 0 ) {
      new_where.append(" AND ");
    }
    if ( sql_operator == "LIKE" ) {
      param_value = "%" + param_value + "%";
    }
    new_where.append(column_name + " " + sql_operator + " ? ");
    param_values.add(param_value);
    return new_where.toString();
  }

  public boolean isNumber( String str )
  {
    java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$"); // 判断小数点后一位的数字的正则表达式
    java.util.regex.Matcher match = pattern.matcher(str);
    if ( match.matches() == false ) {
      return false;
    } else {
      return true;
    }
  }

  /**
   * 拼接update 的sql语句 muti_flag 多选框的情况下特殊处理
   */
  public String buildUpdateSet( List<String> param_values, HttpServletRequest request, String old_set, String param_name, String column_name, boolean muti_flag )
  {
    StringBuilder new_set = new StringBuilder(old_set);
    try {
      String param_value = null;
      if ( muti_flag ) {
        param_value = paramArray(request, param_name);
      } else {
        param_value = request.getParameter(param_name);
      }
      if ( param_value == null ) {
        return old_set;
      }
      if ( old_set.length() > 0 ) {
        new_set.append(" , ");
      }
      new_set.append(column_name + " = ? ");
      param_values.add(param_value);
      return new_set.toString();
    } catch ( Exception e ) {
    }
    return new_set.toString();
  }

  /**
   * 若是有复选框，getParameter(param_name)取不到所有的值 改成用getParameterValues取值，获取到数组，然后在分割
   */
  public String paramArray( HttpServletRequest request, String param_name )
  {
    String[] param_valuearray = request.getParameterValues(param_name);
    StringBuffer param_ = new StringBuffer();
    String param_value = "";
    if ( param_valuearray != null ) {
      for ( int i = 0; i < param_valuearray.length; i++ ) {
        if ( i < param_valuearray.length - 1 ) {
          param_.append(param_valuearray[i] + ",");
        } else {
          param_.append(param_valuearray[i]);
        }
      }
      param_value = param_.toString();
      return param_value;
    }
    return "";
  }

/**
 * 增加，修改后台验证
 */
  public String formvalidate( HttpServletRequest request ) throws Exception
  {
    String result = "";
    List<String> list = new ArrayList<>();
    list.add("name");
    list.add("status");
    list.add("isbn");
    list.add("publish");
    list.add("price");
    for ( String param : list ) {
      String paramvalue = request.getParameter(param);
      if ( paramvalue == null || paramvalue.trim().length() == 0 ) {
        result = param + "不能为空";
        break;
      }
    }
    return result;
  }

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList<String>(1);
    _jspx_dependants.add("/study_ajax_multilist/connect_mysql.jsp");
  }

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write('\n');
      out.write('\n');
      out.write('\n');

  //设置成UTF-8，解决中文乱码问题
  request.setCharacterEncoding("UTF-8");

      out.write('\n');
      out.write("\n");
      out.write("<html>\n");
      out.write("  <head>\n");
      out.write("    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("    <title>AJAX_多表_书本信息</title>\n");
      out.write("    <script type=\"text/javascript\" src=\"jquery.min.js\"></script>\n");
      out.write("    <script src=\"book.js\" type=\"text/javascript\"></script>\n");
      out.write("    <script src=\"jquery-ui.js\" type=\"text/javascript\"></script>\n");
      out.write("    <link href=\"book.css\" rel=\"stylesheet\" type=\"text/css\"/>\n");
      out.write("  </head>\n");
      out.write("  <body>\n");
      out.write("    <div class=\"searchparam\">\n");
      out.write("      <input type=\"hidden\" id=\"page\" name=\"page\" value=\"1\"/>\n");
      out.write("      名  称 <input type=\"text\" name=\"name\" id=\"name\" style=\"width:100px;\"/>\n");
      out.write("      价格   <input type=\"text\" name=\"minprice\" id=\"minprice\"  style=\"width:50px;\" />---<input type=\"text\" name=\"maxprice\" id=\"maxprice\"  style=\"width:50px;\" />\n");
      out.write("      状态   <input type=\"radio\" name=\"status\" id=\"status\" value=\"1\" style=\"width:30px;\"/>在售(1)<input type=\"radio\" name=\"status\" id=\"status\" value=\"0\" style=\"width:30px;\"/>下架(0)\n");
      out.write("      出版社 <input type=\"text\" name=\"publish\" id=\"publish\" style=\"width:100px;\"/>\n");
      out.write("      <br/>\n");
      out.write("      ISBN <input type=\"text\" name=\"isbn\" id=\"isbn\" style=\"width:100px;\" />\n");
      out.write("      作者 <input type=\"text\" name=\"author\" id=\"author\" style=\"width:120px;\"/>\n");
      out.write("      作者性别 \n");
      out.write("      <select name=\"author_sex\" id=\"author_sex\" style=\"width:98px;\">\n");
      out.write("        <option   value =\"\">请选择</option>\n");
      out.write("        <option  value =\"m\" >男</option>\n");
      out.write("        <option  value =\"f\" >女</option></select>\n");
      out.write("      <input type=\"button\" name=\"search\"  value=\"search\" style=\"width:100px;\" onclick=\"search();\"/>\n");
      out.write("      <input type=\"button\" name=\"reset\" value=\"reset\" onclick=\"reset();\" style=\"width:100px;\"/>\n");
      out.write("    </div>\n");
      out.write("    <div>\n");
      out.write("      <input type=\"button\" value=\"Insert\" style=\"width:100px;\" id=\"btn_insert\"  />\n");
      out.write("      <input type=\"button\" value=\"Delete\" onclick=\"confirmDelete()\" style=\"width:100px;\"/>\n");
      out.write("      <input type=\"button\" value=\"测试数据\" style=\"width:100px;\" id=\"test_insert\"  />\n");
      out.write("      <table id =\"table\" border=\"1\" bordercolor=\"#000000\" style=\"border-collapse:collapse;\" cellpadding=\"5\">\n");
      out.write("        <tr class=\"title\">\n");
      out.write("          <th  width=\"1%\"><input type=\"checkbox\" id=\"selectAll\" name=\"selectAll\"  onclick=\"toselectAll();\"/></th>\n");
      out.write("          <th sortcolname=\"bookid\" width=\"2%\">ID</th>\n");
      out.write("          <th sortcolname=\"name\" width=\"6%\">名称</th>\n");
      out.write("          <th sortcolname=\"status\" width=\"3%\">状态</th>\n");
      out.write("          <th sortcolname=\"type\" width=\"8%\">类型</th>\n");
      out.write("          <th sortcolname=\"isbn\" width=\"6%\">ISBN</th>\n");
      out.write("          <th sortcolname=\"publish\" width=\"6%\">出版社</th>\n");
      out.write("          <th sortcolname=\"price\" width=\"2%\">价格</th>\n");
      out.write("          <th sortcolname=\"author_name\" width=\"3%\">作者</th>\n");
      out.write("          <th sortcolname=\"author_sex\" width=\"2%\">性别</th>\n");
      out.write("          <th sortcolname=\"author_age\" width=\"2%\">年龄</th>\n");
      out.write("          <th sortcolname=\"modified\" width=\"7%\">最后修改时间</th>\n");
      out.write("          <th sortcolname=\"created\" width=\"7%\">创建时间</th>\n");
      out.write("          <th sortcolname=\"memo\" width=\"13%\" style=\"word-wrap:break-word;\">备注</th>\n");
      out.write("          <th width=\"2%\">操作</th>\n");
      out.write("        </tr>\n");
      out.write("        <tbody id=\"tbody\">\n");
      out.write("        </tbody>\n");
      out.write("      </table>\n");
      out.write("    </div>\n");
      out.write("    <table>\n");
      out.write("      <tbody id=\"tbody1\">\n");
      out.write("      </tbody>\n");
      out.write("    </table>\n");
      out.write("    <div id=\"addbg\"></div>\n");
      out.write("    <div id=\"adddiv\">\n");
      out.write("      <div class=\"addtop\" id = \"addclose\">\n");
      out.write("        <a href=\"javascript:;\"  class=\"addclose\" id = \"addclosehref\">关闭</a>\n");
      out.write("      </div>\n");
      out.write("      <input type=\"hidden\" name=\"upid\" />\n");
      out.write("      <input type=\"hidden\" name=\"created\" value=\"\"/>\n");
      out.write("      <table border=\"1\" bordercolor=\"#000000\" style=\"border-collapse:collapse; width: 250px\" cellpadding=\"5\" class=\"addTable\" >\n");
      out.write("        <tr>\n");
      out.write("          <th colspan=\"2\">书本信息</th>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>名称：</td>\n");
      out.write("          <td><input type=\"text\" name=\"upname\" style=\"width: 250px\"/></td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>状态：</td>\n");
      out.write("          <td><input type=\"radio\" name=\"upstatus\" value=\"1\" checked=\"checked\"/>在售(1)<input type=\"radio\" name=\"upstatus\" value=\"0\" id=\"status\"/>下架(0)</td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>类型：</td>\n");
      out.write("          <td>\n");
      out.write("            <input type=\"checkbox\" name=\"uptype\" value=\"武侠\"/>武侠&nbsp;\n");
      out.write("            <input type=\"checkbox\" name=\"uptype\" value=\"言情\"/>言情&nbsp;\n");
      out.write("            <input type=\"checkbox\" name=\"uptype\" value=\"校园\"/>校园&nbsp;\n");
      out.write("            <input type=\"checkbox\" name=\"uptype\" value=\"经典\"/>经典\n");
      out.write("          </td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>ISBN：</td>\n");
      out.write("          <td><input type=\"text\" name=\"upisbn\" style=\"width: 250px\"/></td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>出版社：</td>\n");
      out.write("          <td><input type=\"text\" name=\"uppublish\" style=\"width: 250px\"/></td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>价格：</td>\n");
      out.write("          <td><input type=\"text\" name=\"upprice\" style=\"width: 250px\"/></td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>作者：</td>\n");
      out.write("          <td>\n");
      out.write("            <input type=\"text\" name=\"upauthor\"  id=\"upauthor\" style=\"width: 250px\" list=\"upauthorinfo\"  onkeyup=\"select_authorinfo();\"/> \n");
      out.write("            <input type=\"hidden\" name=\"upauthor_id\"  id=\"upauthor_id\" style=\"width: 0px\"/> \n");
      out.write("            <div  id=\"upauthor_name\" style=\"position:absolute;top:317px;left:210px; background-color: wheat; width:250px;height:100px;overflow:auto;display:none;\"></div>\n");
      out.write("            <!-- <datalist id=\"upauthorinfo\"></datalist>-->\n");
      out.write("          </td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td>备注：</td>\n");
      out.write("          <td><textarea id = \"upmemo\" name=\"upmemo\" cols=20 rows=4 style=\"width: 250px\"></textarea></td>\n");
      out.write("        </tr>\n");
      out.write("        <tr>\n");
      out.write("          <td colspan=\"2\" align = \"center\">\n");
      out.write("            <input type=\"button\" value=\"插入\" id=\"add_button\" onclick=\"insert()\"  />\n");
      out.write("            <input type=\"button\" value=\"测试数据\" id=\"test_button\" onclick=\"test_insert()\"  />\n");
      out.write("            <input type=\"button\" value=\"修改\" id=\"update_button\"  />\n");
      out.write("          </td>\n");
      out.write("        </tr>\n");
      out.write("      </table>\n");
      out.write("    </div>\n");
      out.write("  </body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
