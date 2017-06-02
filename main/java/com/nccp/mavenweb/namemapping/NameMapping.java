/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.nccp.mavenweb.namemapping;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.boot.model.naming.Identifier;
import org.hibernate.boot.model.naming.PhysicalNamingStrategy;
import org.hibernate.engine.jdbc.env.spi.JdbcEnvironment;

/**
 *
 * @author liuwei
 */
public class NameMapping implements PhysicalNamingStrategy 
{
  private String tableNamePrefix = "";

  public String getTableNamePrefix()
  {
    return tableNamePrefix;
  }

  public void setTableNamePrefix( String tableNamePrefix )
  {
    this.tableNamePrefix = tableNamePrefix;
  }
  
  @Override
  public Identifier toPhysicalCatalogName( Identifier identifier, JdbcEnvironment jdbcEnv )
  {
    return identifier;
  }

  @Override
  public Identifier toPhysicalColumnName( Identifier identifier, JdbcEnvironment jdbcEnv )
  {
    return identifier;
  }

  @Override
  public Identifier toPhysicalSchemaName( Identifier identifier, JdbcEnvironment jdbcEnv )
  {
    return identifier;
  }

  @Override
  public Identifier toPhysicalSequenceName( Identifier identifier, JdbcEnvironment jdbcEnv )
  {
    return identifier;
  }

  @Override
  public Identifier toPhysicalTableName( Identifier identifier, JdbcEnvironment jdbcEnv )
  {
    if ( identifier == null || StringUtils.isBlank( identifier.getText() ) )
    {
      return identifier;
    }
    String regex = "#__";
    String replacement = this.tableNamePrefix + "_";
    String newName = identifier.getText().replace( regex, replacement ).toLowerCase();
    return Identifier.toIdentifier( newName );
  }
}
