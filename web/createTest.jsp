<%-- 
    Document   : createTest
    Created on : Feb 26, 2012, 3:37:39 PM
    Author     : Chaitanya
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="pes.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%

    String user_id = request.getParameter("user_id");

    String t_type = request.getParameter("t_type");
    String t_comp = request.getParameter("t_comp");
    String su_sub = request.getParameter("su_sub");
    String[] su_top = new String[30];
    su_top = request.getParameterValues("su_top");

    String nques = request.getParameter("nques");
    String t_neg = request.getParameter("t_neg");
    String t_pass = request.getParameter("t_pass");
    int ttime_h = Integer.parseInt(request.getParameter("ttime_h"));
    int ttime_m = Integer.parseInt(request.getParameter("ttime_m"));
    String t_start = request.getParameter("t_start");
    String t_end = request.getParameter("t_end");

    String[] ques_id = new String[100];
    ques_id = request.getParameterValues("ques_id");
    String test_marks = request.getParameter("test_marks");
    String q_gen = request.getParameter("q_gen");
    String q_count = request.getParameter("q_count");

    out.println("Topic Type : " + t_type + "<br />");
    out.println("Topic Comp : " + t_comp + "<br />");
    out.println("Subject : " + su_sub + "<br />");

    if (su_top != null)
    {
        out.println("Topic : ");
        for (int i = 0; i < su_top.length; i++)
        {
            if (i != 0)
            {
                out.println(",");
            }

            out.println(su_top[i]);
        }
    }

    int t_time = (ttime_h * 60) + ttime_m;




    Db db = new Db();
    Connection conn = db.getConnection();
    Statement st = conn.createStatement();

    //java.util.Date c_date = new java.util.Date();
    DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
    String c_date = df.format(new java.util.Date());
    String query = "insert into tests(c_id,test_type,test_comp,t_time,c_date,s_date,e_date,nques,t_pass,t_marks,t_neg) values('" + user_id + "','" + t_type + "','" + t_comp + "'," + t_time + ",'" + c_date + "','" + t_start + "','" + t_end + "'," + nques + "," + t_pass + "," + test_marks + "," + t_neg + ");";
    out.println(query);



%>

