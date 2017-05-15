<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,
        java.util.*"%>
<%!
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

  public Map<String, String> mapFromRS( ResultSet rs )
  {
    Map<String, String> object = new HashMap<>();
    try
    {
      ResultSetMetaData rsmd = rs.getMetaData();
      int count = rsmd.getColumnCount();
      for ( int i = 1; i <= count; i++ )
      {
        String name = rsmd.getColumnName(i).toLowerCase();//获得列名的小写形式
        String key = rsmd.getColumnName(i);//获得列名
        if ( key.equals("ROWNUM_") )
        {
          continue;
        }
        if ( rsmd.getColumnType(i) == Types.CLOB )
        {
          continue;
        }
        if ( rsmd.getColumnType(i) == Types.BLOB )
        {
          continue;
        }
        String value = rs.getString(key);//字段对应的值
        object.put(key, value);
      }
    } catch ( Exception e )
    {
    }
    return object;
  }

  private List<Map<String, String>> query( Connection conn, String sql, List<String> params ) throws Exception
  {
    List<Map<String, String>> data = new ArrayList<>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try
    {
      System.out.println(sql);
      pstmt = conn.prepareStatement(sql);
      int parameterIndex = 0;
      System.out.println(params);
      for ( String param : params )
      {
        pstmt.setString(++parameterIndex, param);
      }
      rs = pstmt.executeQuery();
      while ( rs.next() )
      {
        Map<String, String> row = mapFromRS(rs);
        data.add(row);
      }
    } finally
    {
      try
      {
        rs.close();
      } catch ( Exception e )
      {
      }
      try
      {
        pstmt.close();
      } catch ( Exception e )
      {
      }
    }
    return data;
  }

  public void exec( Connection conn, String sql, List<String> params ) throws Exception
  {
    //具体实现
  }

  public Map<String, String> querySingleRow( Connection conn, String sql, List<String> params ) throws Exception
  {
    //查询单行
    //具体实现
    Map<String, String> row = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try
    {
      System.out.println(sql);
      pstmt = conn.prepareStatement(sql);
      int parameterIndex = 0;
      System.out.println(params);
      for ( String param : params )
      {
        pstmt.setString(++parameterIndex, param);
      }
      rs = pstmt.executeQuery();
      while ( rs.next() )
      {
        row = mapFromRS(rs);
        
      }
    } finally
    {
      try
      { 
        rs.close();
      } catch ( Exception e )
      {
      }
      try
      { 
        pstmt.close();
      } catch ( Exception e )
      {
      }
    }
    return row;

  }

  public int queryCount( Connection conn, String sql, List<String> params ) throws Exception
    {
      //查询数量
      //具体实现
      int count = 0;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      try
      {
        System.out.println(sql);
        pstmt = conn.prepareStatement(sql);
        int parameterIndex = 0;
        System.out.println(params);
        for ( String param : params )
        {
          pstmt.setString(++parameterIndex, param);
        }
        rs = pstmt.executeQuery();
        if ( rs.next() )
        {
          count = rs.getInt("all_count");
        }
      } finally
      {
        try
        {
          rs.close();
        } catch ( Exception e )
        {
        }
        try
        {
          pstmt.close();
        } catch ( Exception e )
        {
        }
      }
      return count;
    }

  public String buildQueryWhere( HttpServletRequest request, String old_where, String param_name, String column_name, String sql_operator )
  {
    StringBuilder new_where = new StringBuilder(old_where);
    if ( old_where != "" )
    {
      new_where.append(" AND ");
    }
//      if ( sql_operator == "LIKE" )
//      {
//        new_where.append("" + column_name + " " + sql_operator + " %" + param_name + "%");
//      } else
//      {
    new_where.append("" + column_name + " " + sql_operator + " " + param_name + "");
    // }
    return new_where.toString();
  }
%>