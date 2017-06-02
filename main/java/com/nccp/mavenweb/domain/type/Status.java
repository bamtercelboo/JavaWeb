/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.domain.type;

public enum Status
{
  SOLDOUT( "下架", 0 ), ONSALE( "在售", 1 );

  private String name;
  private int index;

  private Status( String name, int index )
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
  
  public static Status parse( int index )
  {
    return Status.values()[ index ];
  }
  
  public static Status parse( String name )
  {
    for( Status status : Status.values() )
    {
      if( status.getName().equals( name ) )
        return status;
    }
    return null;
  }
}
