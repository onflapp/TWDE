all: gesture_helper keyboard_helper events_helper apple_disable_ctrl_delay

gesture_helper: gesture_helper.c
	clang gesture_helper.c -linput -ludev -o ./obj/gesture_helper

keyboard_helper: keyboard_helper.c
	clang keyboard_helper.c -o ./obj/keyboard_helper

apple_disable_ctrl_delay: apple_disable_ctrl_delay.c
	clang apple_disable_ctrl_delay.c -o ./obj/apple_disable_ctrl_delay

events_helper: events_helper.c
	clang events_helper.c -lX11 -o ./obj/events_helper

clean:
	rm ./obj/gesture_helper
	rm ./obj/keyboard_helper
	rm ./obj/events_helper
	rm ./obj/apple_disable_ctrl_delay
