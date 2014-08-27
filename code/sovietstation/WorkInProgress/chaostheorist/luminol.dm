/datum/reagent/luminol
	name = "Luminol"
	id = "luminol"
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE

	reaction_obj(var/obj/O, var/volume)
		if(O.type == /obj/effect/decal/cleanable/blood || O.type == /obj/effect/decal/cleanable/blood/drip)
			var/obj/effect/decal/cleanable/blood/B = O
			B.color = "#00BFFF"
			B.SetLuminosity(0.8)
		else if(istype(O, /obj/effect/decal/cleanable/blood/tracks))
			var/obj/effect/decal/cleanable/blood/tracks/B = O
			B.color = "#00BFFF"
			B.SetLuminosity(0.8)

/obj/item/weapon/reagent_containers/spray/luminol
	name = "Luminol Spray"
	volume = 50

	New()
		..()
		reagents.add_reagent("luminol", src.volume)