/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.utils;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.lang.reflect.Type;
import java.net.JarURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.Enumeration;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author liuwei
 */
public class ClassUtils
{
  private static final Logger logger = Logger.getLogger( ClassUtils.class.getName() );
  
  private static void _findAndAddClassesInPackageByFile( String packageName, String superClassName, String packagePath, final boolean recursive, Set<Class<?>> classes )
  {
    // 获取此包的目录 建立一个File  
    File dir = new File( packagePath );
    // 如果不存在或者 也不是目录就直接返回  
    if ( !dir.exists() || !dir.isDirectory() )
    {
      logger.log( Level.WARNING, "用户定义包名 " + packageName + " 下没有任何文件" );
      return;
    }
    // 如果存在 就获取包下的所有文件 包括目录  
    // 自定义过滤规则 如果可以循环(包含子目录) 或则是以.class结尾的文件(编译好的java类文件)  
    File[] dirfiles = dir.listFiles((File file) -> ( recursive && file.isDirectory()) || ( file.getName().endsWith( ".class" ) ));
    // 循环所有文件  
    for ( File file : dirfiles )
    {
      // 如果是目录 则继续扫描
      if ( file.isDirectory() )
      {
        _findAndAddClassesInPackageByFile( packageName + "." + file.getName(), superClassName, file.getAbsolutePath(), recursive, classes );
      }
      else
      {
        // 如果是java类文件 去掉后面的.class 只留下类名  
        String className = file.getName().substring( 0, file.getName().length() - 6 );
        try
        {
          // 添加到集合中去  
          //classes.add(Class.forName(packageName + '.' + className));  
          //经过回复同学的提醒，这里用forName有一些不好，会触发static方法，没有使用classLoader的load干净
          Class c = Thread.currentThread().getContextClassLoader().loadClass( packageName + '.' + className );
          if( ( superClassName != null ) && ( isChildOf( c, superClassName ) ) )
          {
            classes.add( c );
          }
        }
        catch ( ClassNotFoundException e )
        {
          //无法加载 class 忽略
          logger.log( Level.SEVERE, null, e );
        }
      }
    }
  }
  
  /**
   * 扫描指定的包下面的所有 class 并返回
   * 
   * @param packageName 指定的包
   * @param superClassName 如果非NULL, 只装载指定类名的子类
   * @return Set of Class
   */
  public static Set<Class<?>> packageScan( String packageName, String superClassName )
  {
    Set<Class<?>> classes = new LinkedHashSet<>();
    String packageDirName = packageName.replace( '.', '/' );
    // 是否循环迭代  
    boolean recursive = true;
    try
    {
      Enumeration<URL> dirs = Thread.currentThread().getContextClassLoader().getResources( packageDirName );
      while ( dirs.hasMoreElements() )
      {
        // 获取下一个元素  
        URL url = dirs.nextElement();
        // 得到协议的名称  
        String protocol = url.getProtocol();
        if ("file".equals(protocol))
        {
          String filePath = URLDecoder.decode(url.getFile(), "UTF-8");
          _findAndAddClassesInPackageByFile( packageName, superClassName, filePath, recursive, classes );
        }
        else if ("jar".equals(protocol))
        {
          // 如果是jar包文件  
          // 定义一个JarFile  
          System.err.println( "jar类型的扫描" );
          JarFile jar;
          try
          {
            // 获取jar  
            jar = (( JarURLConnection ) url.openConnection()).getJarFile();
            // 从此jar包 得到一个枚举类  
            Enumeration<JarEntry> entries = jar.entries();
            // 同样的进行循环迭代  
            while ( entries.hasMoreElements() )
            {
              // 获取jar里的一个实体 可以是目录 和一些jar包里的其他文件 如META-INF等文件  
              JarEntry entry = entries.nextElement();
              String name = entry.getName();
              // 如果是以/开头的  
              if ( name.charAt( 0 ) == '/' )
              {
                // 获取后面的字符串  
                name = name.substring( 1 );
              }
              // 如果前半部分和定义的包名相同  
              if ( name.startsWith( packageDirName ) )
              {
                int idx = name.lastIndexOf( '/' );
                // 如果以"/"结尾 是一个包  
                if ( idx != -1 )
                {
                  // 获取包名 把"/"替换成"."  
                  packageName = name.substring( 0, idx ).replace( '/', '.' );
                }
                // 如果可以迭代下去 并且是一个包  
                if ( (idx != -1) || recursive )
                {
                  // 如果是一个.class文件 而且不是目录  
                  if ( name.endsWith( ".class" ) && !entry.isDirectory() )
                  {
                    // 去掉后面的".class" 获取真正的类名  
                    String className = name.substring( packageName.length() + 1, name.length() - 6 );
                    try
                    {
                      // 添加到classes  
                      classes.add( Class.forName( packageName + '.' + className ) );
                    }
                    catch ( ClassNotFoundException e )
                    {
                      // 找不到 class 忽略
                      logger.log( Level.SEVERE, null, e );
                    }
                  }
                }
              }
            }
          }
          catch ( IOException e )
          {
            // 装载 jar 出错, 忽略
            logger.log( Level.SEVERE, null, e );
          }
        }
      }
    }
    catch ( IOException ex )
    {
      logger.log( Level.SEVERE, null, ex );
    }
    return classes;
  }
  
  /**
   * 判断某个类是否是指定类名的子类
   * 
   * @param c 类对象
   * @param className 指定类
   * @return true 如果是
   */
  public static boolean isChildOf( Class c, String className )
  {
    Type t = c.getGenericSuperclass();
    if( t.getTypeName().equals( "java.lang.Object" ) )
    {
      return false;
    }
    if( t.getTypeName().equals( className ) )
    {
      return true;
    }
    return isChildOf( t.getClass(), className );
  }
}
