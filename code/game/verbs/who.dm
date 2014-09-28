
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Сейчас играют:</b>\n"

	var/list/Lines = list()

	if(holder)
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Играет за [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Вне сознани&#255;</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Наблюдает</font>"
						else
							entry += " - <font color='black'><b>МЕРТВ</b></font>"
					else
						entry += " - <font color='black'><b>МЕРТВ</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Антагонист</font></b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Всего [length(Lines)] человек онлайн.</b>"
	src << msg

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	if(holder)
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights))
				msg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Наблюдает за рабами"
				else if(istype(C.mob,/mob/new_player))
					msg += " - В лобби"
				else
					msg += " - Играет"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"

				num_admins_online++
			else
				num_mods_online++
	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights))
				if(!C.holder.fakekey)
					msg += "\t[C] is a [C.holder.rank]\n"
					num_admins_online++
			else
				num_mods_online++

	msg = "<b>Администраци&#255; онлайн: ([num_admins_online]):</b>\n" + msg
	msg += "<b>Так же, на текущий момент [num_mods_online] модераторов онлайн.</b> Чтобы узнать, кто из модераторов онлайн, введите 'modwho'\n"
	src << msg

/client/verb/modwho()
	set category = "Admin"
	set name = "Modwho"

	var/msg = ""
	var/num_admins_online = 0
	var/num_mods_online = 0
	if(holder)
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights))
				num_admins_online++
			else
				msg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					msg += " - Наблюдает за рабами"
				else if(istype(C.mob,/mob/new_player))
					msg += " - В лобби"
				else
					msg += " - Играет"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"
				num_mods_online++
	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || !(R_MOD & C.holder.rights) && !C.holder.fakekey)
				num_admins_online++
			else
				msg += "\t[C] is a [C.holder.rank]\n"

	msg = "<b>Модераторы онлайн ([num_mods_online]):</b>\n" + msg
	msg += "<b>На текущий момент онлайн [num_admins_online] администраторов.</b> Чтобы узнать, кто из администраторов онлайн, используйте 'adminwho'\n"
	src << msg
