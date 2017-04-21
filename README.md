## Установка

Добавьте в ваш Gemfile:

    gem 'yaml_aws_sync', git: 'https://github.com/badimalex/yaml_aws_sync.git'

## Настройка

Обязательно сгенерируйте и настройте правила импорта:

```sh
$ rails g yaml_aws_sync:install
```

Генератор задач для capistrano:

```sh
$ rails g yaml_aws_sync:capistrano
```

Для хранения конфигураций используйте гем:

    gem 'config'


```sh
$ rails g config:install
```

Пример настроек для config/settings/[development,production].yml

    aws:
      provider:   "value"
      access_key: "value"
      secret_key: "value"
      directory:  "value"
      region:     "value"

      backup:
        yaml:
          bucket: "value"
          source: "value"
          target: "value"

        images:
          source: "value"
          target: "value"

### Копирование таблиц из aws

- Источник/цель определяется в config/settings/[development,production].yml (секция backup - yaml)
- Запуск команды без аргументов скопирует таблицы указанные в (config/aws/tables.yml)
- Правила можно задать двух типов: type - регулярное выражение, tables - список таблиц

```sh
$ rake aws:sync:restore_zip_from_s3
```

- в аргументах можно указать таблицы для копирования

```sh
$ rake aws:sync:restore_zip_from_s3 tables=catalog_jobs,catalog_materials
```

### Отправка бэкапа текущей базы на aws

```sh
$ rake rake aws:sync:backup_zip_to_s3
```

### Копирование файлов из aws

- Источник/цель определяется в config/settings/[development,production].yml (секция backup - images)
- Запуск команды без аргументов скопирует все папки указанные в (config/aws/folders.yml)

```sh
$ rake aws:sync:restore_images_from_s3
```

- в аргументах можно указать папки для копирования

```sh
$ rake aws:sync:restore_images_from_s3 folders=uploads/slide/image,uploads/catalog/typical_work/image
```
