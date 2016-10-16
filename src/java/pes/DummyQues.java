/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Priyanka
 */
@WebServlet(name = "DummyQues", urlPatterns =
{
    "/DummyQues"
})
public class DummyQues extends HttpServlet
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
            int nos=20;
            String no = request.getParameter("no");
            if(no != null)
            {
                nos = Integer.parseInt(no);
            }
            for (int i = 0; i < nos; i++)
            {
                String comp[] = {"Simple","Medium","Hard"};
                String s_id = request.getParameter("s_id");
                String q_comp = comp[(int)(Math.random()*3)];
                String q_marks = "1";
                int q_opt = (int) (Math.random() * 5 + 1);

                String q_ques = "Dummy question.......";

                String q_op1 = "dummy1";
                String q_op2 = "dummy2";

                String q_op3 = "", q_op4 = "", q_op5 = "";


                switch (q_opt)
                {
                    case 5:
                        q_op5 = "dummy5";

                    case 4:
                        q_op4 = "dummy4";

                    case 3:
                        q_op3 = "dummy3";
                        break;
                }

                int q_ans = (int) (Math.random() * q_opt + 1);
                //String q_ans = request.getParameter("q_ans");

                Db db = new Db();

                Connection conn = db.getConnection();
                Statement st = conn.createStatement();

                String query = "insert into questions(s_id,q_comp,q_marks,question,op1,op2,op3,op4,op5,ans) values(" + s_id + ",'" + q_comp + "','" + q_marks + "','" + q_ques + "','" + q_op1 + "','" + q_op2 + "','" + q_op3 + "','" + q_op4 + "','" + q_op5 + "','" + q_ans + "');";
                int row = st.executeUpdate(query);
                if (row > 0)
                {
                    out.println("1 Question Added for s_id ="+s_id+"<br />");
                }
                conn.close();
            }
        }
        catch (Exception e)
        {
            out.println("Error Occured : " + e.toString());
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
