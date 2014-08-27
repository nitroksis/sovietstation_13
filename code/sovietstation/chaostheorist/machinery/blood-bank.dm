/obj/machinery/smartfridge/secure/bloodbank
	name = "\improper Blood bank"
	desc = "A refrigerated storage unit for storing blood."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
	req_one_access_txt = "5;33"

/obj/machinery/smartfridge/secure/bloodbank/New()
	for(var/W in list(/obj/item/weapon/reagent_containers/blood/APlus, /obj/item/weapon/reagent_containers/blood/AMinus, \
		/obj/item/weapon/reagent_containers/blood/BPlus, /obj/item/weapon/reagent_containers/blood/BMinus, /obj/item/weapon/reagent_containers/blood/OPlus,\
		/obj/item/weapon/reagent_containers/blood/OMinus))
		var/tmp/_amount = rand(0, 2)
		for(var/i = 0; i < _amount; i++)
			var/obj/item/O = new W
			contents += O
			item_quants[O.name]++

	for(var/i = 0; i < 5; i++)
		var/obj/item/O = new /obj/item/weapon/reagent_containers/blood/empty
		contents += O
		item_quants[O.name]++

/obj/machinery/smartfridge/secure/bloodbank/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/blood/))
		return 1
	return 0