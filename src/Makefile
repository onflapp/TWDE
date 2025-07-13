all: gesture_helper keyboard_helper events_helper apple_disable_ctrl_delay

gesture_helper: gesture_helper.c
	gcc `pkg-config --atleast-version=1.19 libinput && echo "-DHAS_LIBINPUT19"` gesture_helper.c -linput -ludev -o ./obj/gesture_helper

keyboard_helper: keyboard_helper.c
	gcc keyboard_helper.c -o ./obj/keyboard_helper

apple_disable_ctrl_delay: apple_disable_ctrl_delay.c
	gcc apple_disable_ctrl_delay.c -o ./obj/apple_disable_ctrl_delay

events_helper: events_helper.c
	gcc events_helper.c -lX11 -o ./obj/events_helper

clean:
	rm ./obj/gesture_helper
	rm ./obj/keyboard_helper
	rm ./obj/events_helper
	rm ./obj/apple_disable_ctrl_delay
