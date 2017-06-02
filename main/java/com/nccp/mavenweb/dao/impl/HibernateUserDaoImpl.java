/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.dao.impl;

import com.nccp.base.impl.HibernateBaseDaoImpl;
import com.nccp.mavenweb.dao.UserDao;
import com.nccp.mavenweb.domain.User;

/**
 *
 * @author liuwei
 */
public class HibernateUserDaoImpl extends HibernateBaseDaoImpl<User> implements UserDao
{
  public HibernateUserDaoImpl()
  {
    super( User.class );
  }
}
