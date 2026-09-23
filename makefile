OUTFILE = bin/DisableVehicleLimit.dll
 
GXX = g++
COMPILE_FLAGS = -m32 -c -O2 -w -std=c++11 -D_WIN32
LINK_FLAGS = -m32 -shared -O3

OBJECTS = main.o amxplugin.o

all:
	# Создаем папку bin на сервере
	mkdir -p bin
	# Используем правильный компилятор через $(GXX) с отключением строгой проверки типов
	$(GXX) $(COMPILE_FLAGS) -fpermissive src/main.cpp -o main.o
	$(GXX) $(COMPILE_FLAGS) -fpermissive src/SDK/amxplugin.cpp -o amxplugin.o
	# Собираем всё в готовый .dll плагин
	$(GXX) $(LINK_FLAGS) -o $(OUTFILE) $(OBJECTS)
	rm -f *.o
