                    </div>
                </div>
            </div>
        </section>
        <footer id="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <h3 class="blue">اکانت</h3>
                        <div class="line"></div>
                        <ul class="nav navbar-nav">
                            <li><a href="/AccountPurchase">خرید</a></li>
                            <li><a href="/AccountRenew">تمدید</a></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h3 class="blue">گذواژه</h3>
                        <div class="line"></div>
                        <ul class="nav navbar-nav">
                            <li><a href="/PasswordChange">تغییر</a></li>
                            <li><a href="/PasswordReset">بازیابی</a></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h3 class="blue">دسترسی سریع</h3>
                        <div class="line"></div>
                        <ul class="nav navbar-nav">
                            <li><a href="/Changelog">لیست تغییرات</a></li>
                            <li><a href="/FAQ">سوالات متداول</a></li>
                            <li><a href="/Contact">تماس</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div id="copyright">
                <div class="container">
                    تمامی حقوق مادی و معنوی وبسایت محفوظ است.
                </div>
            </div>
        </footer>
        <script>
        $(".below_hide").hide();
        $('*[title]').tooltip();

        $("li").hover(function() {
            $(this).find('.dropdown-menu').slideDown();
        }, function() {
            $(this).find('.dropdown-menu').slideUp();
        });

        $(".changelog").on('click', function() {
            var tr = $(this).parent().parent();
            if (tr.next().css('display') === 'none') {
                $(this).find('.glyphicon').removeClass('glyphicon-chevron-down');
                $(this).find('.glyphicon').addClass('glyphicon-chevron-up');
                tr.next().show();
            } else {
                tr.next().hide();
                $(this).find('.glyphicon').removeClass('glyphicon-chevron-up');
                $(this).find('.glyphicon').addClass('glyphicon-chevron-down');
            }
        });
        </script>
    </body>
</html>