<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);


if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('approved', $input)){
    $approved = $input['approved'];
    $approved_by = $input['approved_by'];
    $log_id = $input['log_id'];
    $id = $input['id'];
    
    // insert tbl_approval
    $sql_insert = 'INSERT INTO tbl_approval_logs(approved, approved_by, log_id)
    VALUES (:approved,:approved_by,:log_id)';

    // update tbl_log
    $sql_update = 'UPDATE tbl_logs SET approval_status=:approval_status WHERE id=:id';

    try {
        // insert
        $sql1 = $conn->prepare($sql_insert);
        $sql1->bindParam(':approved', $approved, PDO::PARAM_INT);
        $sql1->bindParam(':approved_by', $approved_by, PDO::PARAM_STR);
        $sql1->bindParam(':log_id', $log_id, PDO::PARAM_INT);
        $sql1->execute();

        // update
        $sql2 = $conn->prepare($sql_update);
        $sql2->bindParam(':approval_status', $approved, PDO::PARAM_INT);
        $sql2->bindParam(':id', $id, PDO::PARAM_INT);
        $sql2->execute();

        echo json_encode(array('success'=>false,'message'=>'ok'));
    } catch (PDOException $e) {
        echo json_encode(array('success'=>false,'message'=>$e->getMessage()));
    } finally{
        // Closing the connection.
        $conn = null;
    }
}else{
    echo json_encode(array('success'=>false,'message'=>'error input'));
    die();
}
?>