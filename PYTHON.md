# Python-разработка в Neovim

Java-настройки и старые mappings сохранены. Space — пробел.

## Что настроено

- Pyright: автокомплит, типы, документация, определения, использования и переименование.
- Ruff: диагностика, форматирование, code actions и организация импортов.
- debugpy: отладка файла, модуля и pytest, подключение к порту 5678.
- Запуск файла, модуля, REPL и pytest из редактора.
- Автоматический выбор .venv и ручной выбор Python для каждого проекта.
- Отступы Python: четыре пробела, только для Python-файлов.

Форматирование выполняется по запросу; настройки Ruff читаются из pyproject.toml / ruff.toml.
Pyright использует basic-проверку типов. Для строгой проверки добавь typeCheckingMode
в pyrightconfig.json или [tool.pyright] проекта.

## Окружение проекта

Открой Python-файл из проекта с pyproject.toml, setup.py, requirements.txt или .git.
Для одиночного файла рабочим каталогом будет его директория.

Выбор интерпретатора: ручной выбор → .venv / venv / env проекта →
VIRTUAL_ENV → CONDA_PREFIX → Python из PATH → установленный Python через uv/py.
Ручной выбор действует до закрытия Neovim и применяется к Pyright, запуску и отладке.
Для Poetry/Conda вне проекта укажи путь к окружению через Space pv.
Зависимости проекта не устанавливаются автоматически.

На этой машине Python 3.12 установлен через uv. Пример нового окружения в терминале проекта:

    uv venv --python 3.12
    uv pip install pytest

Для существующего uv-проекта используй uv sync с его lock-файлом и группами зависимостей.
Для requirements.txt: uv pip install -r requirements.txt.
pytest должен быть установлен именно в выбранном окружении.
debugpy устанавливается отдельно через Mason; ставить его в каждую .venv для launch не нужно.
После создания окружения при открытом Neovim выбери его через Space pv для обновления Pyright.

## Клавиши

| Клавиши | Действие |
|---|---|
| Space pr | Сохранить файлы и запустить текущий Python-файл |
| Space pm | Запустить модуль, например package.main |
| Space pi | Открыть REPL выбранного Python |
| Space pt | pytest текущего файла |
| Space pT | pytest всего проекта |
| Space pd | Отладить pytest текущего файла |
| Space pv | Выбрать Python executable или каталог venv |
| Space pe | Показать выбранный интерпретатор |
| Space po | Организовать импорты через Ruff |
| Space cf | Форматировать файл через Ruff |
| Space ca | Исправления и code actions |
| gd / gi / gr / K | Определение / реализация / использования / документация |
| Space rn | Переименовать символ |
| Space cd / cl | Диагностика строки / список ошибок |
| Ctrl-Space, Tab, Enter | Автокомплит, выбор, подтверждение |

PythonSelect и PythonInfo доступны как команды в Python-буфере.
Запуск и pytest сохраняют изменённые файлы (:wall). Логи остаются в отдельном нижнем терминале.
Esc / jk переводят терминал в normal mode; Space q закрывает окно, Ctrl-C останавливает задачу.
Существующий Ctrl-\ продолжает переключать ToggleTerm; Python-задачи открывают собственные терминальные буферы.

## Отладка

F5 в Python-файле предлагает запуск текущего файла, модуля, pytest файла/проекта
или подключение к localhost:5678. Перед F5 сохрани изменения.

| Клавиши | Действие |
|---|---|
| Space db / dB | Обычная / условная точка останова |
| F5 | Запуск / продолжить |
| F10 / F11 / F12 | Шаг через / внутрь / наружу |
| Space du | Панель переменных, стека и watches |
| Space de | Вычислить выражение |
| Space dr | Консоль отладчика |
| Space dq | Завершить отладку |

Для отдельного pytest-теста выбери тестовый конфиг и укажи node ID в args,
например tests/test_api.py::test_create. Встроенные быстрые команды работают на уровне файла/проекта.
Для Django, FastAPI и других приложений добавь проектную конфигурацию в .vscode/launch.json:
module/program, args, env, django или jinja при необходимости.
Загрузить её явно:
:lua require("dap.ext.vscode").load_launchjs(nil, { python = { "python" } })

## Обслуживание

:Mason — состояние pyright, ruff, debugpy.
:MasonToolsInstall — установка недостающих инструментов.
:checkhealth vim.lsp и :messages — диагностика.
Перезапусти Neovim после первой установки инструментов.
Для повторной установки debugpy Python должен быть доступен Mason в PATH:
можно запустить Neovim из активированной .venv.

Основные файлы: lua/python/env.lua, lua/python/tasks.lua, lua/python/debug.lua,
after/ftplugin/python.lua и Python-секции lua/plugins/lsp.lua, lua/plugins/mason.lua.

Документация:
- [Pyright](https://github.com/microsoft/pyright)
- [Ruff для Neovim](https://docs.astral.sh/ruff/editors/setup/)
- [debugpy](https://github.com/microsoft/debugpy)
