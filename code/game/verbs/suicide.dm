/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == DEAD)
		src << "Ты и так мертв!"
		return

	if (!ticker)
		src << "Ты не можешь совершить суицид до того, как игра началась!"
		return


	var/permitted = 0
	var/list/allowed = list("Syndicate","traitor","Wizard","Head Revolutionary","Cultist","Changeling")
	for(var/T in allowed)
		if(mind.special_role == T)
			permitted = 1
			break

	if(!permitted)
		message_admins("[ckey] попыталс&#255; совершить суицид.", 1)
		src << "Нельз&#255;. Обращайс&#255; к администрации, если на то есть причины."
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
			src << "Ты не можешь совершить суицид, так как твои руки ограничены! (( Однако, ты можешь воспользоватьс&#255; командой Ghost. ))"
			return
		suiciding = 1
		var/obj/item/held_item = get_active_hand()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				var/damage_mod = 1
				switch(damagetype) //Sorry about the magic numbers.
								   //brute = 1, burn = 2, tox = 4, oxy = 8
					if(15) //4 damage types
						damage_mod = 4

					if(6, 11, 13, 14) //3 damage types
						damage_mod = 3

					if(3, 5, 7, 9, 10, 12) //2 damage types
						damage_mod = 2

					if(1, 2, 4, 8) //1 damage type
						damage_mod = 1

					else //This should not happen, but if it does, everything should still work
						damage_mod = 1

				//Do 175 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(175/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(175/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(175/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(175/damage_mod)

				//If something went wrong, just do normal oxyloss
				if(!(damagetype | BRUTELOSS) && !(damagetype | FIRELOSS) && !(damagetype | TOXLOSS) && !(damagetype | OXYLOSS))
					adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				updatehealth()
				return


		viewers(src) << pick("\red <b>[src] пытаетс&#255; отгрызть свой &#255;зык! Божечки, да \he же пытаетс&#255; совершить суицид!</b>", \
							"\red <b>[src] пытаетс&#255; всунуть свой большой палец в \his глазницу! Божечки, да \he же пытаетс&#255; совершить суицид!</b>", \
							"\red <b>[src] пытаетс&#255; свернуть свою шею! Божечки, да \he же пытаетс&#255; совершить суицид!</b>", \
							"\red <b>[src] пытаетс&#255; перекрыть свои дыхательные пути! Божечки, да \he же пытаетс&#255; совершить суицид!</b>")
		adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "Ты и так мертв!"
		return

	if (!ticker)
		src << "Ты не можешь совершить суицид до того, как игра началась!"
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		suiciding = 1
		viewers(loc) << "\red <b>Лицо [src] становитс&#255; тусклым и его маска медленно смен&#255;етс&#255; на безжизненную. Похоже, он потер&#255;л надежду и возможность в счастливую жизнь.</b>"
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "Ты и так мертв!"
		return

	if (!ticker)
		src << "Ты не можешь совершить суицид до того, как игра началась!"
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		if(!canmove || restrained())
			src << "Ты не можешь совершить суицид, так как твои руки ограничены! (( Однако, ты можешь воспользоватьс&#255; командой Ghost. ))"
			return
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] пытаетс&#255; отгрызть свой &#255;зык! Божечки, да \he же пытаетс&#255; совершить суицид!/b>"
		adjustOxyLoss(max(175- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "Ты и так мертв!"
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		suiciding = 1
		viewers(src) << "\red <b>[src] резко отключаетс&#255;! Божечки, да \he же пытаетс&#255; совершить суицид!</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "Ты и так мертв!"
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		suiciding = 1
		viewers(src) << "\red <b>[src] резко отключаетс&#255;! Божечки, да \he же пытаетс&#255; совершить суицид!</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("Ты действительно хочешь окислить свои цепи? Это действие нельз&#255; отменить", "Суицид", "Нет") in list ("Да", "Нет")
	if(answer == "Да")
		var/obj/item/device/paicard/card = loc
		card.removePersonality()
		var/turf/T = get_turf_or_move(card.loc)
		for (var/mob/M in viewers(T))
			M.show_message("\blue [src] выводит сообщение на свой экран \"Форматирование жесткого диска. Пожалуйста, скачайте другую личность карманного ИИ дл&#255; того, чтобы продолжить пользование девайсом.\"", 3, "\blue [src] издает короткие электронные звуки.", 2)
		death(0)
	else
		src << "Нет - так нет."

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "Ты и так мертв!"
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		suiciding = 1
		viewers(src) << "\red <b>[src] издает дикие звуки! Божечки, да \he же пытаетс&#255; совершить суицид!</b>"
		//put em at -175
		adjustOxyLoss(max(175 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()


/mob/living/carbon/slime/verb/suicide()
	set hidden = 1
	if (stat == 2)
		src << "Ты и так мертв!"
		return

	if (suiciding)
		src << "Ты и без того совершаешь суицид!"
		return

	var/confirm = alert("Ты уверен, что хочешь совершить суицид?", "Подтверждение", "Да", "Нет")

	if(confirm == "Да")
		suiciding = 1
		setOxyLoss(100)
		adjustBruteLoss(100 - getBruteLoss())
		setToxLoss(100)
		setCloneLoss(100)

		updatehealth()
