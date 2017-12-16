
/obj/structure/closet/secure_closet/exile
	name = "exile implants"
	req_access = list(ACCESS_HOS)

/obj/structure/closet/secure_closet/exile/New()
	procstart = null
	src.procstart = null
	..()
	new /obj/item/implanter/exile(src)
	new /obj/item/implantcase/exile(src)
	new /obj/item/implantcase/exile(src)
	new /obj/item/implantcase/exile(src)
	new /obj/item/implantcase/exile(src)
	new /obj/item/implantcase/exile(src)