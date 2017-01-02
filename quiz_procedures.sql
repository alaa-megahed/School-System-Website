
DELIMITER //
CREATE PROCEDURE insert_bus(IN bus_number INT, IN school_id INT, IN route VARCHAR(500), IN model VARCHAR(100), IN capacity INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM Bus B WHERE B.bus_number = bus_number)
	THEN 
    BEGIN 
		INSERT INTO Bus (bus_number, school_id, route, model, capacity, cur_capacity) VALUES (bus_number, school_id, route, model, capacity, capacity);
    END;
    END IF;
END //

CREATE PROCEDURE add_student_to_bus(IN student_ssn INT, IN bus_number INT)
BEGIN 
	DECLARE student_school_id INT;
    DECLARE bus_school_id INT;
    DECLARE bus_cur_capacity INT;
    SELECT S.school_id INTO student_school_id
    FROM Students S 
    WHERE S.ssn = student_ssn;
    SELECT B.school_id INTO bus_school_id
    FROM Bus B
    WHERE B.bus_number = bus_number;

    IF (student_school_id = bus_school_id)
    THEN BEGIN
    	SELECT B.cur_capacity INTO bus_cur_capacity FROM Bus B WHERE B.bus_number = bus_number;
    	IF(bus_cur_capacity > 0)
    	THEN BEGIN
    		INSERT INTO Student_Join_Bus(student_ssn, bus_number) VALUES (student_ssn, bus_number);
    		UPDATE Bus B SET B.cur_capacity = B.cur_capacity - 1 WHERE B.bus_number = bus_number;
    	END;
    	END IF;
    END;
    END IF; 

END //

CREATE PROCEDURE average_capacity()
BEGIN 
	SELECT B.school_id, Avg(B.capacity)
	FROM Bus B
	GROUP BY B.school_id;
END //

DELIMITER ;