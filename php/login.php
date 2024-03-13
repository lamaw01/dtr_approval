<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

// if not put id die
if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('employee_id', $input)){
    $employee_id = $input['employee_id'];
    $password = $input['password'];

    $sql_login = "SELECT tbl_approvers.id, tbl_approvers.employee_id, tbl_employee.last_name,tbl_employee.first_name,tbl_employee.middle_name  FROM tbl_approvers
    LEFT JOIN tbl_employee ON tbl_approvers.employee_id = tbl_employee.employee_id
    WHERE tbl_approvers.employee_id = :employee_id AND BINARY tbl_approvers.password = :password";
    //md5()
    try {
        $sql1= $conn->prepare($sql_login);
        $sql1->bindParam(':employee_id', $employee_id, PDO::PARAM_STR);
        $sql1->bindParam(':password', $password, PDO::PARAM_STR);
        $sql1->execute();
        $result_sql1 = $sql1->fetch(PDO::FETCH_ASSOC);
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