/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.controller;

import com.nccp.mavenweb.domain.User;
import com.nccp.mavenweb.domain.type.Gender;
import com.nccp.mavenweb.model.UserModel;
import com.nccp.utils.ParamUtils;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author liuwei
 */
@Controller
@RequestMapping("/user")
public class UserController
{
  @Resource
  private UserModel userModel;
  
  @RequestMapping("/list")
  public String do_list( HttpServletRequest request, ModelMap model )
  {
    int start = ParamUtils.getIntParameter( request, "start", 0 );
    int num = ParamUtils.getIntParameter( request, "num", 10 );
    
    //构造查询条件
    Map<String, Object> fieldValues = new HashMap<>();
    String name = ParamUtils.getParameter( request, "name", "" );
    if( name.trim().length() > 0 )
    {
      fieldValues.put( "name_like", name );
      model.addAttribute( "name", name );
    }
    String gender = ParamUtils.getParameter( request, "gender", "-" );
    if( gender.equals( "0" ) || gender.equals( "1" ) )
    {
      fieldValues.put( "gender", Gender.parse( Integer.parseInt( gender ) ) );
    }
    model.addAttribute( "gender", gender );
    String salary_from = ParamUtils.getParameter( request, "salary_from", "" );
    if( salary_from.trim().length() > 0 )
    {
      fieldValues.put( "salary_ge", Double.parseDouble( salary_from ) );
      model.addAttribute( "salary_from", salary_from );
    }
    String salary_to = ParamUtils.getParameter( request, "salary_to", "" );
    if( salary_to.trim().length() > 0 )
    {
      fieldValues.put( "salary_le", Double.parseDouble( salary_to ) );
      model.addAttribute( "salary_to", salary_to );
    }
    
    Long user_count = userModel.queryCount( fieldValues );
    List<User> users = userModel.query( fieldValues, new ArrayList<>(), start, num );
    model.addAttribute( "users", users );
    model.addAttribute( "user_count", user_count );
    model.addAttribute( "start", start );
    model.addAttribute( "num", num );
    return "user/list";
  }
  
  @RequestMapping("/add")
  public String do_add( ModelMap model )
  {
    Map<Integer, String> genders = new HashMap<>();
    genders.put( Gender.MALE.getIndex(), Gender.MALE.getName() );
    genders.put( Gender.FEMALE.getIndex(), Gender.FEMALE.getName() );
    model.addAttribute( "genders", genders );
    model.addAttribute( "user", new User() );
    return "user/add";
  }
  
  @RequestMapping("/addup")
  public String do_addup( String name, String password, Integer gender, String birthday, Double salary, String memo )
  {
    User user = new User();
    user.setName( name );
    user.setGender( Gender.values()[ gender ] );
    user.setSalary( salary );
    user.setMemo( memo );
    user.setPassword( password );
    user.setBirthday( java.sql.Date.valueOf( birthday ) );
    userModel.save( user );
    return "redirect:/user/list";
  }
  
  @RequestMapping("/edit/{id}")
  public String do_edit( @PathVariable(value="id") Long id, ModelMap model )
  {
    User user = userModel.get( id );
    model.addAttribute( "user", user );
    return "user/edit";
  }
  
  @RequestMapping("/editup/{id}")
  public String do_editup( @PathVariable(value="id") Long id, String name, String password, Integer gender, String birthday, Double salary, String memo )
  {
    User user = userModel.get( id );
    user.setName( name );
    user.setGender( Gender.values()[ gender ] );
    user.setSalary( salary );
    user.setMemo( memo );
    user.setPassword( password );
    user.setBirthday( java.sql.Date.valueOf( birthday ) );
    userModel.save( user );
    return "redirect:/user/list";
  }
  
  @RequestMapping("/delete/{id}")
  public String do_delete( @PathVariable(value="id") Long id )
  {
    User user = userModel.get( id );
    userModel.delete( user );
    return "redirect:/user/list";
  }
}
