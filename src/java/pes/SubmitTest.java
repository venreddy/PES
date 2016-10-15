/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import java.io.*;
import java.sql.*;
import java.text.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 *
 * @author Priyanka
 */
public class SubmitTest extends HttpServlet
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
            String tid = request.getParameter("tid");
            String ques_id[] = request.getParameterValues("ques_id");

            Db db = new Db();
            Connection conn = db.getConnection();
            Statement st = conn.createStatement();
            int correct = 0, uncorrect = 0, unattend = 0;
            float negM = 0, tot_marks = 0;

            String query = "select t_neg,t_pass,t_marks from tests where test_id = " + tid;

            ResultSet rs = st.executeQuery(query);
            Boolean t_neg = false;
            int t_pass = 0, t_marks = 0;
            if (rs.next())
            {
                t_neg = rs.getBoolean("t_neg");
                t_pass = rs.getInt("t_pass");
                t_marks = rs.getInt("t_marks");
            }



            query = "select q.qid,q.q_marks,q.ans from test_ques tq,tests t,questions q where tq.tid = t.test_id and tq.qid = q.qid and t.test_id = " + tid;

            rs = st.executeQuery(query);
            while (rs.next())
            {
                String qid = rs.getString("qid");
                int q_marks = rs.getInt("q_marks");
                int ans = rs.getInt("ans");

                String opt = request.getParameter("q_" + qid);
                int option = 0;
                if (opt == null)
                {
                    option = 0;
                }
                else
                {
                    option = Integer.parseInt(opt);
                }

                if (option == 0)
                {
                    unattend++;
                }
                else if (ans == option)
                {
                    correct++;
                    tot_marks += q_marks;
                }
                else if (ans != option)
                {
                    uncorrect++;
                    if (t_neg)
                    {
                        negM = (float) q_marks / 3;
                        tot_marks -= negM;
                    }
                }

            }


            int porf;
            out.println("Total Marks :" + tot_marks);
            out.println("<br />Correct :" + correct);
            out.println("<br />Uncorrect :" + uncorrect);
            out.println("<br />Unattend :" + unattend);
            if (((int) (tot_marks / t_marks) * 100) >= t_pass)
            {
                out.println("<br />You have Passed in the test");
                porf = 1;
            }
            else
            {
                out.println("<br />You have Failed in the test");
                porf =0;
            }
            
            HttpSession session = request.getSession();
            String uname = session.getAttribute("user_name").toString();
            DateFormat dtf = new SimpleDateFormat("yyyy-MM-dd HH:mm:s");
            String endtime = dtf.format(new java.util.Date());
            query = "update results set tot_marks =" + tot_marks + ", c_ques =" + correct + ", w_ques =" + uncorrect + ", ua_ques =" + unattend + ", pass = "+porf+", test_ended='"+endtime+"', completed =1 where user_id = '"+uname+"'   and test_id ="+tid;
            st.executeUpdate(query);
            out.println("<br /><br /><a href='sttest_take.jsp'>Take Another Test</a>");
        }
        catch (Exception e)
        {
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
