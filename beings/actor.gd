@abstract
class_name Actor extends Node3D

'''
An abstract class that is a parent to Beings and Casters. This is just
in case we ever need to make non-being actors who can perform events,
such as weather effects.
'''

#================================================
# Private methods
#================================================

@abstract
func _choose_being_from_range(param: BeingTargetParam)

@abstract
func _choose_card_from_range(param: CardTargetParam)
