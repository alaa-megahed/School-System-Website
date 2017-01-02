<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="../bootstrap.css">
<link rel="stylesheet" type="text/css" href="parent.css">
<head>
	<title>Parent - View Teachers</title>
</head>
<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
include "../connection-values.php";
$id = $_GET['id']; 

$call = $conn->prepare('SELECT * FROM Parents WHERE id = ?'); 
$call->bind_param('i', $id); 
if($call->execute()) {
	$result = $call->get_result(); 
	$parent = $result->fetch_array(MYSQLI_BOTH);	
} else {
	echo $call->error; 
} 

//getting child's info for later user  
$call->prepare('SELECT POS.child_ssn, S.first_name, S.last_name, S.school_id FROM Parent_Of_Student POS INNER JOIN Students S ON S.ssn = POS.child_ssn WHERE POS.parent_id = ?'); 
$call->bind_param('i', $id); 
if($call->execute()) {
	$children = $call->get_result(); 
	$call->close(); 	
} else {
	echo $call->error; 
}

//getting report reply 

if(!empty($_GET['child_ssn']) && !empty($_GET['teacher_id']) && !empty('report_date')) {
	$child_ssn = $_GET['child_ssn']; 
	$teacher_id = $_GET['teacher_id']; 
	$report_date = $_GET['report_date']; 
	$reply = $_POST[$child_ssn.$teacher_id.$report_date]; 
	echo $reply;
}
?>
<body>
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">Radwa and Alaa</a>
			</div>
			
			<ul class="nav navbar-nav">
				<li class="active"><a href="../index.php">Log Out</a></li>
				<li><a href="../view-schools.php">View Schools</a></li>
			</ul>
			
			<form id = "search-bar"  method = "post" class="navbar-form navbar-right" action = "../search-schools.php">
				<div class="form-group">
					<input  type="text" class="form-control" placeholder="Search schools by name, address or type" name="school">
				</div>
				<button type="submit" class="btn btn-default">Search</button>
			</form>

		</div>
	</nav>
	<div class = "container-custom container-fluid">
		<div class="row">
			<div class="col-md-3 ">
				<img id = "logo" src="parent-icon.png" class="img-responsive img-circle margin" width = "300" height="300">	

			</div>
			<div id = "welcome-panel" class="col-md-7 col-md-offset-1 jumbotron">
				<h1>Welcome, <?php echo $parent['first_name']; ?>!</h1> 
				<h3>We are here to help you take care of your children's education.</h3>
				<p> Here you can view your children's educators and rate them. </p> 
			</div>	
		</div>

		
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-3 sidenav">
				<h4>All You Need In One Place </h4>
				<ul class="nav nav-pills nav-stacked">
					<li><a href="<?php echo 'parent.php?id=' . $id; ?>">Apply for your Children</a></li>
					<li><a href="<?php echo 'parent-accepted.php?id=' . $id; ?>">View Accepted Applications</a></li>
					<li><a href="<?php echo 'parent-view-reports.php?id=' . $id; ?>">View Reports</a></li>
					<li id="active-button" class="active"><a href="<?php echo 'parent-view-teachers.php?id=' . $id; ?>">View Teachers</a></li>
					<li><a href="<?php echo 'parent-view-schools.php?id=' . $id; ?>">View and Review Schools</a></li>
					<li><a href="<?php echo 'parent-reviews.php?id=' . $id; ?>">All Your Reviews</a></li>
				</ul><br>
				<div class="input-group">
					<input type="text" class="form-control" placeholder="Search Blog..">
					<span class="input-group-btn">
						<button class="btn btn-default" type="button">
							<span class="glyphicon glyphicon-search"></span>
						</button>
					</span>
				</div>
			</div>

			<div class="col-md-9">
				<?php
				while($row = $children->fetch_array(MYSQLI_BOTH)) {
						// echo $row[0];
					echo "
					<div>
						
						<table class = 'table'> 
							<h1> $row[1]  $row[2] </h1>
							<thead>
								<tr>
									<th>Teacher Name</th>
									<th>Course </th>
									<th>Grade </th>
									<th> Average Rating </th> 
									<th width> Rate </th>
								</tr>
							</thead>
							<tbody> 
								"; 
								if($call = $conn->prepare('CALL parent_view_child_teachers(?)')) {
									$call->bind_param('i',$row[0]);	


									if($call->execute()) {
							// echo "CALLED PROCEDURE"; 
										$result = $call->get_result(); 
										$call->close(); 
										while($record = $result->fetch_array(MYSQLI_BOTH)) {
											echo 
											"<tr> 
											<td>$record[1] $record[2]</td>
											<td>$record[4]</td>
											<td>$record[5]</td>
											"; 	
											if($ratecall = $conn->prepare('CALL view_rating_teacher(?)')) {
												$ratecall->bind_param('i', $record[0]); 
												if($ratecall->execute()) {
													// echo "CALLED"; 
													$result2 = $ratecall->get_result(); 
													if($record2 = $result2->fetch_array(MYSQLI_BOTH)) {
														echo "<td> $record2[1] </td>"; 
													} else {
														echo "<td> No rating yet. </td>"; 
													}
													$ratecall->close(); 
												} else {
													echo "CALL error 2"; 
													echo $ratecall->error; 
												}
											} else {
												echo "FAILED TO PREPARE"; 
												$conn->error;  
											}


											echo "
											<td> <a href = 'parent-rate-teacher.php?id=$id&teacher_id=$record[0]' class = 'btn btn-success' > View and Rate </a>
											</tr>"; 

										}

									} else {
										echo "CALL ERROR 1"; 
										echo $call->error; 
									}

								} else {
						// echo "YA5TAAAAY\t";
						// echo $id . " " . $row[0];  
									echo $conn->error; 
								}
							}
							echo "</table>
						</div> 
						"; 
						?>
					</div>
				</div>
			</div>	
		</body>
		</html>