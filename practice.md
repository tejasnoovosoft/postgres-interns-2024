Q.1 How can you retrieve all the information from the cd.facilities table?

- Query : `SELECT * FROM cd.facilities`;

- ![image](/images/ex1.png)

Q.2 You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of
only facility names and costs?

- Query : `SELECT name,membercost FROM cd.facilities;`

- ![image](/images/ex2.png)

Q.3 How can you produce a list of facilities that charge a fee to members?

- Query :
  `SELECT * FROM cd.facilities WHERE membercost != 0;`

- ![image](/images/ex3.png)

Q.4 How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the
monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in
question.

- Query : `
  SELECT facid,name,membercost,monthlymaintenance
  FROM cd.facilities
  where membercost <= monthlymaintenance/50
  AND membercost != 0;`

- ![image](/images/ex4.png)

Q.5 How can you produce a list of all facilities with the word 'Tennis' in their name?

- Query :
  `SELECT * FROM cd.facilities
  WHERE name LIKE '%Tennis%';`

- ![image](/images/ex5.png)

Q.6 How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

- Query : `SELECT * FROM cd.facilities WHERE facid IN (1,5);`

- ![image](/images/ex6.png)

Q.7 How can you produce a list of facilities, with each labelled as 'cheap' or 'expensive' depending on if their monthly
maintenance cost is more than $100? Return the name and monthly maintenance of the facilities in question.

- Query :
  `SELECT name,
  CASE WHEN (monthlymaintenance > 100) then 'expensive'
  ELSE 'cheap'
  END AS cost
  FROM cd.facilities; `

- ![image](/images/ex7.png)

Q.8 How can you produce a list of members who joined after the start of September 2012? Return the memid, surname,
firstname, and joindate of the members in question.

- Query :
  `SELECT memid, surname, firstname, joindate
  FROM cd.members
  WHERE joindate >= '2012-09-01';`

- ![image](/images/ex8.png)

Q.9 How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain
duplicates.

- Query :
  `SELECT DISTINCT surname
  FROM cd.members
  ORDER BY surname
  LIMIT 10;`

- ![image](/images/ex9.png)

Q.10 You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived
example :-). Produce that list!

- Query :
  `SELECT surname
  FROM cd.members
  UNION
  SELECT name
  FROM cd.facilities;`

- ![image](/images/ex10.png)

Q.11 You'd like to get the signup date of your last member. How can you retrieve this information?

- Query :
  `SELECT joindate AS latest
  FROM cd.members
  ORDER BY joindate DESC
  LIMIT 1; `

- ![image](/images/ex11.png)

Q.12 You'd like to get the first and last name of the last member(s) who signed up - not just the date. How can you do
that?

- Query : 
  `SELECT firstname, surname, joindate
  FROM cd.members
  WHERE joindate =
  (SELECT max(joindate)
  FROM cd.members);      `

- ![image](/images/ex12.png)