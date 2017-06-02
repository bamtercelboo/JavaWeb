package com.nccp.mavenweb.domain;

import com.alibaba.fastjson.annotation.JSONField;
import static com.mysql.cj.api.x.Type.TIMESTAMP;
import com.nccp.base.BaseDomain;
import com.nccp.mavenweb.domain.type.*;
import java.util.Date;
import java.util.Objects;
import java.util.jar.Attributes;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import static javax.persistence.TemporalType.TIMESTAMP;
import javax.persistence.Version;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import static oracle.jrockit.jfr.events.ContentTypeImpl.TIMESTAMP;
import org.hibernate.validator.constraints.NotBlank;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.ui.ModelMap;

/**
 *
 * @author 
 */
@Entity
@Table(name = "#__books")
public class Book extends BaseDomain
{
  public Book()
  {
    this.price = 100.0;
    this.authorage = 25;
  }
  
  @Id  //声明此列为主键
  @GeneratedValue(strategy = GenerationType.IDENTITY)  //根据不同数据库自动选择合适的id生成方案，这里使用mysql,为递增型
  private long id;
  
  @Column(length = 32,name = "name", nullable = false)
  @NotEmpty(message = "书名不能为空")
  private String name;
  
  @Column(name = "status",length = 2, nullable = false)
  private Status status;
  
  @Column(name = "type", length = 128)
  private String type;

  @Column(name = "isbn", length = 32, nullable = false)
  @NotEmpty(message = "ISBN不能为空")
  private String isbn;
  
  @Column(name = "publish", length = 64, nullable = false)
  @NotEmpty(message = "出版社不能为空")
  private String publish;
  
  @Column(name = "price", length = 18, scale = 2, nullable = false)
  @NotNull(message = "价格不能为空")
  @Min(value = 0, message = "输入价格 >= 0")
 // @Pattern(regexp = "^[0-9]+.?[0-9]*$", message = "价格只能由数字和小数点组合")
  private double price;
  
  @Column(name = "author_name", length = 32, nullable = false)
  @NotEmpty(message = "作者不能为空")
  private String authorname;
  
  @Column(name = "author_sex", length = 2, nullable = false)
  private Gender authorsex;
  
  @Column(name = "author_age",length = 32, nullable = false)
  @NotNull(message = "年龄不能为空")
  @Min(value = 0, message = "年龄 >= 0")
  //@Pattern(regexp = "^[0-9]*$", message = "年龄只能是数字")
  private Integer authorage;
  
  @Column(name = "created", nullable = false)
  @JSONField(format = "yyyy-MM-dd HH:mm:ss") 
  private Date created;
  
  @Column(name = "modified", nullable = false)
  @JSONField(format = "yyyy-MM-dd HH:mm:ss") 
  private Date modified;

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

  public Status getStatus()
  {
    return status;
  }

  public void setStatus( Status status )
  {
    this.status = status;
  }

  public String getType()
  {
    return type;
  }

  public void setType( String type )
  {
    this.type = type;
  }

  public String getIsbn()
  {
    return isbn;
  }

  public void setIsbn( String isbn )
  {
    this.isbn = isbn;
  }

  public String getPublish()
  {
    return publish;
  }

  public void setPublish( String publish )
  {
    this.publish = publish;
  }

  public double getPrice()
  {
    return price;
  }

  public void setPrice( double price )
  {
    this.price = price;
  }

  public String getAuthorname()
  {
    return authorname;
  }

  public void setAuthorname( String authorname )
  {
    this.authorname = authorname;
  }

  public Gender getAuthorsex()
  {
    return authorsex;
  }

  public void setAuthorsex( Gender authorsex )
  {
    this.authorsex = authorsex;
  }

  public Integer getAuthorage()
  {
    return authorage;
  }

  public void setAuthorage( Integer authorage )
  {
    this.authorage = authorage;
  }


  public String getMemo()
  {
    return memo;
  }

  public void setMemo( String memo )
  {
    this.memo = memo;
  }

  public int getVersion()
  {
    return version;
  }

  public void setVersion( int version )
  {
    this.version = version;
  }

  public Date getCreated()
  {
    return created;
  }

  public void setCreated( Date created )
  {
    this.created = created;
  }

  public Date getModified()
  {
    return modified;
  }

  public void setModified( Date modified )
  {
    this.modified = modified;
  }

  @Override
  public int hashCode()
  {
    int hash = 3;
    hash = 83 * hash + (int) (this.id ^ (this.id >>> 32));
    hash = 83 * hash + Objects.hashCode(this.name);
    hash = 83 * hash + Objects.hashCode(this.status);
    hash = 83 * hash + Objects.hashCode(this.type);
    hash = 83 * hash + Objects.hashCode(this.isbn);
    hash = 83 * hash + Objects.hashCode(this.publish);
    hash = 83 * hash + (int) (Double.doubleToLongBits(this.price) ^ (Double.doubleToLongBits(this.price) >>> 32));
    hash = 83 * hash + Objects.hashCode(this.authorname);
    hash = 83 * hash + Objects.hashCode(this.authorsex);
    hash = 83 * hash + Objects.hashCode(this.authorage);
    hash = 83 * hash + Objects.hashCode(this.created);
    hash = 83 * hash + Objects.hashCode(this.modified);
    hash = 83 * hash + Objects.hashCode(this.memo);
    hash = 83 * hash + this.version;
    return hash;
  }

  @Override
  public boolean equals( Object obj )
  {
    if ( this == obj ) {
      return true;
    }
    if ( obj == null ) {
      return false;
    }
    if ( getClass() != obj.getClass() ) {
      return false;
    }
    final Book other = (Book) obj;
    if ( this.id != other.id ) {
      return false;
    }
    if ( Double.doubleToLongBits(this.price) != Double.doubleToLongBits(other.price) ) {
      return false;
    }
    if ( this.version != other.version ) {
      return false;
    }
    if ( !Objects.equals(this.name, other.name) ) {
      return false;
    }
    if ( !Objects.equals(this.type, other.type) ) {
      return false;
    }
    if ( !Objects.equals(this.isbn, other.isbn) ) {
      return false;
    }
    if ( !Objects.equals(this.publish, other.publish) ) {
      return false;
    }
    if ( !Objects.equals(this.authorname, other.authorname) ) {
      return false;
    }
    if ( !Objects.equals(this.authorage, other.authorage) ) {
      return false;
    }
    if ( !Objects.equals(this.memo, other.memo) ) {
      return false;
    }
    if ( this.status != other.status ) {
      return false;
    }
    if ( this.authorsex != other.authorsex ) {
      return false;
    }
    if ( !Objects.equals(this.created, other.created) ) {
      return false;
    }
    if ( !Objects.equals(this.modified, other.modified) ) {
      return false;
    }
    return true;
  }

  @Override
  public String toString()
  {
    return "Book{" + "id=" + id + ", name=" + name + ", status=" + status + ", type=" + type + ", isbn=" + isbn + ", publish=" + publish + ", price=" + price + ", author_name=" + authorname + ", gender=" + authorsex + ", author_age=" + authorage + ", created=" + created + ", modified=" + modified + ", memo=" + memo + ", version=" + version + '}';
  }
}
