require "json"
require "http"
require "./tinkoff_api/*"
require "./tinkoff_api/webhooks/operation"
require "./tinkoff_api/converters/operation_converter"

module TinkoffApi
  DATE_FORMAT = "%Y-%m-%d"
  TINKOFF_SERVER = "https://business.tinkoff.ru"
  TINKOFF_PATH_PREFIX = "/openapi"
end
