import psycopg2

def menu_options():
    print (
        "Enter a number between 1 and 11 to perform the following queries, and 'exit' to exit the program:\n"
        "1. Roll No and Name of all students who are managing the 'Megaevent'\n"
        "2. Roll No and Name of all students who are managing the 'Megaevent' as a 'Secretary'\n"
        "3. Name of all the participants from the college 'IITB' in 'Megaevent'\n"
        "4. Name of all colleges who have at least one participant in 'Megaevent'\n"
        "5. Name of all events managed by a 'Secretary'\n"
        "6. Name all the 'CSE' department student volunteers of 'Megaevent'\n"
        "7. Name of all events which has at least one volunteer from 'CSE' department\n"
        "8. Name of the college with the largest number of participants in 'Megaevent'\n"
        "9. Name of the college with largest participants overall\n"
        "10. Name of the department with the largest number of volunteers in all the events which has at least one participant from 'IITB'\n"
        "11. Roll No and Name of all students who are managing an event (to be inputted by the user)\n"
    )
    
queries = [
"SELECT Student.Roll, Student.Name FROM Student JOIN MANAGE ON Student.Roll = MANAGE.Roll JOIN Event ON MANAGE.EID = Event.EID WHERE Event.EName = 'Megaevent';",
"SELECT Student.Roll, Student.Name FROM Student JOIN MANAGE ON Student.Roll = MANAGE.Roll JOIN Event ON MANAGE.EID = Event.EID JOIN Student_HAS ON Student_HAS.Roll = Student.Roll JOIN Role ON Student_HAS.RID = Role.RID WHERE Event.EName = 'Megaevent' AND Role.Rname = 'Secretary';",
"SELECT Participant.Name FROM Participant JOIN Student_FROM ON Participant.PID = Student_FROM.PID JOIN College ON Student_FROM.College_Name = College.Name JOIN Participant_HAS ON Participant.PID = Participant_HAS.PID JOIN Event ON Participant_HAS.EID = Event.EID WHERE College.Name = 'IIT Bombay' AND Event.EName = 'Megaevent';",
"SELECT DISTINCT College.Name FROM College JOIN Student_FROM ON College.Name = Student_FROM.College_Name JOIN Participant_HAS ON Student_FROM.PID = Participant_HAS.PID JOIN Event ON Participant_HAS.EID = Event.EID WHERE Event.EName = 'Megaevent';",
"SELECT DISTINCT Event.EName FROM Event JOIN MANAGE ON Event.EID = MANAGE.EID JOIN Student ON MANAGE.Roll = Student.Roll JOIN Student_HAS ON Student.Roll = Student_HAS.Roll JOIN Role ON Student_HAS.RID = Role.RID WHERE Role.Rname = 'Secretary';",
"SELECT DISTINCT Student.Name FROM Student JOIN Volunteer ON Student.Roll = Volunteer.Roll JOIN Volunteer_HAS ON Volunteer.Roll = Volunteer_HAS.Roll JOIN Event ON Volunteer_HAS.EID = Event.EID WHERE Student.Dept = 'CSE' AND Event.EName = 'Megaevent';",
"SELECT DISTINCT Event.EName FROM Event JOIN Volunteer_HAS ON Event.EID = Volunteer_HAS.EID JOIN Volunteer ON Volunteer_HAS.Roll = Volunteer.Roll JOIN Student ON Volunteer.Roll = Student.Roll WHERE Student.Dept = 'CSE';",
"SELECT College.Name FROM College JOIN Student_FROM ON College.Name = Student_FROM.College_Name JOIN Participant_HAS ON Student_FROM.PID = Participant_HAS.PID JOIN Event ON Participant_HAS.EID = Event.EID WHERE Event.EName = 'Megaevent' GROUP BY College.Name ORDER BY COUNT(Participant_HAS.PID) DESC LIMIT 1;",
"SELECT College.Name FROM College JOIN Student_FROM ON College.Name = Student_FROM.College_Name JOIN Participant_HAS ON Student_FROM.PID = Participant_HAS.PID GROUP BY College.Name ORDER BY COUNT(Participant_HAS.PID) DESC LIMIT 1;" ,
"SELECT Student.Dept FROM Student JOIN Volunteer ON Student.Roll = Volunteer.Roll JOIN Volunteer_HAS ON Volunteer.Roll = Volunteer_HAS.Roll JOIN Event ON Volunteer_HAS.EID = Event.EID WHERE Event.EID IN (SELECT DISTINCT Participant_HAS.EID FROM Participant_HAS JOIN Student_FROM ON Participant_HAS.PID = Student_FROM.PID WHERE Student_FROM.College_Name = 'IITB') GROUP BY Student.Dept ORDER BY COUNT(Volunteer_HAS.Roll) DESC LIMIT 1;"
]

# Connect to the database remote server 
conn = psycopg2.connect(host="10.5.18.69", database="21CS10064", user="21CS10064", password="21CS10064")

while True:
    #Show all the options in the menu
    menu_options()
    # take input from user
    print("Enter the option: ")
    query_input = input()

    # check if the user wants to exit
    if query_input == "exit":
        break

    # check the query number
    query_number = int(query_input)

    # check if the query number is valid
    if query_number < 1 or query_number > 11:
        print("Invalid query number\n")
        continue

    # Get the query
    if query_number == 11:
        print("Enter the event name: ")
        event_name = input()
        query = queries[0].replace("Megaevent", event_name)
    else:
        query = queries[query_number - 1]

    #Execute the query
    cur = conn.cursor()
    cur.execute(query)

    # display the result
    # display column names
    print("-" * (21 * len(cur.description)+1))
    print("|", end="")
    for desc in cur.description:
        print(f"%-20s|" % desc.name, end="")
    print()
    print("-" * (21 * len(cur.description)+1))

    # If there are no results
    if cur.rowcount == 0:
        print("No results found\n")
        cur.close()
        continue

    for row in cur:
        print("|", end="")
        for col in row:
            print(f"%-20s|"%col, end="")
        print()
    print("-" * (21 * len(cur.description)+1))
    
    cur.close()


