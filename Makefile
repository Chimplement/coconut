#project
NAME	= bootport.bin

SRC_DIR	= src
SRC		= $(SRC_DIR)/bootsector.s

# compiler options
ASM			= nasm
ASM_FLAGS	= -f bin

# colors
INFO	= \x1b[1;36m
CREATED	= \x1b[1;32m
REMOVED = \x1b[1;33m
ERROR	= \x1b[1;31m
END		= \x1b[0m

# targets
.PHONY: all clean fclean all

all: $(NAME)
	@printf '$(INFO)Done making $(NAME)$(END)\n'

clean:

fclean: clean
	@rm -f $(NAME)

re: fclean all

$(NAME): $(SRC)
	@$(ASM) $(ASM_FLAGS) -o $(NAME) $(SRC)
	@printf '$(CREATED)Created $(NAME)$(END)\n'