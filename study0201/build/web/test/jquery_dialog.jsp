<%-- 
    Document   : test
    Created on : 2017-4-25, 9:57:20
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="jquery.min.js"></script>
    <script src="book.js" type="text/javascript"></script>
    <title>JSP Page</title>
  </head>
  <body>
    <input type="button" value="点击" id="dialog_show"/>  
    <div id="dialog" style="display:none;">  
      <div style="background:url(headerbg.gif); width:auto; height:27px; cursor:move" id="dialog_title">  
        <div style="background:url(x.gif); width:18px; height:18px; float:right; cursor:pointer" title="关闭"  id='dialog_close'></div>  
      </div>  
      这里放弹出层内容  
      <br/>  
    </div>

    <script>
      $(document).ready(function () {
        var dialog_with = 400;
        var dialog_height = 200;
        var _move = false;//移动标记  
        var _x, _y;//鼠标离控件左上角的相对位置  
        $("#dialog_show").click(function () {

          $("body").css("opacity", "0.2");//body加蒙板  

          var window_width = $(window).width();
          var window_height = $(window).height();
          /*var widd = $(this).width();  
           var heii = $(this).height();*/
          var left = (window_width - dialog_with) / 2 + "px";//距左边位置  
          var top = (window_height - dialog_height) / 2 + "px";//距顶边位置  

          $("#dialog").css({//设置弹出框样式  
            "z-index": "5",
            "position": "absolute",
            "display": "block",
            "width": "400px",
            "height": "200px",
            "left": left,
            "top": top,
            "background": "#FFFFFF",
            "border": "1px solid #999999",
          });
        });

        $("#dialog_close").click(function (event) {//关闭  
          /*$("#dialog").css({  
           "display":"none",  
           "speed":"600"  
           });*/
          $("#dialog").fadeOut("slow");
          $("body").fadeTo("slow", 1.0);
        });

        $("#dialog_title").click(function () {
          //alert("click");//点击（松开后触发）  
        }).mousedown(function (e) {
          _move = true;
          _x = e.pageX - parseInt($("#dialog").css("left"));
          _y = e.pageY - parseInt($("#dialog").css("top"));
          $("#dialog").fadeTo(20, 0.55);//点击后开始拖动并透明显示  
        });

        $("#dialog").mouseup(function () {
          _move = false;
          $("#dialog").fadeTo("fast", 1);//松开鼠标后停止移动并恢复成不透明  
        });

        $("#dialog_title").mousemove(function (e) {
          if (_move) {
            var x = e.pageX - _x;//移动时根据鼠标位置计算控件左上角的绝对位置  
            var y = e.pageY - _y;
            $("#dialog").css({top: y, left: x});//控件新位置  
          }
        }).mouseup(function () {
          _move = false;
          $("#dialog").fadeTo("fast", 1);//松开鼠标后停止移动并恢复成不透明  
        });
      })
    </script>
  </body>
</html>
