-- ------------------------------------------------------
--  Solving SQL Murder Mystery 
-- viewing the different tables and contents 
-- ------------------------------------------------------
select *
FROM crime_scene_report

select *
from drivers_license

select *
from facebook_event_checkin

select *
from get_fit_now_check_in

select *
from get_fit_now_member

select *
from income

select *
from interview

select *
from person

select *
from solution

-- ----------------------------------
-- finding the crime scene report --
-- ----------------------------------
select description
from crime_scene_report
where city = 'SQL City' and type = 'murder' and date = 20180115

-- ------------------------------------------------------------------------------------------------
-- crime scene report reveals 2 witnesses - 1st lives at last house on Northwestern Dr and 2nd, 
-- Annabel lives somewhere on Franklin Ave --
-- derive the person id for the witnesses to get their interview ---
-- ------------------------------------------------------------------------------------------------
select * , max(address_number)
from person
where address_street_name = 'Northwestern Dr'

-- -------------------------------------------------------
-- id for 4919 western dr is 14887, Morty Schapiro ---
-- -------------------------------------------------------
select *
from person
where address_street_name = 'Franklin Ave' and name like '%Annabel%'

-- ----------------------------------------------------------
-- id for 103 franklin ave is 16371, Annabel Miller ---
-- getting the interview transcript ---
-- ----------------------------------------------------------
select person.name, interview.transcript, interview.person_id
from person
join interview
on person.id = interview.person_id
where person.id = 14887 or person.id = 16371

-- --------------------------------------------------------------------
-- Annabel Miller recognised murderer as gym member, Jan 9th 2018-----
-- Morty saw man with 'get fit now gym' bag, with gold member # 48Z --
-- who got into a car with plates which included H42W ----
-- look for gym members on Jan 9th ---
-- look for gym members with Morty's details --
-- ---------------------------------------------------------------------
select check_in_date, membership_id
from get_fit_now_check_in
where check_in_date = 20180109
and membership_id like '%48Z%'

-- ---------------------------------------------------------------------
-- got two membership ids -  48Z7A and 48Z55 ---
-- find which of the two has a car with plates H42W ---
-- ----------------------------------------------------------------------
select *
FROM drivers_license
where plate_number like '%H42W%'
and gender = 'male'

-- --------------------------------------------------------------------------------------
-- plates 0H42W2 with licence id 423327 ---
-- plates 4H42WR with licence id 664760----
-- get person_id with gold membership status and id of 48Z from get_fit_now_member table
-- ---------------------------------------------------------------------------------------
select *
from get_fit_now_member
where id like '%48Z%'
and membership_status = 'gold'

-- ------------------------------------------------------
-- 48Z7A, person_id 28819 Joe Germuska --
-- 48Z55, person_id 67318 Jeremy Bowers--
-- ----------------------------------------------------------
select *
from person 
where license_id = 423327 or license_id = 664760

-- --------------------------------------------------------
-- person_id 51739, Tushar Chandra license id 664760
-- person_id 67318, Jeremy Bowers license id 67318
-- SO THE KILLER IS JEREMY BOWERS --
-- finding out if he gave any interviews-
-- ------------------------------------------------------
select *
from interview
where person_id = 67318

-- -------------------------------------------------------------
-- he was hired by a red-haired woman, who drives a Tesla Model S
-- height - 5'5'(65") or 5'7'(67")
-- she attended the SQL Symphony Concert 3 times in December 2017
-- so find the woman who ordered the murder
-- get females with a Tesla Model S
-- --------------------------------------------------------------

select *
from drivers_license
where car_make = 'Tesla'
and car_model = 'Model S'
and gender = 'female'
and hair_color = 'red'

-- --------------------------------------------------------------------------
-- license id 202298 
-- license id 291182
-- license id 918773
-- find names of people with this license and ssn to get their income--
-- ---------------------------------------------------------------------

select *
from person
where license_id = 202298 or license_id = 291182 or license_id = 918773

-- ----------------------------------------------------------------------------
-- got three individuals - 2 females and 1 male. will disregard the male --
-- Regina george, person_id 90700
-- Miranda Priestly, person_id 99716
-- will person a search to check which of these women fir the description given
-- by Jeremy Bowers--
-- ---------------------------------------------------------------------------
select person.id, person.name, drivers_license.id, drivers_license.height, 
drivers_license.car_make, drivers_license.car_model, person.ssn
from person
join drivers_license
on person.license_id = drivers_license.id
where drivers_license.id like 
(select drivers_license.id
from drivers_license
where car_make = 'Tesla'
and car_model = 'Model S'
and gender = 'female'
and hair_color = 'red')

-- -----------------------------------------------------------------------------------
-- search revealed Miranda Priestly as the mastermind and murderer
-- will perform a confirmatory check, utilising all the evidence given
-- confirm from the ssn of the two women to find the wealthy one
-- ssn 337169072 regina George
-- ssn 987756388 Miranda Priestly
-- confirm to see if Miranda Priestly attended the SQL symphony concert 3 times
-- confirm that Miranda Priestly acted on her own and does not have any other conspirators
-- -----------------------------------------------------------------------------------------
select *
from income
where ssn = 987756388 or ssn = 337169072

select *
from facebook_event_checkin
where person_id = 99716

select *
from interview
where person_id = 99716

-- ------------------------------------------------------------------------------------------
-- the Murderers are Jeremy Bowers and Miranda Priestly
-- Miranda Priestly contracted Jeremy Bowers to kill the victim
-- Write the solution into the solution table and check solution
-- ------------------------------------------------------------------------------------------

INSERT INTO solution (user, value)
VALUES (99716, 'Miranda Priestly')

INSERT INTO solution (user, value)
VALUES (67318, 'Jeremy Bowers')