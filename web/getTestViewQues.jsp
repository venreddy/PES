<%-- 
    Document   : getQues
    Created on : Feb 23, 2012, 7:14:14 AM
    Author     : Chaitanya
--%>

<%@page import="java.sql.*"%>
<%@page import="pes.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<ol>
    <%

        // t_type=Multiple+Topic&t_comp=m&su_sub=10&su_top=&nques=0&t_neg=0&t_pass=0&ttime_h=0&ttime_m=0&t_start=&t_end=
        Db db = new Db();
        Connection conn = db.getConnection();
        Statement st = conn.createStatement();
        String tid = request.getParameter("tid");
        String query;

        query = "select q.* from test_ques tq,questions q where q.qid  = tq.qid and tq.tid =" + tid;

        ResultSet rs = st.executeQuery(query);
        int count = 1;
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
            String sub_code = rs.getString("s_id");

            int totmarks = 0;
            totmarks += q_marks;

    %>

    <li class="question_list">  
        <div class="question"><%=ques%></div>
        <ol class="options">  

            <%
                for (int i = 0; i < 5; i++) {
                    if (op[i].length() == 0) {
                        break;
                    } else {
                        if (ans == (i + 1)) {
                            out.println("<li class='option answer'>" + op[i] + "</li>");
                        } else {
                            out.println("<li class='option'>" + op[i] + "</li>");
                        }
                    }
                }
            %>
        </ol>
        <div class="question_details">
            <label class="property">Marks :</label><span class="property-value" ><%=q_marks%></span>
            <label class="property">Complexity :</label><span class="property-value" ><%=q_comp%></span>

        </div>
        <!-- <input type="text" hidden="hidden" value="<%=qid%>" id="ques_<%=count%>" name="ques_<%=count%>" class="hiddenfield"/> -->
        <input type="text" hidden="hidden" value="<%=qid%>" id="ques_<%=count%>" name="ques_id" class="hiddenfield"/>
    </li>


    <%
            count++;
        }

    %>

</ol>