gesture_helper: gesture_helper.c
	gcc `pkg-config --atleast-version=1.19 libinput && echo "-DHAS_LIBINPUT19"` gesture_helper.c -linput -ludev -o gesture_helper

keyboard_helper: keyboard_helper.c
	gcc keyboard_helper.c -o keyboard_helper

install: gesture_helper keyboard_helper
	cp ./gesture_helper ${TWDE_HOME}/libexec
	cp ./keyboard_helper ${TWDE_HOME}/libexec
