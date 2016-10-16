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
                        
                $("#sub").change(function(){
                   
                    var subid = $(this).val();
                    
                    if(subid == "")
                    {
                        $("#st_per").html('');}
                    else
                    {
                        $("#st_per").load("getPerformance.jsp?subid="+subid,function(res,status,xhr){
                            //alert(res);
                        });
                    
                    }
            });
                
                
           
        });
   
        </script>



        <title>performance Evaluation System - Admin Page</title>

    </head>

    <body>

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
                                }%>
                        </div>
                        <ul>
                            <li><a href="#">Profile</a></li>
                            <li><a href="#">Change Password</a></li>
                            <li><a href="Logout">Logout</a></li>
                        </ul>
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
                        <li><a href="#" class="mws-i-24 i-users-2">Test Management</a>
                            <ul class="closed">
                                <li><a href="stest_create.jsp">Create Test</a></li>
                                <li><a href="stest_view.jsp">View Tests</a></li>
                            </ul>
                        </li>
                        <li class="active"><a href="#" class="mws-i-24 i-users-2">Student Stats</a>
                            <ul>
                                <li class="active"><a href="sstudents_view.jsp">Subject Wise</a></li>
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
                    <div class="mws-panel grid_8 mws-collapsible">

                        <div class="mws-panel-header">
                            <span class="mws-i-24 i-list">Select Subject</span>
                        </div>
                        <div class="mws-panel-body">
                            <form class="mws-form" action="" method="post" id="adduser">

                                <div class="mws-form-inline">
                                    <div class="mws-form-row">
                                        <label>Subjects<span class="required">*</span></label>
                                        <div class="mws-form-item small">
                                            <select name="sub" id="sub" class="required">
                                                <option value="" >- Select -</option>
                                                <%
                                                    conn = db.getConnection();

                                                    Statement st1 = conn.createStatement();

                                                    String query = "select s.sub_id,s.subject_name,s.subject_short from staff_sub ss, subjects_dept s where ss.sub_id = s.sub_id and ss.aod = 1 and ss.user_id= '" + uname + "'";
                                                    ResultSet rs1 = st.executeQuery(query);

                                                    while (rs1.next())
                                                    {
                                                        String subid = rs1.getString("sub_id");
                                                        String sub_name = rs1.getString("subject_name");
                                                        String sub_short = rs1.getString("subject_short");
                                                        out.println("<option value='" + subid + "'>(" + sub_short + ") " + sub_name + "</option>");
                                                    }
                                                    conn.close();

                                                %>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                            </form>
                        </div>  
                    </div>

                    <div id="st_per">

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
        response.sendRedirect("index.jsp?error=Please Login");
    }
%>