AS      = aarch64-linux-gnu-as
LD      = aarch64-linux-gnu-ld
QEMU    = qemu-aarch64
GDB     = gdb-multiarch

SRC_DIR   = src
BUILD_DIR = build

OBJ       = $(BUILD_DIR)/main.o
TARGET    = $(BUILD_DIR)/tarea3

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) -e _start -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s | $(BUILD_DIR)
	$(AS) -g -o $@ $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

run: $(TARGET)
	$(QEMU) ./$(TARGET)

debug: $(TARGET)
	$(QEMU) -g 1235 ./$(TARGET)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run debug clean