package com.nccp.utils;

import java.io.BufferedReader;
import java.io.StringReader;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.BreakIterator;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.StringTokenizer;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.internet.InternetAddress;

public class StringUtils
{
  private static final char QUOTE_ENCODE[] = "&quot;".toCharArray();
  private static final char AMP_ENCODE[] = "&amp;".toCharArray();
  private static final char LT_ENCODE[] = "&lt;".toCharArray();
  private static final char GT_ENCODE[] = "&gt;".toCharArray();
//  private static final char APOS_ENCODE[] = "&apos;".toCharArray();
  public static final String BLANK = "��";
  private static final Object initLock = new Object();
  private static MessageDigest digest = null;
//  private static final int fillchar = 61;
  private static final String commonWords[] = {
      "a", "and", "as", "at", "be", "do", "i", "if", "in", "is",
      "it", "so", "the", "to"
  };
  private static Map<String, String> commonWordsMap = null;
  private static Random randGen = null;
  private static char numbersAndLetters[] = null;
  private static final char zeroArray[] = "0000000000000000".toCharArray();
  public static final SimpleDateFormat short_date_format = new SimpleDateFormat("yyyy��MM��dd��");
  public static final SimpleDateFormat long_date_format = new SimpleDateFormat("yyyy��MM��dd�� HH��mm��ss��");

  private final static char BASE64_SEED[] = {
          'A','B','C','D','E','F','G','H', // 0
          'I','J','K','L','M','N','O','P', // 1
          'Q','R','S','T','U','V','W','X', // 2
          'Y','Z','a','b','c','d','e','f', // 3
          'g','h','i','j','k','l','m','n', // 4
          'o','p','q','r','s','t','u','v', // 5
          'w','x','y','z','0','1','2','3', // 6
          '4','5','6','7','8','9','+','/'  // 7
  };
  private final static byte BASE64_CONVERT_SEED[] = new byte[256];

  static
  {
    for (int i = 0; i < 255; i++)
      BASE64_CONVERT_SEED[i] = -1;
    for(int i = 0; i < BASE64_SEED.length; i++)
      BASE64_CONVERT_SEED[BASE64_SEED[i]] = (byte) i;
  }

  /**
   * find key word in string and replace it with replace string.
   * @param line the source string
   * @param oldString the key string
   * @param newString the replace string
   * @return new string
   */
  public static String replace(String line, String oldString, String newString)
  {
    if(line == null)
      return null;
    int i = 0;
    if((i = line.indexOf(oldString, i)) >= 0)
    {
      char line2[] = line.toCharArray();
      char newString2[] = newString.toCharArray();
      int oLength = oldString.length();
      StringBuilder buf = new StringBuilder(line2.length);
      buf.append(line2, 0, i).append(newString2);
      i += oLength;
      int j;
      for(j = i; (i = line.indexOf(oldString, i)) > 0; j = i)
      {
        buf.append(line2, j, i - j).append(newString2);
        i += oLength;
      }

      buf.append(line2, j, line2.length - j);
      return buf.toString();
    }
    else
    {
      return line;
    }
  }

  /**
   * find key word in string and replace it with replace string, but ignore string CASE.
   * @param line the source string
   * @param oldString the key string
   * @param newString the replace string
   * @return new string
   */
  public static String replaceIgnoreCase(String line, String oldString, String newString)
  {
    if(line == null)
      return null;
    String lcLine = line.toLowerCase();
    String lcOldString = oldString.toLowerCase();
    int i = 0;
    if((i = lcLine.indexOf(lcOldString, i)) >= 0)
    {
      char line2[] = line.toCharArray();
      char newString2[] = newString.toCharArray();
      int oLength = oldString.length();
      StringBuilder buf = new StringBuilder(line2.length);
      buf.append(line2, 0, i).append(newString2);
      i += oLength;
      int j;
      for(j = i; (i = lcLine.indexOf(lcOldString, i)) > 0; j = i)
      {
        buf.append(line2, j, i - j).append(newString2);
        i += oLength;
      }

      buf.append(line2, j, line2.length - j);
      return buf.toString();
    }
    else
    {
      return line;
    }
  }

  /**
   * find key word in string and replace it with replace string, ignore CASE.
   * @param line the source string
   * @param oldString the key string
   * @param newString the replace string
   * @param count how many key replace put into it
   * @return new string
   */
  public static String replaceIgnoreCase(String line, String oldString, String newString, int count[])
  {
    if(line == null)
      return null;
    String lcLine = line.toLowerCase();
    String lcOldString = oldString.toLowerCase();
    int i = 0;
    if((i = lcLine.indexOf(lcOldString, i)) >= 0)
    {
      int counter = 0;
      char line2[] = line.toCharArray();
      char newString2[] = newString.toCharArray();
      int oLength = oldString.length();
      StringBuilder buf = new StringBuilder(line2.length);
      buf.append(line2, 0, i).append(newString2);
      i += oLength;
      int j;
      for(j = i; (i = lcLine.indexOf(lcOldString, i)) > 0; j = i)
      {
        counter++;
        buf.append(line2, j, i - j).append(newString2);
        i += oLength;
      }

      buf.append(line2, j, line2.length - j);
      count[0] = counter;
      return buf.toString();
    }
    else
    {
      return line;
    }
  }

  /**
   * find key word in string and replace it with replace string.
   * @param line the source string
   * @param oldString the key string
   * @param newString the replace string
   * @param count how many key replace put into it
   * @return new string
   */
  public static String replace(String line, String oldString, String newString, int count[])
  {
    if(line == null)
      return null;
    int i = 0;
    if((i = line.indexOf(oldString, i)) >= 0)
    {
      int counter = 0;
      counter++;
      char line2[] = line.toCharArray();
      char newString2[] = newString.toCharArray();
      int oLength = oldString.length();
      StringBuilder buf = new StringBuilder(line2.length);
      buf.append(line2, 0, i).append(newString2);
      i += oLength;
      int j;
      for(j = i; (i = line.indexOf(oldString, i)) > 0; j = i)
      {
        counter++;
        buf.append(line2, j, i - j).append(newString2);
        i += oLength;
      }

      buf.append(line2, j, line2.length - j);
      count[0] = counter;
      return buf.toString();
    }
    else
    {
      return line;
    }
  }

  /**
   * replace HTML tage with gt and lt tag.
   * @param in string to be escaped.
   * @return escaped string
   */
  public static String escapeHTMLTags(String in)
  {
    if(in == null)
      return null;
    int i = 0;
    int last = 0;
    char input[] = in.toCharArray();
    int len = input.length;
    StringBuilder out = new StringBuilder((int)((double)len * 1.3D));
    for(; i < len; i++)
    {
      char ch = input[i];
      if(ch <= '>')
        if(ch == '<')
        {
          if(i > last)
              out.append(input, last, i - last);
          last = i + 1;
          out.append(LT_ENCODE);
        } else
        if(ch == '>')
        {
          if(i > last)
              out.append(input, last, i - last);
          last = i + 1;
          out.append(GT_ENCODE);
        } else
        if(ch == '"')
        {
          if(i > last)
              out.append(input, last, i - last);
          last = i + 1;
          out.append(QUOTE_ENCODE);
        }
    }

    if(last == 0)
      return in;
    if(i > last)
      out.append(input, last, i - last);
    return out.toString();
  }

  /**
   * MD5 hash, using for password encode.
   * @param data source string
   * @return hashed string
   */
  public static synchronized String hash(String data)
  {
    if(digest == null)
      try
      {
        digest = MessageDigest.getInstance("MD5");
      }
      catch(NoSuchAlgorithmException nsae)
      {
        System.err.println("Failed to load the MD5 MessageDigest. Jive will be unable to function normally.");
      }
    digest.update(data.getBytes());
    return encodeHex(digest.digest());
  }

  /**
   * encode bytes by HEX method.
   * @param bytes to be hexed
   * @return hexed string
   */
  public static String encodeHex(byte bytes[])
  {
    StringBuilder buf = new StringBuilder(bytes.length * 2);
    for(int i = 0; i < bytes.length; i++)
    {
      if((bytes[i] & 0xff) < 16)
        buf.append("0");
      buf.append(Long.toString(bytes[i] & 0xff, 16));
    }

    return buf.toString();
  }

  /**
   * encode string by HEX method
   * @param source string to be hexed
   * @return hexed string
   */
  public static String encodeHex(String source)
  {
    if(source == null)
      return null;

    byte[] bytes = null;
    try
    {
      bytes = source.getBytes("GBK");
    }
    catch(Exception e)
    {
      bytes = source.getBytes();
    }

    return encodeHex(bytes);
  }

  /**
   * decode hexed string
   * @param hex hexed string
   * @return decode string
   */
  public static String decodeHex(String hex)
  {
    if(hex == null)
      return null;

    char chars[] = hex.toCharArray();
    byte bytes[] = new byte[chars.length / 2];
    int byteCount = 0;
    for(int i = 0; i < chars.length; i += 2)
    {
      byte newByte = 0;
      newByte |= hexCharToByte(chars[i]);
      newByte <<= 4;
      newByte |= hexCharToByte(chars[i + 1]);
      bytes[byteCount] = newByte;
      byteCount++;
    }

    String ret = null;
    try
    {
      ret = new String(bytes, "GBK");
    }
    catch(Exception e)
    {
      ret = new String(bytes);
    }
    return ret;
  }

  private static byte hexCharToByte(char ch)
  {
    switch(ch)
    {
    case 48: // '0'
      return 0;

    case 49: // '1'
      return 1;

    case 50: // '2'
      return 2;

    case 51: // '3'
      return 3;

    case 52: // '4'
      return 4;

    case 53: // '5'
      return 5;

    case 54: // '6'
      return 6;

    case 55: // '7'
      return 7;

    case 56: // '8'
      return 8;

    case 57: // '9'
      return 9;

    case 97: // 'a'
      return 10;

    case 98: // 'b'
      return 11;

    case 99: // 'c'
      return 12;

    case 100: // 'd'
      return 13;

    case 101: // 'e'
      return 14;

    case 102: // 'f'
      return 15;

    case 58: // ':'
    case 59: // ';'
    case 60: // '<'
    case 61: // '='
    case 62: // '>'
    case 63: // '?'
    case 64: // '@'
    case 65: // 'A'
    case 66: // 'B'
    case 67: // 'C'
    case 68: // 'D'
    case 69: // 'E'
    case 70: // 'F'
    case 71: // 'G'
    case 72: // 'H'
    case 73: // 'I'
    case 74: // 'J'
    case 75: // 'K'
    case 76: // 'L'
    case 77: // 'M'
    case 78: // 'N'
    case 79: // 'O'
    case 80: // 'P'
    case 81: // 'Q'
    case 82: // 'R'
    case 83: // 'S'
    case 84: // 'T'
    case 85: // 'U'
    case 86: // 'V'
    case 87: // 'W'
    case 88: // 'X'
    case 89: // 'Y'
    case 90: // 'Z'
    case 91: // '['
    case 92: // '\\'
    case 93: // ']'
    case 94: // '^'
    case 95: // '_'
    case 96: // '`'
    default:
      return 0;
    }
  }

  /**
   * encode string by BASE64 method
   * @param data to be encoded string
   * @return encoded string
   */
  public static String encodeBase64(String data)
  {
    if(data == null)
      return "";

    byte[] bytes = null;
    try
    {
      bytes = data.getBytes("GBK");
    }
    catch(Exception e)
    {
      bytes = data.getBytes();
    }
    byte[] rets = encodeBase64(bytes);
    String ret = null;
    try
    {
      ret = new String(rets, "GBK");
    }
    catch(Exception e)
    {
      ret = new String(rets);
    }
    return ret;
  }

  private static byte[] encodeBase64(byte[] inbuf)
  {
    if (inbuf.length == 0)
      return inbuf;
    byte[] outbuf = new byte[((inbuf.length + 2) / 3) * 4];
    int inpos = 0, outpos = 0;
    int size = inbuf.length;
    while (size > 0)
    {
      byte a, b, c;
      if (size == 1)
      {
        a = inbuf[inpos++];
        b = 0;
        c = 0;
        outbuf[outpos++] = (byte)BASE64_SEED[(a >>> 2) & 0x3F];
        outbuf[outpos++] =
            (byte)BASE64_SEED[((a << 4) & 0x30) + ((b >>> 4) & 0xf)];
        outbuf[outpos++] = (byte)'=';  // pad character
        outbuf[outpos++] = (byte)'=';  // pad character
      }
      else if (size == 2)
      {
        a = inbuf[inpos++];
        b = inbuf[inpos++];
        c = 0;
        outbuf[outpos++] = (byte)BASE64_SEED[(a >>> 2) & 0x3F];
        outbuf[outpos++] =
            (byte)BASE64_SEED[((a << 4) & 0x30) + ((b >>> 4) & 0xf)];
        outbuf[outpos++] =
            (byte)BASE64_SEED[((b << 2) & 0x3c) + ((c >>> 6) & 0x3)];
        outbuf[outpos++] = (byte)'=';  // pad character
      }
      else
      {
        a = inbuf[inpos++];
        b = inbuf[inpos++];
        c = inbuf[inpos++];
        outbuf[outpos++] = (byte)BASE64_SEED[(a >>> 2) & 0x3F];
        outbuf[outpos++] =
            (byte)BASE64_SEED[((a << 4) & 0x30) + ((b >>> 4) & 0xf)];
        outbuf[outpos++] =
            (byte)BASE64_SEED[((b << 2) & 0x3c) + ((c >>> 6) & 0x3)];
        outbuf[outpos++] = (byte)BASE64_SEED[c & 0x3F];
      }
      size -= 3;
    }

    byte[] ret = new byte[outpos];
    System.arraycopy(outbuf, 0, ret, 0, outpos);

    return ret;
  }

  private static byte[] decodeBase64(byte[] inbuf)
  {
    int size = inbuf.length;
    if (size == 0)
      return inbuf;

    if (inbuf[inbuf.length - 1] == '=') {
      size--;
      if (inbuf[inbuf.length - 2] == '=')
        size--;
    }
    byte[] outbuf = new byte[size];
    byte[] ret = null;

    int inpos = 0, outpos = 0;
    while (size > 0) {
      byte a, b;
      a = BASE64_CONVERT_SEED[inbuf[inpos++] & 0xff];
      b = BASE64_CONVERT_SEED[inbuf[inpos++] & 0xff];
      // The first decoded byte
      outbuf[outpos++] = (byte)(((a << 2) & 0xfc) | ((b >>> 4) & 3));

      if (inbuf[inpos] == '=') // End of this BASE64 encoding
      {
        ret = new byte[outpos];
        System.arraycopy(outbuf, 0, ret, 0, outpos);

        return ret;
      }
      a = b;
      b = BASE64_CONVERT_SEED[inbuf[inpos++] & 0xff];
      // The second decoded byte
      outbuf[outpos++] = (byte)(((a << 4) & 0xf0) | ((b >>> 2) & 0xf));

      if (inbuf[inpos] == '=') // End of this BASE64 encoding
      {
        ret = new byte[outpos];
        System.arraycopy(outbuf, 0, ret, 0, outpos);

        return ret;
      }
      a = b;
      b = BASE64_CONVERT_SEED[inbuf[inpos++] & 0xff];
      // The third decoded byte
      outbuf[outpos++] = (byte)(((a << 6) & 0xc0) | (b & 0x3f));
      size -= 4;
    }
    ret = new byte[outpos];
    System.arraycopy(outbuf, 0, ret, 0, outpos);

    return ret;
  }

  /**
   * decode BAES64 encoded string
   * @param data encoded string
   * @return decoded string
   */
  public static String decodeBase64(String data)
  {
    if(data == null)
      return "";

    byte[] bytes = null;
    try
    {
      bytes = data.getBytes("GBK");
    }
    catch(Exception e)
    {
      bytes = data.getBytes();
    }
    byte[] rets = decodeBase64(bytes);
    String ret = null;
    try
    {
      ret = new String(rets, "GBK");
    }
    catch(Exception e)
    {
      ret = new String(rets);
    }
    return ret;
  }

  public static String[] toLowerCaseWordArray(String text)
  {
    if(text == null || text.length() == 0)
      return new String[0];
    List<String> wordList = new ArrayList<String>();
    BreakIterator boundary = BreakIterator.getWordInstance();
    boundary.setText(text);
    int count = 0;
    int start = 0;
    for(int end = boundary.next(); end != -1; end = boundary.next())
    {
      String tmp = text.substring(start, end).trim();
      tmp = replace(tmp, "+", "");
      tmp = replace(tmp, "/", "");
      tmp = replace(tmp, "\\", "");
      tmp = replace(tmp, "#", "");
      tmp = replace(tmp, "*", "");
      tmp = replace(tmp, ")", "");
      tmp = replace(tmp, "(", "");
      tmp = replace(tmp, "&", "");
      if(tmp.length() > 0)
      {
        wordList.add(tmp);
        count++;
      }
      start = end;
    }

    return (String[])wordList.toArray(new String[wordList.size()]);
  }

  public static String[] removeCommonWords(String words[])
  {
    synchronized(initLock)
    {
      if(commonWordsMap == null)
      {
        commonWordsMap = new HashMap<String, String>();
        for( String commonWord : commonWords )
          commonWordsMap.put( commonWord, commonWord );
      }
    }
    List<String> results = new ArrayList<String>(words.length);
    for( String word : words )
    {
      if(!commonWordsMap.containsKey( word ))
        results.add( word );
    }

    return (String[])results.toArray(new String[results.size()]);
  }

  /**
   * get out a random string.
   * @param length string length
   * @return random string
   */
  public static String randomString(int length)
  {
    if(length < 1)
      return null;
    synchronized(initLock)
    {
      if(randGen == null)
      {
        randGen = new Random(System.currentTimeMillis());
        numbersAndLetters = "0123456789abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
      }
    }
    char randBuffer[] = new char[length];
    for(int i = 0; i < randBuffer.length; i++)
      randBuffer[i] = numbersAndLetters[randGen.nextInt(71)];

    return new String(randBuffer);
  }

  /**
   * get out a random int.
   * @param sss 0-(seed-1) value
   * @return random int
   */
  public static int randomInt(int sss)
  {
    if(sss <= 1)
      return 0;
    synchronized(initLock)
    {
      if(randGen == null)
      {
        randGen = new Random(System.currentTimeMillis());
        numbersAndLetters = "0123456789abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
      }
    }
    
    return randGen.nextInt( sss );
  }

  public static String chopAtWord(String string, int length)
  {
    if(string == null)
      return string;
    char charArray[] = string.toCharArray();
    int sLength = string.length();
    if(length < sLength)
      sLength = length;
    for(int i = 0; i < sLength - 1; i++)
    {
      if(charArray[i] == '\r' && charArray[i + 1] == '\n')
        return string.substring(0, i + 1);
      if(charArray[i] == '\n')
        return string.substring(0, i);
    }

    if(charArray[sLength - 1] == '\n')
      return string.substring(0, sLength - 1);
    if(string.length() < length)
      return string;
    for(int i = length - 1; i > 0; i--)
      if(charArray[i] == ' ')
        return string.substring(0, i).trim();

    return string.substring(0, length);
  }

  /**
   * escape for XML tags.
   * @param in string to be escaped
   * @return escaped string
   */
  public static String escapeForXML(String in)
  {
    if(in == null)
      return null;
    int i = 0;
    int last = 0;
    char input[] = in.toCharArray();
    int len = input.length;
    StringBuilder out = new StringBuilder((int)((double)len * 1.3D));
    for(; i < len; i++)
    {
      char ch = input[i];
      if(ch <= '>')
        if(ch == '<')
        {
          if(i > last)
            out.append(input, last, i - last);
          last = i + 1;
          out.append(LT_ENCODE);
        } else
        if(ch == '&')
        {
          if(i > last)
            out.append(input, last, i - last);
          last = i + 1;
          out.append(AMP_ENCODE);
        } else
        if(ch == '"')
        {
          if(i > last)
            out.append(input, last, i - last);
          last = i + 1;
          out.append(QUOTE_ENCODE);
        }
    }

    if(last == 0)
      return in;
    if(i > last)
      out.append(input, last, i - last);
    return out.toString();
  }

  /**
   * unescape string from XML tags.
   * @param string escaped string
   * @return un escaped string
   */
  public static String unescapeFromXML(String string)
  {
    string = replace(string, "&lt;", "<");
    string = replace(string, "&gt;", ">");
    string = replace(string, "&quot;", "\"");
    return replace(string, "&amp;", "&");
  }

  public static String zeroPadString(String string, int length)
  {
    StringBuilder buf = new StringBuilder(length);
    buf.append(zeroArray, 0, length - string.length()).append(string);
    return buf.toString();
  }

  public static String dateToMillis(Date date)
  {
    return zeroPadString(Long.toString(date.getTime()), 15);
  }

  //Time constants (in milliseconds)
  private static final long SECOND = 1000;
  private static final long MINUTE = 60 * SECOND;
  private static final long HOUR   = 60 * MINUTE;
  private static final long DAY    = 24 * HOUR;
  private static final long WEEK   = 7 * DAY;

  //Days of the week
  private static final String[] DAYS_OF_WEEK =
      { "������","����һ","���ڶ�","������","������","������","������" };

  // SimpleDateFormat objects for use in the dateToText method
  private static final SimpleDateFormat dateFormatter =
      new SimpleDateFormat("yyyy��MM��dd��");
  private static final SimpleDateFormat shortDateFormatter =
      new SimpleDateFormat("MM��dd��");
  private static final SimpleDateFormat yesterdayFormatter =
      new SimpleDateFormat("���� HH��mm��");
  private static final SimpleDateFormat todayFormatter =
      new SimpleDateFormat("���� HH��mm��");

  /**
   * Returns a String describing the amount of time between now (current
   * system time) and the passed in date time. Example output is "5 hours
   * ago" or "Yesterday at 3:30 pm"
   *
   * @param date the Date to compare the current time with.
   * @return a description of the difference in time, ie: "5 hours ago"
   *      or "Yesterday at 3:30pm"
   */
  public static String shortFormatDate( Date date )
  {
    if( date == null )
      return "";

    long now = System.currentTimeMillis();

    if(now < date.getTime())
      return dateFormatter.format(date);

    Calendar nowCalendar = Calendar.getInstance(new Locale("zh", "CN"));
    nowCalendar.setTime(new Date(now));

    Calendar dateCalendar = Calendar.getInstance(new Locale("zh", "CN"));
    dateCalendar.setTime(date);

    long delta = now - date.getTime();
    // һСʱ��
    if( (delta / HOUR) < 1 )
    {
      long minutes = (delta/MINUTE);
      if( minutes == 0 )
      {
        return "�ղ�";
      }
      else
      {
        return ( minutes + " ����ǰ" );
      }
    }

    // һ����
    if( (delta / DAY) < 1 )
    {
      long hours = (delta/HOUR);
      if(hours <= 4)
      {
        return ( hours + " Сʱǰ" );
      }
      else if(nowCalendar.get(Calendar.DAY_OF_YEAR) == dateCalendar.get(Calendar.DAY_OF_YEAR))
      {
        //����
        return todayFormatter.format(date);
      }
      else //����
        return yesterdayFormatter.format(date);
    }

    // ������
    if( (delta / WEEK) < 1 )
    {
      if(nowCalendar.get(Calendar.WEEK_OF_YEAR) == dateCalendar.get(Calendar.WEEK_OF_YEAR))
      {
        //������
        return DAYS_OF_WEEK[dateCalendar.get(Calendar.DAY_OF_WEEK)-1];
      }
      else //����
        return "��" + DAYS_OF_WEEK[dateCalendar.get(Calendar.DAY_OF_WEEK)-1];
    }

    //����
    if( nowCalendar.get(Calendar.YEAR) == dateCalendar.get(Calendar.YEAR) )
      return shortDateFormatter.format(date);
    else
      return dateFormatter.format(date);
  }

  public static String longFormatDate(Date d)
  {
    return long_date_format.format(d);
  }

  public static String shortString(String string, int length)
  {
    if(string == null)
      return "";

    if(length < 3)
      return string;

    try
    {
      if(string.getBytes("GBK").length <= length)
        return string;

      int tempIndex = (length - 3) / 2;
      String temp = string.substring(0, tempIndex);
      while(temp.getBytes("GBK").length < (length - 3))
      {
        tempIndex ++;
        temp = string.substring(0, tempIndex);
      }
      return (temp + "...");
    }
    catch(Exception e)
    {
      if(string.length() <= length)
        return string;
      return (string.substring(0, length-3) + "...");
    }
  }

  public static String HTMLSafeJustCR(String s)
  {
    if(s == null)
        return null;
    int i = 0;
//    int j = 0;
    char ac[] = s.toCharArray();
    int k = ac.length;
    StringBuilder buff = new StringBuilder("<p>");
    for(; i < k; i++)
    {
      char c = ac[i];
      if(c == '\r')
        continue;
      if(c == '\n')
        buff.append("<br>");
      else
        if(c == ' ')
          buff.append(BLANK);
        else
          buff.append(c);
    }
    buff.append("</p>");
    return buff.toString();
  }

  public static String stringToGBK(String data)
  {
    String ret = null;
    try
    {
      ret = new String(data.getBytes("iso-8859-1"), "GBK");
      return ret;
    }catch(Exception e) {}

    return data;
  }

  public static String stringToISO(String data)
  {
    String ret = null;
    try
    {
      ret = new String(data.getBytes("GBK"), "iso-8859-1");
      return ret;
    }catch(Exception e) {}

    return data;
  }

  public static String convertString(String data, String srcEncoding, String targetEncoding)
  {
    String ret = null;
    try
    {
      ret = new String(data.getBytes(srcEncoding), targetEncoding);
      return ret;
    }catch(Exception e) {}

    return data;
  }

  public static String removeHTMLRemarkTag(String content)
  {
    try
    {
      BufferedReader content_reader = new BufferedReader(new StringReader(content));
      StringBuilder new_content = new StringBuilder();
      String temp = "";
      String temp1 = "";
      while((temp = content_reader.readLine()) != null)
      {
        temp1 = temp.trim();
        if(temp1.startsWith("<!--") && temp1.endsWith("-->"))
          continue;
        if(temp1.equalsIgnoreCase("<tbody>"))
          continue;
        if(temp1.equalsIgnoreCase("</tbody>"))
          continue;

        if(new_content.length() > 0)
          new_content.append("\n");

        new_content.append(temp);
      }
      return new_content.toString();
    }
    catch(Exception e)
    {
      return content;
    }
  }
  
  public static String removePrefix( String src, String prefix )
  {
    if( src.length() > prefix.length() )
      return src.substring( prefix.length() );
    
    return src;
  }
  
  public static String removeSurfix( String src, String surfix )
  {
    if( src.length() > surfix.length() )
      return src.substring( 0, (src.length() - surfix.length()) );
    
    return src;
  }
  
  public static boolean big( String s1, String s2 )
  {
    return (s1.compareTo( s2 ) > 0);
  }
  
  public static String parseHTMLContent( String htmlContent, long mail_id )
  {
    return htmlContent.replaceAll( "src=\"(CID:|cid:)", "src=\"mailAttach.jsp\\" + mail_id + "\\cid:" );
  }
  
  private static final DecimalFormat sizeFormat1 = new DecimalFormat( "0.000" );
  private static final DecimalFormat sizeFormat2 = new DecimalFormat( "0.00" );
  private static final DecimalFormat sizeFormat3 = new DecimalFormat( "0.0" );
  public static String getSizeForDisplay( int size )
  {
    double temp = 0.0;
    if( size < 1024 )
      return "" + size;
    temp = (double)size / 1024;
    if( temp < 10 )
      return sizeFormat1.format( temp ) + "K";
    else if( temp < 100 )
      return sizeFormat2.format( temp ) + "K";
    else if( temp < 1024 )
      return sizeFormat3.format( temp ) + "K";
    
    temp = temp / 1024;
    if( temp < 10 )
      return sizeFormat1.format( temp ) + "M";
    else if( temp < 100 )
      return sizeFormat2.format( temp ) + "M";
    return sizeFormat3.format( temp ) + "M";
  }

  public static InternetAddress convertAddress(String addr) throws Exception
  {
    StringTokenizer token = new StringTokenizer(addr, "<>");
    if(token.countTokens() == 2)
    {
      String name = token.nextToken();
      String ddd = token.nextToken();
      return new InternetAddress(ddd, name);
    }
    else
      return new InternetAddress(addr);
  }
  
  public static List<InternetAddress> convertAddresses(String addr) throws Exception
  {
    StringTokenizer token = new StringTokenizer(addr, ",;");
    List<InternetAddress> ret = new ArrayList<InternetAddress>();
    while(token.hasMoreTokens())
    {
      ret.add( convertAddress(token.nextToken()) );
    }
    return ret;
  }

  public static boolean isEmailPrefixValid( String login_id )
  {
    String regex = "^[A-Za-z0-9]+[\\._A-Za-z0-9-]+[A-Za-z0-9]+$";
    if( login_id.matches( regex ) )
      return true;
    return false;
  }
  
  
  public static void main(String[] args)
  {
    long mail_id = 201201310000000001L;
    Logger.getLogger(StringUtils.class.getName()).log(Level.SEVERE, "test {0,number,#}", mail_id);
  }
}