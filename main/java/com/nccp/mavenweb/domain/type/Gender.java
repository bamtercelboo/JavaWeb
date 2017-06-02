/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.domain.type;

public enum Gender
{
  MALE( "男", 0 ), FEMALE( "女", 1 );

  private String name;
  private int index;

  private Gender( String name, int index )
  {
    this.name = name;
    this.index = index;
  }

  public String getName()
  {
    return this.name;
  }
  
  public int getIndex()
  {
    return this.index;
  }
  
  @Override
  public String toString()
  {
    return this.name;
  }
  
  public static Gender parse( int index )
  {
    return Gender.values()[ index ];
  }
  
  public static Gender parse( String name )
  {
    for( Gender gender : Gender.values() )
    {
      if( gender.getName().equals( name ) )
        return gender;
    }
    return null;
  }
}
