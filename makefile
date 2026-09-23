OUTFILE = bin/DisableVehicleLimit.dll
 
GXX = g++
COMPILE_FLAGS = -m32 -c -O2 -w -std=c++11 -D_WIN32 -D_WINDLL
LINK_FLAGS = -m32 -shared -O3

OBJECTS = main.o amxplugin.o

all:
	# Создаем папку bin на сервере GitHub
	mkdir -p bin
	
	# 1. Заменяем линуксовый mman.h на windows.h в основном заголовочнике
	sed -i 's|<sys/mman.h>|<windows.h>|g' src/main.h
	
	# 2. Подключаем стандартные типы cstdint и cstddef в amx.h
	sed -i '1s|^|#include <cstdint>\n#include <cstddef>\n|' src/SDK/amx/amx.h
	
	# 3. Полностью вырезаем конфликтующий блок кастомных типов из amx.h (с 61 по 69 строки)
	# Это уберет ошибки с int32_t, uint32_t, __int64 и int64_t
	sed -i '61,69d' src/SDK/amx/amx.h
	
	# 4. Исправляем синтаксис шаблонов в urmem.hpp под современные стандарты GCC
	sed -i 's/template<>/ \/\/ template<>/g' src/urmem.hpp

	# Компилируем C++ код силами GitHub Actions
	$(GXX) $(COMPILE_FLAGS) -fpermissive src/main.cpp -o main.o
	$(GXX) $(COMPILE_FLAGS) -fpermissive src/SDK/amxplugin.cpp -o amxplugin.o
	
	# Собираем всё в готовый плагин DisableVehicleLimit.dll
	$(GXX) $(LINK_FLAGS) -o $(OUTFILE) $(OBJECTS)
	rm -f *.o
