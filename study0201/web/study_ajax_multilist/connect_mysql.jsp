<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,
        java.util.*"%>
<%
  //设置成UTF-8，解决中文乱码问题
  request.setCharacterEncoding("UTF-8");
%>
<%!
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
        //System.out.println("row data "+row);
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
    list.add("authorname");
    list.add("authorage");
    for ( String param : list ) {
      String paramvalue = request.getParameter(param);
      if ( paramvalue == null || paramvalue.trim().length() == 0 ) {
        result = param + "不能为空";
        break;
      }
    }
    return result;
  }
 public String book_formvalidate( HttpServletRequest request ) throws Exception
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
%>