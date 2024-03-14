<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

// if not put id die
if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('id', $input)){
    $id = $input['id'];

    $sql_get_for_approval_loadmore = "SELECT tbl_logs.id, tbl_logs.employee_id, tbl_employee.first_name, tbl_employee.last_name, tbl_employee.middle_name, tbl_logs.log_type, tbl_logs.latlng, tbl_logs.image_path,department,tbl_logs.team, tbl_logs.selfie_timestamp as time_stamp FROM tbl_logs
    LEFT JOIN tbl_employee ON tbl_logs.employee_id = tbl_employee.employee_id
    WHERE tbl_logs.is_selfie = 1 AND tbl_logs.approval_status = 0 AND tbl_logs.id < :id ORDER BY tbl_logs.id DESC LIMIT 100;";

    try {
        $sql1= $conn->prepare($sql_get_for_approval_loadmore);
        $sql1->bindParam(':id', $id, PDO::PARAM_INT);
        $sql1->execute();
        $result_sql1 = $sql1->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result_sql1);
    } catch (PDOException $e) {
        echo json_encode(array('success'=>false,'message'=>$e->getMessage()));
    } finally{
        // Closing the connection.
        $conn = null;
    }
}
else{
    echo json_encode(array('success'=>false,'message'=>'Error input'));
    die();
}
?>