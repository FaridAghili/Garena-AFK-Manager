<?php require_once('../includes/Header.php'); ?>
<?php require_once('../includes/Navigation.php'); ?>
<?php require_once('../includes/Sidebar.php'); ?>
<h3 class="title3">بازیابی گذرواژه</h3>
<p>در صورتی که گذرواژه اکانت AFK Manager خود را فراموش کرده اید، می توانید با استفاده از فرم زیر نسبت به بازیابی آن اقدام کنید.</p>
<p>یک گذرواژه جدید توسط سیستم به اکانت شما نسبت داده شده و به ایمیل شما ارسال خواهد شد.</p>
<form class="form-vertical" id="password_reset" autocomplete="off">
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
            <label for="email">ایمیل:</label>
        </div>
        <div class="col-sm-10">
            <input type="email" class="form-control" id="email" placeholder="ایمیلی که هنگام خرید این اکانت ثبت کرده اید" maxlength="64" required>
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
    <button type="submit" class="my-btn submit">بازیابی گذرواژه</button>
</form>
<script>
var result = $("#result");
var username = $("#username");
var email = $("#email");
var captcha = $("#captcha");
$("#password_reset").submit(function(e) {
    e.preventDefault();
    result.attr("class", "alert alert-info");
    result.text("در حال بازیابی گذرواژه، لطفا منتظر بمانید...");
    result.show();
    var t = "username=" + username.val() + "&email=" + email.val() + "&captcha=" + captcha.val();
    if (window.ActiveXObject) {
        http = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        http = new XMLHttpRequest();
    }
    http.open("POST", "/management/PasswordReset.php", true);
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
                        result.text("نام کاربری و ایمیل همخوانی ندارند.");
                        $("#password_reset")[0].reset();
                        $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                        username.focus();
                        break;
                    case 3:
                        result.attr("class", "alert alert-success");
                        result.text("گذرواژه جدید به ایمیل شما ارسال شد.");
                        $("#password_reset")[0].reset();
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
                result.text("متاسفانه قادر به بازیابی گذرواژه شما نیستیم.");
                $("#password_reset")[0].reset();
                $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                username.focus();
            }
        }
    };
    http.send(t);
});
</script>
<?php require_once('../includes/Footer.php'); ?>