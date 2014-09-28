/mob/living/simple_animal/baby
	name = "baby"
	desc = "Very young human who is usually born after coming out of a woman."
	icon = 'icons/mob/baby.dmi'
	icon_state = "living"
	icon_living = "living"
	icon_dead = "dead"
	speak = list("Mama!","Geddy!","Goo goo!","Pshe!")
	speak_emote = list("gooking", "psheking")
	emote_hear = list("gooks","psheks")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "hugs the"
	response_disarm = "gently pushes aside the"
	response_harm   = "punch the"
	var/turns_since_scan = 0
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius