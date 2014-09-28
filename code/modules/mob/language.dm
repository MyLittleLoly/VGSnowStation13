/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/desc = "A language."         // Short description for 'Check Languages'.
	var/speech_verb = "says"         // 'says', 'hisses', 'farts'.
	var/colour = "say_quote"         // CSS style to use for strings in this language.
	var/key = "x"                    // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                    // Various language flags.
	var/native                       // If set, non-native speakers will have trouble speaking.


/datum/language/predator
	name = "Yautja"
	desc = "&#255;зык &#255;джа &#255;вл&#255;етс&#255; сложным &#255;зыком, широко использующимс&#255; в общении между и с &#255;джа. "
	speech_verb = "рычит"
	colour = "soghun"
	key = "y"
	flags = WHITELISTED


/datum/language/unathi
	name = "Sinta'unathi"
	desc = "ќсновной &#255;зык ћоззес, состо&#255;щий из свист&#255;щих и шип&#255;щих звуков. ¬ основном, используетс&#255; только народами моззес."
	speech_verb = "шипит"
	colour = "soghun"
	key = "o"
	flags = WHITELISTED

/datum/language/tajaran
	name = "Siik'tajr"
	desc = "ƒостаточно выразительный и сложный &#255;зык, са&#255;к-тажар, &#255;вл&#255;етс&#255; родным дл&#255; та&#255;р&#255;н."
	speech_verb = "выговаривает"
	colour = "tajaran"
	key = "j"
	flags = WHITELISTED

/datum/language/skrell
	name = "Skrellian"
	desc = "ќчень красивый, поющий &#255;зык скреллов твербалаккского происхождени&#255;. Ќекоторые из нот невозможны к прослушиванию многими гуманойдами, в том числе человеком"
	speech_verb = "дребезжит"
	colour = "skrell"
	key = "k"
	flags = WHITELISTED

/datum/language/vox
	name = "Vox-pidgin"
	desc = "ќсновной &#255;зык большинства космических кораблей воксов. —махивает на хаотичный, негласный визг."
	speech_verb = "вопит"
	colour = "vox"
	key = "v"
	flags = RESTRICTED

/datum/language/diona
	name = "Rootspeak"
	desc = "—крип&#255;щий и шорочащий &#255;зык, которым владеют дионы с самого рождени&#255; на инстинктном уровне."
	speech_verb = "скрипит и шорочет"
	colour = "soghun"
	key = "q"
	flags = RESTRICTED

/datum/language/hylotl
	name = "Hylotl"
	desc = "ћелодичный и простой &#255;зык."
	speech_verb = "воспевает"
	colour = "soghun"
	key = "4"
	flags = RESTRICTED

// Galactic common languages (systemwide accepted standards).

/datum/language/human
	name = "Sol Common"
	desc = "»звращенный гибрид английского &#255;зыка и мандаринского диалекта китайского &#255;зыка; общий &#255;зык на галактическом уровне."
	key = "1"
	flags = RESTRICTED

/datum/language/trader
	name = "Tradeband"
	desc = "ƒостаточно элегантный и структуированный &#255;зык, используемый как крупными, так и малыми торговыми картел&#255;ми на галактическом уровне."
	speech_verb = "формулирует"
	key = "2"

/datum/language/gutter
	name = "Gutter"
	desc = "Ётот сырой &#255;зык был специально сконструирован криминальными элементами дл&#255; общени&#255; на межгалактическом уровне достаточно недавно."
	speech_verb = "рычит"
	key = "3"

// Language handling.
/mob/proc/add_language(var/language)

	for(var/datum/language/L in languages)
		if(L && L.name == language)
			return 0

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language,/datum/language))
		return 0

	languages += new_language
	return 1

/mob/proc/remove_language(var/rem_language)

	for(var/datum/language/L in languages)
		if(L && L.name == rem_language)
			languages -= L
			return 1

	return 0

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>»звестные &#255;зыки</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return