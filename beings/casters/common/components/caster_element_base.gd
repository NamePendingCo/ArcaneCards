@abstract
class_name CasterElementBase extends Node3D

'''
This class exists so that any caster nodes can have a shared codebase.
This would include the casting well, hand, deck, etc.
'''

'''
Just used to return the location state a card should be changed to when 
associated with this element
'''
@abstract
func _get_relevant_location() -> Card.Location
