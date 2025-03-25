
/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost >0
LIMIT 0 , 30

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * )
FROM Facilities
WHERE membercost =0

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost >0
AND membercost < ( monthlymaintenance * 0.2 )
LIMIT 0 , 30

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid
IN ( 1, 5 )
LIMIT 0 , 30

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance >100
THEN 'expensive'
ELSE 'cheap'
END AS cost_category
FROM Facilities
LIMIT 0 , 30

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (
SELECT MAX( joindate )
FROM Members )

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT BF.name, M.firstname, M.surname
FROM (

SELECT B.memid, F.name
FROM Bookings AS B
JOIN Facilities AS F ON B.facid = F.facid
AND F.name LIKE 'Tennis Court%'
) AS BF
JOIN Members AS M ON BF.memid = M.memid
ORDER BY M.firstname, M.surname
LIMIT 0 , 30


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name AS facility_name, m.firstname, m.surname,
CASE
WHEN b.memid =0
THEN b.slots * f.guestcost
ELSE b.slots * f.membercost
END AS cost
FROM Bookings AS b
JOIN Facilities AS f ON b.facid = f.facid
JOIN Members AS m ON b.memid = m.memid
WHERE DATE( b.starttime ) = '2012-09-14'
AND (
(
b.memid =0
AND b.slots * f.guestcost >30
)
OR (
b.memid !=0
AND b.slots * f.membercost >30
)
)
ORDER BY cost DESC
LIMIT 0 , 30

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT facility_name, firstname, surname, cost
FROM (

SELECT f.name AS facility_name, m.firstname, m.surname,
CASE
WHEN b.memid =0
THEN b.slots * f.guestcost
ELSE b.slots * f.membercost
END AS cost, b.starttime
FROM Bookings AS b
JOIN Facilities AS f ON b.facid = f.facid
JOIN Members AS m ON b.memid = m.memid
) AS bookings_with_costs
WHERE DATE( starttime ) = '2012-09-14'
AND cost >30
ORDER BY cost DESC