@abstract
class_name CasterElementBase extends Node3D

'''
Just used to return the location state a card should be changed to when 
associated with this element
'''
@abstract
func _get_relevant_location() -> Card.Location
