OUTFILE = bin/DisableVehicleLimit.dll
 
COMPILE_FLAGS = -m32 -c -O2 -w -std=c++11 -D_WIN32
LINK_FLAGS = -m32 -shared -O3

# Автоматический поиск файлов для Windows-сервера GitHub
SOURCES = src/main.cpp src/SDK/amxplugin.cpp
OBJECTS = main.o amxplugin.o

all:
	# Создаем папку bin на сервере
	mkdir -p bin
	# Компилируем C++ код с отключением строгой проверки типов
	g++ $(COMPILE_FLAGS) -fpermissive src/main.cpp -o main.o
	g++ $(COMPILE_FLAGS) -fpermissive src/SDK/amxplugin.cpp -o amxplugin.o
	# Собираем всё в готовый .dll плагин
	g++ $(LINK_FLAGS) -o $(OUTFILE) $(OBJECTS)
	rm -f *.o
