<?php
	header('Access-Control-Allow-Origin: *');
	header('Access-Control-Allow-Methods: GET, POST');
	header("Access-Control-Allow-Headers: X-Requested-With");

	session_start();
	
	include '../common/config.php';
    
	$json['RET'] = true;
	$json['RET_MSG'] = "";

	$API = $_POST['API'];
    
    switch($API)
    {
    case "CHECK_VERSION":
    {
        if($_POST['version'] == "1.0.0"){
            $json['RET'] = true;
            $json['apiFileUrl'] = 'http://bbiby2.godohosting.com/gangnamkorea/api/api_1_0_0.php';
        }
        else{
            $json['RET'] = false;
        }

        echo json_encode($json);
    }
    break;
    default:
    {
    }
    }


?>