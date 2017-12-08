<?php require_once('../includes/Header.php'); ?>
<?php require_once('../includes/Navigation.php'); ?>
<?php require_once('../includes/Sidebar.php'); ?>
<h3 class="title3">تغییر گذرواژه</h3>
<p>با استفاده از فرم زیر، می توانید گذرواژه اکانت AFK Manager خود را تغییر دهید.</p>
<form class="form-vertical" id="password_change" autocomplete="off">
    <div class="form-group">
        <div class="col-sm-10">
            <div id="result" hidden></div>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="username">نام کاربری:</label>
        </div>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="username" maxlength="16" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="current_password">گذرواژه فعلی:</label>
        </div>
        <div class="col-sm-10">
            <input type="password" class="form-control" id="current_password" maxlength="31" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="new_password">گذرواژه جدید:</label>
        </div>
        <div class="col-sm-10">
            <input type="password" class="form-control" id="new_password" maxlength="31" required>
        </div>
    </div>
    <div class="form-group"><hr></div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="captcha">کد امنیتی:</label>
        </div>
        <div class="col-sm-10">
            <div class="row">
                <div class="col-sm-3">
                    <img src="/img/Captcha.php" id="captcha_image">
                </div>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="captcha" maxlength="5" required>
                </div>
            </div>
        </div>
    </div>
    <div class="form-group"><hr></div>
    <button type="submit" class="my-btn submit">تغییر گذرواژه</button>
</form>
<script>
var result = $("#result");
var username = $("#username");
var current_password = $("#current_password");
var new_password = $("#new_password");
var captcha = $("#captcha");
$("#password_change").submit(function(e) {
    e.preventDefault();
    result.attr("class", "alert alert-info");
    result.text("در حال تغییر گذرواژه، لطفا منتظر بمانید...");
    result.show();
    var t = "username=" + username.val() + "&currentPassword=" + current_password.val() + "&newPassword=" + new_password.val() + "&captcha=" + captcha.val();
    if (window.ActiveXObject) {
        http = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        http = new XMLHttpRequest();
    }
    http.open("POST", "/management/PasswordChange.php", true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            if (http.status == 200) {
                switch (parseInt(http.responseText, 10)) {
                    case 1:
                        result.attr("class", "alert alert-danger");
                        result.text("کد امنیتی وارد شده اشتباه است.");
                        captcha.val("");
                        captcha.focus();
                        break;
                    case 2:
                        result.attr("class", "alert alert-warning");
                        result.text("نام کاربری و یا گذرواژه فعلی اشتباه است.");
                        $("#password_change")[0].reset();
                        $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                        username.focus();
                        break;
                    case 3:
                        result.attr("class", "alert alert-success");
                        result.text("گذرواژه با موفقیت تغییر یافت.");
                        $("#password_change")[0].reset();
                        $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                        username.focus();
                        break;
                    default:
                        result.attr("class", "alert alert-warning");
                        result.text("لطفا فرم را با دقت کامل نمایید.");
                        break;
                }
            } else {
                result.attr("class", "alert alert-danger");
                result.text("متاسفانه قادر به تغییر گذرواژه شما نیستیم.");
                $("#password_change")[0].reset();
                $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                username.focus();
            }
        }
    };
    http.send(t);
});
</script>
<?php require_once('../includes/Footer.php'); ?>