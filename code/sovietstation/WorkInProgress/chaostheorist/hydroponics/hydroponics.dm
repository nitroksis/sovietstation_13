//Hydroponics
var/static/list/obj/machinery/hydroponics_tray/hidroponics_trays = newlist()

/obj/machinery/hydroponics_tray
	name = "hydroponics tray"
	icon = 'code/sovietstation/WorkInProgress/chaostheorist/hydroponics/machines.dmi'
	icon_state = "hydrotray"
	density = 1
	anchored = 1
	flags = OPENCONTAINER | NOREACT
	var
		temperature = 293.0
		target_temperature = 293.0
		last_cycle = 0
		last_check = 0
		last_temperature = 0
		datum/hydro/plant/i_plant = null
		id = null

	New()
		reagents = new/datum/reagents(120)
		reagents.my_atom = src
		processing_objects += src
		hidroponics_trays += src
		..()

	process()
		var/turf/_loc = loc
		if(i_plant)
			//Dead check
			if(i_plant.health <= 0 || i_plant.death)
				if(!i_plant.death)
					i_plant.death = 1
				return

			if(!i_plant.last_water_fail && !i_plant.last_nutrition_fail)
				//Grow
				if(world.time > (last_cycle + (i_plant.p_type.stages_delay * 10)) && i_plant.stage != i_plant.p_type.stages)
					last_cycle = world.time
					if(i_plant.stage == i_plant.p_type.stages && !i_plant.harvest_ready)
						i_plant.harvest_ready = 1
					if(i_plant.stage < i_plant.p_type.stages)
						i_plant.stage++

				//Harvest
				if(i_plant.stage == i_plant.p_type.stages && !i_plant.harvest_ready)
					if(world.time > last_cycle + i_plant.p_type.harvest_delay)
						i_plant.harvest_ready = 1

			//Toxins & fertilizers
			i_plant.last_nutrition_fail = 1
			for(var/datum/reagent/W in reagents.reagent_list)
				if(W.id in i_plant.p_type.get_toxins())
					if(reagents.get_reagent_amount(W.id) > 0.1)
						reagents.remove_reagent(W.id, 0.1)
						i_plant.health -= 1
						if(i_plant.health <= 0)
							i_plant.death_reason = "Stem and leaves eroded."
				else if(W.id in i_plant.p_type.get_fert())
					if(reagents.get_reagent_amount(W.id) > 0.1 * i_plant.p_type.nutritionloving && i_plant.last_nutrition_fail)
						reagents.remove_reagent(W.id, 0.1 * i_plant.p_type.nutritionloving)
						i_plant.last_nutrition_fail = 0
				else if(W.id == "water")
					if(reagents.get_reagent_amount("water") > 0.3 * i_plant.p_type.moistureloving)
						reagents.remove_reagent("water", 0.3 * i_plant.p_type.moistureloving)
						i_plant.last_water_fail = 0
				else
					if(W.id == "blood") continue
					if(reagents.get_reagent_amount(W.id) > 0.1)
						reagents.remove_reagent(W.id, 0.1)
						i_plant.soaked_reagents.add_reagent(W.id, 0.1)

			//Check & photosynthesis delay
			if(!(world.time > (last_check + 15)))
				return
			last_check = world.time

			//Photosynthesis
			if(i_plant.stage > 1 && i_plant.health > 20)
				if(_loc.lighting_lumcount > 10)
					var/tmp/datum/gas_mixture/W = new /datum/gas_mixture
					W.oxygen = 0.01 * i_plant.p_type.photo_intensive
					W.temperature = _loc.air.temperature
					_loc.air.add(W)

			//Temperature check
			if(_loc.air.temperature > i_plant.p_type.temperature_max)
				var/delta_temperature = _loc.air.temperature - i_plant.p_type.temperature_max
				if(delta_temperature <= i_plant.p_type.temperature_resistance * 10)
					if(reagents.get_reagent_amount("water") > delta_temperature / 10)
						reagents.remove_reagent("water", delta_temperature / 10)
				else
					i_plant.health -= delta_temperature / 10
					if(i_plant.health <= 0)
						i_plant.death_reason = "Plant burned"

			else if(_loc.air.temperature < i_plant.p_type.temperature_min)
				i_plant.health -= (i_plant.p_type.temperature_min - _loc.air.temperature) / 10
				if(i_plant.health <= 0)
					i_plant.death_reason = "Plant destroyed by frost"

			//Water check
			if(i_plant.last_water_fail)
				i_plant.health -= rand(1, 5) * i_plant.p_type.moistureloving
				if(i_plant.health <= 0)
					i_plant.death_reason = "Plant withered."

			//Nutrition check
			if(i_plant.last_nutrition_fail)
				i_plant.health -= rand(1, 5) * i_plant.p_type.nutritionloving
				if(i_plant.health <= 0)
					i_plant.death_reason = "Plant stopped growing and died."

		//Temperature calibration
		if(target_temperature != temperature && world.time >= last_temperature + 15)
			var/delta_temperature = target_temperature - temperature
			var/sign = (delta_temperature >= 0 ? 1 : -1)
			if(abs(delta_temperature) > 20)
				temperature += 20 * sign
			else if(abs(delta_temperature) > 5)
				temperature += 5 * sign
			else if(abs(delta_temperature) > 1)
				temperature += sign
			else
				temperature = target_temperature

			last_temperature = world.time

		update_icon()

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/h_seeds))
			var/obj/item/h_seeds/W = O
			i_plant = new /datum/hydro/plant(W.seed_type)
			last_cycle = world.time
			user.drop_item()
			del O

	attack_hand(mob/user as mob)
		if(i_plant.harvest_ready)
			var/amount = rand(i_plant.p_type.yield_amount_min, i_plant.p_type.yield_amount_max)
			var/reagents_amount = i_plant.soaked_reagents.total_volume / amount
			for(var/i = 0; i < amount; i++)
				var/obj/O = new i_plant.p_type.yield
				O.loc = user.loc
				i_plant.soaked_reagents.trans_to(O, reagents_amount)
			i_plant.harvest_ready = 0
			if(!i_plant.p_type.reusable)
				i_plant.death = 1
				i_plant.death_reason = "End of life."

	on_reagent_change()
		return

	update_icon()
		overlays.Cut()
		if(i_plant)
			var/datum/hydro/plant_type/plant = i_plant.p_type
			overlays += image(plant.icon_override ? plant.icon_override : 'code/sovietstation/WorkInProgress/chaostheorist/hydroponics/plants.dmi',\
					 icon_state = "[plant.icon_state]_[i_plant.harvest_ready ? "harvest" : i_plant.stage][i_plant.death ? "_dead" : ""]")


	examine()
		set src in usr
		usr << text("\icon[] [].", src, src.name)
		return

	proc/change_temperature(var/target as num)
		target_temperature = target

	Del()
		processing_objects -= src
		hidroponics_trays -= src
		..()

/obj/machinery/hydroponics_environment_controller
	name = "hydroponics environment controller"
	icon = 'icons/obj/computer.dmi'
	icon_state = "medcomp"
	var
		id = null
		list/linked_machines = newlist()
		temperature = 293.0

	New()
		if(id)
			for(var/obj/machinery/hydroponics_tray/M in hidroponics_trays)
				if(M.id == id)
					linked_machines += M
		..()

	attack_hand(mob/user as mob)
		ui_interact(user)

	ui_interact(mob/user as mob, ui_key = "main", var/datum/nanoui/ui = null)
		if(!user)
			return

		var/list/data = newlist()

		data["temperature"] = temperature
		data["linked_trays"] = newlist()
		for(var/obj/machinery/hydroponics_tray/M in linked_machines)
			var/list/O = newlist()
			O["l_temperature"] = M.temperature
			data["linked_trays"] += O

		ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
		if (!ui)
			// the ui does not exist, so we'll create a new() one
	        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
			ui = new(user, src, ui_key, "environment.tmpl", "Environment Controller UI", 500, 480)
			// when the ui is first opened this is the data it will use
			ui.set_initial_data(data)
			// open the new ui window
			ui.open()
			// auto update every Master Controller tick
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/action = href_list["action"]

		switch(action)
			if("temperature")
				var/amount = href_list["amount"]
				switch(amount)
					if("1")
						amount = 0.1
					if("2")
						amount = 1
					if("3")
						amount = 10

				var/sign = href_list["sign"]
				sign = (sign == "plus" ? 1 : -1)

				if(sign > 0 ? (temperature + amount <= 373.0) : (temperature - amount >= 173.0))
					temperature = round(temperature * 10 + (amount * sign) * 10)/10
				else
					temperature = (sign > 0 ? 373.0 : 173.0)

				change_temperature()
			if("relink")
				linked_machines -= linked_machines
				if(id)
					for(var/obj/machinery/hydroponics_tray/M in hidroponics_trays)
						if(M.id == id)
							linked_machines += M

	proc/change_temperature()
		for(var/obj/machinery/hydroponics_tray/M in linked_machines)
			M.change_temperature(temperature)