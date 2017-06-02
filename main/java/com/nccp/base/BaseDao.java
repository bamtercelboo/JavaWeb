/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.base;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 *
 * @author liuwei
 */
public interface BaseDao<T>
{
  public void save(T t);
  
  public void save(Collection<T> t);
  
  public void delete(long id);
  
  public void delete(T t);
  
  public T get(long id);
  
  public List<T> queryAllRecord();
  
  public Long getRecordCount();
  
  public List<T> query( Map<String, Object> fieldValues, List<String> orders, int start, int count );
  
  public List<T> query( Map<String, Object> fieldValues, List<String> orders );
  
  public List<T> query( Map<String, Object> fieldValues );
  
  public Long queryCount( Map<String, Object> fieldValues );
}
