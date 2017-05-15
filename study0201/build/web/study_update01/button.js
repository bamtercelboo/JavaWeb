
//增加button跳转JSP页面
$(function () {
  $("#btn_insert").click(function () {
    window.location.href = "add_detail.jsp"
  });
});


//验证增加和修改的表单数据
function validate_info()
{
 var name = $("input[name='name']").val();
  if (name == "")
  {
    alert("请输入名称");
    return false;
  }
  var isbn = $("input[name='isbn']").val();  
  if (isbn == "")
  {
    alert("请输入ISBN");
    return false;
  }
  var publish = $("input[name='publish']").val();
  if (publish == "")
  {
    alert("请输入出版社");
    return false;
  }
  var price = $("input[name='price']").val();
  if (price == "")
  {
    alert("请输入书本价格");
    return false;
  }
  if (!isNumber(price))
  {
    alert("书本价格,请输入数字");
    return false;
  }
  if (! priceLength(price))
  {
    alert("价格不合理");
    return false;
  }
  var author = $("input[name='author']").val();
  if (author == "")
  {
    alert("请输入作者");
    return false;
  }
  var author_sex = $("select[name='author_sex']").val();
  if (author_sex == "")
  {
    alert("请输入作者性别");
    return false;
  }

}
//验证输入的价格是否是数字和小数点
function isNumber(str)          // 判断是否为非负整数  
{
  var rx = /^[0-9]+.?[0-9]*$/;//用来验证数字，包括小数的正则
  return rx.test(str);
}
//验证价格长度是否合理，数据库是Decimal（18,2）
function priceLength(str)          
{
  if (str.length > 18)
    return false
  else
    return true;
}