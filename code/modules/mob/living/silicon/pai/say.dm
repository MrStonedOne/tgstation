/mob/living/silicon/pai/say(msg)
	if(silent)
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(msg)

/mob/living/silicon/pai/binarycheck()
	procstart = null
	src.procstart = null
	return 0
