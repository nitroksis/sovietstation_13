/obj/item/clothing/suit/armor/swat/slys
	name = "SlyS Corp SWAT suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations by SlyS Corp."
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "swat_suit"
	icon_override = 'code/sovietstation/Sbotkin/slys/slys_overrides.dmi'
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee,/obj/item/weapon/handcuffs,/obj/item/weapon/tank)
	armor = list(melee = 95, bullet = 70, laser = 70,energy = 35, bomb = 50, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/space/deathsquad/slys
	name = "SlyS Corp SWAT helmet"
	desc = "Perfectly suited for SWAT suit!"
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "swat_helmet"
	icon_override = 'code/sovietstation/Sbotkin/slys/slys_overrides.dmi'
	armor = list(melee = 75, bullet = 65, laser = 45,energy = 30, bomb = 40, bio = 40, rad = 40)

/obj/item/clothing/suit/armor/vest/slys
	name = "armor"
	desc = "An armored vest that protects against some damage. Has SlyS Corp sign on it."
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "armor"
	icon_override = 'code/sovietstation/Sbotkin/slys/slys_overrides.dmi'
	armor = list(melee = 60, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/weapon/storage/wallet/slys
	name = "wallet"
	desc = "An exlusive wallet by SlyS Corp. It can hold a few small and personal things."
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "wallet"
	icon_override = 'code/sovietstation/Sbotkin/slys/slys_overrides.dmi'

/obj/item/device/pda/slys
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "pda"
	ttone = "cash"
	detonate = 0
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is an exlusive model for SlyS Corporation."
	note = "Congratulations, your company has chosen the Thinktronic 5230 Personal Data Assistant!"

/obj/item/device/radio/headset/slys
	name = "radio headset"
	desc = "For rich asses called TRADERS. Takes encryption keys."
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "headset"
	icon_override = 'code/sovietstation/Sbotkin/slys/slys_overrides.dmi'

/obj/structure/sign/slys
	name = "SlyS Corporation Official Store"
	desc = "Gold letters on a black background. This is definitely SlyS."
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "slys_corp_animated"

/obj/item/weapon/stamp/slys
	name = "SlyS Corp. rubber stamp"
	icon_state = "stamp-ce"
	item_color = "chief"


//TComm

/obj/machinery/telecomms/relay/preset/slys
	id = "SlyS Relay"
	hide = 1
	toggled = 1
	heatgen = 0
	autolinkers = list("slys_relay")

/obj/machinery/telecomms/receiver/preset_slys
	id = "SlyS Receiver"
	network = "tcommsat"
	heatgen = 0
	autolinkers = list("receiverSlys")
	freq_listening = list(1346)

/obj/machinery/telecomms/bus/preset_slys
	id = "SlyS Bus"
	network = "tcommsat"
	freq_listening = list(1346)
	heatgen = 0
	autolinkers = list("processorSlys", "slys")

/obj/machinery/telecomms/server/presets/slys
	id = "SlyS Server"
	freq_listening = list(1346)
	heatgen = 0
	autolinkers = list("slys")

/obj/machinery/telecomms/broadcaster/preset_slys
	id = "SlyS Broadcaster"
	network = "tcommsat"
	heatgen = 0
	autolinkers = list("broadcasterSlys")

/obj/machinery/telecomms/hub/preset_slys
	id = "CentComm Hub"
	network = "tcommsat"
	heatgen = 0
	autolinkers = list("hub_cent", "c_relay", "s_relay", "m_relay", "r_relay",
	 "slys", "receiverSlys", "broadcasterSlys")

//-------------
//MECHA "LUPUS"
//-------------
/obj/effect/decal/mecha_wreckage/lupus
	name = "Lupus wreckage"
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "lupus-broken"

/obj/mecha/combat/marauder/lupus
	desc = "Heavy-duty, command-type exosuit. This is a custom model of Marauder, made by SlyS Corp. (&copy; All rights reserved)"
	name = "Lupus"
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "lupus"
	initial_icon = "lupus"
	step_in = 2
	health = 600
	operation_req_access = list(300)
	internals_req_access = list(300)
	wreckage = /obj/effect/decal/mecha_wreckage/lupus
	internal_damage_threshold = 20
	force = 55
	max_equip = 5

/obj/mecha/combat/marauder/lupus/New()
	..()//Let it equip whatever is needed.
	var/obj/item/mecha_parts/mecha_equipment/ME
	if(equipment.len)//Now to remove it and equip anew.
		for(ME in equipment)
			equipment -= ME
			del(ME)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster(src)
	ME.attach(src)
	return

/obj/effect/decal/mecha_wreckage/lupus
	name = "Lupus wreckage"
	icon = 'code/sovietstation/Sbotkin/slys/slys.dmi'
	icon_state = "lupus-broken"