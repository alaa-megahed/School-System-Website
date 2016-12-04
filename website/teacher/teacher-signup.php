<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="../bootstrap.css">
<link rel="stylesheet" type="text/css" href="teacher.css">
<head>
	<title>Teacher Signup</title>
</head>
<?php
include "../connection-values.php"; 
$fname = $mname = $lname = $email = $address = $gender = $birthdate = ""; 
$fnameErr = $lnameErr = $emailErr = $genderErr = $birthdateErr = "";
if($_SERVER["REQUEST_METHOD"] == "POST") {
	if (empty($_POST["fname"])) {
		$fnameErr = "First name is required";
	} else {
		$fname = $_POST['fname'];
	}
	$mname = $_POST['mname'];
	if (empty($_POST["lname"])) {
		$lnameErr = "Last name is required";
	} else {
		$lname = $_POST['lname'];
	}
	if (empty($_POST["email"])) {
		$emailErr = "Email is required";
	} else {
		$email = $_POST['email'];
	}
	$address = $_POST['address'];
	if (empty($_POST["gender"])) {
		$genderErr = "Gender is required";
	} else {
		$gender = $_POST['gender'];
	}
	if (empty($_POST["birthdate"])) {
		$birthdateErr = "Birthdate is required";
	} else {
		$birthdate = $_POST['birthdate'];
	} 
	
	$school_id = $_POST['school']; 

	$call = $conn->prepare('CALL teacher_sign_up(?, ?, ?, ?, ?, ?, ?, ?)'); 
	$call->bind_param(sssssssi, $fname, $mname, $lname, $birthdate, $address, $email, $gender, $school_id); 
	if($call->execute()){
		echo "<h2> You have successfully signed up. Please wait for a confirmation email containing your username and password. </h2>"; 
	} else {
		echo $call->error; 
	}
}

	
?>
<body>
<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">Radwa and Alaa</a>
			</div>
			
			<ul class="nav navbar-nav">
				<li class="active"><a href="../index.php">Home</a></li>
				<li><a href="../view-schools.php">View Schools</a></li>
			</ul>
			
			<form id = "search-bar"  method = "post" class="navbar-form navbar-right" action = "search-schools.php">
				<div class="form-group">
					<input  type="text" class="form-control" placeholder="Search schools by name, address or type" name="school">
				</div>
				<button type="submit" class="btn btn-default">Search</button>
			</form>

		</div>
	</nav>
	<div class="container">
		<div class = "row" class = "center">
			<div id="sign-up" class = "col-md-4 col-centered">
				<h1> Sign Up As A Teacher </h1> 
				<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
					<div class="form-group">
						<label>First name: </label>
						<span class="error">* <?php echo $fnameErr;?></span>
						<input type="text" class="form-control" placeholder="First name" name = "fname">
					</div>

					<div class="form-group">
						<label>Middle name: </label>
						<input type="text" class="form-control" placeholder="Middle name" name = "mname">
					</div>
					<div class="form-group">
						<label>Last name: </label>
						<span class="error">* <?php echo $lnameErr;?></span>
						<input type="text" class="form-control" placeholder="Last name" name = "lname">		
					</div>
					<div class="form-group">
						<label>Email: </label>
						<span class="error">* <?php echo $emailErr;?></span>
						<input type="text" class="form-control" placeholder="Email" name = "email">
					</div>

					<div class="form-group">
						<label>Address: </label>
						<input type="text" class="form-control" placeholder="Address" name = "address">
					</div>
					<div class="form-group">
						<label>Birthdate: </label>
						<span class="error">* <?php echo $birthdateErr;?></span>
						<input type="date" class="form-control" name = "birthdate">

					</div>
					<div class = "form-group">
						<label>Gender: </label>
						<span class="error">* <?php echo $genderErr;?></span>
						<label class = "radio-inline">
							<input type="radio" name = "gender" value = "female"> female
						</label>

						<label class = "radio-inline">
							<input type="radio" name = "gender" value = "male"> male
						</label>
						<br>
						<label>Apply in: </label>
						<select name="school" >
							<!-- <option value="html">html</option>
							<option value="css">CSS</option>
							<option value="javascript">JavaScript</option>
							<option value="php">PHP</option> -->

							<?php
								if($call = $conn->query("SELECT S.id, S.name FROM Schools S")) {
									echo "WEEEE!!"; 
									while($row = $call->fetch_array(MYSQLI_BOTH)) {
										echo '<option value ="' . $row["id"] . '">' . $row["name"] . ' </option>'; 
									} 	
								} else {
									echo $call->error; 
								}
								

							?>
						</select>
						<br>
						
					</div>
					<button type="submit" class="btn btn-default">Sign up</button>
				</form>
			</div>
		</div>
	</body>
	</html>

