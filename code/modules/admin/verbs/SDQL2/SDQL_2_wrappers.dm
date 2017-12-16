// Wrappers for BYOND default procs which can't directly be called by call().

/proc/_abs(A)
	procstart = null
	src.procstart = null
	return abs(A)

/proc/_animate(atom/A, set_vars, time = 10, loop = 1, easing = LINEAR_EASING, flags = null)
	procstart = null
	src.procstart = null
	var/mutable_appearance/MA = new()
	for(var/v in set_vars)
		MA.vars[v] = set_vars[v]
	animate(A, appearance = MA, time, loop, easing, flags)

/proc/_acrccos(A)
	procstart = null
	src.procstart = null
	return arccos(A)

/proc/_arcsin(A)
	procstart = null
	src.procstart = null
	return arcsin(A)

/proc/_ascii2text(A)
	procstart = null
	src.procstart = null
	return ascii2text(A)

/proc/_block(Start, End)
	procstart = null
	src.procstart = null
	return block(Start, End)

/proc/_ckey(Key)
	procstart = null
	src.procstart = null
	return ckey(Key)

/proc/_ckeyEx(Key)
	procstart = null
	src.procstart = null
	return ckeyEx(Key)

/proc/_copytext(T, Start = 1, End = 0)
	procstart = null
	src.procstart = null
	return copytext(T, Start, End)

/proc/_cos(X)
	procstart = null
	src.procstart = null
	return cos(X)

/proc/_get_dir(Loc1, Loc2)
	procstart = null
	src.procstart = null
	return get_dir(Loc1, Loc2)

/proc/_get_dist(Loc1, Loc2)
	procstart = null
	src.procstart = null
	return get_dist(Loc1, Loc2)

/proc/_get_step(Ref, Dir)
	procstart = null
	src.procstart = null
	return get_step(Ref, Dir)

/proc/_hearers(Depth = world.view, Center = usr)
	procstart = null
	src.procstart = null
	return hearers(Depth, Center)

/proc/_image(icon, loc, icon_state, layer, dir)
	procstart = null
	src.procstart = null
	return image(icon, loc, icon_state, layer, dir)

/proc/_length(E)
	procstart = null
	src.procstart = null
	return length(E)

/proc/_link(thing, url)
	procstart = null
	src.procstart = null
	thing << link(url)

/proc/_locate(X, Y, Z)
	procstart = null
	src.procstart = null
	if (isnull(Y)) // Assuming that it's only a single-argument call.
		return locate(X)

	return locate(X, Y, Z)

/proc/_log(X, Y)
	procstart = null
	src.procstart = null
	return log(X, Y)

/proc/_lowertext(T)
	procstart = null
	src.procstart = null
	return lowertext(T)

/proc/_matrix(a, b, c, d, e, f)
	procstart = null
	src.procstart = null
	return matrix(a, b, c, d, e, f)

/proc/_max(...)
	procstart = null
	src.procstart = null
	return max(arglist(args))

/proc/_md5(T)
	procstart = null
	src.procstart = null
	return md5(T)

/proc/_min(...)
	procstart = null
	src.procstart = null
	return min(arglist(args))

/proc/_new(type, arguments)
	procstart = null
	src.procstart = null
	return new type (arglist(arguments))

/proc/_num2text(N, SigFig = 6)
	procstart = null
	src.procstart = null
	return num2text(N, SigFig)

/proc/_ohearers(Dist, Center = usr)
	procstart = null
	src.procstart = null
	return ohearers(Dist, Center)

/proc/_orange(Dist, Center = usr)
	procstart = null
	src.procstart = null
	return orange(Dist, Center)

/proc/_output(thing, msg, control)
	procstart = null
	src.procstart = null
	thing << output(msg, control)

/proc/_oview(Dist, Center = usr)
	procstart = null
	src.procstart = null
	return oview(Dist, Center)

/proc/_oviewers(Dist, Center = usr)
	procstart = null
	src.procstart = null
	return oviewers(Dist, Center)

/proc/_params2list(Params)
	procstart = null
	src.procstart = null
	return params2list(Params)

/proc/_pick(...)
	procstart = null
	src.procstart = null
	return pick(arglist(args))

/proc/_prob(P)
	procstart = null
	src.procstart = null
	return prob(P)

/proc/_rand(L = 0, H = 1)
	procstart = null
	src.procstart = null
	return rand(L, H)

/proc/_range(Dist, Center = usr)
	procstart = null
	src.procstart = null
	return range(Dist, Center)

/proc/_regex(pattern, flags)
	procstart = null
	src.procstart = null
	return regex(pattern, flags)

/proc/_REGEX_QUOTE(text)
	procstart = null
	src.procstart = null
	return REGEX_QUOTE(text)

/proc/_REGEX_QUOTE_REPLACEMENT(text)
	procstart = null
	src.procstart = null
	return REGEX_QUOTE_REPLACEMENT(text)

/proc/_replacetext(Haystack, Needle, Replacement, Start = 1,End = 0)
	procstart = null
	src.procstart = null
	return replacetext(Haystack, Needle, Replacement, Start, End)

/proc/_replacetextEx(Haystack, Needle, Replacement, Start = 1,End = 0)
	procstart = null
	src.procstart = null
	return replacetextEx(Haystack, Needle, Replacement, Start, End)

/proc/_rgb(R, G, B)
	procstart = null
	src.procstart = null
	return rgb(R, G, B)

/proc/_rgba(R, G, B, A)
	procstart = null
	src.procstart = null
	return rgb(R, G, B, A)

/proc/_roll(dice)
	procstart = null
	src.procstart = null
	return roll(dice)

/proc/_round(A, B = 1)
	procstart = null
	src.procstart = null
	return round(A, B)

/proc/_sin(X)
	procstart = null
	src.procstart = null
	return sin(X)

/proc/_list_add(list/L, ...)
	procstart = null
	src.procstart = null
	if (args.len < 2)
		return
	L += args.Copy(2)

/proc/_list_copy(list/L, Start = 1, End = 0)
	procstart = null
	src.procstart = null
	return L.Copy(Start, End)

/proc/_list_cut(list/L, Start = 1, End = 0)
	procstart = null
	src.procstart = null
	L.Cut(Start, End)

/proc/_list_find(list/L, Elem, Start = 1, End = 0)
	procstart = null
	src.procstart = null
	return L.Find(Elem, Start, End)

/proc/_list_insert(list/L, Index, Item)
	procstart = null
	src.procstart = null
	return L.Insert(Index, Item)

/proc/_list_join(list/L, Glue, Start = 0, End = 1)
	procstart = null
	src.procstart = null
	return L.Join(Glue, Start, End)

/proc/_list_remove(list/L, ...)
	procstart = null
	src.procstart = null
	if (args.len < 2)
		return
	L -= args.Copy(2)

/proc/_list_set(list/L, key, value)
	procstart = null
	src.procstart = null
	L[key] = value

/proc/_list_numerical_add(L, key, num)
	procstart = null
	src.procstart = null
	L[key] += num

/proc/_list_swap(list/L, Index1, Index2)
	procstart = null
	src.procstart = null
	L.Swap(Index1, Index2)

/proc/_walk(ref, dir, lag)
	procstart = null
	src.procstart = null
	walk(ref, dir, lag)

/proc/_walk_towards(ref, trg, lag)
	procstart = null
	src.procstart = null
	walk_towards(ref, trg, lag)

/proc/_walk_to(ref, trg, min, lag)
	procstart = null
	src.procstart = null
	walk_to(ref, trg, min, lag)

/proc/_walk_away(ref, trg, max, lag)
	procstart = null
	src.procstart = null
	walk_away(ref, trg, max, lag)

/proc/_walk_rand(ref, lag)
	procstart = null
	src.procstart = null
	walk_rand(ref, lag)

/proc/_step(ref, dir)
	procstart = null
	src.procstart = null
	step(ref, dir)

/proc/_step_rand(ref)
	procstart = null
	src.procstart = null
	step_rand(ref)

/proc/_step_to(ref, trg, min)
	procstart = null
	src.procstart = null
	step_to(ref, trg, min)

/proc/_step_towards(ref, trg)
	procstart = null
	src.procstart = null
	step_towards(ref, trg)

/proc/_step_away(ref, trg, max)
	procstart = null
	src.procstart = null
	step_away(ref, trg, max)


