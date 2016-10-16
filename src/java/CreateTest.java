/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import java.io.*;
import java.sql.*;
import java.text.*;
import java.time.Clock;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 *
 * @author Priyanka
 */
public class CreateTest extends HttpServlet
{

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try
        {
            
            String t_name = request.getParameter("t_name");
            String user_id = request.getParameter("user_id");
            String test_id = request.getParameter("test_id");
            String t_type = request.getParameter("t_type");
            String t_comp = request.getParameter("t_comp");
            String su_sub = request.getParameter("su_sub");
            String[] su_top = new String[30];
            su_top = request.getParameterValues("su_top");

            int nques = Integer.parseInt(request.getParameter("nques"));
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

            int q_count = Integer.parseInt(request.getParameter("ques_count"));


            int t_time = (ttime_h * 60) + ttime_m;




            Db db = new Db();
            Connection conn = db.getConnection();
            Statement st = conn.createStatement();

            //java.util.Date c_date = new java.util.Date();
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String c_date = df.format(new java.util.Date());


            if ((nques == q_count) && (q_gen.equals("1")))
            {
                String query = "";
                if (t_end.equals(""))
                {
                    query = "insert into tests(test_id,t_name,t_sub,c_id,test_type,test_comp,t_time,c_date,s_date,nques,t_pass,t_marks,t_neg) values(" + test_id + ",'" + t_name + "','" + su_sub + "','" + user_id + "','" + t_type + "','" + t_comp + "'," + t_time + ",'" + c_date + "','" + t_start + "'," + nques + "," + t_pass + "," + test_marks + "," + t_neg + ");";
                }
                else
                {
                    query = "insert into tests(test_id,t_name,t_sub,c_id,test_type,test_comp,t_time,c_date,s_date,e_date,nques,t_pass,t_marks,t_neg) values(" + test_id + ",'" + t_name + "','" + su_sub + "','" + user_id + "','" + t_type + "','" + t_comp + "'," + t_time + ",'" + c_date + "','" + t_start + "','" + t_end + "'," + nques + "," + t_pass + "," + test_marks + "," + t_neg + ");";
                }
                //out.println(query);
                st.executeUpdate(query);
               
                if (su_top != null)
                {
                    for (int i = 0; i < su_top.length; i++)
                    {
                        query = "insert into test_topic(test_id,sub_id) values(" + test_id + "," + su_top[i] + ")";
                        st.executeUpdate(query);
                    }
                }
  
                for (int i = 0; i < ques_id.length; i++)
                {
                    System.out.println(test_id+"-"+ques_id[i]);
                    query = "insert into test_ques(tid,qid) values(" + test_id + "," + ques_id[i] + ")";
                    st.executeUpdate(query);
                }

                out.println("<br /><br /><b>Test with name : " + t_name + " is successfully created</b><br />The following message is send to the students<br /><br />");

                query = "select s.rybid,s.subject_name from subjects s where s.sub_id=" + su_sub;
                ResultSet rs = st.executeQuery(query);
                String reg = "";
                String dept = "";
                String subname = "";
                char year = ' ';
                if (rs.next())
                {
                    String rybid = rs.getString("rybid");
                    subname = rs.getString("subject_name");
                    if (rybid.length() == 4)
                    {
                        rybid = "0" + rybid;
                    }
                    
                    reg = rybid.substring(0, 2);
                    year = rybid.charAt(2);
                    dept = rybid.substring(3);
                    int yr = Integer.parseInt("" + year);

                    if (reg.equals("06") || reg.equals("09"))
                    {
                        switch (yr)
                        {
                            case 1:
                                yr = 1;
                                break;
                            case 2:
                            case 3:
                                yr = 2;
                                break;
                            case 4:
                            case 5:
                                yr = 3;
                                break;
                            case 6:
                            case 7:
                                yr = 4;
                                break;
                        }
                    }
                    else
                    {
                        switch (yr)
                        {
                            case 1:
                            case 2:
                                yr = 1;
                                break;
                            case 3:
                            case 4:
                                yr = 2;
                                break;
                            case 5:
                            case 6:
                                yr = 3;
                                break;
                            case 7:
                            case 8:
                                yr = 4;
                                break;
                        }
                    }

                    query = "select u.email from student s, users u where u.user_type_id = 3 and s.user_id = u.user_id and s.regulation = " + reg + " and s.`year` = " + yr + " and u.dept_id = " + dept;
                    ResultSet rs1 = st.executeQuery(query);
                    Functions func = new Functions();
                    ArrayList<String> emails = new ArrayList<String>();
                    while (rs1.next())
                    {
                        String email = rs1.getString("email");
                        emails.add(email);
                    }

                    String msg = "<br />Dear Students,<br /><br />";
                    msg += "You have a NEW TEST on "+subname+"<br />";
                    msg += "Test is available from " + t_start;
                    if (!t_end.equals(""))
                    {
                        msg += " to " + t_end;
                    }
                    msg += "<br /><br />";
                    msg += "<b>Test Details</b><br /><br />";
                    msg += "Test Name            :<b>" + t_name + "</b><br />";
                    msg += "Test Type            :" + t_type + "<br />";
                    msg += "Test Complexity      :" + t_comp + "<br />";
                    
                    if (su_top != null)
                    {
                        String su_tops = "";
                        for (int j = 0; j < su_top.length; j++)
                        {
                            if (j != 0)
                            {
                                su_tops += ",";
                            }
                            su_tops += su_top[j];
                        }
                        msg += "Topics              :<br /><ol>";
                        query = "select subject_name,sub_short from subjects where type = 'c' and sub_id in (" + su_tops + ") order by sub_slno";
                        rs = st.executeQuery(query);
                        while (rs.next())
                        {
                            String sname = rs.getString("subject_name");

                            String sub_short = rs.getString("sub_short");
                            msg += "                    <li>" + sname + "(" + sub_short + ")</li>";
                        }
                        msg += "</ol>";

                    }

                    msg += "No of Questions     :" + nques + "<br />";
                    msg += "Test Time           :" + t_time + "<br />";
                    msg += "Test Pass percentile:" + t_pass + "<br />";
                    if (t_neg.equals("1"))
                    {
                        msg += "<b>Test has Negative Marks</b>";
                    }

                    String[] to = (String[]) emails.toArray(new String[emails.size()]);

                    String confirm = func.sendMail(to, "You have a New Test on "+subname, msg);
                    out.println(msg);

                    if (confirm.equals("sended"))
                    {
                        out.println("<br /><br /><b>Email Sended to :</b><br />");
                        for (int i = 0; i < to.length; i++)
                        {
                            out.println(to[i] + "<br />");
                        }
                    }
                    else
                    {
                        out.println("<br /><br /><b>Email Sended Failed :</b>" + confirm + "<br />");
                    }
                }
            }
            else
            {
                out.println("Please ensure that the required questions are generated");
            }
        }
        catch (MySQLIntegrityConstraintViolationException e)
        {
            e.printStackTrace();
            out.println("Please Enter the form Again : The test name already exists <br /> Try refresing the page");
        }
        catch (Exception e)
        {
            out.println("Error : " + e.toString());
        }
        finally
        {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>
}
