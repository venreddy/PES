/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Priyanka
 */
public class Login extends HttpServlet
{

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     * <p/>
     * @param request servlet request
     * @param response servlet response
     * <p/>
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        try
        {

            String uname = request.getParameter("username").trim();
            String pwd = request.getParameter("password").trim();
            String href = request.getParameter("href");
            
            
            Db db = new Db();
            Connection conn = db.getConnection();

            Statement st = conn.createStatement();

            String query = "select ut.user_type_id,ut.user_role,u.dept_id from users u,user_type ut where u.user_id='" + uname + "' and u.password='" + pwd + "' and u.user_type_id = ut.user_type_id ";

            ResultSet rs = st.executeQuery(query);

            if (rs.next())
            {
                int id = rs.getInt(1);
                String role = rs.getString(2);
                role = role.toLowerCase();
                String dept = rs.getString(3);
                session.setAttribute("user_type_id", id);
                session.setAttribute("user_type", role);
                session.setAttribute("user_name", uname);
                session.setAttribute("dept", dept);

                if (role.equals("student"))
                {
                    query = "select * from student where user_id = '" + uname + "'";
                    ResultSet rs1 = st.executeQuery(query);

                    while (rs1.next())
                    {
                        int year = Integer.parseInt(rs1.getString("year"));
                        String pod = rs1.getString("pod");
                        
                        DateFormat df = new SimpleDateFormat("MM");
                        int mon = Integer.parseInt(df.format(new java.util.Date()));

                        session.setAttribute("year", year);
                        session.setAttribute("pod", pod);

                    }

                }

                if (href != null)
                {
                    response.sendRedirect(href);
                }
                else
                {
                    response.sendRedirect(role + ".jsp");
                }
            }
            else
            {
                response.sendRedirect("index.jsp?error=Invalid Login");
            }



        }
        catch (Exception e)
        {
            out.println(e.toString());
            response.sendRedirect("index.jsp?error=Exception Occured");
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
     * <p/>
     * @param request servlet request
     * @param response servlet response
     * <p/>
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
     * <p/>
     * @param request servlet request
     * @param response servlet response
     * <p/>
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
     * <p/>
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>
}
