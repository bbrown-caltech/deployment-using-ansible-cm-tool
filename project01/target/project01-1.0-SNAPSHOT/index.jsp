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
            padding-top: 250px;
        }

        .centered {
            width: 350px;
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

        .div-row {
        width: 100%;
        display: inline-block;
        line-height: 20px;
        padding: 3px;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box; }
        .div-row .div-col-quarter {
            width: calc(2.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-half {
            width: calc(5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-three-quarters {
            width: calc(7.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-01 {
            width: calc(10% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0125 {
            width: calc(12.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-015 {
            width: calc(15% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0175 {
            width: calc(17.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-02 {
            width: calc(20% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0225 {
            width: calc(22.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-025 {
            width: calc(25% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0275 {
            width: calc(27.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-03 {
            width: calc(30% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0325 {
            width: calc(32.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-035 {
            width: calc(35% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0375 {
            width: calc(37.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-04 {
            width: calc(40% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0425 {
            width: calc(42.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-045 {
            width: calc(45% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0475 {
            width: calc(47.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-05 {
            width: calc(50% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0525 {
            width: calc(52.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-055 {
            width: calc(55% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0575 {
            width: calc(57.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-06 {
            width: calc(60% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0625 {
            width: calc(62.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-065 {
            width: calc(65% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0675 {
            width: calc(67.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-07 {
            width: calc(70% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0725 {
            width: calc(72.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-075 {
            width: calc(75% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0775 {
            width: calc(77.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-08 {
            width: calc(80% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0825 {
            width: calc(82.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-085 {
            width: calc(85% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0875 {
            width: calc(87.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-09 {
            width: calc(90% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0925 {
            width: calc(92.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-095 {
            width: calc(95% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-0975 {
            width: calc(97.5% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-10 {
            width: calc(100% - 6px);
            float: left;
            padding: 3px; }
        .div-row .div-col-auto {
            width: auto;
            float: left;
            padding: 3px; }

        .float-right {
        float: right; }

    </style>
</head>
<body bgcolor="silver">
    <form method="post" action="index.jsp">
        <div class="container">
            <div class="centered">
                <div class="div-row">
                    <div class="div-col-10">
                        <div class="div-row">
                            <div class="div-col-10">
                                <h1>Hooray!!</h1>
                                CM Project01 -- Login Page
                            </div>
                        </div>
                        <div class="div-row">
                            <div class="div-col-01">&nbsp;</div>
                            <div class="div-col-08">
                                <label for="userName">Username:</label>
                                <input class="frm-ctl-elemt" type="text" name="userName" value="" />
                            </div>
                            <div class="div-col-01">&nbsp;</div>
                        </div>
                        <div class="div-row">
                            <div class="div-col-01">&nbsp;</div>
                            <div class="div-col-08">
                                <label for="password">Password:</label>
                                <input class="frm-ctl-elemt" type="password" name="password" value="" />
                            </div>
                            <div class="div-col-01">&nbsp;</div>
                        </div>
                        <div class="div-row">
                            <div class="div-col-01">&nbsp;</div>
                            <div class="div-col-08">
                                <input class="btn btn-somber btn-small float-right" type="submit" value="Login" />
                                <input class="btn btn-crisp btn-small float-right" type="reset" value="Reset" />
                            </div>
                            <div class="div-col-01">&nbsp;</div>
                        </div>
                        <div class="div-row">
                            <div class="div-col-10">
                                <span class="float-right">
                                    New User <a href="#" title="This Does Not Actually Work">Register Here</a>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    </body>
</html>
