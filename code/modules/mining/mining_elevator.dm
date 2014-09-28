var/elevator_1_tickstomove = 5
var/elevator_1_moving = 0
var/elevator_1_location = 0 // 0 = station 13, 1 = mining station

proc/move_elevator_1()
	if(elevator_1_moving)	return
	elevator_1_moving = 1
	spawn(elevator_1_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		var/area/BufferArea = locate(/area/shuttle/mining)
		if (elevator_1_location == 1)
			fromArea = locate(/area/shuttle/mining/station)
			toArea = locate(/area/shuttle/mining/outpost)

		else
			fromArea = locate(/area/shuttle/mining/outpost)
			toArea = locate(/area/shuttle/mining/station)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		for(var/mob/living/simple_animal/pest in toArea) // And for the other kind of bug...
			pest.gib()

		fromArea.move_contents_to(BufferArea)
		toArea.move_contents_to(fromArea)
		BufferArea.move_contents_to(toArea)
		if (elevator_1_location)
			elevator_1_location = 0
		else
			elevator_1_location = 1

		for(var/mob/M in toArea)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 3, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 1) // unbuckled, HOLY SHIT SHAKE THE ROOM
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		elevator_1_moving = 0
	return

/obj/machinery/computer/elevator_1
	name = "Elevator console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_mining)
	circuit = "/obj/item/weapon/circuitboard/elevator_1"
	var/hacked = 0
	var/location = 0 //0 = station, 1 = mining base

/obj/machinery/computer/elevator_1/attack_hand(user as mob)
	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat
	dat = text("<center>Mining elevator:<br> <b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>")
	user << browse("[dat]", "window=miningshuttle;size=200x100")

/obj/machinery/computer/elevator_1/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		//if(ticker.mode.name == "blob")
		//	if(ticker.mode:declared)
		//		usr << "Under directive 7-10, [station_name()] is quarantined until further notice."
		//		return

		if (!elevator_1_moving)
			usr << "\blue Elevator recieved message and will be sent shortly."
			move_elevator_1()
		else
			usr << "\blue Elevator is already moving."

/obj/machinery/computer/elevator_1/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"