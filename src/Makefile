#all: gesture_helper keyboard_helper events_helper apple_disable_ctrl_delay
all: keyboard_helper apple_disable_ctrl_delay

gesture_helper: gesture_helper.c
	mkdir -p ./obj 2>/dev/null
	$(CC) gesture_helper.c -linput -ludev -o ./obj/gesture_helper

keyboard_helper: keyboard_helper.c
	mkdir -p ./obj 2>/dev/null
	$(CC) keyboard_helper.c -o ./obj/keyboard_helper

apple_disable_ctrl_delay: apple_disable_ctrl_delay.c
	mkdir -p ./obj 2>/dev/null
	$(CC) apple_disable_ctrl_delay.c -o ./obj/apple_disable_ctrl_delay

events_helper: events_helper.c
	mkdir -p ./obj 2>/dev/null
	$(CC) events_helper.c -lX11 -o ./obj/events_helper

clean:
	rm -r ./obj

install:all
	sudo cp ./obj/* /usr/local/sbin
