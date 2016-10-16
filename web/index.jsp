<%
    if (session.getAttribute("user_name") != null)
    {
        //String uname = session.getAttribute("user_name").toString();
        String utype = session.getAttribute("user_type").toString();
        response.sendRedirect(utype + ".jsp");
    }
    else
    {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


    <!-- Mirrored from www.malijuthemeshop.com/themes/mws-admin/1.3/ by HTTrack Website Copier/3.x [XR&CO'2010], Sat, 25 Feb 2012 01:16:46 GMT -->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

        <!-- Apple iOS and Android stuff (do not remove) -->
        <meta name="apple-mobile-web-app-capable" content="no" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black" />

        <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no,maximum-scale=1" />

        <!-- Required Stylesheets -->
        <link rel="stylesheet" type="text/css" href="css/reset.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="css/text.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="css/fonts/ptsans/stylesheet.css" media="screen" />

        <link rel="stylesheet" type="text/css" href="css/core/form.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="css/core/login.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="css/core/button.css" media="screen" />

        <link rel="stylesheet" type="text/css" href="css/mws.theme.css" media="screen" />

        <!-- JavaScript Plugins -->
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>

        <!-- jQuery-UI Dependent Scripts -->
        <script type="text/javascript" src="js/jquery-ui-effecs.min.js"></script>

        <!-- Plugin Scripts -->
        <script type="text/javascript" src="plugins/placeholder/jquery.placeholder-min.js"></script>
        <script type="text/javascript" src="plugins/validate/jquery.validate-min.js"></script>

        <!-- Login Script -->
        <script type="text/javascript" src="js/login.js"></script>

        <title>Performance Evaluation System (PES) - Login Page</title>

    </head>



    <body>

        <%

            String error = request.getParameter("error");
            String href = request.getParameter("href");
        %>

        <div id="mws-login-wrapper">
            <div id="mws-login">
                <h1>Login<span style="color: #F00;">
                 <% if (error != null)
                    {
                        out.println("( " + error + " )");
                    }%>
                    
                    </span>  </h1>
                <div class="mws-login-lock"><img src="css/icons/24/locked-2.png" alt="" /></div>
                <div id="mws-login-form">
                    <form class="mws-form" action="Login" method="post">
                        <div class="mws-form-row">
                            <div class="mws-form-item large">
                                <input type="text" name="username" maxlength="7" class="mws-login-username mws-textinput required" placeholder="username" />
                            </div>
                        </div>
                        <div class="mws-form-row">
                            <div class="mws-form-item large">
                                <input type="password" name="password" class="mws-login-password mws-textinput required" placeholder="password" />
                            </div>
                        </div>

                        <div class="mws-form-row">
                            <input type="submit" value="Login" class="mws-button green mws-login-button" />
                        </div>
                        <% if (href != null)
                            {%>
                        <input type="hidden" value="<%=href%>" name="href" />
                        <%  }%>
                    </form>
                </div>
            </div>
        </div>


    </body>

    <!-- Mirrored from www.malijuthemeshop.com/themes/mws-admin/1.3/ by HTTrack Website Copier/3.x [XR&CO'2010], Sat, 25 Feb 2012 01:16:46 GMT -->
</html>
                        
                        
<% }%>





