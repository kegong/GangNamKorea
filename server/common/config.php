<?php

$connect =  mysqli_connect('localhost', 'bbiby2', 'dhfbehd1!');
					
if (!$connect) 
{
	die('Not connected : ');
}

if (!mysqli_select_db($connect, 'bbiby2_godohosting_com') ) 
{
    die ('DB Error: ' . mysqli_error($connect));
}

?>
