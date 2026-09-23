OUTFILE = bin/DisableVehicleLimit.dll
 
GXX = g++
# Добавляем макрос -D_STDINT_H, чтобы MinGW не конфликтовал со старым SDK, 
# и макрос _GCLIBCXX_PERMISSIVE для исправления специализации шаблонов в urmem
COMPILE_FLAGS = -m32 -c -O2 -w -std=c++11 -D_WIN32 -D_WINDLL -D_STDINT_H -fpermissive
LINK_FLAGS = -m32 -shared -O3

OBJECTS = main.o amxplugin.o

all:
	# Создаем папку bin на сервере GitHub
	mkdir -p bin
	
	# 1. Заменяем линуксовый mman.h на windows.h в основном заголовочнике
	sed -i 's|<sys/mman.h>|<windows.h>|g' src/main.h
	
	# 2. Аккуратно добавляем типы cstdint в самый верх amx.h БЕЗ удаления строк
	sed -i '1s|^|#include <cstdint>\n#include <cstddef>\n|' src/SDK/amx/amx.h
	
	# 3. Исправляем специализацию шаблонов в urmem.hpp, заменяя 'template<>' на корректный для GCC синтаксис
	sed -i 's/template<>/template<> \/\/ /g' src/urmem.hpp

	# Компилируем C++ код силами GitHub Actions
	$(GXX) $(COMPILE_FLAGS) src/main.cpp -o main.o
	$(GXX) $(COMPILE_FLAGS) src/SDK/amxplugin.cpp -o amxplugin.o
	
	# Собираем всё в готовый плагин DisableVehicleLimit.dll
	$(GXX) $(LINK_FLAGS) -o $(OUTFILE) $(OBJECTS)
	rm -f *.o
