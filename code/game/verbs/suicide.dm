/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == DEAD)
		src << "�� � ��� �����!"
		return

	if (!ticker)
		src << "�� �� ������ ��������� ������ �� ����, ��� ���� ��������!"
		return


	var/permitted = 0
	var/list/allowed = list("Syndicate","traitor","Wizard","Head Revolutionary","Cultist","Changeling")
	for(var/T in allowed)
		if(mind.special_role == T)
			permitted = 1
			break

	if(!permitted)
		message_admins("[ckey] ��������&#255; ��������� ������.", 1)
		src << "�����&#255;. ��������&#255; � �������������, ���� �� �� ���� �������."
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
			src << "�� �� ������ ��������� ������, ��� ��� ���� ���� ����������! (( ������, �� ������ ��������������&#255; �������� Ghost. ))"
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


		viewers(src) << pick("\red <b>[src] �������&#255; �������� ���� &#255;���! �������, �� \he �� �������&#255; ��������� ������!</b>", \
							"\red <b>[src] �������&#255; ������� ���� ������� ����� � \his ��������! �������, �� \he �� �������&#255; ��������� ������!</b>", \
							"\red <b>[src] �������&#255; �������� ���� ���! �������, �� \he �� �������&#255; ��������� ������!</b>", \
							"\red <b>[src] �������&#255; ��������� ���� ����������� ����! �������, �� \he �� �������&#255; ��������� ������!</b>")
		adjustOxyLoss(max(175 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "�� � ��� �����!"
		return

	if (!ticker)
		src << "�� �� ������ ��������� ������ �� ����, ��� ���� ��������!"
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		suiciding = 1
		viewers(loc) << "\red <b>���� [src] ���������&#255; ������� � ��� ����� �������� ����&#255;���&#255; �� ������������. ������, �� �����&#255;� ������� � ����������� � ���������� �����.</b>"
		spawn(50)
			death(0)
			suiciding = 0

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "�� � ��� �����!"
		return

	if (!ticker)
		src << "�� �� ������ ��������� ������ �� ����, ��� ���� ��������!"
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		if(!canmove || restrained())
			src << "�� �� ������ ��������� ������, ��� ��� ���� ���� ����������! (( ������, �� ������ ��������������&#255; �������� Ghost. ))"
			return
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] �������&#255; �������� ���� &#255;���! �������, �� \he �� �������&#255; ��������� ������!/b>"
		adjustOxyLoss(max(175- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "�� � ��� �����!"
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		suiciding = 1
		viewers(src) << "\red <b>[src] ����� ����������&#255;! �������, �� \he �� �������&#255; ��������� ������!</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "�� � ��� �����!"
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		suiciding = 1
		viewers(src) << "\red <b>[src] ����� ����������&#255;! �������, �� \he �� �������&#255; ��������� ������!</b>"
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("�� ������������� ������ �������� ���� ����? ��� �������� �����&#255; ��������", "������", "���") in list ("��", "���")
	if(answer == "��")
		var/obj/item/device/paicard/card = loc
		card.removePersonality()
		var/turf/T = get_turf_or_move(card.loc)
		for (var/mob/M in viewers(T))
			M.show_message("\blue [src] ������� ��������� �� ���� ����� \"�������������� �������� �����. ����������, �������� ������ �������� ���������� �� ��&#255; ����, ����� ���������� ����������� ��������.\"", 3, "\blue [src] ������ �������� ����������� �����.", 2)
		death(0)
	else
		src << "��� - ��� ���."

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "�� � ��� �����!"
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		suiciding = 1
		viewers(src) << "\red <b>[src] ������ ����� �����! �������, �� \he �� �������&#255; ��������� ������!</b>"
		//put em at -175
		adjustOxyLoss(max(175 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()


/mob/living/carbon/slime/verb/suicide()
	set hidden = 1
	if (stat == 2)
		src << "�� � ��� �����!"
		return

	if (suiciding)
		src << "�� � ��� ���� ���������� ������!"
		return

	var/confirm = alert("�� ������, ��� ������ ��������� ������?", "�������������", "��", "���")

	if(confirm == "��")
		suiciding = 1
		setOxyLoss(100)
		adjustBruteLoss(100 - getBruteLoss())
		setToxLoss(100)
		setCloneLoss(100)

		updatehealth()
