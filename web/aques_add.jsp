<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="pes.Db"%>
<%
    if (session.getAttribute("user_name") != null)
    {
        String uname = session.getAttribute("user_name").toString();
        String utype = session.getAttribute("user_type").toString();
        if (!utype.equals("admin"))
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
                //$(".chzn-select").chosen(); 
                $("#add_ques").validate({
                    
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
                    },
                    submitHandler : function(form){
                        $("#msg").hide();
                        $("#mws-validate-error").hide();
                        jQuery(form).ajaxSubmit({
                            
                            success:function(res,status,xhr,$form){
                                
                                if(status == "success")
                                {
                                    $("#msg").html(res).show();
                                    //alert($("#msg").html());
                                    $("#add_ques .ques").clearFields();
                                    
                                }
                                
                            }
                        });
                        
                    }
                   
                    
                });
                
                $("#su_dept").change(function(){subject_load()});
                
                $("#su_sub").change(function(){
                    
                    sid = $(this).val();
                    
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
                                $("#su_top").fadeIn(300);
                                $("#su_top").removeAttr("disabled");
                                
                            }
                        });
                    }
                });
                
                $("#q_opt").change(function(){
                    
                    nopt = $(this).val();
                    $(".option-d").fadeOut(200).find(".mws-textinput").attr("disabled","disabled");
                    $("#q_ans").find("option[value='']").attr("selected","selected");
                    for(i=3; i<=5; i++)
                        $("#q_ans").find("option[value="+i+"]").attr("disabled","disabled");
                    if(nopt > 2)
                    {
                        for(i=3; i<=nopt; i++)
                        {   
                            $("#div_o_"+i).fadeIn(200).find(".mws-textinput").removeAttr("disabled");
                            
                            $("#q_ans").find("option[value="+i+"]").removeAttr("disabled");
                            $("#q_ans").trigger("liszt:updated"); 
                            
                        }
                    }
                });
                
                
            });
            
            function subject_load()
            {
                su_dept = $("#su_dept").val();
                
                
                
                if(su_dept != "")
                {
                    $("#su_sub").fadeOut(300);
                    $("#su_sub").load('LoadSelects?subject=1&dept='+su_dept,function(response, status, xhr){
                        if(status == "success")
                        {
                                
                            $("#su_sub").fadeIn(300);
                            $("#su_sub").removeAttr("disabled");
                        }
                    });
                }
                else
                {
                    $("#su_sub").html("<option value=''>- Subject -</option>");
                    $("#su_sub").attr("disabled","disabled");
                    
                    $("#su_top").html("<option value=''>- Topic -</option>");
                    $("#su_top").attr("disabled","disabled");
                }
                
            }
        
           

               
   
        </script>



        <title>performance Evaluation System - Admin Page</title>

    </head>

    <body>

        <!-- Themer -->  
       
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
                        <li><a href="admin.jsp" class="mws-i-24 i-home">Dashboard</a></li>
                        <li><a href="#" class="mws-i-24 i-users-2">User Management</a>
                            <ul class="closed">
                                <li><a href="astaffm_view.jsp">View Users</a></li>
                                <li><a href="astaffm_add.jsp">Add User</a></li>
                            </ul>

                        </li>
                        <li><a href="#" class="mws-i-24 i-flag">Subject Allocation</a>
                            <ul class="closed">
                                <li><a href="asub_alloc.jsp">Subject Allocation</a></li>
                                <li><a href="asub_dealloc.jsp">Subject Deallocation</a></li>
                            </ul>
                        </li>
                        <li><a href="#" class="mws-i-24 i-excel-documents-1">Course Management</a>
                            <ul class="closed">
                                <li><a href="acourse_view.jsp">View Course</a></li>
                                <li><a href="acourse_add.jsp">Add Course</a></li>
                            </ul>
                        </li>
                        <li class="active"><a href="#" class="mws-i-24 i-excel-documents-1">Question Bank</a>
                            <ul>
                                <li class="active"><a href="aques_add.jsp">Add Questions</a></li>
                            </ul>
                        </li>

                    </ul>
                </div>
                <!-- End Navigation -->

            </div>


            <!-- Container Wrapper -->
            <div id="mws-container" class="clearfix">

                <div class="container">

                    <div class="mws-panel grid_8">
                        <div class="mws-panel-header">
                            <span class="mws-i-24 i-table-1">Add Questions</span>
                        </div>
                        <div class="mws-panel-body">
                            <form class="mws-form" action="AddQues" method="post" id="add_ques">
                                <div id="mws-validate-error" class="mws-form-message error" style="display:none;"></div>
                                <div class="mws-form-inline">
                                    <div class="mws-form-row">

                                        <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Select Subject</legend>
                                            <div class="mws-form-row">
                                                <label>Select Department<span class="required">*</span></label>
                                                <div class="mws-form-item small">

                                                    <select class="required" name="su_dept" id="su_dept">
                                                        <option value="">- Department -</option>
                                                        <%
                                                            try
                                                            {
                                                                String query;
                                                                Db d = new Db();
                                                                conn = d.getConnection();
                                                                st = conn.createStatement();
                                                                query = "select * from departments";
                                                                rs = st.executeQuery(query);
                                                                while (rs.next())
                                                                {
                                                                    String dept_id = rs.getString("dept_id");
                                                                    String dept_name = rs.getString("dept_name");

                                                                    out.println("<option value=" + dept_id + ">" + dept_name + "</option>");

                                                                }
                                                            }
                                                            catch (Exception e)
                                                            {
                                                            }
                                                 %>
                                                    </select>

                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>Select Subject<span class="required">*</span></label>
                                                <div class="mws-form-item small">

                                                    <select class="required" disabled="disabled" name="su_sub" id="su_sub">
                                                        <option value="">- Subject -</option>

                                                    </select>

                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>Select Topic<span class="required">*</span></label>
                                                <div class="mws-form-item small">

                                                    <select class="required" disabled="disabled" name="su_top" id="su_top">
                                                        <option value="">- Topic -</option>
                                                    </select>

                                                </div>
                                            </div>
                                        </fieldset>
                                        <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Question Details</legend>

                                            <div class="mws-form-row">
                                                <label>Question Type<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <select class="required" name="q_comp" id="q_comp">
                                                        <option value="">- Question Complexity -</option>
                                                        <option value="Simple">Simple</option>
                                                        <option value="Medium">Medium</option>
                                                        <option value="Hard">Hard</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>No of Options<span class="required">*</span></label>

                                                <div class="mws-form-item medium">
                                                    <select class="required" name="q_opt" id="q_opt">
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mws-form-row">
                                                <label>Marks<span class="required">*</span></label>

                                                <div class="mws-form-item medium">
                                                    <select class="required" name="q_marks" id="q_marks">
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </fieldset>


                                    </div>
                                    <div class="mws-form-row"><fieldset class="mws-panel-body grid_8" style="border-top:  1px solid #bcbcbc;"><legend>Question</legend>

                                            <div class="mws-form-row">
                                                <label>Question<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <textarea class="ques required" id="q_ques" name="q_ques"></textarea>
                                                </div>
                                            </div>
                                            <div class="mws-form-row option"  id="div_o_1">
                                                <label>Option 1<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <input type="text" class="mws-textinput required ques" id="q_op1" name="q_op1" placeholder="Option 1" />
                                                </div>
                                            </div>
                                            <div class="mws-form-row option" id="div_o_2">
                                                <label>Option 2<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <input type="text" class="mws-textinput ques required" placeholder="Option 2" id="q_op2" name="q_op2"/>
                                                </div>
                                            </div>
                                            <div class="mws-form-row option option-d" id="div_o_3" style="display:none;">
                                                <label>Option 3<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <input type="text" class="mws-textinput ques required" placeholder="Option 3" disabled="disabled" id="q_op3" name="q_op3"/>
                                                </div>
                                            </div>
                                            <div class="mws-form-row option option-d" id="div_o_4" style="display:none;">
                                                <label>Option 4<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <input type="text" class="mws-textinput ques required" placeholder="Option 4" disabled="disabled" id="q_op4" name="q_op4"/>
                                                </div>
                                            </div>
                                            <div class="mws-form-row option option-d" id="div_o_5" style="display:none;">
                                                <label>Option 5<span class="required">*</span></label>
                                                <div class="mws-form-item medium">
                                                    <input type="text" class="mws-textinput ques required" placeholder="Option 5" disabled="disabled" id="q_op5" name="q_op5"/>
                                                </div>
                                            </div>

                                            <div class="mws-form-row">
                                                <label>Correct Answer<span class="required">*</span></label>

                                                <div class="mws-form-item medium">
                                                    <select class="required ques" name="q_ans" id="q_ans">
                                                        <option value="">- Answer -</option>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3" disabled>3</option>
                                                        <option value="4" disabled>4</option>
                                                        <option value="5" disabled>5</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>
                                    <div class="mws-form-message success" id="msg" style="display: none;"></div>
                                    <div class="mws-button-row">

                                        <input type="reset" value="Reset" id="form_reset" class="mws-button red"/>
                                        <span class="grid_3" style="color: red;">
                                            <% String err;
                                                if ((err = request.getParameter("err")) != null)
                                                {
                                                    out.println(err);
                                                }%>
                                        </span>        

                                        <input type="submit" value="Add Question" class="mws-button black" />

                                    </div>

                                </div>
                            </form>
                        </div>
                    </div>

                </div>



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