#project
NAME	= coconut.bin

SRC_DIR	= src
SRC		= $(SRC_DIR)/bootsector.s

# compiler options
ASM			= nasm
ASM_FLAGS	= -f bin -i$(SRC_DIR)

# colors
INFO	= \x1b[1;36m
CREATED	= \x1b[1;32m
REMOVED = \x1b[1;33m
ERROR	= \x1b[1;31m
END		= \x1b[0m

# targets
.PHONY: all clean fclean re run

all: $(NAME)
	@printf '$(INFO)Done making $(NAME)$(END)\n'

clean:

fclean: clean
	@printf '$(REMOVED)Removed $(NAME)$(END)\n'
	@rm -f $(NAME)

re: fclean all

run: all
	@cp $(NAME) disk.bin
	@if [ -f "bootable.bin" ]; then cat bootable.bin >> disk.bin; fi
	@qemu-system-x86_64 -drive format=raw,file=disk.bin

$(NAME): $(SRC)
	@$(ASM) $(ASM_FLAGS) -o $(NAME) $(SRC)
	@printf '$(CREATED)Created $(NAME)$(END)\n'