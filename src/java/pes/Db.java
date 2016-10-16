/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pes;

import java.sql.*;

/**
 *
 * @author Priyanka
 */
public class Db
{
     /*
    public static String dbURL = "jdbc:mysql:localhost";
    public static String dbUser = "root";
    public static String dbPwd = "admin";
    
    
    */
    
    public static String dbURL = "jdbc:mysql://localhost:3306/pes?autoReconnect=true";
    public static String dbUser = "root";
    public static String dbPwd = "admin";
   
    
    public Db (String dbURL, String dbUser, String dbPwd)
    {

        Db.dbURL = dbURL;
        Db.dbUser = dbUser;
        Db.dbPwd = dbPwd;

    }
    
    public Db ()
    {
        
    }
    
    public static String getDbPwd ()
    {
        return dbPwd;
    }

    public static void setDbPwd (String dbPwd)
    {
        Db.dbPwd = dbPwd;
    }

    public static String getDbURL ()
    {
        return dbURL;
    }

    public static void setDbURL (String dbURL)
    {
        Db.dbURL = dbURL;
    }

    public static String getDbUser ()
    {
        return dbUser;
    }

    public static void setDbUser (String dbUser)
    {
        Db.dbUser = dbUser;
    }

    

    public Connection getConnection ()
    {
        Connection conn;
        try
        {
            Class.forName ("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(this.dbURL,this.dbUser,this.dbPwd);
            return conn;
        }
        catch (Exception e)
        {
            conn = null;
            return conn;
        }
    }
}
