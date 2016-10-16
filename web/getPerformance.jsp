<%-- 
    Document   : getPerformance
    Created on : Apr 7, 2012, 9:31:55 PM
    Author     : Priyanka
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="pes.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    try{
    String subid = request.getParameter("subid");

    Db db = new Db();
    Connection conn = db.getConnection();
    Statement st = conn.createStatement();

    int total = 0, running = 0, ended = 0, upcoming = 0;
    String subName = "", subShort = "", dept = "";
    String query = "select subject_name,subject_short,dept_id from subjects_dept where sub_id = " + subid;
    ResultSet rs = st.executeQuery(query);
    if (rs.next())
    {
        subName = rs.getString("subject_name");
        subShort = rs.getString("subject_short");
        dept = rs.getString("dept_id");
    }
    

    

    query = "select count(*) as Total from tests where t_sub =" + subid;
    rs = st.executeQuery(query);
    if (rs.next())
    {
        total = rs.getInt(1);
    }


    query = "select count(*) as Running from tests where t_sub = " + subid + " and Date(e_date) >= Date(NOW()) and Date(s_date) <= Date(NOW())";
    rs = st.executeQuery(query);
    if (rs.next())
    {
        running = rs.getInt(1);
    }

    query = "select count(*) as Ended from tests where t_sub = " + subid + " and Date(e_date) <= Date(NOW())";
    rs = st.executeQuery(query);
    if (rs.next())
    {
        ended = rs.getInt(1);
    }

    query = "select count(*) as Upcoming from tests where t_sub = " + subid + " and Date(s_date) > Date(NOW())";
    rs = st.executeQuery(query);
    if (rs.next())
    {
        upcoming = rs.getInt(1);
    }


%>
<script>$(".mws-datatable-fn").dataTable({sPaginationType: "full_numbers"});</script>
<div class="mws-report-container clearfix">

    <!-- Statistic Item -->
    <a class="mws-report" href="#">
        <!-- Statistic Icon (edit to change icon) -->
        <span class="mws-report-icon mws-ic ic-clock-go"></span>

        <!-- Statistic Content -->
        <span class="mws-report-content">
            <span class="mws-report-title">Total Tests</span>
            <span class="mws-report-value"><%=total%></span>
        </span>
    </a>

    <a class="mws-report" href="#">
        <!-- Statistic Icon (edit to change icon) -->
        <span class="mws-report-icon mws-ic ic-clock-go"></span>

        <!-- Statistic Content -->
        <span class="mws-report-content">
            <span class="mws-report-title">Running Tests</span>
            <span class="mws-report-value"><%=running%></span>
        </span>
    </a>

    <a class="mws-report" href="#">
        <!-- Statistic Icon (edit to change icon) -->
        <span class="mws-report-icon mws-ic ic-clock-link"></span>

        <!-- Statistic Content -->
        <span class="mws-report-content">
            <span class="mws-report-title">Ended Tests</span>
            <span class="mws-report-value"><%=ended%></span>
        </span>
    </a>

    <a class="mws-report" href="#">
        <!-- Statistic Icon (edit to change icon) -->
        <span class="mws-report-icon mws-ic ic-clock-link"></span>

        <!-- Statistic Content -->
        <span class="mws-report-content">
            <span class="mws-report-title">UpComing Tests</span>
            <span class="mws-report-value"><%=upcoming%></span>
        </span>
    </a>

    <div class="mws-panel grid_8 mws-collapsible">
        <div class="mws-panel-header">
            <span class="mws-i-24 i-table-1">Student's Stats on "<%=subName%> (<%=subShort%>)"</span>
        </div>
        <div class="mws-panel-body">
            <table class="mws-datatable-fn mws-table">
                <thead>
                    <tr>
                        <th>User Id</th>
                        <th>Name</th>
                        <th>Tests Attended</th>
                        <th>Tests Passed</th>
                        <th>Pass Percentage</th>
                    </tr>
                </thead>
                <tbody>
                    <%

                        conn = db.getConnection();

                        Statement st1 = conn.createStatement();
                        query = "select u.user_id,u.name from student s, users u where u.user_type_id = 3 and s.user_id = u.user_id and u.dept_id = " + dept;
                        ResultSet r = st1.executeQuery(query);
                        while (r.next())
                        {
                            String uid = r.getString("user_id");
                            String name = r.getString("name");
                            int pass =0,tot = 0;
                            query = "select count(*) from results r,tests t where r.user_id='"+uid+"' and r.test_id = t.test_id and t.t_sub = "+subid+" and r.pass = 1";
                            ResultSet rs1 = st.executeQuery(query);
                            if(rs1.next())
                                pass = rs1.getInt(1);
                            
                            query = "select count(*) from results r,tests t where r.user_id='"+uid+"' and r.test_id = t.test_id and t.t_sub = "+subid;
                            rs1 = st.executeQuery(query);
                            if(rs1.next())
                                tot = rs1.getInt(1);
                            float per;
                            if(tot == 0)
                                per = 0;
                            else 
                                per = ((float)pass/tot) * 100;
                            
                            
                            out.println("<tr><td>" + uid + "</td><td>" + name + "</td><td>" + tot + "</td><td>" + pass + "</td><td>" + per + " %</td>");
                            
                        }
                        conn.close();

                    %>

                </tbody>
            </table>
        </div>
    </div>

</div>
<%
    }catch(Exception e)
    {
        e.printStackTrace();
        out.println(e.toString());
    }
%>