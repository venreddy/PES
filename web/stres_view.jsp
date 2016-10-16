<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="pes.Db"%>
<%
    if (session.getAttribute("user_name") != null)
    {
        String uname = session.getAttribute("user_name").toString();
        String utype = session.getAttribute("user_type").toString();
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
        <script>
            $(document).ready(function(){
                $("#test").countdown({until:+10});
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
                        <li><a href="#" class="mws-i-24 i-users-2">Tests</a>
                            <ul class="closed">
                                <li><a href="sttest_view.jsp">View Tests</a></li>
                                <li><a href="sttest_take.jsp">Take Tests</a></li>
                            </ul>
                        </li>
                        <li class="active"><a href="#" class="mws-i-24 i-users-2">Results</a>
                            <ul>
                                <li class="active"><a href="stres_view.jsp">View Results</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <!-- End Navigation -->
            </div>
            <!-- Container Wrapper -->

            <div id="mws-container" class="clearfix">

                <!-- Inner Container Start -->
                <div class="container">

                    <!-- Statistics Button Container -->
                    <div class="mws-panel grid_8 mws-collapsible">
                        <div class="mws-panel-header">
                            <span class="mws-i-24 i-table-1">Results of Tests Attended</span>
                        </div>
                        <div class="mws-panel-body">
                            <table class="mws-datatable-fn mws-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Test Name</th>
                                        <th>Test Subject</th>
                                        <th>Correct Ques</th>
                                        <th>Incorrect Ques</th>
                                        <th>Unattended Ques</th>
                                        <th>Total Marks</th>
                                        <th>Result</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%

                                        Connection c = db.getConnection();

                                        Statement st1 = c.createStatement();
                                        String query = "select r.*,t.t_name,s.subject_name,s.sub_id from results r,tests t,subjects_dept s where r.test_id = t.test_id and t.t_sub = s.sub_id and r.completed =1 and user_id = '" + uname + "' order by r.test_ended desc";
                                        ResultSet rs1 = st1.executeQuery(query);
                                        int slno = 1;
                                        while (rs1.next())
                                        {
                                            String t_name = rs1.getString("t_name");
                                            String t_sub = rs1.getString("subject_name");
                                            String c_ques = rs1.getString("c_ques");
                                            String w_ques = rs1.getString("w_ques");
                                            String ua_ques = rs1.getString("ua_ques");
                                            String tot_marks = rs1.getString("tot_marks");
                                            boolean pass = rs1.getBoolean("pass");
                                            String res = "";
                                            if (pass)
                                            {
                                                res = "Pass";
                                            }
                                            else
                                            {
                                                res = "Fail";
                                            }
                                            out.println("<tr><td>"+(slno++)+"</td><td>" + t_name + "</td><td>" + t_sub + "</td><td>" + c_ques + "</td><td>" + w_ques + "</td><td>" + ua_ques + "</td><td>" + tot_marks + "</td><td>" + res + "</td>");
                                            //out.println("<td><a href='astaffm_edit.jsp?uid=" + uid + "'>Edit</a></td></tr>");


                                        }
                                        conn.close();

                                    %>

                                </tbody>
                            </table>
                        </div>
                    </div>
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