/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.domain;

import com.nccp.base.BaseDomain;
import com.nccp.mavenweb.domain.type.Gender;
import java.sql.Date;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Version;

/**
 *
 * @author liuwei
 */
@Entity
@Table(name = "#__users")
public class User extends BaseDomain
{
  @Id  //声明此列为主键
  @GeneratedValue(strategy = GenerationType.IDENTITY)  //根据不同数据库自动选择合适的id生成方案，这里使用mysql,为递增型
  private long id;
  
  @Column(length = 32, nullable = false, name = "name", unique = true)
  private String name;
  
  @Column(length = 32,nullable = false, name = "password")
  private String password;
  
  @Column(name = "gender")
  private Gender gender;
  
  @Column(name = "birthday")
  private Date birthday;
  
  @Column(name = "salary", scale = 2)
  private double salary;
  
  @Lob
  private String memo;

  @Version
  @Column(name = "version")
  private int version;
  
  public long getId()
  {
    return id;
  }

  public void setId( long id )
  {
    this.id = id;
  }

  public String getName()
  {
    return name;
  }

  public void setName( String name )
  {
    this.name = name;
  }

  public Gender getGender()
  {
    return gender;
  }

  public void setGender( Gender gender )
  {
    this.gender = gender;
  }

  public String getPassword()
  {
    return password;
  }

  public void setPassword( String password )
  {
    this.password = password;
  }

  public int getVersion()
  {
    return version;
  }

  public void setVersion( int version )
  {
    this.version = version;
  }

  public double getSalary()
  {
    return salary;
  }

  public void setSalary( double salary )
  {
    this.salary = salary;
  }

  public Date getBirthday()
  {
    return birthday;
  }

  public void setBirthday( Date birthday )
  {
    this.birthday = birthday;
  }

  public String getMemo()
  {
    return memo;
  }

  public void setMemo( String memo )
  {
    this.memo = memo;
  }

  @Override
  public int hashCode()
  {
    int hash = 3;
    hash = 23 * hash + ( int ) (this.id ^ (this.id >>> 32));
    hash = 23 * hash + Objects.hashCode( this.name );
    hash = 23 * hash + Objects.hashCode( this.password );
    hash = 23 * hash + Objects.hashCode( this.gender );
    hash = 23 * hash + Objects.hashCode( this.birthday );
    hash = 23 * hash + ( int ) (Double.doubleToLongBits( this.salary ) ^ (Double.doubleToLongBits( this.salary ) >>> 32));
    hash = 23 * hash + Objects.hashCode( this.memo );
    hash = 23 * hash + this.version;
    return hash;
  }

  @Override
  public boolean equals( Object obj )
  {
    if ( this == obj )
    {
      return true;
    }
    if ( obj == null )
    {
      return false;
    }
    if ( getClass() != obj.getClass() )
    {
      return false;
    }
    final User other = ( User ) obj;
    if ( this.id != other.id )
    {
      return false;
    }
    if ( Double.doubleToLongBits( this.salary ) != Double.doubleToLongBits( other.salary ) )
    {
      return false;
    }
    if ( this.version != other.version )
    {
      return false;
    }
    if ( !Objects.equals( this.name, other.name ) )
    {
      return false;
    }
    if ( !Objects.equals( this.password, other.password ) )
    {
      return false;
    }
    if ( !Objects.equals( this.memo, other.memo ) )
    {
      return false;
    }
    if ( this.gender != other.gender )
    {
      return false;
    }
    if ( !Objects.equals( this.birthday, other.birthday ) )
    {
      return false;
    }
    return true;
  }

  @Override
  public String toString()
  {
    return "User{" + "id=" + id + ", name=" + name + ", password=" + password + ", gender=" + gender + ", birthday=" + birthday + ", salary=" + salary + ", memo=" + memo + ", version=" + version + '}';
  }
}
