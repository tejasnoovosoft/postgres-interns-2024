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

[//]: # (DAY 2 - EXERCISE 2)

Q.1 For our first foray into aggregates, we're going to stick to something simple. We want to know how many facilities
exist - simply produce a total count.

- Query : `SELECT COUNT(facid) FROM cd.facilities; `
- ![image](/exerciseday2/1%20(1).png)

Q.2 Produce a count of the number of facilities that have a cost to guests of 10 or more.

- Query : `SELECT COUNT(facid) FROM cd.facilities WHERE guestcost >= 10;`
- ![image](/exerciseday2/1%20(2).png)

Q.3 Produce a count of the number of recommendations each member has made. Order by member ID.

- Query : `SELECT recommendedby,COUNT(*)
  FROM cd.members WHERE recommendedby IS NOT NULL
  GROUP BY recommendedby
  ORDER BY recommendedby;`
- ![image](/exerciseday2/1%20(3).png)

Q.4 Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of
facility id and slots, sorted by facility id.

- Query : `SELECT facid,SUM(slots) AS Total_Slots
  FROM cd.bookings
  GROUP BY facid
  ORDER BY facid;`
- ![image](/exerciseday2/1%20(4).png)

Q.5 Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output
table consisting of facility id and slots, sorted by the number of slots.

- Query : `SELECT facid,SUM(slots) AS Total_Slots
  FROM cd.bookings
  WHERE starttime >= '2012-09-01' AND starttime < '2012-10-1'
  GROUP BY facid
  ORDER BY SUM(slots);`
- ![image](/exerciseday2/1%20(5).png)

Q.6 Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output
table consisting of facility id and slots, sorted by the id and month.

- Query : `SELECT facid, extract(month FROM starttime) AS month, sum(slots) AS "Total Slots"
  FROM cd.bookings
  WHERE extract(year FROM starttime) = 2012
  group BY facid, month
  ORDER BY facid, month;`
- ![image](/exerciseday2/1%20(6).png)

Q.7 Find the total number of members (including guests) who have made at least one booking.

- Query : `SELECT COUNT(DISTINCT memid) FROM cd.bookings;`
- ![image](/exerciseday2/1%20(7).png)

Q.8 Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and
slots, sorted by facility id.

- Query : `SELECT facid, sum(slots) AS total_slots
  FROM cd.bookings
  GROUP BY facid
  HAVING sum(slots) > 1000
  ORDER BY facid;`
- ![image](/exerciseday2/1%20(8).png)

Q.9 Produce a list of facilities along with their total revenue. The output table should consist of facility name and
revenue, sorted by revenue. Remember that there's a different cost for guests and members!

- Query : `SELECT f.name, sum(slots * CASE
  WHEN memid = 0 THEN f.guestcost
  ELSE f.membercost
  END)
  AS revenue
  FROM cd.bookings b
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  GROUP BY f.name
  ORDER BY revenue;`
- ![image](/exerciseday2/1%20(9).png)

Q.10 Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility
name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
Schema reminder

- Query : `SELECT name, revenue FROM (
  SELECT f.name, sum(CASE
  WHEN memid = 0 THEN slots * f.guestcost
  ELSE slots * membercost
  END) AS revenue
  FROM cd.bookings b
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  GROUP BY f.name
  ) AS agg WHERE revenue < 1000
  ORDER BY revenue;`
- ![image](/exerciseday2/1%20(10).png)

Q.11 Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT
clause. This version will probably look messy!

- Query : `SELECT facid,SUM(slots) AS total_slots
  FROM cd.bookings
  GROUP BY facid
  order by sum(slots) desc
  FETCH FIRST 1 ROW ONLY;`
- ![image](/exerciseday2/1%20(11).png)

Q.12 Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version,
include output rows containing totals for all months per facility, and a total for all months for all facilities. The
output table should consist of facility id, month and slots, sorted by the id and month. When calculating the aggregated
values for all months and all facids, return null values in the month and facid columns.

- Query : `SELECT facid, extract(month FROM starttime) AS month, SUM(slots) AS slots
  FROM cd.bookings
  WHERE starttime >= '2012-01-01' AND starttime < '2013-01-01'
  GROUP BY rollup(facid, month)
  ORDER BY facid, month;`
- ![image](/exerciseday2/1%20(12).png)

Q.13 Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. The
output table should consist of the facility id, name, and hours booked, sorted by facility id. Try formatting the hours
to two decimal places.

- Query : `SELECT
  f.facid,
  f.name,
  ROUND(SUM(b.slots) / 2.0, 2) AS hours_booked
  FROM
  cd.facilities f
  JOIN
  cd.bookings b ON f.facid = b.facid
  GROUP BY
  f.facid, f.name
  ORDER BY
  f.facid;`
- ![image](/exerciseday2/1%20(13).png)

Q.14 Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.

- Query : `SELECT m.surname,m.firstname,m.memid,MIN(b.starttime) AS starttime
  FROM cd.members m
  LEFT JOIN cd.bookings b ON m.memid = b.memid
  WHERE b.starttime > '2012-09-01' AND b.starttime IS NOT NULL
  GROUP BY m.memid
  ORDER BY m.memid;`
- ![image](/exerciseday2/1%20(14).png)

Q.15 Produce a list of member names, with each row containing the total member count. Order by join date, and include
guest members.

- Query : `SELECT COUNT(*) over(),m.firstname,m.surname
  FROM cd.members m
  ORDER BY m.joindate;`
- ![image](/exerciseday2/1%20(15).png)

Q.16 Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing
results get output.

- Query : `SELECT facid, total FROM (
  SELECT facid, sum(slots) total, rank() over (ORDER BY sum(slots) DESC) rank
  FROM cd.bookings
  GROUP BY facid
  )AS ranked
  WHERE rank = 1;`
- ![image](/exerciseday2/1%20(16).png)

Q.17 Produce a list of members (including guests), along with the number of hours they've booked in facilities, rounded
to the nearest ten hours. Rank them by this rounded figure, producing output of first name, surname, rounded hours,
rank. Sort by rank, surname, and first name.

- Query : `SELECT firstname, surname,((sum(bks.slots)+10)/20)*10 AS hours,
  rank() OVER (ORDER BY ((SUM(bks.slots)+10)/20)*10 DESC) AS rank
  FROM cd.bookings bks
  LEFT JOIN cd.members mems
  ON bks.memid = mems.memid
  GROUP BY mems.memid
  ORDER BY rank, surname, firstname;`
- ![image](/exerciseday2/1%20(17).png)

Q.18 Produce a list of the top three revenue generating facilities (including ties). Output facility name and rank,
sorted by rank and facility name.

- Query : `SELECT name, rank FROM (
  SELECT facs.name AS name, RANK() OVER (ORDER BY sum(case
  WHEN memid = 0 THEN slots * facs.guestcost
  ELSE slots * membercost
  END) DESC) AS rank
  FROM cd.bookings bks
  INNER JOIN cd.facilities facs
  ON bks.facid = facs.facid
  group BY facs.name
  ) AS subq
  WHERE rank <= 3
  ORDER BY rank;`
- ![image](/exerciseday2/1%20(18).png)

Q.19 Classify facilities into equally sized groups of high, average, and low based on their revenue. Order by
classification and facility name.

- Query : `SELECT name, CASE WHEN class=1 THEN 'high'
  WHEN class=2 THEN 'average'
  ELSE 'low'
  END revenue
  FROM (
  SELECT f.name AS name, ntile(3) OVER (ORDER BY SUM(CASE
  WHEN memid = 0 THEN slots * f.guestcost
  ELSE slots * membercost
  END) DESC) AS class
  FROM cd.bookings b
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  GROUP BY f.name
  ) AS subq
  ORDER BY class,name;`
- ![image](/exerciseday2/1%20(19).png)

Q.20 Based on the 3 complete months of data so far, calculate the amount of time each facility will take to repay its
cost of ownership. Remember to take into account ongoing monthly maintenance. Output facility name and payback time in
months, order by facility name. Don't worry about differences in month lengths, we're only looking for a rough value
here!

- Query : `SELECT f.name AS name,
  f.initialoutlay/((SUM(CASE
  WHEN memid = 0 THEN slots * f.guestcost
  ELSE slots * membercost
  END)/3) - f.monthlymaintenance) AS months
  FROM cd.bookings b
  INNER JOIN cd.facilities f
  ON b.facid = f.facid
  GROUP BY f.facid
  ORDER BY name;`
- ![image](/exerciseday2/1%20(20).png)

Q.21 For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. Output should
contain date and revenue columns, sorted by the date. Remember to account for the possibility of a day having zero
revenue. This one's a bit tough, so don't be afraid to check out the hint!

- Query : ``SELECT dategen.date,
      (
      SELECT SUM(CASE
      WHEN memid = 0 THEN slots * facs.guestcost
      ELSE slots * membercost
      END) as rev

  	FROM cd.bookings bks
  	INNER JOIN cd.facilities facs
  		ON bks.facid = facs.facid
  	WHERE bks.starttime > dategen.date - interval '14 days'
  		AND bks.starttime < dategen.date + interval '1 day'
      )/15 AS revenue
  FROM
  (
  SELECT cast(generate_series(timestamp '2012-08-01',
  '2012-08-31','1 day') AS date) AS date
  )  AS dated
  ORDER BY dategen.date;`