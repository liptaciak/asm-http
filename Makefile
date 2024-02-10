# Compiler and linker options
NASM = nasm
LD = ld
NASM_FLAGS = -f elf64

# Target executable
TARGET = a.out

# Source files
SOURCE = server.asm

# Object files
OBJ = server.o

# Default target
all: $(TARGET)

# Rule to build the executable
$(TARGET): $(OBJ)
	$(LD) $^ -o $@

# Rule to assemble source file into object file
%.o: %.asm
	$(NASM) $(NASM_FLAGS) $< -o $@

# Clean rule
clean:
	rm -f $(OBJ) $(TARGET)