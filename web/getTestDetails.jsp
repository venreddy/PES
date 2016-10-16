<%@page import="java.sql.*"%>
<%@page import="pes.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    try{
    Db db = new Db();
    Connection conn = db.getConnection();
    Statement st = conn.createStatement();
    ResultSet rs;
    String query = "";
    String tid = request.getParameter("tid");

    if (tid != null)
    {
        query = "select t.*,s.subject_name,s.subject_short,u.name from tests t, subjects_dept s,users u where s.sub_id = t.t_sub and u.user_id = t.c_id and test_id = " + tid;
        rs = st.executeQuery(query);
        if (rs.next())
        {

            String t_name = rs.getString("t_name");
            String t_sub = rs.getString("t_sub");
            String u_name = rs.getString("name");
            String t_type = rs.getString("test_type");
            String t_comp = rs.getString("test_comp");
            int t_time = Integer.parseInt(rs.getString("t_time"));
            String c_date = rs.getString("c_date");
            String s_date = rs.getString("s_date");
            String e_date = rs.getString("e_date");
            String nques = rs.getString("nques");
            String t_pass = rs.getString("t_pass");
            String t_marks = rs.getString("t_marks");
            int t_neg = Integer.parseInt(rs.getString("t_neg"));
            String s_name = rs.getString("subject_name");
            String s_short = rs.getString("subject_short");
%>
<div class="mws-panel-content">
    <div class="mws-form-inline">
        <div class="mws-form-row">

            <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Test Details</legend>
                <div class="mws-form-row">
                    <label>Test Name</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=t_name%></label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Subject</label>
                    <div class="mws-form-item large">
                        <label style="width: 100%;"><%=s_name%> (<%=s_short%>)</label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Created By</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=u_name%></label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Type</label>
                    <div class="mws-form-item">
                        <label  style="width: 100%;"><%=t_type%></label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Complexity</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=t_comp%></label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>No of Questions</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=nques%></label>
                    </div>
                </div>

            </fieldset>

            <fieldset class="mws-panel-body grid_4" style="border-top:  1px solid #bcbcbc;"><legend>Test Details</legend>
                <div class="mws-form-row">
                    <label>Test Time</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=t_time%> Minutes  (<%=(t_time / 60)%> Hrs <%=(t_time % 60)%> Mins)</label>
                        <input type="hidden" value="<%=t_time%>" id="t_time" />
                             
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Created On</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=c_date%></label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Start Date</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=s_date%></label>
                    </div>
                </div>
                <% if (e_date != null)
                    {%>
                <div class="mws-form-row">
                    <label>Test End Date</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=e_date%></label>
                    </div>
                </div>
                <% }%>
                <div class="mws-form-row">
                    <label>Test Marks</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=t_marks%></label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test Pass Percentage</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%=t_pass%>%</label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Test with negative marks</label>
                    <div class="mws-form-item">
                        <label style="width: 100%;"><%
                            if (t_neg == 1)
                            {
                                out.println("True");
                            }
                            else
                            {
                                out.println("False");
                            }%></label>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="mws-form-row">
            <fieldset class="mws-panel-body grid_8" style="border-top:  1px solid #bcbcbc;"><legend>Topic Details</legend>
                <div class="mws-form-row">
                    <label>Test Subject</label>
                    <div class="mws-form-item large">
                        <label style="width: 100%;"><%=s_name%> (<%=s_short%>)</label>
                    </div>
                </div>
                <div class="mws-form-row">
                    <label>Topics Covered</label>
                    <div class="mws-form-item" style="display: block;">
                        <ol class="mws-form-list">
                            <%
                                query = "select s.sub_id,s.subject_name,s.subject_short,count(s.sub_id) as qcount from test_ques tq, tests t,questions q,subjects_dept s where t.test_id = tq.tid and q.qid = tq.qid and q.s_id = s.sub_id and s.sub_id in (select ss.sub_id FROM subjects_dept ss where ss.su_id = t.t_sub and ss.sub_id != ss.su_id) and t.test_id = " + tid + "  GROUP BY s.sub_id";
                                ResultSet rs1 = st.executeQuery(query);
                                while (rs1.next())
                                {
                                    String sub_id = rs1.getString("sub_id");
                                    String top_name = rs1.getString("subject_name");
                                    String top_short = rs1.getString("subject_short");
                                    String qcount = rs1.getString("qcount");

                                    out.println("<li>(" + top_short + ") " + top_name + " (" + qcount + ")</li>");
                                }

                            %>
                        </ol>
                    </div>
                </div>


            </fieldset>



        </div>

        <div id="test-details-short" style="display: none;"></div>                
    </div> 
</div>
<%        }
    }
    }catch(Exception e)
    {
        e.printStackTrace();
        out.println(e.toString());
    }

%>