/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.controller;

import com.alibaba.fastjson.JSON;
import com.nccp.mavenweb.domain.*;
import com.nccp.mavenweb.domain.type.*;
import com.nccp.mavenweb.model.*;
import com.nccp.utils.ParamUtils;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author 
 */
@Controller
@RequestMapping(value="/book")
public class BookController
{
  @Resource
  private BookModel bookModel;
  
  @RequestMapping("/start")
  public String do_start( ModelMap model )
  {
    return "book/list";
  }
  
  /**
   * 查询数据显示列表
   * @param request
   * @param model
   * @return
   * @throws Exception 
   */
  @RequestMapping(value = "/list", produces="text/plain;charset=UTF-8")
  @ResponseBody
  public String do_list( HttpServletRequest request, ModelMap model ) throws Exception
  {
    String curr_page = request.getParameter("page");
    if ( curr_page == null ) {
      curr_page = "1";
    }
    String page_size = request.getParameter("page_size");
    int start = (Integer.parseInt(curr_page) - 1) * Integer.parseInt(page_size);
    int num = Integer.parseInt(page_size);
    //构造查询条件
    Map<String, Object> fieldValues = new HashMap<>();
    String name = ParamUtils.getParameter(request, "name", "");
    if ( name.trim().length() > 0 ) {
      fieldValues.put("name_like", name);
    }
    String gender = ParamUtils.getParameter(request, "gender", "-");
    if ( gender.equals("0") || gender.equals("1") ) {
      fieldValues.put("authorsex", Gender.parse(Integer.parseInt(gender)));
    }
    String status = ParamUtils.getParameter(request, "status", "");
    if ( status.equals("0") || status.equals("1") ) {
      fieldValues.put("status", Status.parse(Integer.parseInt(status)));
    }
    String minprice = ParamUtils.getParameter(request, "minprice", "");
    if ( minprice.trim().length() > 0 ) {
      fieldValues.put("price_ge", Double.parseDouble(minprice));
    }
    String maxprice = ParamUtils.getParameter(request, "maxprice", "");
    if ( maxprice.trim().length() > 0 ) {
      fieldValues.put("price_le", Double.parseDouble(maxprice));
    }
    Long book_count = bookModel.queryCount(fieldValues);
    
    List<String> order = new ArrayList<>();
    order.add("id");
    order.add("name");
    List<Book> books = bookModel.query(fieldValues, order, start, num);
    model.addAttribute("books", books);
    model.addAttribute("book_count", book_count);
    model.addAttribute("start", start);
    model.addAttribute("num", num);
    List<Map<String, Object>> data = new ArrayList<>();
    Map<String, Object> map = new HashMap();
    map.put("book_count", book_count);
    map.put("start", start);
    map.put("num", num);
    map.put("books", books);
    data.add(map);
    //JSONArray s = JSONArray.fromObject(data);
    String json = JSON.toJSONString(data);
    return json;
  }
  
  /**
   * 添加增加表单默认值
   * @return 
   */
  @RequestMapping(value="/add", produces="text/plain;charset=UTF-8")
  @ResponseBody
  public String do_add()
  {
    Map<String, Object> map = new HashMap();
    try {
      Map<String, String> genders = new HashMap<>();
      genders.put(Gender.MALE.getIndex() + "", Gender.MALE.getName());
      genders.put(Gender.FEMALE.getIndex() + "", Gender.FEMALE.getName());
      Map<String, String> status = new HashMap<>();
      status.put(Status.ONSALE.getIndex() + "", Status.ONSALE.getName());
      status.put(Status.SOLDOUT.getIndex() + "", Status.SOLDOUT.getName());
      map.put("genders", genders);
      map.put("status", status);
      map.put("book", new Book());
      return JSON.toJSONString(map);
    } catch ( Exception e ) {
      Map<String, String> map1 = new HashMap<>();
      return JSON.toJSONString(map1);
    }
  }
  
  /**
   * 增加数据
   * @return 
   */
  @RequestMapping(value = "/addup", produces="text/plain;charset=UTF-8")
  @ResponseBody
  public String do_addup( @Valid Book books, BindingResult br, String name, Integer status1, String type, String isbn, String publish, double price, String authorname, Integer gender, Integer authorage, String memo )
  {
    if ( br.hasErrors() ) {
      List<ObjectError> ls = br.getAllErrors();
      return JSON.toJSONString(ls);
    } else {
      try {
        Map<String, Object> map = new HashMap();
        Book book = new Book();
        book.setName(name);
        book.setStatus(Status.values()[status1]);
        book.setType(type);
        book.setIsbn(isbn);
        book.setPublish(publish);
        book.setPrice(price);
        book.setAuthorname(authorname);
        book.setAuthorsex(Gender.values()[gender]);
        book.setAuthorage(authorage);
        book.setCreated(Date.from(Instant.now()));
        book.setModified(Date.from(Instant.now()));
        book.setMemo(memo);
        bookModel.save(book);
        map.put("InsertStatus", "Insert Success");
        return JSON.toJSONString(map);
      } catch ( Exception e ) {
        System.out.println(e.getMessage());
        Map<String, Object> map = new HashMap();
        map.put("InsertStatus", "Insert Failed");
        return JSON.toJSONString(map);
      }
    }
  }
  
  /**
   * 返回需要需改的数据
   * @param request
   * @return 
   */
  @RequestMapping(value = "/edit", produces="text/plain;charset=UTF-8")
  @ResponseBody
  public String do_edit( HttpServletRequest request )
  {
    Map<String, Object> map = new HashMap();
    String id = request.getParameter("id");
    Book book = bookModel.get(Integer.parseInt(id));
    map.put("book", book);
    Map<String, String> genders = new HashMap<>();
    genders.put(Gender.MALE.getIndex() + "", Gender.MALE.getName());
    genders.put(Gender.FEMALE.getIndex() + "", Gender.FEMALE.getName());
    Map<String, String> status = new HashMap<>();
    status.put(Status.ONSALE.getIndex() + "", Status.ONSALE.getName());
    status.put(Status.SOLDOUT.getIndex() + "", Status.SOLDOUT.getName());
    map.put("genders", genders);
    map.put("status", status);
    return JSON.toJSONString(map);
  }
  
  /**
   * 修改数据操作
   * @return 
   */
  @RequestMapping(value = "/editup", produces="text/plain;charset=UTF-8")
  @ResponseBody
  public String do_editup( @Valid Book books, BindingResult br, String bookid, String name, Integer status1, String type, String isbn, String publish, double price, String authorname, Integer gender, Integer authorage, String memo )
  {
    if ( br.hasErrors() ) {
      List<ObjectError> ls = br.getAllErrors();
      return JSON.toJSONString(ls);
    } else {
      try {
        Map<String, Object> map = new HashMap();
        Book book = bookModel.get(Integer.parseInt(bookid));
        book.setName(name);
        book.setStatus(Status.values()[status1]);
        book.setType(type);
        book.setIsbn(isbn);
        book.setPublish(publish);
        book.setPrice(price);
        book.setAuthorname(authorname);
        book.setAuthorsex(Gender.values()[gender]);
        book.setAuthorage(authorage);
        book.setModified(Date.from(Instant.now()));
        book.setMemo(memo);
        bookModel.save(book);
        map.put("UpdateStatus", "Update Success");
        return JSON.toJSONString(map);
      } catch ( Exception e ) {
        System.out.println(e.getMessage());
        Map<String, Object> map = new HashMap();
        map.put("UpdateStatus", "Update Failed");
        return JSON.toJSONString(map);
      }
    }
  }

  /**
   * 删除数据操作
   * @param id
   * @return 
   */
  @RequestMapping("/delete")
  @ResponseBody
  public String do_delete( Long id )
  {
    try {
      Map<String, Object> map = new HashMap();
      Book book = bookModel.get(id);
      bookModel.delete(book);
      map.put("DeleteStatus", "Delete Success");
      return JSON.toJSONString(map);
    } catch ( Exception e ) {
      Map<String, Object> map = new HashMap();
      map.put("DeleteStatus", "Delete Failed");
      return JSON.toJSONString(map);
    }
  }
}
