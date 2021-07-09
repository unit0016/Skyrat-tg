///The Tank///
/mob/living/simple_animal/hostile/megafauna/wendigo/tank
	name = "tank"
	desc = "A particularly well-dressed blobbernaut, kitted in jeans. You probably aren't going to live through this."
	health = 5000
	maxHealth = 5000
	icon_state = "tank"
	icon_living = "tank"
	icon_dead = "tank_dead"
	icon = 'modular_skyrat/modules/awaymissons_skyrat/icons/tank.dmi'
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	attack_sound = 'sound/effects/bang.ogg'
	armour_penetration = 35 //Slightly less armor penetration due to it being blunt force.
	speed = 4 //Ever so slightly slower.
	move_to_delay = 5 //Ever so slightly faster than a normal wendigo in delays.
	rapid_melee = 4 // Half a regular Wendigo's melee attacks. Uses his muscly arms!
	gps_name = "Specimin X-12"
	loot = list()
	butcher_results = list()
	guaranteed_butcher_results = list(/obj/item/slimecross/chilling/green = 1)
	crusher_loot = list(/obj/item/slimepotion/spaceproof/tank) //If you manage to not only get a crusher in here, but use it to BTFO of a buffed wendigo? You deserve being able to say no to space.

///Tank Loot///
/obj/item/slimepotion/spaceproof/tank
	name = "gooey pressurization potion"
	desc = "A potent chemical sealant that will render any article of clothing airtight. Has ten uses."
	uses = 10

//Fluff Paper///
/obj/item/paper/fluff/awaymissions/a2d/glubtastic
	name = "handwritten note"
	icon_state = "scrap_mud"
	show_written_words = FALSE
	info = {"Call me 4 a glubtastic time <3 - NT NET ID; 2459037122"} //I feel compelled to state this isn't a phone number, but a ID for a certain, specific website. Honk.
