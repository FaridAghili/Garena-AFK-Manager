<?php require_once('../includes/Header.php'); ?>
<?php require_once('../includes/Navigation.php'); ?>
<?php require_once('../includes/Sidebar.php'); ?>
<h3 class="title3">تمدید اکانت</h3>
<p>
با استفاده از فرم زیر می توانید نسبت به تمدید اکانت AFK Manager خود اقدام نمایید.<br>
تمدید اکانت بلافاصله پس از پرداخت به صورت خودکار اعمال می شود.
</p>
<form class="form-vertical" id="account_renew" autocomplete="off">
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
            <label for="days">تعداد روز:</label>
        </div>
        <div class="col-sm-10">
            <input type="number" class="form-control" id="days" title="با خرید روز های بیشتر از تخفیف ویژه برخوردار شوید" placeholder="تعداد روز باید بین 30 تا 180 باشد (حداقل 1 و حداکثر 6 ماه)" min="30" max="180" required>
        </div>
    </div>
    <div class="form-group"><hr></div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="resellerId">کد نماینده:</label>
        </div>
        <div class="col-sm-10">
            <input type="resellerId" class="form-control" id="resellerId" placeholder="مربوط به نمایندگان فروش، می توانید این قسمت را خالی بگذارید." maxlength="32">
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="price">مبلغ:</label>
        </div>
        <div class="col-sm-10">
            <div class="row">
                <div class="col-sm-3">
                    <input type="button" class="my-btn submit" id="calculate" value="محاسبه هزینه">
                </div>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="price" disabled>
                </div>
            </div>
        </div>
    </div>
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
    <button type="submit" class="my-btn submit">تمدید اکانت</button>
</form>
<script>
var result = $("#result");
var username = $("#username");
var days = $("#days");
var calculate = $("#calculate");
var price = $("#price");
var resellerId = $("#resellerId");
var captcha = $("#captcha");
$("#account_renew").submit(function(e) {
    e.preventDefault();
    result.attr("class", "alert alert-info");
    result.text("در حال بررسی اطلاعات وارد شده، لطفا منتظر بمانید...");
    result.show();
    var t = "username=" + username.val() + "&days=" + days.val() + "&resellerId=" + resellerId.val() + "&captcha=" + captcha.val();
    if (window.ActiveXObject) {
        http = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        http = new XMLHttpRequest();
    }
    http.open("POST", "/management/AccountRenew.php", true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            if (http.status == 200) {
                if (http.responseText.substring(1, 5) == "form") {
                    result.attr("class", "alert alert-info");
                    result.text("در حال انتقال به درگاه بانک، لطفا منتظر بمانید...");
                    $(http.responseText).appendTo("body").submit().remove();
                    return;
                }
                switch (parseInt(http.responseText, 10)) {
                    case 1:
                        result.attr("class", "alert alert-danger");
                        result.text("کد امنیتی وارد شده اشتباه است.");
                        captcha.val("");
                        captcha.focus();
                        break;
                    case 2:
                        result.attr("class", "alert alert-warning");
                        result.text("نام کاربری یافت نشد.");
                        username.val("");
                        captcha.val("");
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
                result.text("متاسفانه قادر به ارتباط با درگاه بانک نیستیم.");
                $("#account_renew")[0].reset();
                $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                username.focus();
            }
        }
    };
    http.send(t);
});
calculate.click(function() {
    if (username.val() ===  "") {
        price.val("لطفا نام کاربری را وارد نمایید");
        username.focus();
        return;
    }
    if (days.val() ===  "") {
        price.val("لطفا تعداد روز را وارد نمایید");
        days.focus();
        return;
    }
    if (parseInt(days.val(), 10) < 30 || parseInt(days.val(), 10) > 180) {
        price.val("تعداد روز خارج از محدوده مجاز است");
        days.focus();
        return;
    }
    var t = "username=" + username.val() + "&days=" + days.val();
    if (window.ActiveXObject) {
        http = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        http = new XMLHttpRequest();
    }
    http.open("POST", "/management/AccountRenewGetPrice.php", true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            if (http.status == 200) {
                price.val(http.responseText);
            } else {
                price.val("");
            }
            calculate.prop('disabled', false);
        }
    };
    calculate.prop('disabled', true);
    http.send(t);
});
</script>
<?php require_once('../includes/Footer.php'); ?>