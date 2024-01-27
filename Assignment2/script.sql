-- Create college table
CREATE TABLE college (
    name VARCHAR(511) PRIMARY KEY,
    location VARCHAR(2047) NOT NULL
);

-- Insert sample data into college table
INSERT INTO college (name, location) VALUES
    ('IITB', 'Mumbai'),
    ('MIT', 'Cambridge'),
    ('Stanford', 'Palo Alto'),
    ('Harvard', 'Cambridge'),
    ('Caltech', 'Pasadena');

-- Create participant table
CREATE TABLE participant (
    pid VARCHAR(20) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Insert sample data into participant table
INSERT INTO participant (pid, name) VALUES
    ('P001', 'John Doe'),
    ('P002', 'Jane Smith'),
    ('P003', 'Michael Johnson'),
    ('P004', 'Emily Brown'),
    ('P005', 'Robert Davis');

-- Create volunteer table
CREATE TABLE volunteer (
    roll VARCHAR(20) PRIMARY KEY
);

-- Insert sample data into volunteer table
INSERT INTO volunteer (roll) VALUES
    ('V001'),
    ('V002'),
    ('V003'),
    ('V004'),
    ('V005');

-- Create event table
CREATE TABLE event (
    eid VARCHAR(20) PRIMARY KEY,
    date DATE NOT NULL,
    ename VARCHAR(255) NOT NULL,
    type VARCHAR(255)
);

-- Insert sample data into event table
INSERT INTO event (eid, date, ename, type) VALUES
    ('E001', '2024-02-01', 'Megaevent', 'Conference'),
    ('E002', '2024-02-15', 'Tech Symposium', 'Symposium'),
    ('E003', '2024-03-05', 'Sports Fest', 'Sports'),
    ('E004', '2024-04-10', 'Cultural Night', 'Cultural'),
    ('E005', '2024-05-20', 'Workshop Series', 'Workshop');

-- Create student table
CREATE TABLE student (
    roll VARCHAR(20) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dept VARCHAR(255) NOT NULL
);

-- Insert sample data into student table
INSERT INTO student (roll, name, dept) VALUES
    ('S001', 'Alice Johnson', 'CSE'),
    ('S002', 'Bob Smith', 'ECE'),
    ('S003', 'Charlie Brown', 'Mechanical'),
    ('S004', 'Diana Davis', 'Chemical'),
    ('S005', 'Edward White', 'Civil');

-- Create role table
CREATE TABLE role (
    rid VARCHAR(20) PRIMARY KEY,
    rname VARCHAR(255) NOT NULL,
    description VARCHAR(255)
);

-- Insert sample data into role table
INSERT INTO role (rid, rname, description) VALUES
    ('R001', 'Secretary', 'Manages administrative tasks'),
    ('R002', 'Treasurer', 'Handles financial matters'),
    ('R003', 'President', 'Leads and oversees the organization'),
    ('R004', 'Event Coordinator', 'Plans and coordinates events'),
    ('R005', 'Public Relations Officer', 'Manages public relations and communications');

-- Create student_from table
CREATE TABLE student_from (
    college_name VARCHAR(255),
    pid VARCHAR(20),
    PRIMARY KEY (college_name, pid),
    FOREIGN KEY (college_name) REFERENCES college(name),
    FOREIGN KEY (pid) REFERENCES participant(pid)
);

-- Insert sample data into student_from table
INSERT INTO student_from (college_name, pid) VALUES
    ('IITB', 'P001'),
    ('MIT', 'P002'),
    ('Stanford', 'P003'),
    ('Harvard', 'P004'),
    ('Caltech', 'P005');

-- Create participant_has table
CREATE TABLE participant_has (
    pid VARCHAR(20),
    eid VARCHAR(20),
    PRIMARY KEY (pid, eid),
    FOREIGN KEY (pid) REFERENCES participant(pid),
    FOREIGN KEY (eid) REFERENCES event(eid)
);

-- Insert sample data into participant_has table
INSERT INTO participant_has (pid, eid) VALUES
    ('P001', 'E001'),
    ('P002', 'E002'),
    ('P003', 'E003'),
    ('P004', 'E004'),
    ('P005', 'E005');

-- Create volunteer_has table
CREATE TABLE volunteer_has (
    roll VARCHAR(20),
    eid VARCHAR(20),
    PRIMARY KEY (roll, eid),
    FOREIGN KEY (roll) REFERENCES volunteer(roll),
    FOREIGN KEY (eid) REFERENCES event(eid)
);

-- Insert sample data into volunteer_has table
INSERT INTO volunteer_has (roll, eid) VALUES
    ('V001', 'E001'),
    ('V002', 'E002'),
    ('V003', 'E003'),
    ('V004', 'E004'),
    ('V005', 'E005');

-- Create manage table
CREATE TABLE manage (
    roll VARCHAR(20),
    eid VARCHAR(20),
    PRIMARY KEY (roll, eid),
    FOREIGN KEY (roll) REFERENCES student(roll),
    FOREIGN KEY (eid) REFERENCES event(eid)
);

-- Insert sample data into manage table
INSERT INTO manage (roll, eid) VALUES
    ('S001', 'E001'),
    ('S002', 'E002'),
    ('S003', 'E003'),
    ('S004', 'E004'),
    ('S005', 'E005');

-- Create student_has table
CREATE TABLE student_has (
    roll VARCHAR(20),
    rid VARCHAR(20),
    PRIMARY KEY (roll, rid),
    FOREIGN KEY (roll) REFERENCES student(roll),
    FOREIGN KEY (rid) REFERENCES role(rid)
);

-- Insert sample data into student_has table
INSERT INTO student_has (roll, rid) VALUES
    ('S001', 'R001'),
    ('S002', 'R002'),
    ('S003', 'R003'),
    ('S004', 'R004'),
    ('S005', 'R005');

-- Query 1: Roll number and name of all the students who are managing the “Megaevent”
SELECT Student.Roll, Student.Name
FROM Student
JOIN MANAGE ON Student.Roll = MANAGE.Roll
JOIN Event ON MANAGE.EID = Event.EID
WHERE Event.EName = 'Megaevent';

-- Query 2: Roll number and name of all the students who are managing “Megevent” as an “Secretary”
SELECT Student.Roll, Student.Name
FROM Student
JOIN MANAGE ON Student.Roll = MANAGE.Roll
JOIN Event ON MANAGE.EID = Event.EID
JOIN Role ON MANAGE.Roll = Role.RID
WHERE Event.EName = 'Megaevent' AND Role.Rname = 'Secretary';

-- Query 3: Name of all the participants from the college “IITB” in “Megaevent”
SELECT Participant.Name
FROM Participant
JOIN Student_FROM ON Participant.PID = Student_FROM.PID
JOIN College ON Student_FROM.College_Name = College.Name
JOIN Participant_HAS ON Participant.PID = Participant_HAS.PID
JOIN Event ON Participant_HAS.EID = Event.EID
WHERE College.Name = 'IIT Bombay' AND Event.EName = 'Megaevent';

-- Query 4: Name of all the colleges who have at least one participant in “Megaevent”
SELECT DISTINCT College.Name
FROM College
JOIN Student_FROM ON College.Name = Student_FROM.College_Name
JOIN Participant_HAS ON Student_FROM.PID = Participant_HAS.PID
JOIN Event ON Participant_HAS.EID = Event.EID
WHERE Event.EName = 'Megaevent';

-- Query 5: Name of all the events which is managed by a “Secretary”
SELECT DISTINCT Event.EName
FROM Event
JOIN MANAGE ON Event.EID = MANAGE.EID
JOIN Student ON MANAGE.Roll = Student.Roll
JOIN Role ON MANAGE.Roll = Role.RID
WHERE Role.Rname = 'Secretary';

-- Query 6: Name of all the “CSE” department student volunteers of “Megaevent”
SELECT DISTINCT Student.Name
FROM Student
JOIN Student_HAS ON Student.Roll = Student_HAS.Roll
JOIN Role ON Student_HAS.RID = Role.RID
JOIN Volunteer ON Student.Roll = Volunteer.Roll
JOIN Volunteer_HAS ON Volunteer.Roll = Volunteer_HAS.Roll
JOIN Event ON Volunteer_HAS.EID = Event.EID
WHERE Student.Dept = 'CSE' AND Event.EName = 'Megaevent';

-- Query 7: Name of all the events which has at least one volunteer from “CSE”
SELECT DISTINCT Event.EName
FROM Event
JOIN Volunteer_HAS ON Event.EID = Volunteer_HAS.EID
JOIN Volunteer ON Volunteer_HAS.Roll = Volunteer.Roll
JOIN Student ON Volunteer.Roll = Student.Roll
WHERE Student.Dept = 'CSE';

-- Query 8: Name of the college with the largest number of participants in “Megaevent ”
SELECT College.Name
FROM College
JOIN Student_FROM ON College.Name = Student_FROM.College_Name
JOIN Participant_HAS ON Student_FROM.PID = Participant_HAS.PID
JOIN Event ON Participant_HAS.EID = Event.EID
WHERE Event.EName = 'Megaevent'
GROUP BY College.Name
ORDER BY COUNT(Participant_HAS.PID) DESC
LIMIT 1;

-- Query 9: Name of the college with largest number of participant over all
SELECT College.Name
FROM College
JOIN Student_FROM ON College.Name = Student_FROM.College_Name
JOIN Participant_HAS ON Student_FROM.PID = Participant_HAS.PID
GROUP BY College.Name
ORDER BY COUNT(Participant_HAS.PID) DESC
LIMIT 1;

-- Query 10: Name of the department with the largest number of volunteers in all the events which has at least one participant from “IITB”
SELECT Student.Dept
FROM Student
JOIN Student_HAS ON Student.Roll = Student_HAS.Roll
JOIN Volunteer ON Student.Roll = Volunteer.Roll
JOIN Volunteer_HAS ON Volunteer.Roll = Volunteer_HAS.Roll
JOIN Event ON Volunteer_HAS.EID = Event.EID
WHERE Event.EID IN (
    SELECT DISTINCT Participant_HAS.EID
    FROM Participant_HAS
    JOIN Student_FROM ON Participant_HAS.PID = Student_FROM.PID
    WHERE Student_FROM.College_Name = 'IITB'
    )
GROUP BY Student.Dept
ORDER BY COUNT(Volunteer_HAS.Roll) DESC
LIMIT 1;

