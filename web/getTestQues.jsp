<%-- 
    Document   : getQues
    Created on : Feb 23, 2012, 7:14:14 AM
    Author     : Chaitanya
--%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="pes.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String tid = request.getParameter("tid");
    String uname = session.getAttribute("user_name").toString();

    Db db = new Db();
    Connection conn = db.getConnection();
    Statement st = conn.createStatement();
    DateFormat dtf = new SimpleDateFormat("yyyy-MM-dd HH:mm:s");
    String start_time = dtf.format(new java.util.Date());


    String query = "select * from results where user_id ='" + uname + "' and test_id=" + tid;
    ResultSet rs = st.executeQuery(query);
    if (rs.next()) {
        query = "update results set tot_marks = 0, c_ques = 0, w_ques = 0, ua_ques = 0, pass = 0,completed = 1 where user_id ='" + uname + "' and test_id=" + tid;
        st.executeUpdate(query);
        
        out.println("You have already once taken this test and exited without submitting<br />You cannot take this test once again");
        
    } else {
        query = "insert into results(user_id,test_id,test_started) values('" + uname + "'," + tid + ",'" + start_time + "')";
        st.executeUpdate(query);
%>    

<ol class="questions">
    <%

        // t_type=Multiple+Topic&t_comp=m&su_sub=10&su_top=&nques=0&t_neg=0&t_pass=0&ttime_h=0&ttime_m=0&t_start=&t_end=

        if (tid != null) {
            conn = db.getConnection();
            st = conn.createStatement();
            //select * from questions q, subjects s where q.s_id = s.sub_id and q.q_comp = 's' and  s.sub_id in (135,136,138) ;

            int totmarks = 0;
            query = "select q.* from test_ques tq,questions q where q.qid  = tq.qid and tq.tid =" + tid;

            rs = st.executeQuery(query);
            int count = 0;
            while (rs.next()) {
                String op[] = new String[5];
                String qid = rs.getString("qid");
                String q_comp = rs.getString("q_comp");
                int q_marks = rs.getInt("q_marks");
                String ques = rs.getString("question");
                op[0] = rs.getString("op1");
                op[1] = rs.getString("op2");
                op[2] = rs.getString("op3");
                op[3] = rs.getString("op4");
                op[4] = rs.getString("op5");
                int ans = rs.getInt("ans");

    %>

    <li class="question_list">  
        <div class="question"><%=ques %></div>
        <ol class="options">  

            <%
                for (int i = 0; i < 5; i++) {
                    if (op[i].length() == 0) {
                        break;
                    } else {
                        out.println("<li class='option'> <input type='checkbox' value='" + (i + 1) + "' name='q_" + qid + "' /> " + op[i] + "</li>");
                    }
                }
            %>
        </ol>
        <input type="text" hidden="hidden" value="<%=qid%>" id="ques_<%=count%>" name="ques_id" class="hiddenfield"/>
        <div class="question_details">
            <label class="property">Marks :</label><span class="property-value" ><%=q_marks%></span>

        </div>
    </li>
    <%
                count++;
            }

        }
    %>

</ol>
<% }%>
