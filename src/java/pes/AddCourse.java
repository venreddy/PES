/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Priyanka
 */
public class AddCourse extends HttpServlet
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

            String sid = request.getParameter("su_sub").trim();
            String t_name = request.getParameter("t_name").trim();
            String t_sname = request.getParameter("t_sname").trim();
            String sub_name = "", dept_id = "", sub_code = "";
            int slno;
            Db db = new Db();
            Connection conn = db.getConnection();
            Statement st = conn.createStatement();

            String query = "select subject_name, dept_id from subjects_dept where sub_id =" + sid;
            ResultSet rs = st.executeQuery(query);
            if (rs.next())
            {
                sub_name = rs.getString("subject_name");
                dept_id = rs.getString("dept_id");
                
                query = "select max(sub_slno)+1 from subjects_dept where su_id = "+sid+" and sub_id != "+sid+" order by sub_slno;";

                ResultSet rs1 = st.executeQuery(query);
                if (rs1.next())
                {
                    slno = rs1.getInt(1);
                    if(slno == 0) slno = 1;
                }
                else
                {
                    slno = 1;
                }
                query = "INSERT INTO subjects_dept(subject_name,subject_short,sub_slno,dept_id,su_id) VALUES('"+t_name+"','"+t_sname+"','"+slno+"','"+dept_id+"','"+sid+"');";
                int r = st.executeUpdate(query);
                out.println("Topic added to '" + sub_name + "' with Sl.No : " + slno);
            }

        }
        catch (Exception e)
        {
            e.printStackTrace();
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
