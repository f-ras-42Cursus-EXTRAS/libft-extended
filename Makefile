# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: fras <fras@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2023/05/01 18:18:49 by fras          #+#    #+#                  #
#    Updated: 2023/07/08 16:47:37 by fras          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = libftextended.a
CC = gcc
CFLAGS = -Werror -Wextra -Wall
INCLUDE = -I include
LIB_DIR = libft ft_printf gnl_lib
LIBRARY_NAMES = libft.a libftprintf.a gnl_lib.a
USED_LIBS = $(notdir $(shell find . -type f -name "*.a" -d 1))
LIBRARY_PATHS = $(addprefix lib/, $(join \
			$(addsuffix /, $(LIB_DIR)), $(LIBRARY_NAMES)))
SRC_DIR = src
OBJ_DIR = obj
SOURCES = $(shell find $(SRC_DIR) -type f -name "*.c")
OBJECTS = $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SOURCES:%.c=%.o))
RM = rm -f

# Functions
get_lib_dir = $(filter %/$(1), $(LIBRARY_PATHS))

# Targets
.PHONY: all clean fclean re directories updatelibs useinfo

all: $(LIBRARY_NAMES) $(NAME)

$(NAME): $(OBJ_DIR) $(OBJECTS)
	ar -rcs $(NAME) $(OBJECTS)
	@$(MAKE) useinfo

$(OBJ_DIR): directories

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $^	

# Libraries
$(LIBRARY_NAMES):
	$(MAKE) $(call get_lib_dir,$@)
	cp $(call get_lib_dir,$@) $@
	@$(MAKE) useinfo

$(LIBRARY_PATHS):
	$(MAKE) -C $(dir $@) all

libsupdate:
	git submodule update --init

# Directories
directories:
	@find $(SRC_DIR) -type d | sed 's/$(SRC_DIR)/$(OBJ_DIR)/' | xargs mkdir -p

# Cleaning
clean:
	$(RM) $(OBJECTS)
	$(RM) -r obj

fclean: clean
	@for lib in $(LIB_DIR); do \
		$(MAKE) -C lib/$$lib fclean; \
	done
	$(RM) $(LIBRARY_NAMES) $(NAME)

re: fclean all

# Information
useinfo:
	@echo "\033[92mLibraries available: $(USED_LIBS)\033[0m"
