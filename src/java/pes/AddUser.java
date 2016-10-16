/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 *
 * @author Priyanka
 */
public class AddUser extends HttpServlet
{

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     * <p/>
     * @param request  servlet request
     * @param response servlet response
     * <p/>
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType ("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter ();
        try
        {

            String utype = request.getParameter ("utype");
            String name = request.getParameter ("name");
            String pwd = request.getParameter ("pwd");
            String rpwd = request.getParameter ("rpwd");
            String email = request.getParameter ("email");
            String phone = request.getParameter ("phone");
            String dept = request.getParameter ("dept");
            String uid = request.getParameter ("uid");
            String desg = "0", year = "0";
            //out.println("utype ="+utype+" Name :"+name+" pwd="+pwd+" email:"+email+" phone="+phone+" dept"+dept+" uid"+uid+"<br />");

            if (utype.equals ("2"))
            {
                desg = request.getParameter ("desg");
            }
            else if (utype.equals ("3"))
            {
                year = request.getParameter ("year");
            }


            if (utype.equals ("") || name.equals ("") || "".equals (pwd) || "".equals (rpwd) || "".equals (email) || "".equals (phone) || "".equals (dept) || "".equals (uid) || desg.equals ("") || year.equals (""))
            {
                out.println("All Fields are Required");
            }
            else
            {
                Db db = new Db ();
                Connection conn = db.getConnection ();
                Statement st = conn.createStatement ();

                if ( ! pwd.equals (rpwd))
                {
                    out.println("Passwords should be same");
                }
                else
                {

                    String query = "insert into users(user_id, password, name, email, phone, dept_id, user_type_id) values('" + uid + "','" + pwd + "','" + name + "','" + email + "','" + phone + "'," + dept + "," + utype + ")";
                    st.executeUpdate (query);

                    if (utype.equals ("3"))
                    {
                        query = "insert into student(user_id, year) values('" + uid + "'," + year + ")";
                        st.executeUpdate (query);
                    }
                    else if (utype.equals ("2"))
                    {
                        query = "insert into staff(user_id, desg_name) values('" + uid + "','" + desg + "')";
                        st.executeUpdate (query);
                    }
                    out.println("User Added");
                }
            }

        }
        catch (Exception e)
        {
            out.println("Error :"+e.toString ());
        }
        finally
        {
            out.close ();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     * <p/>
     * @param request  servlet request
     * @param response servlet response
     * <p/>
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {

        processRequest (request, response);


    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     * <p/>
     * @param request  servlet request
     * @param response servlet response
     * <p/>
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest (request, response);
    }

    /**
     * Returns a short description of the servlet.
     * <p/>
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo ()
    {
        return "Short description";
    }// </editor-fold>
}
