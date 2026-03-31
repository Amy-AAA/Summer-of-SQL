sql-mruder
--You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City
--Start by retrieving the corresponding crime scene report from the police department's database.

SELECT *
FROM crime_scene_report
WHERE date = '20180115'
 AND type = 'murder'
 AND city IS 'SQL City';    
--results show there are 2 witnessess - one lives at the last house on Northwestern Dr and second is Annabel who lives 
--somewhere on Franklin Ave

SELECT *
FROM person
WHERE address_street_name IS 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;
-- witness 1
SELECT *
FROM person
WHERE (address_street_name IS 'Franklin Ave' AND name LIKE 'Annabel%');
-- witness 2

SELECT *
FROM interview
WHERE person_id = '14887';
-- witness 1's transcript: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag.
--The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a 
--plate that included "H42W"

SELECT *
FROM interview
WHERE person_id = '16371';
--witness 2's transcript: I saw the murder happen, and I recognized the killer from my gym when I was working out last
-- week on January the 9th.

SELECT GFM.id,
GFCI.membership_id,
GFM.person_id,
GFM.name,
GFM.membership_status,
GFCI.check_in_date
FROM get_fit_now_member as GFM
JOIN get_fit_now_check_in as GFCI on GFCI.membership_id = GFM.id
WHERE GFCI.membership_id LIKE '48Z%'
AND GFM.membership_status = 'gold'
AND GFCI.check_in_date = '20180109';
-- this returns two members: 1- Joe Germuska with id 28819 and gym id 48Z7A 2- Jeremy Bowers with id 67318 and gym id 48Z55


SELECT P.id,
P.name,
P.license_id,
D.id,
D.plate_number
FROM drivers_license as D
JOIN person as P on P.license_id = D.id
WHERE plate_number LIKE '%H42W%'
  AND P.id = '28819' OR P.id = '67318' ;
-- this tells us that the potential suspect is Jeremy Bowers with id 67318!

--Bonus task: Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying
--the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your
--SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect
--to check your answer.

--query 1:
SELECT *
FROM interview
WHERE person_id = '67318';
-- Jeremy's transcript reads: 	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5"
--(65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3
--times in December 2017.

--query 2:
SELECT FEC.person_id,
FEC.event_name,
FEC.date,
P.id,
P.name,
P.license_id,
DL.id,
DL.height,
DL.hair_color,
DL.car_make,
DL.car_model
FROM facebook_event_checkin as FEC
JOIN person as P on P.id = FEC.person_id
JOIN drivers_license as DL on DL.id = P.license_id
WHERE event_name is 'SQL Symphony Concert'
AND FEC.date LIKE '201712%'
AND car_make = 'Tesla'
AND car_model = 'Model S'
AND hair_color = 'red'
AND (height >= '65' AND height <= '67');
-- this reveals that the murderer is infact Miranda Priestly!
