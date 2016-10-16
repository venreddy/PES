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
        try{
        // t_type=Multiple+Topic&t_comp=m&su_sub=10&su_top=&nques=0&t_neg=0&t_pass=0&ttime_h=0&ttime_m=0&t_start=&t_end=
        String su_top[] = new String[100];
        String t_type = request.getParameter("t_type");
        String t_comp = request.getParameter("t_comp");

        String su_sub = request.getParameter("su_sub");
        //if(!su_sub.equals("Subject"))
        //su_top = request.getParameterValues("su_top");
        int totmarks = 0;
        int nques = Integer.parseInt(request.getParameter("nques"));
        //String t_neg = request.getParameter("t_neg");

        if (t_type != "" && t_comp != "" && su_sub != "" && nques != 0)
        {
            Db db = new Db();

            Connection conn = db.getConnection();
            Statement st = conn.createStatement();
            //select * from questions q, subjects s where q.s_id = s.sub_id and q.q_comp = 's' and  s.sub_id in (135,136,138) ;

            if (t_type.equals("Subject"))
            {
                String query = "select sub_id from subjects_dept where su_id=" + su_sub + " and sub_id != " + su_sub;
                ResultSet rs1 = st.executeQuery(query);
                int c = 0;
                while (rs1.next())
                {
                    su_top[c] = rs1.getString("sub_id");
                    c++;
                }
            }
            else
            {
                su_top = request.getParameterValues("su_top");
            }
            String su_tops = "";
            for (int j = 0; j < su_top.length; j++)
            {
                if (j != 0)
                {
                    su_tops += ",";
                }
                su_tops += su_top[j];
            }

            String query = "select q.qid,q.q_comp,q.q_marks,q.question,q.op1,q.op2,q.op3,q.op4,q.op5,q.ans,s.subject_name from questions q, subjects_dept s where q.s_id = s.sub_id and q.q_comp = '" + t_comp + "' and  s.sub_id in (" + su_tops + ") order by rand() limit " + nques;

            ResultSet rs = st.executeQuery(query);
            int count = 1;
            while (rs.next())
            {
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
                String sub_name = rs.getString("subject_name");

                totmarks += q_marks;

    %>

    <li class="question_list">  
        <div class="question"><%=ques%></div>
        <ol class="options">  

            <%
                for (int i = 0; i < 5; i++)
                {
                    if (op[i].length() == 0)
                    {
                        break;
                    }
                    else
                    {
                        if (ans == (i + 1))
                        {
                            out.println("<li class='option answer'>" + op[i] + "</li>");
                        }
                        else
                        {
                            out.println("<li class='option'>" + op[i] + "</li>");
                        }
                    }
                }
            %>
        </ol>
        <div class="question_details">
            <label class="property">Marks :</label><span class="property-value" ><%=q_marks%></span>
            <label class="property">Complexity :</label><span class="property-value" ><%=q_comp%></span>
            <label class="property">Topic :</label><span class="property-value" ><%=sub_name%></span>
        </div>
        <!-- <input type="text" hidden="hidden" value="<%=qid%>" id="ques_<%=count%>" name="ques_<%=count%>" class="hiddenfield"/> -->
        <input type="text" hidden="hidden" value="<%=qid%>" id="ques_<%=count%>" name="ques_id" class="hiddenfield"/>
    </li>


    <%
            count++;
        }
    %>
    <input type="text" hidden="hidden" value="<%=totmarks%>" id="test_marks" name="test_marks" class="hiddenfield"/>
    <input type="text" hidden="hidden" value="<%=(count - 1)%>" id="ques_count" name="ques_count" class="hiddenfield"/>
    <%
            if (count == 1)
            {
                out.println("No questions are available for the selected topic and complexity");
                out.println("<input type='text' value='0' id='q_gen' style='display:none;' name='q_gen' class='hiddenfield required'/>");
            }
            else if ((count - 1) < nques)
            {
                out.println("Only " + (count - 1) + " questions are available for the selected topic and complexity");
                out.println("<input type='text' value='0' id='q_gen' name='q_gen' style='display:none;' class='hiddenfield required'/>");
            }
            else
            {
                out.println("<input type='text' value='1' id='q_gen' style='display:none;' name='q_gen' class='hiddenfield required'/>");
            }
        }
        
        }
        catch(Exception e)
        {
            e.printStackTrace();
            out.println(e.toString());
        }
    %>

</ol>