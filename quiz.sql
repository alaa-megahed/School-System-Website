-- USE School_System;

CREATE TABLE Bus
(
	bus_number INT,
    route varchar(500),
    model varchar(100),
    capacity INT,
    cur_capacity INT,
    school_id INT NOT NULL,
    PRIMARY KEY (bus_number),
    FOREIGN KEY (school_id) REFERENCES Schools(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Student_Join_Bus
(
	student_ssn INT,
    bus_number INT,
    PRIMARY KEY (student_ssn),
    FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE,
    FOREIGN KEY (bus_number) REFERENCES Bus(bus_number) ON DELETE CASCADE
);


-- procedure-calls after executing the procedure file
CALL insert_bus(50, 1, 'rehab-tagamoaa', '123',35);
CALL add_student_to_bus(612065, 50);

CALL average_capacity();
