local cards = {}
cards.base = {}

cards.base.tier1 = {
	red =	{"Charge!", "Charge!", "Stargate", "God Speed"},
	blue = {"Recruiting Scribe", "Recruiting Scribe", "Defense!", "Defense!"},
	white = {"Priest", "Priest", "Priestess", "Priestess"},
	black = {"Mercenaries", "Mercenaries", "Enforced Recruitment", "Dark Ritual"},
}

cards.base.tier2 = {
	red = {"Carnage", "Offensive Strategy", "Open Gates", "Teleport"},
	blue = {"Legion", "Ancestral Elephant", "Defensive Strategy", "Deep Desert Snake"},
	white = {"Slaves", "High Priest", "Crusade", "Divine Boon"},
	black = {"Honor in Battle", "Dedication to Battle", "Khnum's Sphinx", "Twin Ceremony"},
}

cards.base.tier3 = {
	red = {"Royal Scarab", "Blades of Neith", "Divine Wound", "Victory Point"},
	blue = {"Shield of Neith", "Defensive Victory", "Prescience", "Victory Point"},
	white = {"Hand of God", "Vision", "Holy War", "Victory Point"},
	black = {"Griffin Sphinx", "Forced March", "Deadly Trap", "Victory Point"},
}

cards.base.tier4 = {
	red = {"Giant Scorpion", "Initiative", "Phoenix", "Act of God"},
	blue = {"Reinforcements", "Sphinx", "Divine Will", "Act of God"},
	white = {"Priest of Ra", "Priest of Amon", "The Mummy", "Act of God"},
	black = {"Devourer", "Bestial Fury", "Divine Strength", "Act of God"},
}

cards.greek_legends = {
	tier2 = {
		red = {"Cerberus"},
		blue = {"Kraken"},
		white = {"Chiron", "Minotaur"},
	},
	tier3 = {
		red = {"Medusa"},
		blue = {"Polyphemus"},
	}
}

cards.ta_seti_goodies = {
	tier1 = {
		blue = {"Protective Aura"},
	},
	tier2 = {
		red = {"Night Expedition"},
		white = {"Reminiscence"},
		black = {"Piety"},
	}
}

return cards
