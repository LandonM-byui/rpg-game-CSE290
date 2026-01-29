extends Node2D

# Tbh, just copying Dallin here
class_name ScenePreset
@onready var button = $VBoxContainer/TextureButton



# commenting this out to test the basic version first!
#func _assign_buttons():
## assigning all buttons, should do up to 10!
### if we have more than 10, we will need to update this function
### IF BUTTONS are given CUTSOM NAMES: will have to add more logic to this function to generalize it for each scene
	#if $TextureButton:
		#var button = $TextureButton
	#if $TextureButton1:
		#var button1 = $TextureButton1
	#if $TextureButton2:
		#var button2 = $TextureButton2
	#if $TextureButton3:
		#var button3 = $TextureButton3
	#if $TextureButton4:
		#var button4 = $TextureButton4
	#if $TextureButton5:
		#var button5 = $TextureButton5
	#if $TextureButton6:
		#var button6 = $TextureButton6
	#if $TextureButton7:
		#var button7 = $TextureButton7
	#if $TextureButton8:
		#var button8 = $TextureButton8
	#if $TextureButton9:
		#var button9 = $TextureButton9
	#if $TextureButton10:
		#var button10 = $TextureButton10
