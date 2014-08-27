/obj/machinery/shreder
	name = "shreder"
	icon = 'icons/shreder.dmi'
	icon_state = "shreder_off"
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP

	var/on = 0
	var/ready = 1

/obj/machinery/shreder/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/shreder/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/shreder/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(on)
		user << "You turn off shreder"
		icon_state = "shreder_off"
		on = 0
	else
		user << "You turn on shreder"
		icon_state = "shreder_on"
		on = 1

/obj/machinery/shreder/attackby(obj/item/O as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN) || !on || !ready)
		return

	if(istype(O, /obj/item/weapon/paper))
		user.drop_item()
		del O
		ready = 0
		icon_state = "shreder_mill"
		spawn(15)
			ready = 1
			icon_state = "shreder_on"
		return