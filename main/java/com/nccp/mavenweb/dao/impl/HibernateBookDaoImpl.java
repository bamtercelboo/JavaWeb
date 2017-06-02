/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.dao.impl;

import com.nccp.base.impl.HibernateBaseDaoImpl;
import com.nccp.mavenweb.dao.BookDao;
import com.nccp.mavenweb.domain.Book;

/**
 *
 * @author liuwei
 */
public class HibernateBookDaoImpl extends HibernateBaseDaoImpl<Book> implements BookDao
{
  public HibernateBookDaoImpl()
  {
    super( Book.class );
  }
}
