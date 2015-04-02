/client/proc/generateorigintechwikitables()
	set category = "Debug"
	set name = "Generate Origin Tech WikiTables"

	/*
	{| class="wikitable sortable mw-collapsible mw-collapsed" style="text-align:center" width="100%"
|+Protolathe Manufacturing List
! class="unsortable" |Icon
!Item
!Material
!Enginee<br>ring
!Plasma
!Power
!Blue<br>space
!Bio
!Combat
!EMP
!Data
!Illegal
|-
|[[File:Icard.png]]||Intellicard AI Transportation System
|{{row-bg-10|4| | | | | | | |4| }}
|-

*/
	var/withorigintechtable = {"{| class="wikitable sortable mw-collapsible mw-collapsed" style="text-align:center" width="100%"
|+Items with Origin tech
!Type
!Name
!Material
!Enginee<br>ring
!Plasma
!Power
!Blue<br>space
!Bio
!Combat
!EMP
!Data
!Illegal"}
	var/noorigintechtable = {"{| class="wikitable sortable mw-collapsible mw-collapsed" style="text-align:center" width="100%"
|+Items without Origin tech
!Type
!Name
"}

	for(var/T in typesof(/obj/item))
		var/flags = initial(T:flags)
		if (flags & (NODROP|ABSTRACT))
			continue
		var/tech = initial(T:origin_tech)
		var/name = initial(T:name)


		var/list/techlist = params2list("materials=0;programming=0;magnets=0;powerstorage=0;bluespace=0;combat=0;biotech=0;syndicate=0;engineering=0;plasmatech=0")
		var/list/temp_list = params2list(tech)
		if (!tech || temp_list.len == 0)
			noorigintechtable += {"|-
|[T] || [name]
"}
			continue
		for(var/I in temp_list)
			techlist[I] = text2num(temp_list[I])

		withorigintechtable += {"
|-
|[T] || [name]"}

		withorigintechtable += " || [techlist["materials"]]"
		withorigintechtable += " || [techlist["engineering"]]"
		withorigintechtable += " || [techlist["plasmatech"]]"
		withorigintechtable += " || [techlist["powerstorage"]]"
		withorigintechtable += " || [techlist["bluespace"]]"
		withorigintechtable += " || [techlist["biotech"]]"
		withorigintechtable += " || [techlist["combat"]]"
		withorigintechtable += " || [techlist["magnets"]]"
		withorigintechtable += " || [techlist["programming"]]"
		withorigintechtable += " || [techlist["syndicate"]]"

	withorigintechtable += {"
|}
"}
	noorigintechtable += {"
|}
"}
	usr << browse("<pre>" + withorigintechtable + "\n\n\n" + noorigintechtable + "</pre>", "window=redirect")