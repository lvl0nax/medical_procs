# README

### _Парсинг процедур_ - https://en.wikipedia.org/wiki/Medical_procedure#List_of_medical_procedures
Wiki API - https://en.wikipedia.org/w/api.php?action=query&rvprop=content&titles=Medical_procedure&format=json&prop=revisions

Поскольку Википедия имеет API, хоть и скудное, было принято решение воспользоваться им, поскольку верстка может меняться. 
Наполнить БД данными можно с помощью seed-ов - `bundle exec rake db:seed`

### _"Дай возможность наполнить базу процедурами"_
Помимо seed-ов есть возможность создавать новые процедуры через api. Не уверен, что это надо было делать, но для удобство 
тестирования возможно может пригодиться. Это не продакшин реди экшин, поскольку нет авторизации и тд. Но из текущей постановки задачи, 
подумал, что возможно имеет смысл создать.

## API 
### Поиск и получение списка процедур - GET
- https://med-procs-app.herokuapp.com/api/v1/medical_procedures?query=angiogr

где `query` GET-параметр для поиска медицинской процедуры по названию

ответ
```json
[
"Angiography",
"Lymphangiography",
"Cerebral angiography",
"Coronary angiography",
"Pulmonary angiography"
]
```

Для данного API не было никаких указаний по структуре JSON и тд. Поэтому опять же для простоты, оставил наиболее простой 
вариант без сериалайзеров и прочих "красивостей". Так на данный момент быстрее отрабатывает и проще и понятней читать код.

### Создание процедуры - POST
- https://med-procs-app.herokuapp.com/api/v1/medical_procedures

params: `{ title: 'some medical procedure name' }`

В данном API имеется одна валидация на уникальность. 
В случае если `title` уже существует вернется статус `400 - bad request`

Поскольку, в моем понимании, этот урл создан __исключительно__ для тестирования. Индексов на уникальность я не создавал. 
Регистр учитывается в проверке на уникальность (т.е. если название имеет разный регистр - процедуры разные)  

## Допущения

1) На первый взгляд, кажется, что это относительно полный список процедур. Изменятся он будет не часто, и не уверен что 
   таблица может вырасти до огромных размеров. Поэтой причине поиск сделан обычным `ILIKE` и без каких-либо индексов. 
   Для большой таблицы надо было бы смотреть в зависимости от требований и возможностей. На мой взгляд для больших таблиц 
   можно посмотреть следующие варианты: 
   - расширение pg_trgm - (индекс `gin (lower(title) gin_trgm_ops)`, word_similarity и тд)
   - полнотекстовый поиск в postgresql (to_tsvector, to_tsquery и тд)
   - либо выйти за пределы postgresql и посмотреть в сторону ElasticSearch и Sphinx

2) Код оставлен, на мой взгляд, максимально простым, и в то же время, выполняющим все необходимые требования (если я ничего 
   не упустил и все правильно понял). Это сделано специально для того, чтоб если в дальнейшем придется развивать проект/API, 
   с получением новых входных требований/условий и тд мы могли выбрать наиболее правильные интструменты и подходы

3) > Вначале списка выдаются те процедуры, у которых запрос совпадает с началом слова, а далее те, у которых просто запрос 
   > входит в название.
   
    в данном предложении "__с началом слова__" я понял как "__с началом названия__". Если в данном случае имеется ввиду 
   "__с началом ЛЮБОГО слова из названия__", то в данном случае имеет смысл, как мне кажется, использовать `pg_trgm`
   ```sql
    CREATE extension pg_trgm;
    CREATE INDEX lower_title_trgm_index ON medical_procedures USING gin (lower(title) gin_trgm_ops);
   
    SELECT title, strict_word_similarity('ther', lower(title)) AS sws
    FROM medical_procedures
    WHERE 'ther' <% title
    ORDER BY sws DESC, title;
    ```
