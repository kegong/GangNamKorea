<?php
	header('Access-Control-Allow-Origin: *');
	header('Access-Control-Allow-Methods: GET, POST');
	header("Access-Control-Allow-Headers: X-Requested-With");

	session_start();
	
	include '../common/config.php';

	$json['RET'] = true;
	$json['RET_MSG'] = "";

	$API = $_POST['API'];
    $userNo = $_POST['userNo'];

    if($API == null|| $API=="" || $API=="TEMP")
    {
        $json['RET'] = false;
        $json['RET_MSG'] = "Empty API";
        echo json_encode($json);
        exit;
    }

    if($API != "LOGIN" && $API != "JOIN")
    {
        if($userNo == null || $userNo == 0)
        {
            $json['RET'] = false;
            $json['RET_MSG'] = "Error userNo";
            echo json_encode($json);
            exit;
        }

        if($_SESSION['userNo'] != $userNo)
        {
            // $json['session'] = 0;
            $query = "SELECT userNo FROM GK_USER WHERE userNo = $userNo AND authKey = '$_POST[authKey]'";

            $result = mysqli_query($connect, $query);
            $data = mysqli_fetch_array($result);
            if(!$data)
            {
                $json['RET'] = false;
                $json['RET_MSG'] = "Error auth";
                echo json_encode($json);
                exit;
            }

            $_SESSION['userNo'] = $data['userNo'];
        }
        else
        {
            // $json['session'] = $_SESSION['userNo'];
        }
    }
	
switch($API)
{
    case "USER_LOGIN":
    {
        // 인증키 가져와서 없으면 유저 생성
        $query = "SELECT userNo, authKey FROM GK_USER WHERE loginID = '$_POST[loginID]' AND loginPW = md5('$_POST[loginPW]') ";

        $result = mysqli_query($connect, $query);
        $data = mysqli_fetch_array($result);
        if(!$data)
        {
            $json['RET'] = false;
            $json['RET_MSG'] = "아이디 또는 비밀번호가 틀립니다.";
            echo json_encode($json);
            exit;
        }
        
        $userNo = $data['userNo'];
        $authKey = $data['authKey'];

        $query = "UPDATE GK_USER SET loginDate = now() WHERE userNo = $userNo";
        $result = mysqli_query($connect, $query);

        $json['userNo'] = $userNo;
        $json['authKey'] = $authKey;

        echo json_encode($json);
    }
    break;
    case "USER_JOIN":
    {
        // loginID 체크
        $query = "SELECT userNo FROM GK_USER WHERE loginID = '$_POST[loginID]'";
        $result = mysqli_query($connect, $query);
        if($data = mysqli_fetch_array($result))
        {
            $json['RET'] = false;
            $json['RET_MSG'] = "동일한 아이디가 존재합니다.";
            echo json_encode($json);
            exit;
        }

        // nickName 체크
        $query = "SELECT userNo FROM GK_USER WHERE nickName = '$_POST[nickName]'";
        $result = mysqli_query($connect, $query);
        if($data = mysqli_fetch_array($result))
        {
            $json['RET'] = false;
            $json['RET_MSG'] = "동일한 닉네임이 존재합니다.";
            echo json_encode($json);
            exit;
        }

        $query = "INSERT INTO GK_USER(userNo, authKey, nickName, loginID, loginPW, grade, joinDate, loginDate) 
                    VALUES( null, '$_POST[authKey]', '$_POST[nickName]', '$_POST[loginID]', md5('$_POST[loginPW]'), 1, now(), now() )";
        $result = mysqli_query($connect, $query);
        if($result != 1)
        {
            $json['RET'] = false;
            $json['RET_MSG'] = "시스템 에러 입니다.";
            echo json_encode($json);
            exit;
        }

        $userNo = mysqli_insert_id($connect);
        $authKey = $_POST['authKey'];

        $json['userNo'] = $userNo;
        $json['authKey'] = $authKey;

        echo json_encode($json);
    }
    break;
    case "POST_WRITE":
    {
        // imageKey
        // boardNo, author, anonymity, subject, content, thumbOriginUrl
        $categoryNo = 0;
        $subMenuNo = 0;
        $thumbUrl = $_POST['thumbOriginUrl'];
        $query = "INSERT INTO GK_POST(postNo, userNo, categoryNo, subMenuNo, boardNo, author, anonymity, `subject`, content, thumbUrl, readCnt, replyCnt, likeCnt, unlikeCnt, wdate) 
                VALUES( null, $userNo, $categoryNo, $subMenuNo, $_POST[boardNo], '$_POST[author]', $_POST[anonymity], '$_POST[subject]', '$_POST[content]', '$thumbUrl', 0, 0, 0, 0, now() )";
        $result = mysqli_query($connect, $query);
        if($result != 1)
        {
            $json['RET'] = false;
            $json['RET_MSG'] = "시스템 에러 입니다.";
            echo json_encode($json);
            exit;
        }

        $postNo = mysqli_insert_id($connect);

        // POST_IMAGE 업데이트

        $json['postNo'] = $postNo;

        echo json_encode($json);
    }
    break;
    case "POST_MODIFY":
    {
        echo json_encode($json);
    }
    break;
    case "POST_DELETE":
    {
        $query = "DELETE FROM GK_POST WHERE userNo = $userNo AND postNo = '$_POST[postNo]'";
        $result = mysqli_query($connect, $query);

        echo json_encode($json);
    }
    break;
    case "POST_LIST":
    {
        // pageNo

        $index = 0;
        $posts = array();

        $pageLimit = 50;
        $page = $_POST['pageNo']*$pageLimit;

        $query = "SELECT postNo, author, 'subject', thumbUrl, readCnt, replyCnt, likeCnt, wdate FROM GK_POST WHERE 1 
                    ORDER BY wdate DESC LIMIT $page, $pageLimit";

        $result = mysqli_query($connect, $query);
        while($data = mysqli_fetch_array($result))
        {
            $posts[$index]['postNo'] = $data['postNo'];
            $posts[$index]['author'] = $data['author'];
            $posts[$index]['subject'] = $data['subject'];
            $posts[$index]['thumbUrl'] = $data['thumbUrl'];
            $posts[$index]['readCnt'] = $data['readCnt'];
            $posts[$index]['replyCnt'] = $data['replyCnt'];
            $posts[$index]['likeCnt'] = $data['likeCnt'];
            $posts[$index]['wdate'] = $data['wdate'];
        }

        $json['posts'] = $posts;

        echo json_encode($json);
    }
    break;

}

?>