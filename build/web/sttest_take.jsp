<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="pes.Db"%>
<%
    if (session.getAttribute("user_name") != null)
    {
        String uname = session.getAttribute("user_name").toString();
        String utype = session.getAttribute("user_type").toString();
        String dept = session.getAttribute("dept").toString();
        if (!utype.equals("student"))
        {
            response.sendRedirect("index.jsp?error=Please Login");
        }
        
        
        Db db = new Db();

        Connection conn = db.getConnection();

        Statement st = conn.createStatement();

        ResultSet rs = st.executeQuery("select * from users where user_id='" + uname + "'");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <%@include file="css_js.jsp" %>
        <style>

            .mws-form-item label
            {
                font-weight: bold;
            }

            .mws-form-list
            {
                padding: 0px;
                margin: 0px;
                margin-top: 7px;
            }

            .mws-form-list li
            {
                display: list-item;
                float : left;
                width : 30%;
                font-weight: bold;
            }

            li.option
            {
                cursor: pointer;

            }

            .mws-themer-section ul li
            {
                display: list-item;
                float : left;
                width : 10%;
                font-weight: bold; 
                line-height: 15px;
                background-color: red;
                text-align: center;
                color: black;
                border:1px;
                border-color:#FC0;
                margin: .3em;
            }
            #test-details-dialog
            {
                overflow: auto;
                height: 300px;
                width: 100px;
            } 
        </style>
        <script>

            $(document).ready(function(){
                
                $("#test-panel").hide();
                
                $("#test-details-dialog").dialog({
                    autoOpen: false,
                    title: "Test Details",
                    modal: true,
                    width: "640",
                    show: "slide",
                    hide: "explode",
                    buttons: [{
                            text: "Close Dialog",
                            click: function() {
                                $( this ).dialog( "close" );
                            }}]
                });

                $(".view-test-details").bind("click", function(event) {
                    $("#test-details-dialog").dialog("option", {modal: true}).dialog("open");
                    event.preventDefault();
                });
                $("#test-instructions").dialog({
                    autoOpen: false,
                    title: "Instructions",
                    modal: true,
                    width: "640",
                    buttons: [{
                            text: "Close Dialog",
                            click: function() {
                                $( this ).dialog( "close" );
                            }}]
                });

                $(".view-instructions").bind("click", function(event) {
                    $("#test-instructions").dialog("option", {modal: false}).dialog("open");
                    event.preventDefault();
                });


                $('#sh_opt_t,#sh_opt_b').click( function() {
                        
                    $('.options').toggle('200');
                    if ($('#sh_opt_t').html() == "Show Options" ) {
                        $('#sh_opt_t,#sh_opt_b').html('Hide Options');
                    } else {
                        $('#sh_opt_t,#sh_opt_b').html('Show Options'); 
                    }
                    $('#sh_opt_t,#sh_opt_b').toggleClass("ic-minus").toggleClass("ic-add");
                    
                    return false;
                });
            
                $('#sh_pro_t,#sh_pro_b').click( function() {
                        
                    $('.question_details').toggle('200');
                    if ($('#sh_pro_t').html() == "Show Properties" ) {
                        $('#sh_pro_t,#sh_pro_b').html('Hide Properties') 
                    } else {
                        $('#sh_pro_t,#sh_pro_b').html('Show Properties') 
                    }
                    $('#sh_pro_t,#sh_pro_b').toggleClass("ic-minus").toggleClass("ic-add");
                    return false;
                });

                $("#test_name").change(function(){

                    tid = $(this).val();
                    $("#tid").val(tid);
                    if(tid == "")
                    {
                        $(".view-test-details").attr("disabled","disabled").val('View Details');
                        $("#test_details").html("");
                        $(".start-test").attr("disabled","disabled");
                    }
                    else
                    {
                        $(".view-test-details").attr("disabled","disabled").val("Loading...");
                        $(".start-test").attr("disabled","disabled");
                        $("#test_details").load('getTestDetails.jsp?tid='+tid,function(res,status,xhr){
                            if(status == "success")
                            {
                                $(".view-test-details").removeAttr("disabled").val('View Details');
                                $(".start-test").removeAttr("disabled");
                            }

                        });

                    }


                });
                
                function sub(){
                
                    $("#takeTest").submit();
                
                }
                
                $(".start-test").click(function(){
                
                    $("#test-panel").show();
                    $("#test_name").attr("disabled","disabled");
                    tid = $("#test_name").val();
                    $("#ajaxload").show();
                    $("#ques_div").load('getTestQues.jsp?tid='+tid,function(res,status,xhr){
                        //alert(res);
                        if(status == 'success')
                        {    
                            $("#ajaxload").hide(); 
                            
                            var time = $("#t_time").val();
                            time = eval(time) * 60;
                            if(time != 0)
                                $('.test-time').countdown({until: time,format:'HMS',compact:true,onExpiry : sub});
                            else
                                $("#test-time").html('No Time Limit');
                            
                        }
                       
                    });
                    
                    $("#select-test-panel").toggleClass("mws-collapsed").find(".mws-panel-body").slideToggle("fast");
                    
                    $(".start-test").val("Test Started").attr("disabled","disabled");
                
                });
            
                $(document).on("click","li.option",function(){
                
                    opt = $(this).html();
                
                    v =$(this).find("input:checkbox");
                
                    if(v.attr("checked"))
                    {
                        v.removeAttr("checked");
                        $(this).css("font-weight","normal");
                        $(this).css("color","");
                    }
                    else
                    {
                        v.attr("checked","checked");
                        $(this).css("font-weight","bold");
                        $(this).css("color","green");
                    }
                    
                    $("input[name='"+v.attr("name")+"']").not(v).removeAttr("checked");
                    $("input[name='"+v.attr("name")+"']").not(v).parent("li").css("font-weight","normal").css("color","");
                    
                });
                
                $(document).on("click","input:checkbox",function(){
                    
                    name = $(this).attr("name");
                    if($(this).attr("checked"))
                    {
                        $(this).removeAttr("checked").parent('li').css("font-weight","bold").css("color","green");
                    }
                    else
                    {
                        $(this).attr("checked","checked").parent('li').css("font-weight","normal").css("color","");
                    }
                    $("input[name='"+name+"']").not(this).removeAttr("checked");
                    $("input[name='"+name+"']").not(this).parent("li").css("font-weight","normal").css("color","");    
                    
                });
                
                $("#takeTest").submit(function(){
                    
                    //alert($(this).serialize());
                    var url = "SubmitTest"; // the script where you handle the form input.

                    $.ajax({
                        type: "POST",
                        url: url,
                        data: $("#takeTest").serialize(), // serializes the form's elements.
                        success: function(data)
                        {
                            $(".test-time").countdown('pause')
                            $("#ques_div").html(data);
                        }
                    });

                    return false; // avoid to execute the actual submit of the form.
                    
                    
                });

            });

        </script>
        <title>Performance Evaluation System - Take Test</title>
    </head>

    <body>

        <!-- Themer -->
        <!-- 
        <div id="mws-themer">
             <div id="mws-themer-content">
                 <div id="mws-test-ribbon"></div>
                 <div id="mws-themer-toggle"></div>
                 <div id="" class="mws-themer-section">
                     <input type="button" class="mws-button red view-instructions mws-i-24 i-info-about icon-small" value="" />
                     <input type="button" class="mws-button red view-test-details small" value="View Details" id="view-test-details" disabled="disabled" />
                 </div>
                 <div class="mws-themer-separator"></div>
                 <div class="mws-themer-section">
                     <span style="color: white">Questions</span>
                     <div>
                         <ul>
                             <li style="">1</li>
                             <li style="display: list-item;float : left;width : 10%;font-weight: bold; line-height: 15px;background-color: green;text-align: center;color: black;border:1px;border-color:#FC0;margin: .3em">2</li>
                             <li style="display: list-item;float : left;width : 10%;font-weight: bold; line-height: 15px;background-color: white;text-align: center;color: black;border:1px;border-color:#FC0;margin: .3em">3</li>
                             <li style="display: list-item;float : left;width : 10%;font-weight: bold; line-height: 15px;background-color: red;text-align: center;color: black;border:1px;border-color:#FC0;margin: .3em">4</li>
                             <li style="display: list-item;float : left;width : 10%;font-weight: bold; line-height: 15px;background-color: red;text-align: center;color: black;border:1px;border-color:#FC0;margin: .3em">5</li>
                         </ul>
                     </div>
                 </div>
                 <div class="mws-themer-separator"></div>
                 <div class="mws-themer-section">
                     <ul>
                         <li class="clearfix"><span></span> <div id="mws-textglow-op"></div></li>
                     </ul>
                 </div>
                 <div class="mws-themer-separator"></div>
                 <div class="mws-themer-section">
                     <label>Test Time</label> <span class="test-time" style=""></span>
                 </div>
             </div>
             <div id="mws-themer-css-dialog">
                 <form class="mws-form">
                     <div class="mws-form-row">
                         <div class="mws-form-item">
                             <textarea cols="auto" rows="auto" readonly="readonly"></textarea>
                         </div>
                     </div>
                 </form>
             </div>
         </div> 
        -->
        <!-- Themer End -->


        <!-- Header Wrapper -->
        <div id="mws-header" class="clearfix">

            <!-- Logo Wrapper -->
            <div id="mws-logo-container">
                <div id="mws-logo-wrap">
                    <img src="images/mws-logo.png" alt="mws admin" />
                </div>
            </div>

            <!-- User Area Wrapper -->
            <div id="mws-user-tools" class="clearfix">
                <div id="mws-user-info" class="mws-inset">
                    <div id="mws-user-photo">
                        <img src="example/profile.jpg" alt="User Photo" />
                    </div>
                    <div id="mws-user-functions">
                        <div id="mws-username">
                            Hello, <% if (rs.next())
                                {
                                    out.println(rs.getString("name"));
                                }
                                conn.close();%>
                        </div>
                        <ul>
                            <li><a href="#">Profile</a></li>
                            <li><a href="#" id="change-pwd">Change Password</a></li>
                            <li><a href="Logout">Logout</a></li>
                        </ul>
                        <%@include file="changePwd.jsp" %>
                    </div>
                </div>
            </div>
        </div>
        <!-- Main Wrapper -->
        <div id="mws-wrapper">
            <!-- Necessary markup, do not remove -->
            <div id="mws-sidebar-stitch"></div>
            <div id="mws-sidebar-bg"></div>

            <!-- Sidebar Wrapper -->
            <div id="mws-sidebar">

                <!-- Main Navigation -->
                <div id="mws-navigation">
                    <ul>
                        <li><a href="student.jsp" class="mws-i-24 i-home">Dashboard</a></li>
                        <li class="active"><a href="#" class="mws-i-24 i-users-2">Tests</a>
                            <ul>
                                <li><a href="sttest_view.jsp">View Tests</a></li>
                                <li class="active"><a href="sttest_take.jsp">Take Tests</a></li>
                            </ul>
                        </li>
                        <li><a href="#" class="mws-i-24 i-users-2">Results</a>
                            <ul class="closed">
                                <li><a href="stres_view.jsp">View Results</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <!-- End Navigation -->
            </div>
            <!-- Container Wrapper -->

            <div id="mws-container" class="clearfix">

                <!-- Main Container -->
                <div class="container">
                    <form class="mws-form" action="SubmitTest" method="post" id="takeTest">
                        <div class="mws-panel grid_8 mws-collapsible" id="select-test-panel">

                            <div class="mws-panel-header">
                                <span class="mws-i-24 i-list">Select Test</span>
                            </div>
                            <div class="mws-panel-body">
                                <div class="mws-form-inline">

                                    <div class="mws-form-row">
                                        <label>Select Unattended Test</label>
                                        <div class="mws-form-item medium">
                                            <select class="required" id="test_name" name="test_name">
                                                <%


                                                    String query = "select * from tests t,subjects_dept s where Date(t.s_date) <= Date(NOW()) and (t.e_date is NULL or Date(t.e_date) >= Date(NOW())) and t.test_id not in (select r.test_id from results r where r.completed = 1 and r.user_id = '" + uname + "') and t.t_sub = s.sub_id and s.dept_id =" + dept;

                                                    Connection c = db.getConnection();
                                                    Statement st1 = c.createStatement();
                                                    ResultSet rs1 = st1.executeQuery(query);
                                                    String options = "";
                                                    while (rs1.next())
                                                    {
                                                        String t_id = rs1.getString("test_id");
                                                        String t_name = rs1.getString("t_name");

                                                        options += "<option value='" + t_id + "'>" + t_name + "</option>";
                                                    }
                                                    if(options == null || options.equals(""))
                                                    {
                                                        options = "<option value=''>- No Available Tests -</option>";
                                                    }
                                                    out.println(options);

                                                %>
                                            </select>
                                            <input type="hidden" value="" name="tid" id="tid" />
                                        </div>

                                    </div>
                                    <div class="mws-button-row">
                                        <input type="button" class="mws-button red view-instructions mws-i-24 i-info-about icon" value="" />
                                        <input type="button" class="mws-button red view-test-details mws-i-24 i-tag-1 large" value="View Details" id="view-test-details" disabled="disabled" />

                                        <input type="button" class="mws-button red start-test mws-i-24 i-check large" value="Start Test" disabled="disabled" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mws-panel grid_8 mws-collapsible" id="test-panel">

                            <div class="mws-panel-header">
                                <span class="mws-i-24 i-list">Test Questions</span>
                            </div>
                            <div class="mws-panel-body">

                                <div class="mws-panel-toolbar top clearfix">
                                    <ul>

                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_opt_t">Hide Options</a></li>
                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_pro_t">Hide Properties</a></li>
                                    </ul>
                                    <div class="mws-panel-toolbar right top clearfix">
                                        <ul>
                                            <li><a href="#" class="mws-ic-16 ic-stopwatch" id="q_get_t" onclick="return false;">Remaining Time</a></li>
                                            <li style="font-weight: bold;"><a href="#" id="test-time" class="test-time" onclick="return false;"></a></li>

                                        </ul>

                                    </div>
                                </div>
                                <div class="mws-form-row">
                                    <div id="time"></div>
                                    <div class="ajaxload" id="ajaxload" align="center" style="display: none;">Fetching Questions...<br /><img src="images/ajax-loader.gif" /></div>
                                    <div id="ques_div" class="mws-form-row" style="padding: 10px">

                                    </div>
                                </div>
                                <div class="mws-panel-toolbar bottom clearfix">
                                    <ul>

                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_opt_b">Hide Options</a></li>
                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_pro_b">Hide Properties</a></li>

                                    </ul>
                                </div>
                                <div class="mws-button-row">


                                    <span class="grid_3" style="color: red;" id="msg">
                                        <% String err;
                                            if ((err = request.getParameter("err")) != null)
                                            {
                                                out.println(err);
                                            }%>
                                    </span>        

                                    <input type="submit" value="Submit Test" class="mws-button black" id="submit"/>

                                </div>    


                            </div>

                        </div>                      
                        <div id="test-details-dialog">
                            <div id="test_details">


                            </div>
                        </div>
                        <div id="test-instructions">
                            <div class="mws-dialog-inner">
                                Instructions to take test.
                                <ul>
                                    <li>
                                        Make sure the internet connection will remains. 
                                    </li>
                                </ul>

                            </div>
                        </div>

                    </form>
                </div>
                <div id="test_time"></div>
                <div id="mws-footer">
                    Copyright Your Website 2012. All Rights Reserved.
                </div>
            </div>
            <!-- End Container Wrapper -->

        </div>
        <!-- End Main Wrapper -->

    </body>
</html>
<% }
    else
    {
        String href = application.getRealPath(request.getServletPath());
        href = href.substring(href.lastIndexOf("\\") + 1);
        response.sendRedirect("index.jsp?error=Please Login&href=" + href);
    }
%>
