/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.base.impl;

import com.nccp.base.BaseDao;
import com.nccp.base.BaseModel;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import org.hibernate.Session;

/**
 *
 * @author liuwei
 */
public class HibernateBaseModelImpl<T> implements BaseModel<T>
{

  private BaseDao<T> dao;

  public BaseDao<T> getDao()
  {
    return dao;
  }

  public void setDao( BaseDao<T> dao )
  {
    this.dao = dao;
  }

  @Override
  public void save( T t )
  {
    this.dao.save( t );
  }

  @Override
  public void save(Collection<T> t)
  {
    this.dao.save( t );
  }
  
  @Override
  public void delete( long id )
  {
    this.dao.delete( id );
  }

  @Override
  public void delete( T t )
  {
    this.dao.delete( t );
  }

  @Override
  public T get( long id )
  {
    return this.dao.get( id );
  }

  @Override
  public List<T> queryAllRecord()
  {
    return this.dao.queryAllRecord();
  }

  @Override
  public Long getRecordCount()
  {
    return this.dao.getRecordCount();
  }

  @Override
  public List<T> query( Map<String, Object> fieldValues, List<String> orders, int start, int count )
  {
    return this.dao.query( fieldValues, orders, start, count );
  }

  @Override
  public List<T> query( Map<String, Object> fieldValues, List<String> orders )
  {
    return this.dao.query( fieldValues, orders );
  }

  @Override
  public List<T> query( Map<String, Object> fieldValues )
  {
    return this.dao.query( fieldValues );
  }

  @Override
  public Long queryCount( Map<String, Object> fieldValues )
  {
    return this.dao.queryCount( fieldValues );
  }
}
