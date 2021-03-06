//每页显示的数量
var PAGE_SIZE = 15;
//总页数
var total_pages = 1;
var totalpages = 0;
//当前页码
var curr_page = 1; 
var currpage = 1;
//显示的页码超链接数量
var clickPageList = 5;
//参数页码
var page = 1;
//设置变量count 不让页码超链接重复添加
var count = 0;
//标题排序关键字、排序字段
var sortkey = "";
var sortcolname = "";
/**
 * @description 整体加载完之后调用加载相关函数
 */
$(function () {
  //每一个标题th都绑定click事件
  $(".title th").bind("click", function () {
    sortkey = $(this).attr("sortkey");
    if ( sortkey == "ASC" ) {
      $(this).attr("sortkey", "DESC");
    } else {
      $(this).attr("sortkey", "ASC");
    }
    sort(this);
  });
  
  //点击insert 显示弹框
  $('#btn_insert').click(function () {
    //置空
    $("input[name='upid']").val("");
    $("input[name='upname']").val("");
    $("input[name='upstatus']").attr("checked", false);
    $("input[name='upstatus']").get(0).checked = true;//设置默认
    $("[name='uptype']").removeAttr("checked");//取消全选  
    $("input[name='upprice']").val("");
    $("input[name='uppublish']").val("");
    $("input[name='upisbn']").val("");
    $("input[name='upauthor']").val("");
    $("#upmemo").val("");
    //显示增加button
    $("#add_button").show();
    //隐藏测试数据button
    $("#test_button").hide();
    //隐藏修改button
    $("#update_button").hide();
    //隐藏表单淡入淡出
    $('#addbg').fadeIn();
    $('#adddiv').fadeIn();
    //弹框拖拽
    $('#adddiv').draggable();
  });
  
  //测试数据button
  $('#test_insert').click(function () {
    //置空
    $("input[name='upid']").val("");
    $("input[name='upname']").val("");
    $("input[name='upstatus']").attr("checked", false);
    $("[name='uptype']").removeAttr("checked");//取消全选  
    $("input[name='upprice']").val("");
    $("input[name='uppublish']").val("");
    $("input[name='upisbn']").val("");
    $("input[name='upauthor']").val("");
    $("#upmemo").val("");
    //显示测试button
    $("#test_button").show();
    //隐藏增加button
    $("#add_button").hide();
    //隐藏修改button
    $("#update_button").hide();
    //隐藏表单进入
    $('#addbg').fadeIn();
    $('#adddiv').fadeIn();
    //弹框拖拽
    $('#adddiv').draggable();
  });
  //关闭弹窗
  $('#addclosehref').click(function () {
    $('#adddiv').fadeOut(function () {
      $("#update_button").show();
      $('#addbg').fadeOut();
    });
  });
  //jquery-ui 拖拽
  $('#adddiv').draggable();
});

/**
 * @description 条件查询数据
 * @param {type} page 传过来的页码
 */
function search( page ) {
  //获取条件查询文本框值
  var name = $("input[name='name']").val();
  var status = $("input[name='status']:checked").val();
  var minprice = $("input[name='minprice']").val();
  var maxprice = $("input[name='maxprice']").val();
  var publish = $("input[name='publish']").val();
  var isbn = $("input[name='isbn']").val();
  var author = $("input[name='author']").val();
  var author_sex = $("select[name='author_sex']").val();
  $.ajax({
    type: "post",
    url: "/study0201/study_ajax_multilist/search.jsp",
    data: {
      name: name,
      status: status,
      minprice: minprice,
      maxprice: maxprice,
      publish: publish,
      isbn: isbn,
      author: author,
      author_sex: author_sex,
      page: page,
      sortcolname: sortcolname,
      sortkey: sortkey
    },
    dataType: 'json',
    success: function ( ret ) {
      var data = ret[0].rows;
      //总记录数
      var total_count = ret[0].count;
      //清空tbody
      $("#tbody").empty();
      var html = "";
      //拼接html 生成新的table数据元素并添加到table中
      for ( var i = 0; i < data.length; i++ ) {
        html += '<tr class="' + ((i % 2) == "0" ? "evencolor" : "oddcolor") + '" id="row" onclick = "rowchecked(this);">';
        html += '<td><input type="checkbox" name="id" value = "' + data[i].bookid + '"/></td>';
        html += "<td>" + data[i].bookid + "</td>";
        html += "<td>" + data[i].book_name + "</td>";
        html += "<td>" + ((data[i].status) == "0" ? "下架" : ((data[i].status) == "1" ? "在售" : "")) + "</td>";
        html += "<td>" + data[i].type + "</td>";
        html += "<td>" + data[i].isbn + "</td>";
        html += "<td>" + data[i].publish + "</td>";
        html += "<td>" + data[i].price + "</td>";
        html += "<td>" + data[i].author_name + "</td>";
        html += "<td>" + ((data[i].author_sex) == "f" ? "女" : ((data[i].author_sex) == "m" ? "男" : "")) + "</td>";
        html += "<td>" + data[i].author_age + "</td>";
        html += "<td>" + data[i].modified + "</td>";
        html += "<td>" + data[i].created + "</td>";
        html += "<td>" + data[i].book_memo + "</td>";
        html += '<td><a href = "javascript:update(' + data[i].bookid + ');">修改</a></td>';
        html += "</tr>";
      }
      $("#tbody").append(html);
      //全选/全不选函数
      toselectAll();
      //页码超链接函数
      pagehref(total_count, page);
    }
  });
}

/**
 * @description 点击当前行，当前行处于选中状态，并改变当前行颜色，checkBox处于选中状态
 * @param obj 当前所在行对象
 */
function rowchecked( obj )
{
  //toggleClass() 是 addclass() removeclass()之间切换
  //$(obj).toggleClass("rowchecked")
  if ( !($(obj).hasClass("rowchecked")) ) {
    $(obj).addClass("rowchecked").find(":checkbox").attr("checked", true);
  } else {
    $(obj).removeClass("rowchecked").find(":checkbox").attr("checked", false);
  }
  //全部选中的时候，若取消某一行处于未选中状态，selectAll是false
  if( ($("#selectAll").attr("checked")) == "checked" ){
    $("#selectAll").attr("checked",false);
  }
}

/**
 * @description  标题排序
 * @param {type} obj 当前对象 
 */
function sort( obj )
{
  sortkey = $(obj).attr("sortkey");
  sortcolname = $(obj).attr("sortcolname");
  search(currpage);
}

/**
 * @description 触发onkeyup事件，根据输入的author_name，模糊查询显示作者信息
 */
function select_authorinfo()
{
  //显示author_name的隐藏div
  $("#upauthor_name").fadeIn();
  var author_name = $("#upauthor").val();
  //清空div
  $("#upauthor_name").empty();
  var html = "";
  $.ajax({
    type: "post",
    url: "/study0201/study_ajax_multilist/select_authorinfo.jsp",
    data: {
      author_name: author_name
    },
    dataType: 'json',
    success: function ( data ) {
      for ( var i = 0; i < data.length; i++ ) {
        html += '<tr onclick="javascript:author_selected(' + data[i].au_id + ',\'' + data[i].author_name + '\');"><td>' + data[i].author_name + "</td></tr>";
      }
      $("#upauthor_name").append(html);
    }
  });
}

/**
 * @description  选中某个作者并填入author_name,author_id
 * @param {type} id 作者ID author_id
 * @param {type} author_name 作者姓名 
 */
function author_selected( id, author_name )
{
  //填入author_name 和 id
  $("#upauthor").val(author_name);
  $("#upauthor_id").val(id);
  //作者信息div弹出
  $("#upauthor_name").fadeOut();
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
  if ( (total_count % PAGE_SIZE) == 0 ) {
    total_pages = parseInt(total_count / PAGE_SIZE);
  } else {
    total_pages = parseInt(total_count / PAGE_SIZE + 1);
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
  //跳转页面全选false
  $("#selectAll").attr("checked", false);
  //调用查询函数
  search(page);
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
  $("#publish").val("");
  $("#isbn").val("");
  $("#author").val("");
  $("#author_sex").val("");
}

/**
 * @description 批量删除、单条删除
 */
function confirmDelete()
{
  var chk_value = [];
  $('input[name="id"]:checked').each(function ()
  {
    //push() 方法可向数组的末尾添加一个或多个元素，并返回新的长度
    chk_value.push($(this).val());
  });
  //至少要选中一条
  if ( chk_value.length > 0 ) {
    if ( confirm("确认删除？") ) {
      $.ajax({
        type: "post",
        url: "/study0201/study_ajax_multilist/delete_function.jsp",
        data: 'id=' + chk_value,
        dataType: 'json',
        success: function ( data ) {
          //itemscount 选中的个数 itemstotal 当前页总个数
          var itemscount = 0;
          var itemstotal = $("#tbody").children().length;
          if ( data > 0 ) {
            alert("删除成功");
            $("input[name='id']").each(function ()
            {
              if ( $(this).attr('checked') == "checked" ) {
                itemscount += 1;
              }
            });
            $("#selectAll").attr("checked", false);
            //最后一页且选中的个数等于当前页数总个数,跳转到前一页，否则跳转到当前页
            if ( itemscount == itemstotal && currpage == totalpages && currpage != 1 ) {
              search(currpage - 1);
            } else {
              search(currpage);
            }
          } else {
            alert("很抱歉，失败");
          }
        },
        error: function ( data ) {
          alert("很抱歉，失败");
        }
      });
    }
  } else {
    alert(" 至少勾选一条删除选项 ！ ");
  }
}

/**
 * @description checkBox 全选、全不选
 */
function toselectAll( )
{
  if ( ($("input[name='selectAll']").attr("checked")) != "checked" ) {
    $("input[name='id']").each(function ()
    {
      if ( $(this).parents('tr').hasClass("rowchecked") ) {
        $(this).attr("checked", true);
      } else {
        $(this).attr("checked", false);
      }
    });
  } else {
    $("input[name='id']").each(function ()
    {
      $(this).parents('tr').addClass("rowchecked").find(":checkbox").attr("checked", true);
    });
    $("input[name='id']").attr("checked", "true");
  }
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
  $("#test_button").hide();
  $.ajax({
    type: "post",
    url: "/study0201/study_ajax_multilist/select_single.jsp",
    data: {
      id: id
    },
    dataType: 'json',
    success: function ( data ) {
      var i = 0;
      $("input[name='upid']").val(id);
      $("input[name='upname']").val(data[i].book_name);
      $("input[name='upisbn']").val(data[i].isbn);
      $("input[name='uppublish']").val(data[i].publish);
      $("input[name='upprice']").val(data[i].price);
      $("input[name='upauthor']").val(data[i].author_name);
      $("input[name='upauthor_id']").val(data[i].author_id);
      $("#upmemo").val(data[i].memo);
      //status radio
      if ( data[i].status == "0" ) {
        $("input:radio[name='upstatus']").get(1).checked = true;
      } else {
        $("input:radio[name='upstatus']").get(0).checked = true;
      }
      //type checkbox 
      $("input[name='uptype']").each(function () {
        $(this).attr('checked', false);
      });
      if ( isContains(data[i].type.toString(), "武侠") ) {
        $("input:checkbox[name='uptype']").get(0).checked = true;
      }
      if ( isContains(data[i].type.toString(), "言情") ) {
        $("input:checkbox[name='uptype']").get(1).checked = true;
      }
      if ( isContains(data[i].type.toString(), "校园") ) {
        $("input:checkbox[name='uptype']").get(2).checked = true;
      }
      if ( isContains(data[i].type.toString(), "经典") ) {
        $("input:checkbox[name='uptype']").get(3).checked = true;
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
    var id = $("input[name='upid']").val();
    //获取条件查询文本框值
    var name = $("input[name='upname']").val();
    var status = $("input[name='upstatus']:checked").val();
    var typeall = "";
    $("input[name='uptype']").each(function ()
    {
      if ( $(this).attr('checked') == "checked" ) {
        typeall += $(this).val() + ",";
      }
    });
    var type = typeall.substring(0, typeall.length - 1)
    var price = $("input[name='upprice']").val();
    var publish = $("input[name='uppublish']").val();
    var isbn = $("input[name='upisbn']").val();
    var author_name = $("input[name='upauthor']").val();
    var author_id = $("input[name='upauthor_id']").val();
    var memo = $("#upmemo").val();
    //若id为空走insert方法，否则走update方法
    if ( id == null || id == "" ) {
       $(".title th").attr("sortkey","");
      $.ajax({
        type: "post",
        url: "/study0201/study_ajax_multilist/add_function.jsp",
        data: {
          name: name,
          status: status,
          type: type,
          price: price,
          publish: publish,
          isbn: isbn,
          author_id: author_id,
          memo: memo
        },
        dataType: 'text',
        success: function ( data ) {
          if ( data > 0 ) {
            //增加成功之后先把增加表单隐藏，然后在异步跳转
            $('#adddiv').fadeOut(function () {
              $("#update_button").show();
              $('#addbg').fadeOut();
            });
            alert("恭喜，插入成功");
            //insert成功之后，会显示在第一条，相应的页跳转到第一页查看
            search(1);
          } else {
            alert(data);
          }
        },
        error: function ( data ) {
          alert(data);
        }
      });
    } else {
      $.ajax({
        type: "post",
        url: "/study0201/study_ajax_multilist/update_function.jsp",
        data: {
          id: id,
          name: name,
          status: status,
          type: type,
          price: price,
          publish: publish,
          isbn: isbn,
          author_name: author_name,
          author_id: author_id,
          memo: memo
        },
        dataType: 'text',
        success: function ( data ) {
          if ( data > 0 ) {
            //修改成功之后先把修改表单隐藏，然后在异步跳转
            $('#adddiv').fadeOut(function () {
              $('#addbg').fadeOut("fast");
            });
            alert("恭喜，修改成功");
            //update成功之后会显示在第一条，相应的跳转到第一页
            search(1);
          } else {
            alert(data);
          }
        },
        error: function ( data ) {
          alert(data);
        }
      });
    }
  }
}

/**
 * @description 测试数据insert
 */
function test_insert()
{
  //验证信息是否合理
  if ( validate_info() ) {
    //取值
    var id = $("input[name='upid']").val();
    //获取条件查询文本框值
    var name = $("input[name='upname']").val();
    var status = $("input[name='upstatus']:checked").val();
    var typeall = "";
    $("input[name='uptype']").each(function ()
    {
      if ( $(this).attr('checked') == "checked" ) {
        typeall += $(this).val() + ",";
      }
    });
    var type = typeall.substring(0, typeall.length - 1)
    var price = $("input[name='upprice']").val();
    var publish = $("input[name='uppublish']").val();
    var isbn = $("input[name='upisbn']").val();
    var author_name = $("input[name='upauthor']").val();
    var author_id = $("input[name='upauthor_id']").val();
    var memo = $("#upmemo").val();
    $.ajax({
      type: "post",
      url: "/study0201/study_ajax_multilist/add_function.jsp",
      data: {
        name: name,
        status: status,
        type: type,
        price: price,
        publish: publish,
        isbn: isbn,
        author_id: author_id,
        memo: memo
      },
      dataType: 'json',
      success: function ( data ) {
      },
      error: function ( data ) {
        alert("很抱歉，失败");
      }
    });
  }
}

/**
 * @description  验证insert 和 update 数据
 * @returns {Boolean}
 */
function validate_info()
{
  var name = $("input[name='upname']").val();
  if ( name == "" ) {
    alert("请输入名称");
    return false;
  }
  var status = $("input[name='upstatus']:checked").val();
  if ( !(status == "1" || status == "0") ) {
    alert("请选择状态");
    return false;
  }
  var isbn = $("input[name='upisbn']").val();
  if ( isbn == "" ) {
    alert("请输入ISBN");
    return false;
  }
  var publish = $("input[name='uppublish']").val();
  if ( publish == "" ) {
    alert("请输入出版社");
    return false;
  }
  var price = $("input[name='upprice']").val();
  if ( price == "" ) {
    alert("请输入书本价格");
    return false;
  }
  if ( !isNumber(price) ) {
    alert("书本价格,请输入数字");
    return false;
  }
  if ( !priceLength(price) ) {
    alert("价格不合理");
    return false;
  }
  var author = $("input[name='upauthor']").val();
  if ( author == "" ) {
    alert("请输入作者");
    return false;
  }
  return true;
}

/**
 * @description 验证输入的价格是否是数字和小数点
 * @param {type} str price
 * @returns {Boolean}
 */
function isNumber( str )    
{
  //用来验证数字，包括小数的正则
  var rx = /^[0-9]+.?[0-9]*$/;
  return rx.test(str);
}

/**
 * @description 验证价格长度是否合理，数据库是Decimal（18,2）
 * @param {type} str price
 * @returns {Boolean}
 */
function priceLength( str )
{
  if ( str.length > 18 )
    return false;
  else
    return true;
}