drop table if exists member_eval; 

create temporary table member_eval 
as
select 
	w.groupprojectmemberid,
	max(case when w.isbefore = 'f' then t.value else null end)  as "max_after",
	min(case when w.isbefore = 'f' then t.value else null end)  as "min_after",
	avg(case when w.isbefore = 'f' then t.value else null end)  as "avg_after",
	max(case when w.isbefore = 't' then t.value else null end)  as "max_before",
	min(case when w.isbefore = 't' then t.value else null end)  as "min_before",
	avg(case when w.isbefore = 't' then t.value else null end)  as "avg_before",
	max(case when t.reference='Agree your responsibilities and see them through' and w.isbefore = 'f'  then t.value else null end)  as "agree_your_responsibilities_and_see_them_through_after",
	max(case when t.reference='Settle disagreements' and w.isbefore = 'f'  then t.value else null end)  as "settle_disagreements_after",
	max(case when t.reference='Solve problems' and w.isbefore = 'f'  then t.value else null end)  as "solve_problems_after",
	max(case when t.reference='Deal with power and authority' and w.isbefore = 'f'  then t.value else null end)  as "deal_with_power_and_authority_after",
	max(case when t.reference='Cope with stress and tension' and w.isbefore = 'f'  then t.value else null end)  as "cope_with_stress_and_tension_after",
	max(case when t.reference='Evaluate your own performance' and w.isbefore = 'f'  then t.value else null end)  as "evaluate_your_own_performance_after",
	max(case when t.reference='Communicate' and w.isbefore = 'f'  then t.value else null end)  as "communicate_after",
	max(case when t.reference='Search for information and get advice' and w.isbefore = 'f'  then t.value else null end)  as "search_for_information_and_get_advice_after",
	max(case when t.reference='Work out what youre good and not so good at' and w.isbefore = 'f'  then t.value else null end)  as "work_out_what_youre_good_and_not_so_good_at_after",
	max(case when t.reference='Make decisions' and w.isbefore = 'f'  then t.value else null end)  as "make_decisions_after",
	max(case when t.reference='Negotiate' and w.isbefore = 'f'  then t.value else null end)  as "negotiate_after",
	max(case when t.reference='Plan your time and energy' and w.isbefore = 'f'  then t.value else null end)  as "plan_your_time_and_energy_after",
	max(case when t.reference='Agree your responsibilities and see them through' and w.isbefore = 't'  then t.value else null end)  as "agree_your_responsibilities_and_see_them_through_before",
	max(case when t.reference='Settle disagreements' and w.isbefore = 't'  then t.value else null end)  as "settle_disagreements_before",
	max(case when t.reference='Solve problems' and w.isbefore = 't'  then t.value else null end)  as "solve_problems_before",
	max(case when t.reference='Deal with power and authority' and w.isbefore = 't'  then t.value else null end)  as "deal_with_power_and_authority_before",
	max(case when t.reference='Cope with stress and tension' and w.isbefore = 't'  then t.value else null end)  as "cope_with_stress_and_tension_before",
	max(case when t.reference='Evaluate your own performance' and w.isbefore = 't'  then t.value else null end)  as "evaluate_your_own_performance_before",
	max(case when t.reference='Communicate' and w.isbefore = 't'  then t.value else null end)  as "communicate_before",
	max(case when t.reference='Search for information and get advice' and w.isbefore = 't'  then t.value else null end)  as "search_for_information_and_get_advice_before",
	max(case when t.reference='Work out what youre good and not so good at' and w.isbefore = 't'  then t.value else null end)  as "work_out_what_youre_good_and_not_so_good_at_before",
	max(case when t.reference='Make decisions' and w.isbefore = 't'  then t.value else null end)  as "make_decisions_before",
	max(case when t.reference='Negotiate' and w.isbefore = 't'  then t.value else null end)  as "negotiate_before",
	max(case when t.reference='Plan your time and energy' and w.isbefore = 't'  then t.value else null end)  as "plan_your_time_and_energy_before"
from sandbox.groupprojectmemberskillwheelitem  as t
left JOIN	
	sandbox.groupprojectmemberskillwheel w on  w.id = t.groupprojectmemberskillwheelid
group by 1
;

drop table if exists sandbox.eval_by_project; 

create table sandbox.eval_by_project 
as
select
	g.groupprojectid as "groupprojectid_e",
	avg(e.avg_after) as "evaluation_score_average_after",
	avg(e.avg_before) as "evaluation_score_average_before",
	max(e.max_after) as "evaluation_score_max_after",
	max(e.max_before) as "evaluation_score_max_before",
	min(e.min_after) as "evaluation_score_min_after",
	min(e.min_before) as "evaluation_score_min_before",
	avg(e.agree_your_responsibilities_and_see_them_through_before) as "evaluation_agree_your_responsibilities_and_see_them_through_before",
	avg(e.settle_disagreements_before) as "evaluation_settle_disagreements_before",
	avg(e.solve_problems_before) as "evaluation_solve_problems_before",
	avg(e.deal_with_power_and_authority_before) as "evaluation_deal_with_power_and_authority_before",
	avg(e.cope_with_stress_and_tension_before) as "evaluation_cope_with_stress_and_tension_before",
	avg(e.evaluate_your_own_performance_before) as "evaluation_evaluate_your_own_performance_before",
	avg(e.communicate_before) as "evaluation_communicate_before",
	avg(e.search_for_information_and_get_advice_before) as "evaluation_search_for_information_and_get_advice_before",
	avg(e.work_out_what_youre_good_and_not_so_good_at_before) as "evaluation_work_out_what_youre_good_and_not_so_good_at_before",
	avg(e.make_decisions_before) as "evaluation_make_decisions_before",
	avg(e.negotiate_before) as "evaluation_negotiate_before",
	avg(e.plan_your_time_and_energy_before) as "evaluation_plan_your_time_and_energy_before",
	avg(e.agree_your_responsibilities_and_see_them_through_after) as "evaluation_agree_your_responsibilities_and_see_them_through_after",
	avg(e.settle_disagreements_after) as "evaluation_settle_disagreements_after",
	avg(e.solve_problems_after) as "evaluation_solve_problems_after",
	avg(e.deal_with_power_and_authority_after) as "evaluation_deal_with_power_and_authority_after",
	avg(e.cope_with_stress_and_tension_after) as "evaluation_cope_with_stress_and_tension_after",
	avg(e.evaluate_your_own_performance_after) as "evaluation_evaluate_your_own_performance_after",
	avg(e.communicate_after) as "evaluation_communicate_after",
	avg(e.search_for_information_and_get_advice_after) as "evaluation_search_for_information_and_get_advice_after",
	avg(e.work_out_what_youre_good_and_not_so_good_at_after) as "evaluation_work_out_what_youre_good_and_not_so_good_at_after",
	avg(e.make_decisions_after) as "evaluation_make_decisions_after",
	avg(e.negotiate_after) as "evaluation_negotiate_after",
	avg(e.plan_your_time_and_energy_after) as "evaluation_plan_your_time_and_energy_after",
	count(*) as "evaluation_skills_wheels"
from member_eval e
left join sandbox.groupprojectmember g on e.groupprojectmemberid = g.id
group by 1
;

drop table if exists sandbox.project_analysis_stage;

create table sandbox.project_analysis_stage as 
select 
a.id as groupprojectid,
a.groupid,
a.name,
a.stage,
a.potfundperiodid,
a.potfundamount,
a.contactid,
a.registered,
a.nobenefiting,
a.paneldate,
a.description,
a.panelbudget,
a.panelreport,
a.panelinvoice,
a.evaluationfacilitator,
a.evaluationgroup,
a.evaluationreceipts,
a.evaluationproceeding,
a.evaluationcertificates,
a.groupprojecthistoryid,
a.groupprojectevaluationfacilitatorid,
a.groupprojectpanelreportid,
a.groupprojectpanelinvoiceid,
a.panelstyle,
a.ishistorysubmitted,
a.iscostsubmitted,
a.ispanelreportsubmitted,
a.ispanelinvoicesubmitted,
a.isfacilitatorevaluationsubmitted,
a.isecmsubmitted,
a.isfundreturnsubmitted,
a.statustimestamp,
a.panellocation,
a.minimummembers,
a.isendskillwheel,
a.isindividualplanning,
a.chequenotes,
a.licenseholderid,
a.keyfundstage,
a.projectissues,
a.howwillprojecttackleissues,
a.allmembersnotified,
a.datefacilitatorevalcompleted,
a.projectsubmitteddate,
e.*,
ebp.*,
gpt.*,
groupprojectmember.*,
contact.*,
r.*
from groupproject as a
left join
	eval_by_project as ebp on a.id = ebp.groupprojectid_e
left join
	sandbox.groupprojectfacilitatorevaluation_stage e on a.groupprojectevaluationfacilitatorid = e.id
left join (
	select
		g.id as "group_id_g",
		g.zoneid as "group_zoneid",
		g.type as "group_type",
		g.name as "group_name",
		x.*
	from sandbox.group as g
	left join ( 
		select
			o.id as "organisation_id_o",
			o.name as "organisation_name_messy",
			trim(replace(replace(replace(lower(o.name),'duplicate do not use',''),'duplicate',''),'do not use','')) as "organisation_name",
			o.postcode as "organisation_postcode",
			o.latitude as "organisation_latitude",
			o.longitude as "organisation_longitude"
		from sandbox.organisation as o
		) x on g.organisationid = x.organisation_id_o 
	) as r on a.groupid = r.group_id_g
left join (
	select	
		c.id as "contactid_c",
		c.dob as "contact_dob",	
		c.ismale as "contact_ismale",	
		c.ethnicityref as "contact_ethnicityref",	
		c.jobtitle as "contact_jobtitle",	
		c.crb as "contact_crb",	
		c.crbdate as "contact_crbdate",	
		c.membershiprenewaldate as "contact_membershiprenewaldate",	
		c.islapsedmember as "contact_islapsedmember", 
		c.istrainer as "contact_istrainer",
		c.latitude as "contact_latitude",
		c.longitude as "contact_longitude",
		training.contact_licence_holder_id,
		training.contact_days_since_training,
		training.contact_training_date,
		date_part('d',now() - c.membershiprenewaldate::timestamp) as "contact_days_since_member_renewal",
		date_part('d',now() - c.dob::timestamp)/365 as "contact_age_years"
	from sandbox.contact as c
	left join (
		select 
			td.contactid as "contactid_t",
			min(td.licenseholderid) as "contact_licence_holder_id",
			max(date_part('d',now() - td.date::timestamp)) as "contact_days_since_training",
			min(td.date)::timestamp  as "contact_training_date"
		from trainingdate as td 
		group by 1
		) as training on c.id = training.contactid_t
	) contact on a.contactid = contact.contactid_c
left join (
	select	
		gpm.groupprojectid as "groupproject_id_m",
		count (distinct gpm.groupmemberid) as "group_member_count",
		count (distinct case when gpm.isineducation ='t' then gpm.groupmemberid else null end) as "group_members_ineducation",
		count (distinct case when gpm.ispreviouslyinvolved ='t' then gpm.groupmemberid else null end) as "group_members_previouslyinvolved",
		count (distinct case when gpm.ispublicconsent ='t' then gpm.groupmemberid else null end) as "group_members_publicconsent"
	from sandbox.groupprojectmember as gpm
	group by 1
) as groupprojectmember on a.id = groupprojectmember.groupproject_id_m
left join (
	select 
		y.groupprojectid as "groupprojectid_t",
		count(*) as "group_project_type_count",
		max(case when y.type = 'Media' then 1 else  0 end) as "group_project_type_indicator_media",
		max(case when y.type = 'Sport' then 1 else  0 end) as "group_project_type_indicator_sport",
		max(case when y.type = 'Leisure' then 1 else  0 end) as "group_project_type_indicator_leisure",
		max(case when y.type = 'Arts' then 1 else  0 end) as "group_project_type_indicator_arts",
		max(case when y.type = 'Environmental' then 1 else  0 end) as "group_project_type_indicator_environmental",
		max(case when y.type = 'Health' then 1 else  0 end) as "group_project_type_indicator_health",
		max(case when y.type = 'Community' then 1 else  0 end) as "group_project_type_indicator_community",
		max(case when y.type = 'Social Issues' then 1 else  0 end) as "group_project_type_indicator_socialissues",
		max(case when y.type = 'Employment/Career' then 1 else  0 end) as "group_project_type_indicator_employment",
		max(case when y.type = 'Drama' then 1 else  0 end) as "group_project_type_indicator_drama",
		max(case when y.type = 'Fundraising Activity' then 1 else  0 end) as "group_project_type_indicator_fundraising"
		from sandbox.groupprojecttype as y
		group by 1 
	) as gpt on a.id = gpt.groupprojectid_t
;

drop table if exists sandbox.project_analysis;

create table sandbox.project_analysis
as 
SELECT
	t.*,
	o.organisation_project_bins,
	o.organisation_project_rank_bins,
	project_num_total.contact_project_of_total,
	project_num_completed.contact_project_of_completed,
	projects_total.contact_total_projects,
	projects_completed.contact_total_completed_projects,
	case 
		when projects_completed.contact_total_completed_projects = 1 then '1 Project' 
		when projects_completed.contact_total_completed_projects between 2 and 3 then '2-3 Projects' 
		when projects_completed.contact_total_completed_projects > 4 then '4+ Projects' 
		else 'Other'
	end as "contact_projects_bin",
	case when project_num_total.contact_project_of_total = projects_total.contact_total_projects then 'Last Project' else 'Other' end as "contact_last_project",
	case when project_num_total.contact_project_of_total = projects_total.contact_total_projects then 'Last Completed Project' else 'Other' end as "contact_last_completed_project"
from sandbox.project_analysis_stage t
left join (
		select 
		 f.contactid,
		 max(f.contact_project) as "contact_total_projects"
		from (
			select
				l.contactid,
				rank() over (PARTITION BY l.contactid ORDER BY l.registered ASC) as "contact_project"
			from sandbox.project_analysis_stage l
		) f group by 1) as projects_total on t.contactid = projects_total.contactid
left join(
		select 
		 f.contactid,
		 max(f.contact_project) as "contact_total_completed_projects"
		from (
			select
				l.contactid,
				rank() over (PARTITION BY l.contactid ORDER BY l.registered ASC) as "contact_project"
			from sandbox.project_analysis_stage l where l.stage = 9
		) f group by 1)  as projects_completed on t.contactid = projects_completed.contactid
left join (
	select
		l.groupprojectid,
		l.contactid,
		rank() over (PARTITION BY l.contactid ORDER BY l.registered ASC) as "contact_project_of_total"
	from sandbox.project_analysis_stage l
	) as project_num_total on t.groupprojectid = project_num_total.groupprojectid
left join	
	(select
		l.groupprojectid,
		l.contactid,
		rank() over (PARTITION BY l.contactid ORDER BY l.registered ASC) as "contact_project_of_completed"
	from sandbox.project_analysis_stage l where l.stage = 9) as project_num_completed on t.groupprojectid = project_num_completed.groupprojectid
left join (
	select
	t.organisation_id_o,
	case 
		when t.projects >= 400 then 'Projects 400+' 
		when t.projects between 200 and 399 then 'Projects 200-400+' 
		else 'Projects <200' 
	end as "organisation_project_bins",
	case 
		when t.rank between 1 and 20 then 'Top 20' 
		when t.rank between 21 and 50 then 'Top 21-50' 
		when t.rank between 51 and 100 then 'Top 51-100' 
		when t.rank between 101 and 1000 then 'Top 101-1000' 
		else 'Other' 
	end as "organisation_project_rank_bins"
	from (
		select 
			s.organisation_id_o, 
			count(*) as "projects",
			rank() over (order by count(*) desc) as "rank"
		from sandbox.project_analysis_stage as s
		group by 1
		order by 3 desc
		) as t
	) as o on t.organisation_id_o = o.organisation_id_o
;

drop table if exists sandbox.project_analysis_stage;

