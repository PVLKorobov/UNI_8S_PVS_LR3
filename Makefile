# Make считывает конфиг формата KEY=VALUE как переменные. Их можно вызывать напрямую $(KEY)
ifneq ("$(wildcard config.txt)","")
	include config.txt
endif

# Локальные пути к директориям исходных и скомпелированых файлов
BINARY_DIR=bin/
SOURCE_DIR=src/

# Флаги компилятора
F_CPU=1200000
CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-std=c99 -Wall -g -Os -mmcu=${MCU} -DF_CPU=${F_CPU} -I.
TARGET=$(BINARY_DIR)main
SRCS=$(SOURCE_DIR)main.c

# ID портов для проверки условий на этапе препроцессора в C файлах
# Сравнение регистров напрямую не работают
PORTA_ID := 0
PORTB_ID := 1
PORTD_ID := 2

# Список названий макросов для передачи компилятору в виде флагов -D
# TODO MACROS_DEFS_NAMES := 

# Вызов компилятора с собранными флагами
# TODO Переделать компиляцию под несколько файлов прошивки
all:
	if [ ! -d "$(BINARY_DIR)" ]; then mkdir $(BINARY_DIR); fi
	${CC} ${CFLAGS} $(foreach v,$(MACROS_DEFS_NAMES),-D$(v)=$($(v))) -o ${TARGET}.bin ${SRCS}
	${OBJCOPY} -j .text -j .data -O ihex ${TARGET}.bin ${TARGET}.hex

# Очистка директории со скомпелироваными файлами
clean:
	rm -f $(TARGET).bin $(TARGET).hex

# Создание директорий исходных и скомпелированых файлов если их нет
setup:

# 	TODO Создать конфиг с пустыми ключами
	touch config.txt

	if [ ! -d "$(SOURCE_DIR)" ]; then mkdir $(SOURCE_DIR); fi