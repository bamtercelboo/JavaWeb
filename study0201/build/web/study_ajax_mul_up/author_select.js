//每页显示的数量
var authorpagesize = 6;
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
  //insert div 位置
  var browser_height = document.body.clientHeight
  var brower_width = document.body.clientWidth;
  var div_height = $("#addauthordiv").height();
  var div_width = $("#addauthordiv").width();
  var top_height = (browser_height / 2) - (div_height / 2);
  var left_width = (brower_width / 2) - (div_width / 2);
  $("#addauthordiv").css("top", top_height);
  $("#addauthordiv").css("left", left_width);
  $(".authorsearchparam").css("width",div_width - 20);
  $(".authordata").css("width",div_width - 20);
  $(".authordata").css("height",div_height - 100);
  $(window).resize(function () {
    var browser_height = document.body.clientHeight
    var brower_width = document.body.clientWidth;
    var div_height = $("#addauthordiv").height();
    var div_width = $("#addauthordiv").width();
    var top_height = (browser_height / 2) - (div_height / 2);
    var left_width = (brower_width / 2) - (div_width / 2);
    $("#addauthordiv").css("top", top_height + 10);
    $("#addauthordiv").css("left", left_width + 10);
    $(".authordata").css("width",div_width - 40);
    $(".authordata").css("height",div_height - 50);
  });
  
  //每一个标题th都绑定click事件
  $(".author_title th").bind("click", function () {
    sortkey = $(this).attr("sortkey");
    if ( sortkey == "ASC" ) {
      $(this).attr("sortkey", "DESC");
    } else {
      $(this).attr("sortkey", "ASC");
    }
    author_sort(this);
  });
  
   
  //点击author_info 弹出层
  $('#authorinfo').click(function () {
    //隐藏表单进入
    $('#addauthorbg').fadeIn();
    $('#addauthordiv').fadeIn();
    //弹框拖拽
    $('#authordraggable').mousedown(function () {
      $('#addauthordiv').draggable({disabled: false});
    });
    $('#authordraggable').mouseup(function () {
      $('#addauthordiv').draggable({disabled: true});
    });
    //清空
    $("#tauthorbody").empty();
    $("#tauthorbody1").empty();
    author_reset();
  });
   //作者弹出层关闭
  $('#addauthorclosehref').click(function () {
    $('#addauthordiv').fadeOut(function () {
      $('#addauthorbg').fadeOut();
    });
  });
  
   //选中作者弹出层关闭
  $('#author_select').click(function () {
    $("input[name='author_auid']").each(function () {
      if ( $(this).parents('tr').hasClass("rowchecked") ) {
        if ( confirm("确定选中?") ) {
          $('#addauthordiv').fadeOut(function () {
            $('#addauthorbg').fadeOut();
          });
        }
      }
    });
  });
});

/**
 * @description 条件查询数据
 * @param {type} page 传过来的页码
 */
function author_search( page ) {
  //获取条件查询文本框值
  var name = $(".authorsearchparam input[name='name']").val();
  var authorsex = $(".authorsearchparam input[name='authorssex']:checked").val();
  var minage = $(".authorsearchparam input[name='minage']").val();
  var maxage = $(".authorsearchparam input[name='maxage']").val();
  $.ajax({
    type: "post",
    url: "/study0201/study_ajax_mul_up/author_search.jsp",
    data: {
      name: name,
      authorsex: authorsex,
      minage: minage,
      maxage: maxage,
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
      $("#tauthorbody").empty();
      var html = "";
      //拼接html 生成新的table数据元素并添加到table中
      for ( var i = 0; i < data.length; i++ ) {
        html += '<tr class="' + ((i % 2) == "0" ? "evencolor" : "oddcolor") + '" id="row" onclick = "author_rowchecked(this);">';
        html += '<td><input type="radio" name="author_auid" value = "' + data[i].au_id + '"/></td>';
        html += '<td id="aauid">' + data[i].au_id + "</td>";
        html += '<td name="aname" id="aname">' + data[i].name + "</td>";
        html += "<td>" + ((data[i].author_sex) == "f" ? "女" : ((data[i].author_sex) == "m" ? "男" : "")) + "</td>";
        html += "<td>" + data[i].author_age + "</td>";
        html += "<td>" + data[i].author_created + "</td>";
        html += "<td>" + data[i].author_modified + "</td>";
        html += '<td style="word-break:break-all;overflow: scroll;">' + ((data[i].memo) == null ? "" : ((data[i].memo))) + "</td>";
        html += "</tr>";
      }
      $("#tauthorbody").append(html);
      //页码超链接函数
      author_pagehref(total_count, page);
    }
  });
}

/**
 * @description 点击当前行，当前行处于选中状态，并改变当前行颜色，Radio处于选中状态
 * @param obj 当前所在行对象
 */
function author_rowchecked( obj )
{
  $("input[name='author_auid']").each(function () {
    if ( $(this).parents('tr').hasClass("rowchecked") ) {
      $(this).parents('tr').removeClass("rowchecked").find(":radio").attr("checked", false);
    }
  });
  $(obj).addClass("rowchecked").find(":radio").attr("checked", true);
  //填入author_name 和 id
  $("#upauthor").val($(obj).find("#aname").text());
  $("#upauthor_id").val($(obj).find("#aauid").text());
  
}

/**
 * @description  标题排序
 * @param {type} obj 当前对象 
 */
function author_sort( obj )
{
  sortkey = $(obj).attr("sortkey");
  sortcolname = $(obj).attr("sortcolname");
  author_search(currpage);
}

/**
 * @description 创建页码超链接
 * @param {type} total_count 总记录数
 * @param {type} curr_page 当前页
 */
function author_pagehref( total_count, curr_page )
{
  var total_count = total_count;
  //计算总页数
  if ( (total_count % authorpagesize) == 0 ) {
    total_pages = parseInt(total_count / authorpagesize);
  } else {
    total_pages = parseInt(total_count / authorpagesize + 1);
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
    html += '<a href = "javascript:author_goto(1);" >首页</a>&nbsp;&nbsp;';
    html += '<a href = "javascript:author_goto(' + ((curr_page > 1) ? (curr_page - 1) : 1) + ');" >上一页</a>&nbsp;&nbsp;';
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
          html += '<a href = "javascript:author_goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
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
          html += '<a href = "javascript:author_goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
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
          html += '<a href = "javascript:author_goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
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
        html += '<a href = "javascript:author_goto(' + i + ');">' + i + '</a>&nbsp;&nbsp;';
      }
    }
  }
  //末页下一页和末页都不能点击
  if ( curr_page == total_pages ) {
    html += "下一页&nbsp;&nbsp;";
    html += "末页&nbsp;&nbsp;";
  } else {
    html += '<a href = "javascript:author_goto(' + ((curr_page < total_pages) ? (curr_page + 1) : total_pages) + ');" >下一页</a>&nbsp;&nbsp;';
    html += '<a href ="javascript:author_goto(' + (total_pages) + ');" >末页</a>&nbsp;&nbsp;';
  }
  html += '第' + curr_page + '页/共' + total_pages + '页';
  //变量count，控制不重复添加页码超链接
  count = count + 1;
  if ( count >= 2 ) {
    $("#tauthorbody1").empty();
  }
  $("#tauthorbody1").append(html);
  //设置全局变量currpage（当前页）和totalpages（总页数）完成删除，修改，增加的异步刷新
  currpage = curr_page;
  totalpages = total_pages;
}

/**
 * @description 页码跳转
 * @param {type} page 页码
 */
function author_goto( page )
{
  //调用查询函数
  author_search(page);
}

/**
 * @description 重置查询条件
 */
function author_reset()
{
  $(".authorsearchparam #name").val("");
  $(".authorsearchparam #minage").val("");
  $(".authorsearchparam #maxage").val("");
  $(".authorsearchparam input:radio[name='authorssex']").get(1).checked = false;
  $(".authorsearchparam input:radio[name='authorssex']").get(0).checked = false;
}

