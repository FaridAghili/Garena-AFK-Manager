<?php require_once('../includes/Header.php'); ?>
<?php require_once('../includes/Navigation.php'); ?>
<?php require_once('../includes/Sidebar.php'); ?>
<h3 class="title3">تماس</h3>
<p>لطفا در صورتی که سوال، پیشنهاد و یا انتقادی دارید از طریق فرم زیر با ما در میان بگذارید.</p>
<p>سعی ما بر آن است که در کوتاه ترین زمان ممکن به پیام شما پاسخ دهیم.</p>
<form class="form-vertical" id="contact">
    <div class="form-group">
        <div class="col-sm-10">
            <div id="result" hidden></div>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="fullName">نام:</label>
        </div>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="fullName" maxlength="32" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="email">ایمیل:</label>
        </div>
        <div class="col-sm-10">
            <input type="email" class="form-control" id="email" maxlength="64" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="message">پیام:</label>
        </div>
        <div class="col-sm-10">
            <textarea class="form-control" id="message" rows="5" required></textarea>
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
    <button type="submit" class="my-btn submit">ارسال پیام</button>
</form>
<script>
var result = $("#result");
var fullName = $("#fullName");
var email = $("#email");
var message = $("#message");
var captcha = $("#captcha");
$("#contact").submit(function(e) {
    e.preventDefault();
    result.attr("class", "alert alert-info");
    result.text("در حال ارسال پیام، لطفا منتظر بمانید...");
    result.show();
    var t = "fullName=" + fullName.val() + "&email=" + email.val() + "&message=" + message.val() + "&captcha=" + captcha.val();
    if (window.ActiveXObject) {
        http = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        http = new XMLHttpRequest();
    }
    http.open("POST", "/management/Contact.php", true);
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
                        result.attr("class", "alert alert-success");
                        result.text("پیام شما با موقیت ارسال شد.");
                        $("#contact")[0].reset();
                        $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                        fullName.focus();
                        break;
                    default:
                        result.attr("class", "alert alert-warning");
                        result.text("لطفا فرم را با دقت کامل نمایید.");
                        break;
                }
            } else {
                result.attr("class", "alert alert-danger");
                result.text("متاسفانه قادر به ارسال پیام شما نیستیم.");
                $("#contact")[0].reset();
                $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                fullName.focus();
            }
        }
    };
    http.send(t);
});
</script>
<?php require_once('../includes/Footer.php'); ?>