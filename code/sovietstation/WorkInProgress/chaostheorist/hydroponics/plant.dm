//Hydroponics Plants
var/static/list/datum/reagent/master_reagent_toxins = list("toxin", "plantbgone")
var/static/list/datum/reagent/master_reagent_ferts = list("sugar", "nutriment", "ammonia")

/datum/hydro/plant_type
	var
		name = ""

		temperature_min = 0
		temperature_max = 0
		temperature_resistance = 1
		stages = 0
		harvest_delay = 0
		stages_delay = 0
		reusable = 0
		photo_intensive = 1
		moistureloving = 1
		nutritionloving = 1

		yield = null
		yield_amount_min = 0
		yield_amount_max = 0

		list/datum/reagent/reagent_include_toxins = null
		list/datum/reagent/reagent_include_ferts = null
		list/datum/reagent/reagent_exclude_toxins = null
		list/datum/reagent/reagent_exclude_ferts = null

		icon_override = null
		icon_state = ""


	proc/get_toxins()
		return master_reagent_toxins - reagent_exclude_toxins + reagent_include_toxins

	proc/get_fert()
		return master_reagent_ferts - reagent_exclude_ferts + reagent_include_ferts

/datum/hydro/plant
	var
		health = 100
		datum/hydro/plant_type/p_type = null
		stage = 1
		harvest_ready = 0
		last_water_fail = 0
		last_nutrition_fail = 0
		death = 0
		death_reason = ""
		datum/reagents/soaked_reagents = null

	New(datum/hydro/plant_type/_ptype)
		p_type = _ptype
		soaked_reagents = new /datum/reagents(100)

/obj/item/h_seeds
	name = "Seed Packet"
	icon = 'icons/obj/seeds.dmi'
	var/datum/hydro/plant_type/seed_type = null

/datum/hydro/plant_type/tomato
	name = "Tomato"

	temperature_min = 288.0
	temperature_max = 320.0
	stages = 6
	harvest_delay = 10
	stages_delay = 50

	yield = /obj/item/weapon/reagent_containers/food/snacks/grown/tomato
	yield_amount_min = 4
	yield_amount_max = 7

/obj/item/h_seeds/tomato
	name = "Tomato Seeds"
	icon_state = "seed-tomato"

	New()
		seed_type = new /datum/hydro/plant_type/tomato