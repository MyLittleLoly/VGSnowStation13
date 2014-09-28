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
	desc = "&#255;��� &#255;��� &#255;��&#255;���&#255; ������� &#255;�����, ������ �������������&#255; � ������� ����� � � &#255;���. "
	speech_verb = "�����"
	colour = "soghun"
	key = "y"
	flags = WHITELISTED


/datum/language/unathi
	name = "Sinta'unathi"
	desc = "�������� &#255;��� ������, �����&#255;��� �� �����&#255;��� � ���&#255;��� ������. � ��������, �����������&#255; ������ �������� ������."
	speech_verb = "�����"
	colour = "soghun"
	key = "o"
	flags = WHITELISTED

/datum/language/tajaran
	name = "Siik'tajr"
	desc = "���������� ������������� � ������� &#255;���, ��&#255;�-�����, &#255;��&#255;���&#255; ������ ��&#255; ��&#255;�&#255;�."
	speech_verb = "������������"
	colour = "tajaran"
	key = "j"
	flags = WHITELISTED

/datum/language/skrell
	name = "Skrellian"
	desc = "����� ��������, ������ &#255;��� �������� ��������������� ������������&#255;. ��������� �� ��� ���������� � ������������� ������� �����������, � ��� ����� ���������"
	speech_verb = "���������"
	colour = "skrell"
	key = "k"
	flags = WHITELISTED

/datum/language/vox
	name = "Vox-pidgin"
	desc = "�������� &#255;��� ����������� ����������� �������� ������. ��������� �� ���������, ��������� ����."
	speech_verb = "�����"
	colour = "vox"
	key = "v"
	flags = RESTRICTED

/datum/language/diona
	name = "Rootspeak"
	desc = "�����&#255;��� � ��������� &#255;���, ������� ������� ����� � ������ �������&#255; �� ����������� ������."
	speech_verb = "������� � �������"
	colour = "soghun"
	key = "q"
	flags = RESTRICTED

/datum/language/hylotl
	name = "Hylotl"
	desc = "���������� � ������� &#255;���."
	speech_verb = "���������"
	colour = "soghun"
	key = "4"
	flags = RESTRICTED

// Galactic common languages (systemwide accepted standards).

/datum/language/human
	name = "Sol Common"
	desc = "����������� ������ ����������� &#255;���� � ������������� �������� ���������� &#255;����; ����� &#255;��� �� ������������� ������."
	key = "1"
	flags = RESTRICTED

/datum/language/trader
	name = "Tradeband"
	desc = "���������� ���������� � ���������������� &#255;���, ������������ ��� ��������, ��� � ������ ��������� ������&#255;�� �� ������������� ������."
	speech_verb = "�����������"
	key = "2"

/datum/language/gutter
	name = "Gutter"
	desc = "���� ����� &#255;��� ��� ���������� �������������� ������������� ���������� ��&#255; ������&#255; �� ���������������� ������ ���������� �������."
	speech_verb = "�����"
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

	var/dat = "<b><font size = 5>��������� &#255;����</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return