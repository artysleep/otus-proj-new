# otus-proj-new

Перед началом работы необходимо скорректировать .env по примеру example_env, а так же если запуск осуществляется в первый раз необходимо подготовить (настроить Data Stream в Elasticsearch, загрузить дефолтные Dashboards Filebeat с интересующим индексом).
Используемые pipline указаны в reqs.txt. Для запуска можно сразу скопировать nf-app.service в /etc/systemd/system и в дальнейшем запускать:
```sh
systemctl start nf-app
```

РК и восстановление проекта автоматизированы, можно посмотреть [здесь].
[здесь]: <https://github.com/artysleep/otus-proj-automatization>

