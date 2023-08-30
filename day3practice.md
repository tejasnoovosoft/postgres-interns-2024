[//]: # (SECTION FIRST)

Q.1 The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

- Query : `insert into cd.facilities values (9,'Spa',20,30,100000,800);`
- ![image](/exerciseday3/section1/1%20(1).png)

Q.2 In the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one
command. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.

- Query : `insert into cd.facilities values
  (9,'Spa',20,30,100000,800),
  (10,'Squash Court 2',3.5,17.5,5000,80);`
- ![image](/exerciseday3/section1/1%20(2).png)

Q.3 Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the
value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

- Query : `insert into cd.facilities values
  ((select max(facid) from cd.facilities)+1,'Spa',20,30,100000,800);`
- ![image](/exerciseday3/section1/1%20(3).png)

Q.4 We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000:
you need to alter the data to fix the error.

- Query : `UPDATE cd.facilities
  SET initialoutlay = 10000
  WHERE facid = 1;`
- ![image](/exerciseday3/section1/1%20(4).png)

Q.5 We want to increase the price of the tennis courts for both members and guests. Update the costs to be 6 for
members, and 30 for guests.

- Query : `UPDATE cd.facilities
  SET membercost = 6,guestcost=30
  WHERE facid IN (0,1);`
- ![image](/exerciseday3/section1/1%20(5).png)

Q.6 We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this
without using constant values for the prices, so that we can reuse the statement if we want to

- Query : `UPDATE cd.facilities
  SET membercost = membercost + (SELECT membercost FROM cd.facilities WHERE facid = 0)*0.1,
  guestcost = guestcost + (SELECT guestcost FROM cd.facilities WHERE facid = 0)*0.1
  WHERE facid = 1;`
- ![image](/exerciseday3/section1/1%20(6).png)

Q.7 As part of a clear out of our database, we want to delete all bookings from the cd.bookings table. How can we
accomplish this?

- Query : `DELETE FROM cd.bookings;`
- ![image](/exerciseday3/section1/1%20(7).png)

Q.8 We want to remove member 37, who has never made a booking, from our database. How can we achieve that?

- Query : `DELETE FROM cd.members WHERE memid = 37;`
- ![image](/exerciseday3/section1/1%20(8).png)

Q.9 In our previous exercises, we deleted a specific member who had never made a booking. How can we make that more
general, to delete all members who have never made a booking?

- Query : `DELETE FROM cd.members WHERE memid NOT IN (SELECT memid FROM cd.bookings);`
- ![image](/exerciseday3/section1/1%20(9).png)

[//]: # (SECTION SECOND)

Q.1 Output the names of all members, formatted as 'Surname, Firstname'

- Query : `SELECT (surname||', '||firstname) AS name FROM cd.members;`
- ![image](/exerciseday3/section2/1%20(1).png)

Q.2 Find all facilities whose name begins with 'Tennis'. Retrieve all columns.

- Query : `SELECT * FROM cd.facilities WHERE name LIKE 'Tennis%';`
- ![image](/exerciseday3/section2/1%20(2).png)

Q.3 Perform a case-insensitive search to find all facilities whose name begins with 'tennis'. Retrieve all columns.

- Query : `SELECT * FROM cd.facilities WHERE LOWER(name) LIKE 'tennis%';`
- ![image](/exerciseday3/section2/1%20(3).png)

Q.4 You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to
find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member
ID.

- Query : `SELECT memid,telephone FROM cd.members WHERE telephone LIKE '(%)%';`
- ![image](/exerciseday3/section2/1%20(4).png)

Q.5 The zip codes in our example dataset have had leading zeroes removed from them by virtue of being stored as a
numeric type. Retrieve all zip codes from the members table, padding any zip codes less than 5 characters long with
leading zeroes. Order by the new zip code.

- Query : `SELECT LPAD(CAST(zipcode AS CHAR(5)),5,'0') zip FROM cd.members ORDER BY zip;`
- ![image](/exerciseday3/section2/1%20(5).png)

Q.6 You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet.
Sort by the letter, and don't worry about printing out a letter if the count is 0.

- Query : `SELECT SUBSTR (mems.surname,1,1) AS letter, COUNT(*) AS count
  FROM cd.members mems
  GROUP BY letter
  ORDER BY letter;`
- ![image](/exerciseday3/section2/1%20(6).png)

Q.7 The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids
and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.

- Query : `SELECT memid, TRANSLATE(telephone, '-() ', '') AS telephone
  FROM cd.members
  ORDER BY memid;`
- ![image](/exerciseday3/section2/1%20(7).png)

[//]: # (SECTION THIRD)

Q.1 Produce a timestamp for 1 a.m. on the 31st of August 2012.

- Query : `SELECT TIMESTAMP '2012-08-31 01:00:00';`
- ![image](/exerciseday3/section3/a%20(1).png)

Q.2 Find the result of subtracting the timestamp '2012-07-30 01:00:00' from the timestamp '2012-08-31 01:00:00'

- Query : `SELECT TIMESTAMP '2012-08-31 01:00:00' - TIMESTAMP '2012-07-30 01:00:00' as interval;`
- ![image](/exerciseday3/section3/a%20(2).png)

Q.3 Produce a list of all the dates in October 2012. They can be output as a timestamp (with time set to midnight) or a
date.

- Query : `SELECT generate_series(TIMESTAMP '2012-10-01', TIMESTAMP '2012-10-31', INTERVAL '1 day') AS ts;`
- ![image](/exerciseday3/section3/a%20(3).png)

Q.4 Get the day of the month from the timestamp '2012-08-31' as an integer.

- Query : `SELECT EXTRACT(DAY FROM TIMESTAMP '2012-08-31');`
- ![image](/exerciseday3/section3/a%20(4).png)

Q.5 Work out the number of seconds between the timestamps '2012-08-31 01:00:00' and '2012-09-02 00:00:00'

- Query : `SELECT ROUND(EXTRACT(epoch FROM (TIMESTAMP '2012-09-02 00:00:00' - '2012-08-31 01:00:00')));`
- ![image](/exerciseday3/section3/a%20(5).png)

Q.6 For each month of the year in 2012, output the number of days in that month. Format the output as an integer column
containing the month of the year, and a second column containing an interval data type.

- Query : `SELECT EXTRACT(MONTH FROM cal.month) AS month,
  (cal.month + interval '1 month') - cal.month AS length
  FROM
  (
  SELECT generate_series(timestamp '2012-01-01', timestamp '2012-12-01', interval '1 month') AS month
  ) cal
  ORDER BY month;`
- ![image](/exerciseday3/section3/a%20(6).png)

Q.7 For any given timestamp, work out the number of days remaining in the month. The current day should count as a whole
day, regardless of the time. Use '2012-02-11 01:00:00' as an example timestamp for the purposes of making the answer.
Format the output as a single interval value.

- Query : `select (date_trunc('month',ts.testts) + interval '1 month')
  date_trunc('day', ts.testts) as remaining
  from (select timestamp '2012-02-11 01:00:00' as testts) ts`
- ![image](/exerciseday3/section3/a%20(7).png)

Q.8 Return a list of the start and end time of the last 10 bookings (ordered by the time at which they end, followed by
the time at which they start) in the system.

- Query : `select starttime, starttime + slots*(interval '30 minutes') endtime
  from cd.bookings
  order by endtime desc, starttime desc
  limit 10`
- ![image](/exerciseday3/section3/a%20(8).png)

Q.9 Return a count of bookings for each month, sorted by month

- Query : `select date_trunc('month', starttime) as month, count(*)
  from cd.bookings
  group by month
  order by month`
- ![image](/exerciseday3/section3/a%20(9).png)