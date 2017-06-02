/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.base.impl;

import com.nccp.base.BaseDao;
import com.nccp.utils.StringUtils;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Order;
import javax.persistence.criteria.Root;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

/**
 *
 * @author liuwei
 */
public class HibernateBaseDaoImpl<T> implements BaseDao<T>
{
  protected SessionFactory sessionFactory;

  public SessionFactory getSessionFactory()
  {
    return sessionFactory;
  }

  public void setSessionFactory( SessionFactory sessionFactory )
  {
    this.sessionFactory = sessionFactory;
  }

  private Class<T> clazz;

  public HibernateBaseDaoImpl( Class<T> clazz )
  {
    this.clazz = clazz;
  }

  @Override
  public void save( T t )
  {
    Session session = sessionFactory.getCurrentSession();
    session.saveOrUpdate( t );
  }

  @Override
  public void save(Collection<T> t)
  {
    Session session = sessionFactory.getCurrentSession();
    t.stream().forEach( (tt) ->
    {
      session.saveOrUpdate( tt );
    } );
  }

  @Override
  public void delete( long id )
  {
    Session session = sessionFactory.getCurrentSession();
    Object obj = session.get( this.clazz, id );
    session.delete( obj );
  }

  @Override
  public void delete( T t )
  {
    Session session = sessionFactory.getCurrentSession();
    session.delete( t );
  }

  @Override
  public T get( long id )
  {
    Session session = sessionFactory.getCurrentSession();
    return (T)session.get( this.clazz, id );
  }

  @Override
  public List<T> queryAllRecord()
  {
    Session session = sessionFactory.getCurrentSession();
    String hql = "from " + clazz.getSimpleName();
    return session.createQuery( hql ).list();
  }

  @Override
  public Long getRecordCount()
  {
    Session session = sessionFactory.getCurrentSession();
    String hql = "select count(*) from " + clazz.getSimpleName();
    return ( Long ) session.createQuery( hql ).uniqueResult();
  }

  private Query __getQuery( Session session, String pre_hql, Map<String, Object> fieldValues, List<String> orders )
  {
    StringBuilder hql = new StringBuilder( pre_hql + " from " + clazz.getSimpleName() );
    List<String> conditions = new ArrayList<>();
    for( String name : fieldValues.keySet() )
    {
      if( name.endsWith( "_ge" ) )
      {
        String realName = StringUtils.removeSurfix( name, "_ge" );
        conditions.add( realName + " >= " + ":" + name );
      }
      else if( name.endsWith( "_gt" ) )
      {
        String realName = StringUtils.removeSurfix( name, "_gt" );
        conditions.add( realName + " > " + ":" + name );
      }
      else if( name.endsWith( "_lt" ) )
      {
        String realName = StringUtils.removeSurfix( name, "_lt" );
        conditions.add( realName + " < " + ":" + name );
      }
      else if( name.endsWith( "_le" ) )
      {
        String realName = StringUtils.removeSurfix( name, "_le" );
        conditions.add( realName + " <= " + ":" + name );
      }
      else if( name.endsWith( "_like" ) )
      {
        String realName = StringUtils.removeSurfix( name, "_like" );
        String value = (String)fieldValues.get( name );
        value = "%" + value + "%";
        fieldValues.put( name, value );
        conditions.add( realName + " like " + ":" + name );
      }
      else
        conditions.add( name + " = " + ":" + name );
    };
    if( conditions.size() > 0 )
    {
      hql.append( " where " );
      int condition_index = 0;
      for( String condition : conditions )
      {
        if( condition_index > 0 )
          hql.append( " and " );
        hql.append( " " ).append( condition ).append(" ");
        condition_index ++;
      }
    }
    if( orders.size() > 0 )
    {
      hql.append( " order by " );
      int order_index = 0;
      for( String order : orders )
      {
        if( order_index > 0 )
          hql.append( "," );
        hql.append( order );
      };
    }
    
    Query query = session.createQuery( hql.toString() );
    for( String name : fieldValues.keySet() )
    {
      Object value = fieldValues.get( name );
      query.setParameter( name, value );
    };
    return query;
  }
  
  @Override
  public List<T> query( Map<String, Object> fieldValues, List<String> orders, int start, int count )
  {
    Session session = sessionFactory.getCurrentSession();
    
    //CriteriaQuery<T> q = this.__getCriteriaQuery( session, fieldValues, orders );
    Query query = this.__getQuery( session, "", fieldValues, new ArrayList<>() );
    query.setFirstResult( start );
    query.setMaxResults( count );
    return query.list();
  }

  @Override
  public List<T> query( Map<String, Object> fieldValues, List<String> orders )
  {
    return this.query(fieldValues, orders, 0, 99999999);
  }

  @Override
  public List<T> query( Map<String, Object> fieldValues )
  {
    return this.query( fieldValues, new ArrayList<>() );
  }

  @Override
  public Long queryCount( Map<String, Object> fieldValues )
  {
    Session session = sessionFactory.getCurrentSession();
    Query query = this.__getQuery( session, "select count(*)", fieldValues, new ArrayList<>() );
    return ( Long ) query.uniqueResult();
  }
  
}
