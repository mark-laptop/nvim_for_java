# HTML, Markdown, Docker и YAML

Старые mappings, Java и Python сохранены. Все серверы устанавливаются через Mason.

| Файлы | Поддержка |
|---|---|
| .html | Теги, атрибуты, HTML-сниппеты, документация и форматирование |
| .md | Дополнение ссылок на файлы и заголовки, wiki-links, навигация и переименование через Marksman |
| Dockerfile, Dockerfile.*, Containerfile, Containerfile.* | Дополнение инструкций Dockerfile, документация и диагностика |
| compose.yml/.yaml, docker-compose.yml/.yaml и варианты *.override.* / *.dev.* | Дополнение полей Compose, документация, диагностика и форматирование |
| .yml / .yaml | YAML-диагностика, форматирование, дополнение по JSON Schema |

## Клавиши

- Ctrl-Space — вызвать подсказки; Tab / Shift-Tab — выбор, Enter — подтверждение.
- K — документация под курсором.
- gd / gr — определение / использования, если сервер поддерживает.
- Space rn — переименование символа или Markdown-заголовка со ссылками.
- Space ca — доступные code actions.
- Space cf — форматирование через LSP, если сервер предоставляет форматирование.
- Space cd / cl — диагностика строки / список ошибок.
- Space fs / fS — символы файла / проекта.

Marksman дополняет ссылки и заголовки, а не произвольный текст.
Например, набери [[ или [текст]( и вызови Ctrl-Space.
Для общего Markdown-workspace используются .git или .marksman.toml.
Без них работает режим отдельного файла. Для ссылок между заметками вне Git
создай пустой .marksman.toml в корневом каталоге заметок.
Marksman не предоставляет форматирование Markdown; Space cf для .md не форматирует текст.

YAML использует SchemaStore: схемы известных форматов выбираются по имени файла.
Произвольный YAML не имеет фиксированного набора ключей, поэтому для предметных подсказок
укажи свою схему первой строкой:

    # yaml-language-server: $schema=./schema.json

Внешние схемы требуют доступа к сети; можно использовать локальную JSON Schema.
Отступы YAML — два пробела; вставка Tab использует пробелы.
Compose использует собственный сервер, обычный YAML LSP к нему не подключается.
Для нестандартного имени Compose-файла: :setfiletype yaml.docker-compose
(если тип уже yaml, используй :set filetype=yaml.docker-compose).

Docker Engine для подсказок в Dockerfile и Compose не нужен.
Запуск контейнеров и установка Docker в эту настройку не входят.

После первой установки перезапусти Neovim.
:Mason — состояние серверов; :MasonToolsInstall — повторная установка недостающих;
:checkhealth vim.lsp и :messages — диагностика.
Конфигурация: lua/core/web-lsp.lua.

Документация:
- [HTML language server](https://github.com/hrsh7th/vscode-langservers-extracted)
- [Marksman](https://github.com/artempyanykh/marksman)
- [Dockerfile language server](https://github.com/rcjsuen/dockerfile-language-server-nodejs)
- [Compose language service](https://github.com/microsoft/compose-language-service)
- [YAML language server](https://github.com/redhat-developer/yaml-language-server)
