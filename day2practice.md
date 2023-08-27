Q.1 How can you produce a list of the start times for bookings by members named 'David Farrell'?

- Query :
  `SELECT starttime FROM cd.bookings b
  INNER JOIN cd.members m
  ON m.memid = b.memid
  WHERE m.firstname = 'David' AND m.surname = 'Farrell';`

- ![IMAGE](/exercise2/1.png)

Q.2 How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a
list of start time and facility name pairings, ordered by the time.

- Query :
  `SELECT b.starttime AS start,f.name AS name FROM cd.bookings b
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  WHERE DATE(b.starttime) = '2012-09-21' AND f.name in ('Tennis Court 1','Tennis Court 2')
  ORDER BY b.starttime;`

- ![IMAGE](/exercise2/2.png)

Q.3 How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in
the list, and that results are ordered by (surname, firstname).

- Query :
  `SELECT DISTINCT m.firstname,m.surname FROM cd.members m
  INNER JOIN cd.members r
  ON m.memid = r.recommendedby
  ORDER BY m.surname,m.firstname;`

- ![IMAGE](/exercise2/3.png)

Q.4 How can you output a list of all members, including the individual who recommended them (if any)? Ensure that
results are ordered by (surname, firstname).

- Query :
  `SELECT m.firstname AS memfname,m.surname AS memsname,r.firstname AS recfname,r.surname AS recsname
  FROM cd.members m
  LEFT JOIN cd.members r
  ON m.recommendedby = r.memid
  ORDER BY m.surname,m.firstname;`

- ![IMAGE](/exercise2/4.png)

Q.5 How can you produce a list of all members who have used a tennis court? Include in your output the name of the
court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name
followed by the facility name.

- QUERY :
  `SELECT DISTINCT m.firstname || ' ' || m.surname AS member,f.name AS facility
  FROM
  cd.members m
  INNER JOIN cd.bookings b
  ON m.memid = b.memid
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  WHERE f.name IN ('Tennis Court 1','Tennis Court 2') ORDER BY member,facility;`

- ![IMAGE](/exercise2/5.png)

Q.6 How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30?
Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is
always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and
the cost. Order by descending cost, and do not use any subqueries.

- QUERY :
  `SELECT m.firstname || ' ' || m.surname AS member,f.name AS facility,
  CASE
  WHEN m.memid = 0 THEN
  b.slots*f.guestcost
  ELSE
  b.slots*f.membercost
  END AS cost
  FROM
  cd.members m
  INNER JOIN cd.bookings b
  on m.memid = b.memid
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  WHERE
  DATE(starttime) = '2012-09-14' AND
  ((m.memid = 0 AND b.slots*f.guestcost > 30) OR (m.memid != 0 AND b.slots*f.membercost > 30))
  ORDER BY cost DESC;`

- ![IMAGE](/exercise2/6.png)

Q.7 How can you output a list of all members, including the individual who recommended them (if any), without using any
joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a
column and ordered.

- QUERY : `SELECT DISTINCT m.firstname || ' ' || m.surname AS member,
  (SELECT r.firstname || ' ' || r.surname as recommender
  FROM cd.members r
  WHERE r.memid = m.recommendedby
  )
  FROM
  cd.members m
  ORDER BY member;`

- ![IMAGE](/exercise2/7.png)

Q.8 The Produce a list of costly bookings exercise contained some messy logic: we had to calculate the booking cost in
both the WHERE clause and the CASE statement. Try to simplify this calculation using subqueries. For reference, the
question was:
How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30?
Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is
always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and
the cost. Order by descending cost.

- QUERY : `SELECT member, facility, cost FROM (
  SELECT
  m.firstname || ' ' || m.surname AS member,
  f.name AS facility,
  CASE
  WHEN m.memid = 0 THEN
  b.slots*f.guestcost
  ELSE
  b.slots*f.membercost
  END AS cost
  FROM
  cd.members m
  INNER JOIN cd.bookings b
  ON m.memid = b.memid
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  WHERE
  b.starttime >= '2012-09-14' AND
  b.starttime < '2012-09-15'
  ) AS bookings
  WHERE cost > 30
  ORDER BY cost DESC;`

- ![IMAGE](/exercise2/8.png)