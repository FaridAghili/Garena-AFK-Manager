<?php require_once('../includes/Header.php'); ?>
<?php require_once('../includes/Navigation.php'); ?>
<?php require_once('../includes/Sidebar.php'); ?>
<h3 class="title3">خرید اکانت</h3>
<p>
با استفاده از فرم زیر می توانید با توجه به نیاز خود نسبت به خرید اکانت AFK Manager اقدام نمایید.<br>
اکانت خریداری شده بلافاصله پس از پرداخت فعال شده و قابل استفاده می باشد.
</p>
<form class="form-vertical" id="account_purchase" autocomplete="off">
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
            <input type="text" class="form-control" id="username" placeholder="فقط از حروف و اعداد انگلیسی استفاده شود" maxlength="16" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="password">گذرواژه:</label>
        </div>
        <div class="col-sm-10">
            <input type="password" class="form-control" id="password" maxlength="31" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="email">ایمیل:</label>
        </div>
        <div class="col-sm-10">
            <input type="email" class="form-control" id="email" placeholder="اطلاعات اکانت شما به این آدرس ارسال خواهد شد" maxlength="64" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="mobile">شماره موبایل:</label>
        </div>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="mobile" title="لطفا شماره موبایل را بدون صفر و خط فاصله وارد کنید" placeholder="فرمت صحیح: 9123456789" maxlength="10" required>
        </div>
    </div>
    <div class="form-group"><hr></div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="days">تعداد روز:</label>
        </div>
        <div class="col-sm-10">
            <input type="number" class="form-control" id="days" title="با خرید روز های بیشتر از تخفیف ویژه برخوردار شوید" placeholder="تعداد روز باید بین 30 تا 180 باشد (حداقل 1 و حداکثر 6 ماه)" min="30" max="180" required>
        </div>
    </div>
    <div class="form-group">
        <div class="col-sm-2">
            <label for="users">تعداد کاربران:</label>
        </div>
        <div class="col-sm-10">
            <input type="number" class="form-control" id="users" title="حداکثر کاربرانی که می توانند بطور همزمان از این اکانت استفاده کنند" placeholder="تعداد کاربران باید بین 1 تا 3 باشد (حداقل 1 و حداکثر 3 کاربر)" min="1" max="3" required>
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
            <input type="text" class="form-control" id="price" disabled>
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
    <button type="submit" class="my-btn submit">خرید اکانت</button>
</form>
<script>
function setPrice() {
    var e = parseInt(days.val(), 10);
    var t = parseInt(users.val(), 10);
    if (e >= 30 && e <= 180 && t >= 1 && t <= 3) {
    } else {
        price.val("تعداد روز و یا تعداد کاربران خارج از محدوده مجاز است");
        return;
    }
    var n, r;
    if (e >= 5 && e <= 15) {
        n = 185;
        r = 155 - t * 7;
    } else if (e >= 16 && e <= 30) {
        n = 184;
        r = 154 - t * 7;
    } else if (e >= 31 && e <= 45) {
        n = 183;
        r = 153 - t * 7;
    } else if (e >= 46 && e <= 60) {
        n = 182;
        r = 152 - t * 7;
    } else if (e >= 61 && e <= 75) {
        n = 181;
        r = 151 - t * 7;
    } else if (e >= 76 && e <= 90) {
        n = 180;
        r = 150 - t * 7;
    } else if (e >= 91 && e <= 105) {
        n = 179;
        r = 149 - t * 7;
    } else if (e >= 106 && e <= 120) {
        n = 178;
        r = 148 - t * 7;
    } else if (e >= 121 && e <= 135) {
        n = 177;
        r = 147 - t * 7;
    } else if (e >= 136 && e <= 150) {
        n = 176;
        r = 146 - t * 7;
    } else if (e >= 151 && e <= 165) {
        n = 175;
        r = 145 - t * 7;
    } else {
        n = 174;
        r = 144 - t * 7;
    }
    var i = t > 1 ? r * (t - 1) * e : 0;
    var s = e * 80 * t;
    var o = (e * n) + i + s;
    price.val(o + " تومان");
}
var result = $("#result");
var username = $("#username");
var password = $("#password");
var email = $("#email");
var mobile = $("#mobile");
var days = $("#days");
var users = $("#users");
var resellerId = $("#resellerId");
var price = $("#price");
var captcha = $("#captcha");
$("#account_purchase").submit(function(e) {
    e.preventDefault();
    result.attr("class", "alert alert-info");
    result.text("در حال بررسی اطلاعات وارد شده، لطفا منتظر بمانید...");
    result.show();
    var t = "username=" + username.val() + "&password=" + password.val() + "&email=" + email.val() + "&mobile=" + mobile.val() + "&days=" + days.val() + "&users=" + users.val() + "&resellerId=" + resellerId.val() + "&captcha=" + captcha.val();
    if (window.ActiveXObject) {
        http = new ActiveXObject("Microsoft.XMLHTTP");
    } else {
        http = new XMLHttpRequest();
    }
    http.open("POST", "/management/AccountPurchase.php", true);
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
                        result.text("این نام کاربری قبلا انتخاب شده است.");
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
                $("#account_purchase")[0].reset();
                $("#captcha_image").attr("src", "/img/Captcha.php?" + Math.random());
                username.focus();
            }
        }
    };
    http.send(t);
});
days.on("keyup", setPrice);
days.on("change", setPrice);
users.on("keyup", setPrice);
users.on("change", setPrice);
bypass.on("change", setPrice);
</script>
<?php require_once('../includes/Footer.php'); ?>