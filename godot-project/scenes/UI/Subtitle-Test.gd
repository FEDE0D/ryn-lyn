extends Control

var count = 0

func _on_Button_pressed():
	count+=1
	$"%LiveCaption".caption("[DOOR KNOCK %s]" % count, true)
