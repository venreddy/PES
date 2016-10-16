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

        String year = session.getAttribute("year").toString();
        String pod = session.getAttribute("pod").toString();
        Db db = new Db();

        Connection conn = db.getConnection();

        Statement st = conn.createStatement();

        ResultSet rs = st.executeQuery("select * from users where user_id='" + uname + "'");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <%@include file="css_js.jsp" %>

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
                        <li class="active"><a href="student.jsp" class="mws-i-24 i-home">Dashboard</a></li>
                        <li><a href="#" class="mws-i-24 i-users-2">Tests</a>
                            <ul class="closed">
                                <li><a href="sttest_view.jsp">View Tests</a></li>
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

                <!-- Inner Container Start -->
                <div class="container">

                    <!-- Statistics Button Container -->
                    <div class="mws-report-container clearfix">

                        <!-- Statistic Item -->
                        <a class="mws-report" href="#">
                            <!-- Statistic Icon (edit to change icon) -->
                            <span class="mws-report-icon mws-ic ic-pencil-go"></span>

                            <!-- Statistic Content -->
                            <span class="mws-report-content">
                                <span class="mws-report-title">Unattended Tests</span>
                                <span class="mws-report-value">

                                    <%

                                        Connection c = db.getConnection();
                                        Statement st1 = c.createStatement();
                                        String query = "select count(*) as available from tests t,subjects_dept s where Date(t.s_date) <= Date(NOW()) and (t.e_date is NULL or Date(t.e_date) >= Date(NOW())) and t.test_id not in (select r.test_id from results r where r.completed = 1 and r.user_id = '" + uname + "') and t.t_sub = s.sub_id";

                                        ResultSet rs1 = st1.executeQuery(query);
                                        if (rs1.next())
                                        {
                                            out.println(rs1.getString("available"));
                                        }
                                        c.close();
                                        rs1.close();
                                    %>

                                </span>
                            </span>
                        </a>

                        <a class="mws-report" href="#">
                            <!-- Statistic Icon (edit to change icon) -->
                            <span class="mws-report-icon mws-ic ic-clock-go"></span>

                            <!-- Statistic Content -->
                            <span class="mws-report-content">
                                <span class="mws-report-title">Tests Started Today</span>
                                <span class="mws-report-value">
                                    <%
                                        c = db.getConnection();
                                        st1 = c.createStatement();
                                        query = "select count(*) as available from tests t,subjects_dept s where Date(t.s_date) = Date(NOW()) and t.t_sub = s.sub_id";

                                        rs1 = st1.executeQuery(query);
                                        if (rs1.next())
                                        {
                                            out.println(rs1.getString("available"));
                                        }
                                        c.close();
                                        rs1.close();
                                    %>
                                </span>
                            </span>
                        </a>
                        <a class="mws-report" href="#">
                            <!-- Statistic Icon (edit to change icon) -->
                            <span class="mws-report-icon mws-ic ic-clock-link"></span>
                            <!-- Statistic Content -->
                            <span class="mws-report-content">
                                <span class="mws-report-title">Tests End Today</span>
                                <span class="mws-report-value">
                                    <%
                                        c = db.getConnection();
                                        st1 = c.createStatement();
                                        query = "select count(*) as available from tests t,subjects_dept s where Date(t.e_date) = Date(NOW()) and t.t_sub = s.sub_id";

                                        rs1 = st1.executeQuery(query);
                                        if (rs1.next())
                                        {
                                            out.println(rs1.getString("available"));
                                        }
                                        c.close();
                                        rs1.close();
                                    %>
                                </span>
                            </span>
                        </a>
                        <a class="mws-report" href="#">
                            <!-- Statistic Icon (edit to change icon) -->
                            <span class="mws-report-icon mws-ic ic-thumb-up"></span>
                            <!-- Statistic Content -->
                            <span class="mws-report-content">
                                <span class="mws-report-title">Tests Passed</span>
                                <span class="mws-report-value">
                                    <%
                                        c = db.getConnection();
                                        st1 = c.createStatement();
                                        query = "select count(*) as passed from results where user_id='" + uname + "' and pass = 1 and completed = 1";

                                        rs1 = st1.executeQuery(query);
                                        if (rs1.next())
                                        {
                                            out.println(rs1.getString("passed"));
                                        }
                                        c.close();
                                        rs1.close();
                                    %>
                                </span>
                            </span>
                        </a>
                        <a class="mws-report" href="#">
                            <!-- Statistic Icon (edit to change icon) -->
                            <span class="mws-report-icon mws-ic ic-tick"></span>
                            <!-- Statistic Content -->
                            <span class="mws-report-content">
                                <span class="mws-report-title">Tests Attended</span>
                                <span class="mws-report-value">
                                    <%
                                        c = db.getConnection();
                                        st1 = c.createStatement();
                                        query = "select count(*) as attended from results where user_id='" + uname + "' and completed = 1";

                                        rs1 = st1.executeQuery(query);
                                        if (rs1.next())
                                        {
                                            out.println(rs1.getString("attended"));
                                        }
                                        c.close();
                                        rs1.close();
                                    %>
                                </span>
                            </span>
                        </a>
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