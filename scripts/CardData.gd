class_name Card extends Node3D

@export var data: CardData:
	set(value):
		#Get the cardface object to modify
		var spell_face = $"Cardfront/SubViewport/CardFace"
		
		#set the new data as the data for this card
		data = value
		
		#set name in cardface
		spell_face.get_node("Name").text = data.cardName
		
		#set tier and activation cost on cardface
		var ac = data.activation_cost
		match data.tier:
			1:
				spell_face.get_node("Tier").text = 'I'
				spell_face.get_node("ActivationCost").text = ac[0]
			2:
				spell_face.get_node("Tier").text = 'II'
				spell_face.get_node("ActivationCost").text = ac[0] + '/' + ac[1]
			3:
				spell_face.get_node("Tier").text = 'III'
				spell_face.get_node("ActivationCost").text = ac[0] + '/' + ac[1] + '/' + ac[2]
				
		#set upkeep cost on cardface
		spell_face.get_node("UpkeepCost").text = data.upkeep_cost
		
		#creates the overview string and sets it on cardface
		spell_face.get_node("Overview").text = '-- ' + Enums.colorString(data.color) + ' (' + Enums.subdomainString(data.subdomain) + ') -- ' + Enums.typeString(data.type) + ' --'
