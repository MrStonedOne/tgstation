/datum/topic_input
	var/href
	var/list/href_list

/datum/topic_input/New(thref,list/thref_list)
	procstart = null
	src.procstart = null
	href = thref
	href_list = thref_list.Copy()
	return

/datum/topic_input/proc/get(i)
	procstart = null
	src.procstart = null
	return listgetindex(href_list,i)

/datum/topic_input/proc/getAndLocate(i)
	procstart = null
	src.procstart = null
	var/t = get(i)
	if(t)
		t = locate(t)
	if (istext(t))
		t = null
	return t || null

/datum/topic_input/proc/getNum(i)
	procstart = null
	src.procstart = null
	var/t = get(i)
	if(t)
		t = text2num(t)
	return isnum(t) ? t : null

/datum/topic_input/proc/getObj(i)
	procstart = null
	src.procstart = null
	var/t = getAndLocate(i)
	return isobj(t) ? t : null

/datum/topic_input/proc/getMob(i)
	procstart = null
	src.procstart = null
	var/t = getAndLocate(i)
	return ismob(t) ? t : null

/datum/topic_input/proc/getTurf(i)
	procstart = null
	src.procstart = null
	var/t = getAndLocate(i)
	return isturf(t) ? t : null

/datum/topic_input/proc/getAtom(i)
	procstart = null
	src.procstart = null
	return getType(i, /atom)

/datum/topic_input/proc/getArea(i)
	procstart = null
	src.procstart = null
	var/t = getAndLocate(i)
	return isarea(t) ? t : null

/datum/topic_input/proc/getStr(i)//params should always be text, but...
	var/t = get(i)
	return istext(t) ? t : null

/datum/topic_input/proc/getType(i,type)
	procstart = null
	src.procstart = null
	var/t = getAndLocate(i)
	return istype(t,type) ? t : null

/datum/topic_input/proc/getPath(i)
	procstart = null
	src.procstart = null
	var/t = get(i)
	if(t)
		t = text2path(t)
	return ispath(t) ? t : null

/datum/topic_input/proc/getList(i)
	procstart = null
	src.procstart = null
	var/t = getAndLocate(i)
	return islist(t) ? t : null
