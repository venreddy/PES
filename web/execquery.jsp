<%-- 
    Document   : execquery
    Created on : Feb 16, 2012, 1:49:59 PM
    Author     : Chaitanya
--%>

<%@page import="java.sql.*"%>
<%@page import="pes.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%

            Db db = new Db();

            Connection conn = db.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select sub_id from subjects");
            while (rs.next())
            {
                String sid = rs.getString("sub_id");
                Statement s = conn.createStatement();
                s.executeUpdate("update subjects set su_id='" + sid + "' where sub_id = '" + sid + "'");
                out.println(sid + " -> " + sid + "<br />");
                //ResultSet
            }

        %>
    </body>
</html>
