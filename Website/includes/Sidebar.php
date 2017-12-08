<?php
require_once '../server/Database.php';

$version      = 'خطا';
$releaseDate  = 'خطا';
$fileSize     = 'خطا';
$downloadLink = '#';

$database = databaseConnect();
if ($database != NULL) {
    $query = "SELECT version, release_date "
           . "FROM program "
           . "WHERE id = 1";
    $result = mysqli_query($database, $query);

    $program     = mysqli_fetch_assoc($result);
    $version     = $program['version'];
    $releaseDate = $program['release_date'];

    $fileName = "../downloads/AFK-Manager-{$version}-Setup.exe";
    if (file_exists($fileName)) {
        $fileSize = filesize($fileName);
        $fileSize = round($fileSize / 1024 / 1024, 2) . ' مگابایت';

        $downloadLink = $fileName;
    }
}
?>
<section id="content">
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <aside id="sidebar">
                    <h3 class="title">دانلود آخرین نسخه</h3>
                    <table class="table table-bordered">
                        <tr>
                            <th>نسخه</th>
                            <td><?php echo $version; ?></td>
                        </tr>
                        <tr>
                            <th>زمان انتشار</th>
                            <td><?php echo $releaseDate; ?></td>
                        </tr>
                        <tr>
                            <th>حجم فایل</th>
                            <td><?php echo $fileSize; ?></td>
                        </tr>
                        <tr>
                            <th>دانلود</th>
                            <td><a href="<?php echo $downloadLink; ?>"><span class="glyphicon glyphicon-download-alt" style="font-size:20px;"></span></a></td>
                        </tr>
                    </table>
                </aside>
            </div>
            <div class="col-md-9">