LIB_NAME = mpv-crystal-simple-plugin

PLUGIN_ENTRY_FILE = ./src/simple-plugin.cr

BUILD_OBJECT_COMMAND = crystal build --cross-compile $(PLUGIN_ENTRY_FILE)

all: $(LIB_NAME).so

$(LIB_NAME).so:
	$(eval BUILD_LINK_COMMAND = $(shell $(BUILD_OBJECT_COMMAND)))
	$(eval BUILD_LINK_COMMAND += -shared -o $(LIB_NAME).so)
	$(BUILD_LINK_COMMAND)

clean:
	rm -f *.o

fclean: clean
	rm -f $(LIB_NAME).so

re: fclean all

.PHONY: all clean fclean re
