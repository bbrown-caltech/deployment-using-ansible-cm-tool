<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Example</title>
    <style>
        body {
            background-color: #fff;
        }
        .container {
            width: 100%;
        }

        .centered {
            width: 65%;
            margin-left: auto;
            margin-right: auto;
            background-color: #222;
            color: #fff;
        }

        .frm-ctl-elemt {
        width: 100%;
        min-width: 50px;
        height: 30px;
        margin: .5px;
        border: 1px solid #CCCCCC;
        border-radius: 3px; }
        .frm-ctl-elemt:focus {
            outline: none;
            border-color: #0c639c;
            box-shadow: 0 0 10px #66AFE9; }
        .frm-ctl-elemt:hover {
            outline: none;
            border-color: #0c639c; }
        .frm-ctl-elemt:disabled {
            cursor: not-allowed; }
        .frm-ctl-elemt::-webkit-input-placeholder {
            /* Chrome/Opera/Safari */
            color: #ababab; }
        .frm-ctl-elemt::-moz-placeholder {
            /* Firefox 19+ */
            color: #ababab; }
        .frm-ctl-elemt:-ms-input-placeholder {
            /* IE 10+ */
            color: #ababab; }
        .frm-ctl-elemt:-moz-placeholder {
            /* Firefox 18- */
            color: #ababab; }

        .btn {
        margin: .5px;
        border-radius: 2px;
        font-family: Arial, Helvetica, sans-serif;
        background-size: cover;
        cursor: pointer;
        text-align: center; }
        .btn:disabled {
            cursor: not-allowed; }

        .btn-crisp {
        border: 1px solid #444;
        color: #333;
        background: linear-gradient(#fff, #efefef); }
        .btn-crisp:focus {
            outline: none;
            color: #fff;
            background: linear-gradient(#999, #444);
            background-size: cover;
            border-color: #555; }
        .btn-crisp:hover {
            outline: none;
            color: #fff;
            background: linear-gradient(#999, #444);
            background-size: cover;
            border-color: #555; }

        .btn-somber {
        border: 1px solid #0c639c;
        color: #fff;
        background: linear-gradient(#118cdf, #0e76bd); }
        .btn-somber:focus {
            outline: none;
            color: #fff;
            background: linear-gradient(#0e74b8, #0d6aa8);
            background-size: cover;
            border-color: #0c639c; }
        .btn-somber:hover {
            outline: none;
            color: #fff;
            background: linear-gradient(#0e74b8, #0d6aa8);
            background-size: cover;
            border-color: #0c639c; }

        .btn-small {
        min-width: 25px;
        height: 25px;
        line-height: 15px;
        font-size: 110% !important;
        font-weight: bold; }

    </style>
</head>
<body bgcolor="silver">
    <form method="post" action="login.jsp">
        <div class="container">
            <div class="centered">
                <table border="0" width="30%" cellpadding="3">
                    <thead>
                        <tr>
                            <th colspan="2">Login Page</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Username</td>
                            <td><input class="frm-ctl-elemt" type="text" name="userName" value="" /></td>
                        </tr>
                        <tr>
                            <td>Password</td>
                            <td><input class="frm-ctl-elemt" type="password" name="password" value="" /></td>
                        </tr>
                        <tr>
                            <td><input class="btn btn-somber btn-small" type="submit" value="Login" /></td>
                            <td><input class="btn btn-crisp btn-small" type="reset" value="Reset" /></td>
                        </tr>
                        <tr>
                            <td colspan="2">New User <a href="#" title="This Does Not Actually Work">Register Here</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
    </body>
</html>
