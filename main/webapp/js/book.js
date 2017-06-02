/**
 *图书管理系统JS文件 
 */

//每页显示的数量
var page_size = 10;
//总页数
var total_pages = 1;
//当前页码
var curr_page = 1; 
//显示的页码超链接数量
var clickPageList = 5;
//参数页码
var page = 1;
//设置变量count 不让页码超链接重复添加
var count = 0;

$(function () {
  
  //insert div 位置
  var browser_height = document.body.clientHeight
  var brower_width = document.body.clientWidth;
  var div_height = $("#adddiv").height();
  var div_width = $("#adddiv").width();
  var top_height = (browser_height / 2) - (div_height / 2);
  var left_width = (brower_width / 2) - (div_width / 2);
  $("#adddiv").css("top", top_height);
  $("#adddiv").css("left", left_width);
  $(".searchparam").css("width", brower_width / 2);
  //浏览器窗口大小变化
  $(window).resize(function () {
    var browser_height = document.body.clientHeight
    var brower_width = document.body.clientWidth;
    var div_height = $("#adddiv").height();
    var div_width = $("#adddiv").width();
    var top_height = (browser_height / 2) - (div_height / 2);
    var left_width = (brower_width / 2) - (div_width / 2);
    $("#adddiv").css("top", top_height);
    $("#adddiv").css("left", left_width);
    $(".searchparam").css("width", brower_width - 20);
  });
 
  //点击insert button 
  $('#btn_insert').click(function () {
    showInsertInfo();
    //置空
    $("#add_form input[name='bookid']").val("");
    $("#add_form input[name='name']").val("");
    $("#add_form input[name='isbn']").val("");
    $("#add_form input[name='publish']").val("");
    $("#add_form input[name='price']").val("");
    $("#add_form input[name='authorname']").val("");
    $("#add_form input[name='authorage']").val("");
    $("#add_form .memo").val("");
    $("#add_form input:radio[name='gender']").attr("checked", false);
    $("#add_form input:radio[name='gender']").get(0).checked = true;//设置默认
    $("#add_form input:radio[name='status1']").attr("checked", false);
    $("#add_form input:radio[name='status1']").get(0).checked = true;//设置默认
    $("#add_form input:checkbox[name='type']").attr("checked",false);
    $("#add_form input:checkbox[name='type']").get(0).checked = true;
    //清除错误颜色标记
    $("#add_form input[name='name']").removeClass("inputerror");
    $("#add_form input[name='isbn']").removeClass("inputerror");
    $("#add_form input[name='publish']").removeClass("inputerror");
    $("#add_form input[name='price']").removeClass("inputerror");
    $("#add_form input[name='authorname']").removeClass("inputerror");
    $("#add_form input[name='authorage']").removeClass("inputerror");
    //显示增加button
    $("#add_button").show();
    //隐藏修改button
    $("#update_button").hide();
    //隐藏表单淡入淡出
    $('#addbg').fadeIn();
    $('#adddiv').fadeIn();
    //弹框拖拽
    $('#draggable').mousedown(function () {
      $('#adddiv').draggable({disabled: false});
    });
    $('#draggable').mouseup(function () {
      $('#adddiv').draggable({disabled: true});
    });
  });
  
  //弹框拖拽
  $('#draggable').mousedown(function () {
      $('#adddiv').draggable({disabled: false});
    });
    $('#draggable').mouseup(function () {
      $('#adddiv').draggable({disabled: true});
    });
    
  //关闭弹窗
  $('#addclosehref').click(function () {
    $('#adddiv').fadeOut(function () {
      $('#addbg').fadeOut();
    });
  });
});

/**
 * 
 * @param {type} page
 * @returns {undefined}
 */
function search( page ) {
  //获取条件查询文本框值
  var name = $("#search  input[name='name']").val();
  var gender = $("#search select[name='gender']").val();
  var status = $("#search input[name='status']:checked").val();
  var minprice = $("#search  input[name='minprice']").val();
  var maxprice = $("#search  input[name='maxprice']").val();
  $.ajax({
    type: "post",
    url: "./book/list",
    data: {
        page:page,
        page_size:page_size,
        name:name,
        gender:gender,
        status:status,
        minprice:minprice,
        maxprice:maxprice
    },
    dataType: 'json',
    success: function ( ret ) {
      var total_count = ret[0].book_count;
      var data = ret[0].books;
      //清空
      $("#tbody").empty();
      //拼接html
      var html = "";
      for ( var i = 0; i < data.length; i++ ) {
        html += '<tr class="' + ((i % 2) == "0" ? "evencolor" : "oddcolor") + '" id="row" onclick = "rowchecked(this);">';
        html += "<td>" + data[i].id + "</td>";
        html += "<td>" + data[i].name + "</td>";
        html += "<td>" + ((data[i].status) == "SOLDOUT" ? "下架" : ((data[i].status) == "ONSALE" ? "在售" : "")) + "</td>";
        html += "<td>" + (data[i].type == undefined ? "" : (data[i].type)) + "</td>";
        html += "<td>" + data[i].isbn + "</td>";
        html += "<td>" + data[i].publish + "</td>";
        html += "<td>" + data[i].price + "</td>";
        html += "<td>" + data[i].authorname + "</td>";
        html += "<td>" + ((data[i].authorsex) == "MALE" ? "男" : ((data[i].authorsex) == "FEMALE" ? "女" : "")) + "</td>";
        html += "<td>" + data[i].authorage + "</td>";
        html += "<td>" + data[i].created + "</td>";
        html += "<td>" + data[i].modified + "</td>";
        html += '<td style="word-break:break-all;overflow: scroll;">' + ((data[i].memo) == null ? "" : ((data[i].memo))) + "</td>";
        html += "<td>" + data[i].version + "</td>";
        html += '<td><a href = "javascript:update(' + data[i].id + ');">修改</a></td>';
        html += '<td><a href = "javascript:confirmDelete(' + data[i].id + ');">删除</a></td>';
        html += "</tr>";
      }
      $("#tbody").append(html);
      pagehref(total_count, page);
    },
    error: function ( data ) {
      alert("error");
    }
  });
}

/**
 * @description 创建页码超链接
 * @param {type} total_count 总记录数
 * @param {type} curr_page 当前页
 */
function pagehref( total_count, curr_page )
{
  var total_count = total_count;
  //计算总页数
  if ( (total_count % page_size) == 0 ) {
    total_pages = parseInt(total_count / page_size);
  } else {
    total_pages = parseInt(total_count / page_size + 1);
  }
  if ( curr_page == null ) {
    curr_page = 1;
  }
  if ( total_pages <= curr_page ) {
    curr_page = total_pages;
  }
  var html = "";
  //当前页是首页，首页、上一页都不能点击
  if ( curr_page == 1 || curr_page == 0 ) {
    html += "首页&nbsp;&nbsp;";
    html += "上一页&nbsp;&nbsp;";
  } else {
    html += '<a href = "javascript:goto(1);" >首页</a>&nbsp;&nbsp;';
    html += '<a href = "javascript:goto(' + ((curr_page > 1) ? (curr_page - 1) : 1) + ');" >上一页</a>&nbsp;&nbsp;';
  }
  if ( total_pages >= clickPageList ) {
    var line = parseInt(clickPageList / 2);
    if ( curr_page >= 1 && curr_page <= line + 1 ) {
      //若clickPageList=5，如果当前页数大于等与1并小于等与3（这里表示点击前3页的链接，都显示的是1到5页的链接）
      for ( var i = 1; i <= clickPageList; i++ ) {
        //如果是当前页，则直接显示页码，不显示成超链接
        if ( curr_page == i ) {
          html += "" + i + "&nbsp;&nbsp;";
        } else {
          html += '<a href = "javascript:goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
        }
      }
    }
    if ( curr_page > line + 1 && curr_page <= total_pages - line ) {
      //若clickPageList=5，如果当前页数大于3，并且小于等与总页数；则循环显示当前页-2，到当前页+2的链接
      for ( var i = curr_page - line; i <= curr_page + line; i++ ) {
        //如果是当前页，则直接显示页码，不显示成超链接
        if ( curr_page == i ) {
          html += "" + i + "&nbsp;&nbsp;";
        } else {
          html += '<a href = "javascript:goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
        }
      }
    }
    if ( curr_page > total_pages - line && curr_page <= total_pages ) {
      //若clickPageList=5，如果当前页大于总页数-2，并且小于总页数
      for ( var i = total_pages - line - 2; i <= total_pages; i++ ) {
        //如果是当前页，则直接显示页码，不显示成超链接
        if ( curr_page == i ) {
          html += "" + i + "&nbsp;&nbsp;";
        } else {
          html += '<a href = "javascript:goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
        }
      }
    }
  } else {
    for ( var i = 1; i <= total_pages; i++ ) {
      //若clickPageList=5，如果总页数小于5就直接把所有链接循环输出。
      //如果是当前页，则直接显示页码，不做成超链接
      if ( curr_page == i ) {
        html += "" + i + "&nbsp;&nbsp;";
      } else {
        html += '<a href = "javascript:goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
      }
    }
  }
  //末页下一页和末页都不能点击
  if ( curr_page == total_pages ) {
    html += "下一页&nbsp;&nbsp;";
    html += "末页&nbsp;&nbsp;";
  } else {
    html += '<a href = "javascript:goto(' + ((curr_page < total_pages) ? (curr_page + 1) : total_pages) + ');" >下一页</a>&nbsp;&nbsp;';
    html += '<a href ="javascript:goto(' + (total_pages) + ');" >末页</a>&nbsp;&nbsp;';
  }
  html += '第' + curr_page + '页/共' + total_pages + '页';
  //变量count，控制不重复添加页码超链接
  count = count + 1;
  if ( count >= 2 ) {
    $("#tbody1").empty();
  }
  $("#tbody1").append(html);
  //设置全局变量currpage（当前页）和totalpages（总页数）完成删除，修改，增加的异步刷新
  currpage = curr_page;
  totalpages = total_pages;
}

/**
 * @description 页码跳转
 * @param {type} page 页码
 */
function goto( page )
{
  //调用查询函数
  search(page);
}

/**
 * 所在行选中
 * @param {type} obj
 * @returns {undefined}
 */
function rowchecked( obj )
{
  //toggleClass() 是 addclass() removeclass()之间切换
  //$(obj).toggleClass("rowchecked")
  if ( !($(obj).hasClass("rowchecked")) ) {
    $(obj).addClass("rowchecked");
  } else {
    $(obj).removeClass("rowchecked");
  }
}

/**
 * 填充增加表单默认值
 * @returns {undefined}
 */
function showInsertInfo()
{
  $.ajax({
        type: "post",
        url: "./book/add",
        data: null,
        dataType: 'json',
        success: function ( data ) {
          $("#add_form input[name='price']").val(data.book.price);
          $("#add_form input[name='authorage']").val(data.book.authorage);
        },
        error: function ( data ) {
          alert("Insert BackError");
        }
      });
}

/**
 * @description 点击修改超链接，回填表单信息
 * @param {type} id 修改单条记录的id
 */
function update( id )
{
  //隐藏插入button
  $("#add_button").hide();
  //隐藏测试数据button
  //清除错误颜色标记
  $("#add_form input[name='name']").removeClass("inputerror");
  $("#add_form input[name='isbn']").removeClass("inputerror");
  $("#add_form input[name='publish']").removeClass("inputerror");
  $("#add_form input[name='price']").removeClass("inputerror");
  $("#add_form input[name='authorname']").removeClass("inputerror");
  $("#add_form input[name='authorage']").removeClass("inputerror");
  $.ajax({
    type: "post",
    url: './book/edit',
    data: {
      id: id
    },
    dataType: 'json',
    success: function ( ret ) {
      var data = ret.book;
      alert(data.id);
      $("#add_form input[name='bookid']").val(data.id);
      $("#add_form input[name='name']").val(data.name);
      $("#add_form input[name='isbn']").val(data.isbn);
      $("#add_form input[name='publish']").val(data.publish);
      $("#add_form input[name='price']").val(data.price);
      $("#add_form input[name='authorname']").val(data.authorname);
      $("#add_form input[name='authorage']").val(data.authorage);
      $("#add_form .memo").val(data.memo);
      //status radio
      if ( data.status == "SOLDOUT" ) {
        $("#add_form input:radio[name='status1']").get(0).checked = true;
      } else if ( data.status == "ONSALE" ) {
        $("#add_form input:radio[name='status1']").get(1).checked = true;
      }
      if ( data.authorsex == "MALE" ) {
        $("#add_form input:radio[name='gender']").get(0).checked = true;
      } else if ( data.authorsex == "FEMALE" ) {
        $("#add_form input:radio[name='gender']").get(1).checked = true;
      } 
      //checkbox
      if ( isContains(data.type.toString(), "武侠") ) {
        $("#add_form input:checkbox[name='type']").get(0).checked = true;
      }
      if ( isContains(data.type.toString(), "言情") ) {
        $("#add_form input:checkbox[name='type']").get(1).checked = true;
      }
      if ( isContains(data.type.toString(), "校园") ) {
        $("#add_form input:checkbox[name='type']").get(2).checked = true;
      }
      if ( isContains(data.type.toString(), "经典") ) {
        $("#add_form input:checkbox[name='type']").get(3).checked = true;
      }
      $('#addbg').fadeIn();
      $('#adddiv').fadeIn();
      //调用函数 先解除绑定click事件，再绑定click事件
      $('#update_button').unbind('click').bind('click', function () {
        insert();
      });
    },
    error: function ( data ) {
      alert("很抱歉，失败");
    }
  });
}

/**
 * @description 判断substr  是否在 str 中
 * @param {type} str 
 * @param {type} substr
 * @returns {Boolean}
 */
function isContains( str, substr )
{
  //test() 方法检索字符串中的指定值
  return new RegExp(substr).test(str);
}

/**
 * @description indert、update 
 */
function insert()
{
  //验证信息是否合理 validate_info()
  if ( validate_info() ) {
    //取值
    var id = $("input[name='bookid']").val();
    alert(" id " + id);
    //若id为空走insert方法，否则走update方法
    if ( id == null || id == "" ) {
      $.ajax({
        type: "post",
        url: "./book/addup",
        data: $("#add_form").serialize(),
        dataType: 'json',
        success: function ( data ) {
          if ( data.InsertStatus != null ) {
            alert(data.InsertStatus);
            if ( data.InsertStatus == "Insert Success" ) {
              $('#adddiv').fadeOut(function () {
                $('#addbg').fadeOut();
              });
              if ( currpage == null ) {
                search(1);
              } else {
                search(currpage)
              }
            }
          } else {
            alert(data[0].defaultMessage);
          }
        },
        error: function ( data ) {
          alert("Insert Error");
        }
      });
    } else {
      alert("update");
      $.ajax({
        type: "post",
        url: "./book/editup",
        data: $("#add_form").serialize(),
        dataType: 'json',
        success: function ( data ) {
         if ( data.UpdateStatus != null ) {
            alert(data.UpdateStatus);
            if ( data.UpdateStatus == "Update Success" ) {
              $('#adddiv').fadeOut(function () {
                $('#addbg').fadeOut();
              });
              if ( currpage == null ) {
                search(1);
              } else {
                search(currpage)
              }
            }
          } else {
            alert(data[0].defaultMessage);
          }
        },
        error: function ( data ) {
          alert("update error");
        }
      });
    }
  }
}

/**
 * 单个删除
 * @param {type} id
 * @returns {undefined}
 */
function confirmDelete(id)
{
    if ( confirm("确认删除？") ) {
      $.ajax({
        type: "post",
        url: "./book/delete",
        data:{
          id:id
        },
        dataType: 'json',
        success: function ( data ) {
          if ( data.DeleteStatus != null ) {
            alert(data.DeleteStatus);
            if ( data.DeleteStatus == "Delete Success" ) {
              search(currpage)
            }
          } else {
            alert("Delete 失败");
          }
        },
        error: function ( data ) {
          alert("很抱歉，Delete Error!");
        }
      });
    }
}

/**
 * 批量删除
 * @returns {undefined}
 */
function deletemul()
{
  alert("deletemul");
}

/**
 * @description 重置查询条件
 */
function reset()
{
  $("#name").val("");
  $("#minprice").val("");
  $("#maxprice").val("");
  $("input:radio[name='status']").get(1).checked = false;
  $("input:radio[name='status']").get(0).checked = false;
  $("select[name='gender']").val("");
}

//验证增加和修改的表单数据
function validate_info()
{
  var name = $("#add_form input[name='name']").val();
  if ( name == "" ) {
    alert("请输入名称");
    $("#add_form input[name='name']").focus();
    $("#add_form input[name='name']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='name']").removeClass("inputerror");
  }
  var isbn = $("#add_form input[name='isbn']").val();
  if ( isbn == "" ) {
    alert("请输入ISBN");
    $("#add_form input[name='isbn']").focus();
    $("#add_form input[name='isbn']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='isbn']").removeClass("inputerror");
  }
  var publish = $("#add_form input[name='publish']").val();
  if ( publish == "" ) {
    alert("请输入出版社");
    $("#add_form input[name='publish']").focus();
    $("#add_form input[name='publish']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='publish']").removeClass("inputerror");
  }
  var price = $("#add_form input[name='price']").val();
  if ( price == "" ) {
    alert("请输入书本价格");
    $("#add_form input[name='price']").focus();
    $("#add_form input[name='price']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='price']").removeClass("inputerror");
  }
  if ( !isNumber(price) ) {
    alert("书本价格,请输入数字");
    $("#add_form input[name='price']").focus();
    $("#add_form input[name='price']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='price']").removeClass("inputerror");
  }
  if ( !priceLength(price) ) {
    alert("价格不合理");
    $("#add_form input[name='price']").focus();
    $("#add_form input[name='price']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='price']").removeClass("inputerror");
  }
  var author_name = $("#add_form input[name='authorname']").val();
  if ( author_name == "" ) {
    alert("请输入作者");
    $("#add_form input[name='authorname']").focus();
    $("#add_form input[name='authorname']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='authorname']").removeClass("inputerror");
  }
  var author_age = $("#add_form input[name='authorage']").val();
  if ( author_age == "" ) {
    alert("请输入作者年龄");
    $("#add_form input[name='authorage']").focus();
    $("#add_form input[name='authorage']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='authorage']").removeClass("inputerror");
  }
  if ( !isNumberage(author_age) ) {
    alert("作者年龄,请输入数字");
    $("#add_form input[name='authorage']").focus();
    $("#add_form input[name='authorage']").addClass("inputerror");
    return false;
  } else {
    $("#add_form input[name='authorage']").removeClass("inputerror");
  }
  return true;
}

//验证输入的价格是否是数字和小数点
function isNumber( str )          // 判断是否为非负整数  
{
  var rx = /^[0-9]+.?[0-9]*$/;//用来验证数字，包括小数的正则
  return rx.test(str);
}

//验证输入的价格是否是数字和小数点
function isNumberage( str )          // 判断是否为非负整数  
{
  var rx = /^[0-9]*$/;//用来验证数字
  return rx.test(str);
}

//验证价格长度是否合理，数据库是Decimal（18,2）
function priceLength( str )
{
  if ( str.length > 18 )
    return false
  else
    return true;
}