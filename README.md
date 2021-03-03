# TinkoffApi для Crystal Lang

Библиотека для доступ к Tinkoff Business OpenApi с авторизацией через сценарий Селф-Сервиса.

Ознакомиться с [документацией](https://business.tinkoff.ru/openapi/docs) Тинькоффа.

## Установка

1. Добавьте зависимость в Ваш `shard.yml`:

   ```yaml
   dependencies:
     tinkoff_api:
       github: marzhaev/tinkoff_api
   ```

2. Выполните `shards install`

## Использование

```crystal
require "tinkoff_api"
```

Для авторизации требуется передать выданный банком ключ доступа (AccessToken) Селф-Сервис сценария через переменную среды.

Пример через командную строку
```bash
  TINKOFF_ACCESS_TOKEN=... crystal run src/tinkoff_api.cr
```

Пример через код Вашего приложения
```crystal
  ENV["TINKOFF_ACCESS_TOKEN"] ||= "..."
```

## Примеры запросов

На данный момент реализованы три сервиса: - информация по компании, информация по счетам, выписка по счёту

Информация по компании доступна:

```crystal
response = TinkoffApi::Company::Client.new.execute #=> TinkoffApi::Company::Response
response.name # Название Вашей компании
```

Список счетов компании доступен:

```crystal
response = TinkoffApi::BankAccounts::Client.new.execute #=> TinkoffApi::BankAccounts::Response
bank_account = response.bank_accounts[0] # Первый доступный счёт
bank_account.balance # Остаток на первом счёте
```

Получение выписки требует указания счёта и, по желания, начала и конца периода.
В примере ниже мы используем два разных варианта задания даты
```crystal
from = Time.utc(2021, 3, 2, 0, 0, 0).to_tinkoff # Задание через родной Time
from = TinkoffApi::Date.new("2021-03-02") # Задание вручную
statement = TinkoffApi::BankStatement::Client.new.execute(account_number: "...", from: from)
statement.saldo_in # Возвращает входящее сальдо
operation = statement.saldoIn[0] # Возвращает первое платёжное поручение
operation.amount # Возвращает сумму платёжного поручения
```

## Contributing

1. Fork it (<https://github.com/marzhaev/tinkoff_api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Mikhail Arzhaev](https://github.com/marzhaev) - creator and maintainer
