OUTFILE = bin/DisableVehicleLimit.dll
 
GXX = g++
COMPILE_FLAGS = -m32 -c -O2 -w -std=c++11 -D_WIN32
LINK_FLAGS = -m32 -shared -O3

OBJECTS = main.o amxplugin.o

all:
	# Создаем папку bin на сервере
	mkdir -p bin
	
	# Автоматически заменяем линуксовый mman.h на windows.h прямо в файле main.h
	sed -i 's|<sys/mman.h>|<windows.h>|g' src/main.h
	
	# Компилируем C++ код
	$(GXX) $(COMPILE_FLAGS) -fpermissive src/main.cpp -o main.o
	$(GXX) $(COMPILE_FLAGS) -fpermissive src/SDK/amxplugin.cpp -o amxplugin.o
	
	# Собираем всё в готовый .dll плагин
	$(GXX) $(LINK_FLAGS) -o $(OUTFILE) $(OBJECTS)
	rm -f *.o
