#define JOB_MODIFICATION_MAP_NAME "PubbyStation"

/datum/job/hos/New()
	procstart = null
	src.procstart = null
	..()
	MAP_JOB_CHECK
	access += ACCESS_CREMATORIUM
	minimal_access += ACCESS_CREMATORIUM

/datum/job/warden/New()
	procstart = null
	src.procstart = null
	..()
	MAP_JOB_CHECK
	access += ACCESS_CREMATORIUM
	minimal_access += ACCESS_CREMATORIUM

/datum/job/officer/New()
	procstart = null
	src.procstart = null
	..()
	MAP_JOB_CHECK
	access += ACCESS_CREMATORIUM
	minimal_access += ACCESS_CREMATORIUM

MAP_REMOVE_JOB(lawyer)
