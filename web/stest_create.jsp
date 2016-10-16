<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="pes.Db"%>
<%
    if (session.getAttribute("user_name") != null)
    {
        String uname = session.getAttribute("user_name").toString();
        String utype = session.getAttribute("user_type").toString();
        if (!utype.equals("staff"))
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
        <script>
    
            $(document).ready(function(){
                
                generate_testid();
                
                $('#q_get_t,#q_get_b').bind('click', function(e) {
                    
                    // t_type=Multiple+Topic&t_comp=m&su_sub=10&su_top=&nques=0&t_neg=0&t_pass=0&ttime_h=0&ttime_m=0&t_start=&t_end=
                    generate_ques(true);
                    return false;
                });
                
                
            $('#sh_opt_t,#sh_opt_b').click( function() {
                        
                $('.options').toggle('200');
                if ($('#sh_opt_t').html() == "Show Options" ) {
                    $('#sh_opt_t,#sh_opt_b').html('Hide Options')
                            
                } else {
                    $('#sh_opt_t,#sh_opt_b').html('Show Options') 
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
                
                
               
               
            $( "#t_start,#t_end" ).datepicker({
                    
                changeMonth : true,
                changeYear : true,
                dateFormat : "yy-mm-dd",
                minDate : 0,
                numberOfMonths: 1
                   
                    
            });
               
                
                
            jQuery.validator.addMethod("greaterThanZero", function(value, element) {
                return this.optional(element) || (parseFloat(value) > 0);
            }, "The value must be > 0");

            $("#createTest").validate({
                    
                rules:{
                        
                    nques : { greaterThanZero : true},
                    t_start : { dpDate:true, dpCompareDate :['before', '#t_end'] , dpCompareDate : 'notBefore today' },
                    t_end: {dpDate:true, dpCompareDate: {notBefore: '#t_start'}},
                    t_name:{remote : 'CheckTestName'}
                },
                messages:{
                        
                    t_name : "The test name already exists"
                        
                },
                
                submitHandler : function(form){
                    var nques = $("#nques").val();
                    var q_count = $("#ques_count").val();
                    if((nques != q_count) || (q_count == null))
                    {
                        generate_ques(false);
                        alert("All questions are not generated. Please submit the form again ");
                    }
                    else
                    {
                        $("#ajaxcreateload").show();
                        $("#msg1").hide();
                        $("#submit").attr("disabled","disabled");
                    
                        jQuery(form).ajaxSubmit({
                        
                            success : function(res,status,xhr,$form){
                                if(status == "success")
                                {
                                    $("#ajaxcreateload").hide();
                                    $("#msg1").show().html(res);
                                    $("#submit").removeAttr("disabled");
                                    generate_testid();
                                    $("#ques_div").html('');
                                }
                            }
                        });
                        
                    }
                        
                },
                    
                invalidHandler: function(form, validator) {
                    var errors = validator.numberOfInvalids();
                    if (errors) {
                        var message = errors == 1
                            ? 'You missed 1 field. It has been highlighted'
                        : 'You missed ' + errors + ' fields. They have been highlighted';
                        $("#mws-validate-error").html(message).show();
                    } else {
                        $("#mws-validate-error").hide();
                    }
                }
                   
                   
                    
            });
                
                
                
                
            $("#ttime_h").spinner({min:0, max:3});
            $("#ttime_m").spinner({min:0,max:59});
            $("#nques").spinner({min:0, max:100 });
            $("#t_pass").spinner({min:0,max:100});
                
            $('#nques').bind('change', function(event, ui) {
                generate_ques(false);
            });
                
            $("#su_sub").change(function(){
                    
                if(topic)
                {
                    topic_load();
                }
                generate_ques(false);
            });
                
            $("#t_comp,#su_top").change(function(){generate_ques(false);});
               
            //$("#t_type").val() = "";
            $("#t_type").change(function(){
                    
                ttype = $(this).val();
                //alert(ttype);    
                if(ttype == "")
                {
                    $("#su_sub").val("");
                    topic_load();
                    $("#su_sub").attr("disabled","disabled");
                    $("#su_top").attr("disabled","disabled");
                    $("#su_top_d").fadeOut(300);
                }
                else if(ttype == "Subject")
                {
                    topic = false;
                    $("#su_sub").removeAttr("disabled");
                    $("#su_top").attr("disabled", "disabled").removeAttr("multiple");
                    $("#su_top_d").fadeOut(300);
                        
                }    
                else if(ttype == "Topic")
                {
                    topic = true;
                    $("#su_top_d").fadeIn(300);
                    $("#su_sub").removeAttr("disabled");
                    $("#su_top").removeAttr("multiple");
                    topic_load();
                       
                }
                else if(ttype == "Multiple Topic")
                {
                    topic = true;
                    $("#su_top_d").fadeIn(300);
                    $("#su_sub").removeAttr("disabled");
                    $("#su_top").attr("multiple","multiple");
                    $("#su_top").find("option[value='']").attr("selected","selected");
                    topic_load();
                       
                }
                generate_ques(false)
                
            });
                
                
           
        });
            
        function topic_load()
        {
            sid = $("#su_sub").val();
                    
            if(sid == "")
            {
                            
                $("#su_top").html("<option value=''>- Topic -</option>");
                $("#su_top").attr("disabled","disabled");
            }
            else
            {
                $("#su_top").fadeOut(300);
                $("#su_top").load('LoadSelects?subject=1&su_sid='+sid,function(response, status, xhr){
                    //alert(response);
                    if(status == "success")
                    {
                        //alert(response);
                        $("#su_top").fadeIn(300);
                        $("#su_top").removeAttr("disabled");
                                
                    }
                });
            }
        }
            
        function generate_testid()
        {
            //tid = $("#test_id");
            $.ajax({
                url: 'GetFunc?tid=1',
                success: function(data) {
                    $("#test_id").val(data);
                    //alert($("#test_id").val());
                }
            });
                
        }
            
        function generate_ques(alt)
        {
                    
            $("#ques_div").html('');
                    
            t_type = $("#t_type").val();
            t_comp = $("#t_comp").val();
            su_sub = $("#su_sub").val();
            su_top = $("#su_top").val();
            nques = $("#nques").val();
                    
            t_type_e = false;
            t_comp_e = false;
            su_sub_e = false;
            su_top_e = false;
            nques_e = false;
                    
            if(t_type == "")
            {
                t_type_e = true;
            }
            else if(t_type == "Subject")
            {
                if(su_sub == "")
                    su_sub_e = true;
                        
            }
            else if(t_type == "Topic")
            {
                if(su_sub == ""){
                    su_sub_e =true;
                }
                else if(su_top == "")
                    su_top_e = true;
                        
            }
            else if(t_type == "Multiple Topic")
            {
                if(su_sub == "")
                    su_sub_e = true;
                else if(su_top == "" || su_top == null)
                    su_top_e = true;
                        
            }
                    
            if(t_comp == "") t_comp_e = true;
            if(nques == "" || nques == 0) nques_e = true;
                    
            if(t_type_e || t_comp_e || nques_e || su_top_e || su_sub_e)
            {
                if(alt)
                {
                    str = "Please Select : \n"+((t_type_e)?'Topic Type \n':'')+((su_sub_e)?'Subject \n':'')+((su_top_e)?'Topic \n':'')+((t_comp_e)?'Topic Complexity \n':'')+((nques_e)?'No of Questions \n':'')+""; 
                    alert(str);
                }
                else
                {
                    str = "Please Select : <b><br />"+((t_type_e)?'Topic Type <br />':'')+((su_sub_e)?'Subject <br />':'')+((su_top_e)?'Topic <br />':'')+((t_comp_e)?'Topic Complexity <br />':'')+((nques_e)?'No of Questions <br />':'')+"</b>"; 
                    $("#ques_div").html(str);
                }
            }
            else
            {
                str = $("#createTest").serialize();
                //alert(str);
                    
                $("#ques_div").fadeOut(100,function(){
                    $("#ajaxload").show();
                    $("#ques_div").load("getQues.jsp?"+str,function(response,status,xhr){
                        //alert(response);
                        if(status == "success"){
                            $("#ajaxload").hide();
                            $("#sh_opt_t,#sh_opt_b").html("Hide Options");
                            $("#sh_pro_t,#sh_pro_b").html("Hide Properties");
                            $("#sh_opt_t,#sh_opt_b, #sh_pro_t,#sh_pro_b").addClass("ic-minus").removeClass("ic-add");
                                
                            $("#ques_div").fadeIn(300);
                        }
                    });
                });
            }
        }
            
        </script>



        <title>performance Evaluation System - Admin Page</title>

    </head>

    <body>

        <!-- Header Wrapper -->
        <div id="mws-header" class="clearfix">

            <!-- Logo Wrapper -->
            <div id="mws-logo-container">
                <div id="mws-logo-wrap">
                    <img src="images/mws-logo.png" alt="Admin" />
                </div>
            </div>

            <!-- User Area Wrapper -->
            <div id="mws-user-tools" class="clearfix">

                <!-- User Notifications -->


                <!-- User Messages -->




                <!-- User Functions -->
                <div id="mws-user-info" class="mws-inset">
                    <div id="mws-user-photo">
                        <img src="example/profile.jpg" alt="User Photo" />
                    </div>
                    <div id="mws-user-functions">
                        <div id="mws-username">




                            Hello, <% if (rs.next())
                                {
                                    out.println(rs.getString("name"));
                                }%>
                        </div>
                        <ul>
                            <li><a href="#">Profile</a></li>
                            <li><a href="#" id="change-pwd">Change Password</a></li>
                            <li><a href="Logout">Logout</a></li>
                        </ul>
                        <%@include file="changePwd.jsp" %>
                    </div>
                </div>
                <!-- End User Functions -->

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
                        <li><a href="staff.jsp" class="mws-i-24 i-home">Dashboard</a></li>
                        <li><a href="#" class="mws-i-24 i-users-2">Course Management</a>
                            <ul class="closed">
                                <li><a href="scourse_view.jsp">View Course</a></li>
                                <li><a href="scourse_add.jsp">Add Course</a></li>
                            </ul>
                        </li>
                        <li><a href="#" class="mws-i-24 i-users-2">Question Management</a>
                            <ul class="closed">
                                <li><a href="sques_add.jsp">Add Questions</a></li>
                            </ul>
                        </li>
                        <li class="active"><a href="#" class="mws-i-24 i-users-2">Test Management</a>
                            <ul>
                                <li class="active"><a href="stest_create.jsp">Create Test</a></li>
                                <li><a href="stest_view.jsp">View Tests</a></li>
                            </ul>
                        </li>
                        <li><a href="#" class="mws-i-24 i-users-2">Student Stats</a>
                            <ul class="closed">
                                <li><a href="sstudents_view.jsp">Subject Wise</a></li>
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
                    <form class="mws-form" action="CreateTest" method="get" id="createTest">
                        <div class="mws-panel grid_8 mws-collapsible">

                            <div class="mws-panel-header">
                                <span class="mws-i-24 i-list">Test Details</span>
                            </div>
                            <div class="mws-panel-body">


                                <div class="mws-form-inline">
                                    <div class="mws-form-row">
                                        <label>Test Name<span class="required">*</span></label>
                                        <div class="mws-form-item large">
                                            <input type="text" class="mws-textinput required" id="t_name" name="t_name" />
                                        </div>
                                    </div>
                                    <div class="mws-form-row">
                                        <input type="hidden" value="<%=uname%>" name="user_id" id="user_id" />
                                        <input type="hidden" value="1" name="test_id" id="test_id" />
                                        <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Test Type</legend>
                                            <div class="mws-form-row">
                                                <label>Test Type<span class="required">*</span></label>
                                                <div class="mws-form-item small">
                                                    <select name="t_type" id="t_type" class="required">
                                                        <option value="" >- Select -</option>
                                                        <option value="Subject" > Subject </option>
                                                        <option value="Topic" > Topic </option>
                                                        <option value="Multiple Topic" > Multiple Topic </option>
                                                    </select>
                                                </div>
                                            </div>


                                            <div class="mws-form-row">
                                                <label>Test Complexity<span class="required">*</span></label>
                                                <div class="mws-form-item small">

                                                    <select class="required" name="t_comp" id="t_comp">
                                                        <option value="">- Test Complexity -</option>
                                                        <option value="Simple"> Simple </option>
                                                        <option value="Medium"> Medium </option>
                                                        <option value="Hard"> Hard </option>
                                                    </select>

                                                </div>
                                            </div>
                                        </fieldset>
                                        <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Test Subject</legend>
                                            <div align="center">Select Test type* to select subject</div>
                                            <div class="mws-form-row">
                                                <label>Subjects<span class="required">*</span></label>
                                                <div class="mws-form-item large">
                                                    <select name="su_sub" id="su_sub" class="required" disabled="disabled">
                                                        <option value="" >- Select -</option>
                                                        <%
                                                            conn = db.getConnection();

                                                            st = conn.createStatement();

                                                            String query = "select s.sub_id,s.subject_name,s.subject_short from staff_sub ss, subjects_dept s where ss.sub_id = s.sub_id and ss.aod = 1 and ss.user_id= '" + uname + "'";
                                                            rs = st.executeQuery(query);

                                                            while (rs.next())
                                                            {
                                                                String subid = rs.getString("sub_id");
                                                                String sub_name = rs.getString("subject_name");
                                                                String sub_short = rs.getString("subject_short");

                                                                out.println("<option value='" + subid + "'>(" + sub_short + ") " + sub_name + "</option>");


                                                            }
                                                            conn.close();
                                                        %>
                                                    </select>
                                                </div>
                                            </div>


                                            <div class="mws-form-row" style="display: none;" id="su_top_d">
                                                <label>Select Topic<span class="required">*</span></label>
                                                <div class="mws-form-item large">

                                                    <select class="required" disabled="disabled" name="su_top" id="su_top">
                                                        <option value="" selected="selected">- Topic -</option>
                                                    </select>

                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>
                                    <div class="mws-form-row">
                                        <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Test Stats</legend>
                                            <div class="mws-form-row">
                                                <label>No of Questions<span class="required">*</span></label>
                                                <div class="mws-form-item small">
                                                    <input type="text" class="mws-textinput required" id="nques" name="nques" value="0" title="No of Questions" /> 
                                                </div>
                                            </div>

                                            <div class="mws-form-row">
                                                <label>Test with Negative Marks<span class="required">*</span></label>
                                                <div class="mws-form-item small">

                                                    <select class="required" name="t_neg" id="t_neg" title="Test with -ve marks or not">
                                                        <option value="0">False</option>
                                                        <option value="1">True</option>
                                                    </select>

                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>Test Pass Percentage<span class="required">*</span></label>
                                                <div class="mws-form-item small">
                                                    <input type="text" class="mws-textinput required" id="t_pass" name="t_pass" value="0" title="Pass Percentage" /> 
                                                </div>
                                            </div>
                                        </fieldset>
                                        <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Test Timings</legend>
                                            <div align="center">If Time is Zero => Not Time Bounded</div>
                                            <div align="center">If End Date is NULL => Not Time Bounded</div>
                                            <div class="mws-form-row">
                                                <label>Test Time<span class="required">*</span><br /> Hours & Minutes</label>
                                                <div class="mws-form-item small">
                                                    <input type="text" class="mws-textinput required" id="ttime_h" name="ttime_h" value="0" title="Hours" /> 
                                                </div>
                                                <div class="mws-form-item small">
                                                    <input type="text" class="mws-textinput required" id="ttime_m" name="ttime_m" value="0" title="Minutes" /> 
                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>Test Start Date<span class="required">*</span></label>
                                                <div class="mws-form-item small">
                                                    <input type="text" class="mws-textinput required date" id="t_start" name="t_start" title="Test Start Date (mm/dd/yyy)" /> 
                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>Test End Date<br /> Hours & Minutes</label>
                                                <div class="mws-form-item small">
                                                    <input type="text" class="mws-textinput date" id="t_end" name="t_end" title="Test End Date (mm/dd/yyy)" /> 
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>


                                </div>

                            </div>  
                        </div>

                        <div class="mws-panel grid_8 mws-collapsible">

                            <div class="mws-panel-header">
                                <span class="mws-i-24 i-list">Questions</span>
                            </div>
                            <div class="mws-panel-body">
                                <div class="mws-panel-toolbar top clearfix">
                                    <ul>
                                        <li><a href="#" class="mws-ic-16 ic-arrow-refresh" id="q_get_t">Generate Questions</a></li>
                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_opt_t">Hide Options</a></li>
                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_pro_t">Hide Properties</a></li>

                                    </ul>
                                </div>
                                <div class="mws-form-row">
                                    <div class="ajaxload" id="ajaxload" align="center" style="display: none;">Generating Questions...<br /><img src="images/ajax-loader.gif" /></div>
                                    <div id="ques_div" class="mws-form-row" style="padding: 10px">

                                    </div>
                                </div>
                                <div class="mws-panel-toolbar bottom clearfix">
                                    <ul>
                                        <li><a href="#" class="mws-ic-16 ic-arrow-refresh" id="q_get_b">Generate Questions</a></li>
                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_opt_b">Hide Options</a></li>
                                        <li><a href="#" class="mws-ic-16 ic-minus" id="sh_pro_b">Hide Properties</a></li>

                                    </ul>
                                </div>
                                <div class="mws-button-row">

                                    <input type="reset" value="Reset" id="form_reset" class="mws-button red"/>
                                    <span class="grid_3" style="color: red;" id="msg">
                                        <% String err;
                                            if ((err = request.getParameter("err")) != null)
                                            {
                                                out.println(err);
                                            }%>
                                    </span>        

                                    <input type="submit" value="Create Test" class="mws-button black" id="submit"/>

                                </div>    


                            </div>

                        </div>
                    </form>
                    <div class="mws-panel grid_8 mws-collapsible">

                        <div class="mws-panel-header">
                            <span class="mws-i-24 i-list">Message</span>
                        </div>
                        <div class="mws-panel-body">
                            <div class="mws-panel-content">

                                <div class="ajaxload" id="ajaxcreateload" align="center" style="display: none;">
                                    Creating Test...<br /><img src="images/ajax-loader.gif" />
                                </div>
                                <div id="msg1">

                                </div>

                            </div>


                        </div>

                    </div>
                </div>
                <!-- End Main Container -->

                <!-- Footer -->
                <div id="mws-footer">
                    Copyright Your Website 2012. All Rights Reserved.
                </div>
                <!-- End Footer -->

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