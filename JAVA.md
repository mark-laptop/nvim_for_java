# Java-разработка в Neovim

Существующие сочетания сохранены. В таблицах Space — пробел (leader).
Требуется JDK 21+ для языковых серверов; текущая машина использует JDK 21.
Плагины закреплены в lazy-lock.json. Mason устанавливает недостающие инструменты автоматически, без автообновления.

## Начало работы

Открой Neovim в каталоге Maven/Gradle-проекта и открой Java-файл.
Дождись первоначального импорта зависимостей и индексации JDTLS.
В проекте должны быть pom.xml или build.gradle / build.gradle.kts.
При новой установке: :Lazy install, затем :MasonToolsInstall и перезапуск Neovim.
Состояние инструментов: :Mason. Ошибки: :messages и :checkhealth vim.lsp.

## Код и навигация

| Клавиши | Действие |
|---|---|
| Ctrl-Space | Вызвать автокомплит |
| Tab / Shift-Tab, Enter | Выбор и подтверждение подсказки (как раньше) |
| gd / gD / gi / gr | Определение / объявление / реализация / использования |
| K | Документация |
| Space rn | Переименование символа |
| Space ca | Code actions: исправления, генерация кода и рефакторинг |
| Space cf | Форматирование текущего файла |
| Space cd / cl | Диагностика строки / список ошибок проекта |
| Space fs / fS | Символы файла / проекта, включая Spring |
| Space jo | Упорядочить импорты |
| Space ju | Перечитать конфигурацию сборки |
| Space jv / jm в visual mode | Извлечь переменную / метод |

Автокомплит поддерживает встроенные сниппеты Neovim и пути.
Для перехода по полям сниппета используй команды Neovim;
явные команды: :lua vim.snippet.jump(1) и :lua vim.snippet.jump(-1).
Форматирование выполняется по запросу, без автоматической перезаписи при сохранении.
Lombok подключается из Mason. JDTLS импортирует Maven/Gradle и исходники зависимостей.
Для pom.xml включён XML LSP, для YAML — YAML LSP.

## Запуск и тесты

| Клавиши | Действие |
|---|---|
| Space jr | Выбрать и запустить main без остановок отладчика |
| Space js | Spring Boot: spring-boot:run / bootRun |
| Space jb | Собрать текущий модуль без тестов |
| Space ja | Все тесты текущего модуля через Maven/Gradle |
| Space jt / jT | Запустить ближайший тест / тестовый класс |
| Space jd | Spring Boot с портом отладки 5005 |

Команды сборки сначала сохраняют открытые изменённые файлы (:wall).
Используется ближайший модуль, wrapper ищется в нём и родительских каталогах.
Без wrapper используется mvn или gradle из PATH. На Windows используются .cmd / .bat.
Логи остаются в терминале после завершения. Ctrl-C в terminal mode останавливает приложение.
Существующее Ctrl-\ переключает терминал; Esc или jk переводит его в normal mode.
Для многомодульной сборки всего reactor запускай Maven/Gradle из корня в терминале.
Для Spring-запуска в модуле должен быть подключён Spring Boot build plugin.

## Отладка

| Клавиши | Действие |
|---|---|
| F5 | Выбрать конфигурацию / продолжить выполнение |
| F10 / F11 / F12 | Шаг через / внутрь / наружу |
| Space db / dB | Обычная / условная точка останова |
| Space du | Панель отладчика: переменные, стек, watches |
| Space de | Вычислить выражение |
| Space dr | Консоль отладчика |
| Space dq | Завершить сессию |
| Space dt / dT | Отладить ближайший тест / класс |

Для обычного Java или Spring main: поставь breakpoint, нажми F5 и выбери main.
Для запуска через build tool: Space jd, затем вернись в Java-файл и F5 → Attach localhost:5005.
Gradle --debug-jvm ожидает подключения до запуска приложения.
Maven запускается сразу; подключайся после сообщения о порте 5005.
Панель сохраняется после завершения, чтобы можно было изучить результат; Space du скрывает её.
Hot code replace включён там, где изменение поддерживается JVM.

Дополнительные конфигурации (args, vmArgs, env, mainClass, projectName) можно добавить
в require("dap").configurations.java в lua/plugins/java.lua.
Для проекта можно использовать .vscode/launch.json, загрузив его явно:
:lua require("dap.ext.vscode").load_launchjs(nil, { java = { "java" } })

## Spring и разные JDK

Spring Boot LS подключён для Java и application*.properties / application*.yml / application*.yaml:
подсказки свойств, навигация, Spring symbols. Для полного контекста открой также Java-файл проекта.
Результаты зависят от версии Spring и метаданных зависимостей.
Это интеграция языковых серверов, а не полный набор инструментов IntelliJ Ultimate.

JDTLS_JAVA_HOME задаёт JDK для серверов; иначе используется JAVA_HOME, затем java из PATH.
JAVA8_HOME, JAVA11_HOME, JAVA17_HOME, JAVA21_HOME, JAVA25_HOME добавляют JDK проектов.
Версия языка задаётся в pom.xml / Gradle; :JdtSetRuntime позволяет выбрать runtime.
После изменения зависимостей: Space ju. После установки расширений: перезапуск Neovim.
Рабочие индексы разделены по полному пути проекта, включая проекты с одинаковыми именами.

Документация:
- https://github.com/mfussenegger/nvim-jdtls
- https://github.com/JavaHello/spring-boot.nvim/blob/main/README_en.md
- https://github.com/mfussenegger/nvim-dap

