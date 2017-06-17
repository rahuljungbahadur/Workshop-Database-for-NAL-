#Queries
#This query retrieves trainer name, workshop topic, organization name, workshop presentation quality
#where quality of presentation quality is greater than 2
select awic_trainer.trainer_name, workshop.topic, organization.organization_name, workshop.presentation_quality
from (((workshop
inner join workshop_trainer on workshop.workshop_id = workshop_trainer.workshopID)
inner join awic_trainer on workshop_trainer.trainerID = awic_trainer.trainer_id)
inner join organization on organization.organization_id = workshop.organization_id)
where presentation_quality > 2 order by presentation_quality;

#this query retrieves the total amount and organization name for every organization
select sum(payment_info.amount_paid) as total_amount, organization.organization_name
from (payment_info
inner join organization on organization.organization_id = payment_info.org_id)
group by org_id order by total_amount;

#retrieves average of the overall rating of all workshops conducted by an organization
select avg(workshop.overall_rating) as average_rating, organization.organization_name
from (workshop
inner join organization on workshop.organization_id = organization.organization_id)
group by workshop.organization_id order by average_rating;

#retrieves number of attendees, workshop title and the start date of the workshop for every 
#workshop ordered in 
#increasing order of the number of attendees
select count(workshop_has_attendee.Attendee_Attendee_id) as registered_count, workshop.topic, workshop.start_date
from (workshop
inner join workshop_has_attendee on workshop.workshop_id = workshop_has_attendee.Workshop_workshop_id)
group by workshop.workshop_id
order by registered_count;

#fetches results of all attendees from every workshop in order of timestamp. This gives the list of the attendees who are eligible to attend (i.e not on the waitlist)
select workshop_has_attendee.Attendee_Attendee_id , workshop.topic, workshop.start_date, concat(attendee.first_name,' ', attendee.last_name) as attendee_name
from (workshop
inner join workshop_has_attendee on workshop.workshop_id = workshop_has_attendee.Workshop_workshop_id)
inner join attendee on attendee.Attendee_id = workshop_has_attendee.Attendee_Attendee_id
order by workshop_has_attendee.Reg_Time ASC limit 10;

#This query gives us details about how many attendees each organization is sending for workshops.
select count(attendee.Attendee_id) as registered_count, organization.organization_name
from (attendee
inner join organization on attendee.attendee_orgID = organization.organization_is)
group by organization.organization_id
order by registered_count;

#The below query returns the ratio of number of people who are experienced in databases to the number of people who aren't 
select (
(select count(workshop_has_attendee.Attendee_Attendee_id) from workshop_has_attendee
inner join attendee on attendee.Attendee_id = workshop_has_attendee.Attendee_Attendee_id
inner join workshop on workshop.workshop_id = workshop_has_attendee.Workshop_workshop_id
where attendee.experienced_db_searcher = 1 and Workshop_workshop_id = 205)/(select count(workshop_has_attendee.Attendee_Attendee_id) from workshop_has_attendee
inner join attendee on attendee.Attendee_id = workshop_has_attendee.Attendee_Attendee_id
inner join workshop on workshop.workshop_id = workshop_has_attendee.Workshop_workshop_id
where attendee.experienced_db_searcher = 0 and Workshop_workshop_id = 205)) as Experienced_DB_professionals_ratio, workshop.topic, workshop.location_address
from (workshop
inner join workshop_has_attendee on workshop.workshop_id = workshop_has_attendee.Workshop_workshop_id)
inner join attendee on attendee.Attendee_id = workshop_has_attendee.Attendee_Attendee_id
where workshop_id = 205
group by workshop_id order by Experienced_DB_professionals_ratio;

