extends Resource
class_name Status

@export var name : String = "Unnamed Status"

# link Effect to a status with a HookedEffect

# create AppliedStatus that tracks the status, and the inflictor_id (enemy id or hero id)