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
        if (dept.length() == 1)
        {
            dept = "0" + dept;
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

        </style>
        <script>
            
            $(document).ready(function(){
                
                
                
                
                $("#subject").change(function(){
                    
                    sid = $(this).val();
                    
                    if(sid == "")
                    {
                        $("#test_name").html("<option value=''>- Select Test -</option>").attr("disabled","disabled");
                        
                        $("#test_details").slideUp(100).html("");
                    }
                    else
                    {
                        $("#test_name").load('LoadSelectsSt?sid='+sid,function(res,status,xhr){
                            if(status == "success")
                            {  
                                $("#test_name").removeAttr("disabled");
                            }
                            
                        });
                        
                    }
                });
                
                $("#test_name").change(function(){
                    
                    tid = $(this).val();
                    
                    if(tid == "")
                    {
                        $("#test_details").slideUp(100).html("");
                    }
                    else
                    {
                        $("#test_details_panel").removeClass("mws-collapsed");
                        
                        $("#test_details").slideUp(100,function(){
                            
                            $("#ajaxload").show();
                            $("#test_details").load('getTestDetails.jsp?tid='+tid,function(res,status,xhr){
                                
                                if(status == "success")
                                {  
                                    //alert(res);
                                    $("#ajaxload").hide();
                                    $("#test_details").slideDown(100);
                                }
                            
                            });
                        });
                    }
                });
                
                
            });
            
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
                        <li><a href="student.jsp" class="mws-i-24 i-home">Dashboard</a></li>
                        <li class="active"><a href="#" class="mws-i-24 i-users-2">Tests</a>
                            <ul>
                                <li class="active"><a href="sttest_view.jsp">View Tests</a></li>
                                <li><a href="sttest_take.jsp">Take Tests</a></li>
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
                    <form class="mws-form" action="CreateTest" method="get" id="createTest">
                        <div class="mws-panel grid_8 mws-collapsible">

                            <div class="mws-panel-header">
                                <span class="mws-i-24 i-list">Select Test</span>
                            </div>
                            <div class="mws-panel-body">
                                <div class="mws-form-inline">
                                    <div class="mws-form-row">
                                        <label>Select Subject<span class="required">*</span></label>
                                        <div class="mws-form-item">
                                            <select class="required" name ="subject" id="subject">
                                                <option value="">- Select Subject -</option>
                                                <%
                                                    String query = "select sub_id,subject_short,subject_name from subjects_dept where sub_id = su_id and dept_id = " + session.getAttribute("dept").toString();
                                                    Connection c = db.getConnection();
                                                    Statement st1 = c.createStatement();
                                                    ResultSet r = st1.executeQuery(query);
                                                    while (r.next())
                                                    {
                                                        String sid = r.getString("sub_id");
                                                        String scode = r.getString("subject_short");
                                                        String sname = r.getString("subject_name");
                                                        out.println("<option value='" + sid + "'>(" + scode + ") " + sname + "</option>");
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mws-form-row">
                                        <label>Select Test<span class="required">*</span></label>
                                        <div class="mws-form-item">
                                            <select class="required" name ="tes_namet" id="test_name" disabled="disabled">
                                                <option value="">- Select test -</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="mws-panel grid_8 mws-collapsible" id="test_details_panel">

                            <div class="mws-panel-header">
                                <span class="mws-i-24 i-list">Test Details <img src="images/ajax-load-small.gif" id="ajaxload" style="display: none;" /> </span>
                            </div>
                            <div class="mws-panel-body">
                                <div class="mws-panel-content" id="test_details">

                                </div>
                            </div>
                        </div>
                    </form>
                </div>
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
        response.sendRedirect("index.jsp?error=Please Login");
    }
%>