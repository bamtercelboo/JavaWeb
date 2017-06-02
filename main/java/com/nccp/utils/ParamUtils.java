package com.nccp.utils;

import javax.servlet.ServletRequest;

/**
 *  This class privide some method to get parameters.
 */
public class ParamUtils {

  /**
   *  Gets a parameter as a string.
   *
   *  @param request The HttpServletRequest object, known as "request" in a JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @param default_value The default value
   *  @return The value of the parameter or null if the parameter was not found or if the parameter is a zero-length string.
   */
  public static String getParameter( ServletRequest request, String paramName, String default_value )
  {
    String temp = getParameter( request, paramName, false );
    if( null == temp )
      return default_value;
    return temp;
  }

  /**
   *  Gets a parameter as a string.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @return The value of the parameter or null if the parameter was not
   *  found or if the parameter is a zero-length string.
   */
  public static String getParameter( ServletRequest request, String paramName )
  {
    return getParameter( request, paramName, false );
  }

  /**
   *  Gets a parameter as a string.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @param emptyStringsOK Return the parameter values even if it is an empty string.
   *  @return The value of the parameter or null if the parameter was not
   *  found.
   */
  public static String getParameter( ServletRequest request, String paramName, boolean emptyStringsOK )
  {
    String temp = request.getParameter(paramName);
    if( temp != null )
    {
      if( temp.equals("") && !emptyStringsOK )
          return null;
      else
          return temp;
    }
    else
      return null;
  }

  /**
   *  Gets a parameter as a boolean.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @return True if the value of the parameter was "true", false otherwise.
   */
  public static boolean getBooleanParameter( ServletRequest request, String paramName )
  {
    String temp = request.getParameter( paramName );
    if( temp != null && temp.equals("true") )
      return true;
    else
      return false;
  }

  /**
   *  Gets a parameter as a int.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @param defaultNum The default value
   *  @return The int value of the parameter specified or the default value if
   *  the parameter is not found.
   */
  public static int getIntParameter( ServletRequest request, String paramName, int defaultNum )
  {
    String temp = request.getParameter(paramName);
    if( temp != null && !temp.equals("") )
    {
      int num = defaultNum;
      try
      {
        num = Integer.parseInt(temp);
      }
      catch( Exception ignored ) {}
      return num;
    }
    else
      return defaultNum;
  }

  /**
   *  Gets a parameter as a long.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @param defaultNum The default value
   *  @return The int value of the parameter specified or the default value if
   *  the parameter is not found.
   */
  public static long getLongParameter( ServletRequest request, String paramName, long defaultNum )
  {
    String temp = request.getParameter(paramName);
    if( temp != null && !temp.equals("") )
    {
      long num = defaultNum;
      try
      {
        num = Long.parseLong(temp);
      }
      catch( Exception ignored ) {}
      return num;
    }
    else
      return defaultNum;
  }

  /**
   *  Gets a checkbox parameter value as a boolean.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param paramName The name of the parameter you want to get
   *  @return True if the value of the checkbox is "on", false otherwise.
   */
  public static boolean getCheckboxParameter( ServletRequest request, String paramName )
  {
    String temp = request.getParameter(paramName);
    if( temp != null && temp.equals("on") )
      return true;
    else
      return false;
  }

  /**
   *  Gets a request attribute as a string.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param attribName The name of the parameter you want to get
   *  @return The value of the parameter or null if the parameter was not
   *  found or if the parameter is a zero-length string.
   */
  public static String getAttribute( ServletRequest request, String attribName )
  {
    return getAttribute( request, attribName, false );
  }

  /**
   *  Gets a request attribute as a string.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param attribName The name of the parameter you want to get
   *  @param emptyStringsOK Return the parameter values even if it is an empty string.
   *  @return The value of the parameter or null if the parameter was not
   *  found.
   */
  public static String getAttribute( ServletRequest request, String attribName, boolean emptyStringsOK )
  {
    String temp = (String)request.getAttribute(attribName);
    if( temp != null )
    {
      if( temp.equals("") && !emptyStringsOK )
        return null;
      else
        return temp;
    }
    else
      return null;
  }

  /**
   *  Gets a request attribute as a boolean.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param attribName The name of the attribute you want to get
   *  @return True if the value of the attribute is "true", false otherwise.
   */
  public static boolean getBooleanAttribute( ServletRequest request, String attribName )
  {
    String temp = (String)request.getAttribute(attribName);
    if( temp != null && temp.equals("true") )
      return true;
    else
      return false;
  }

  /**
   *  Gets a request attribute as a int.
   *  @param request The HttpServletRequest object, known as "request" in a
   *  JSP page.
   *  @param attribName The name of the attribute you want to get
   *  @param defaultNum The default value
   *  @return The int value of the attribute or the default value if the attribute is not
   *  found or is a zero length string.
   */
  public static int getIntAttribute( ServletRequest request, String attribName, int defaultNum )
  {
    String temp = (String)request.getAttribute(attribName);
    if( temp != null && !temp.equals("") )
    {
      int num = defaultNum;
      try
      {
        num = Integer.parseInt(temp);
      }
      catch( Exception ignored ) {}
      return num;
    }
    else
      return defaultNum;
  }
}
