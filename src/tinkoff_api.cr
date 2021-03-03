require "json"
require "http"
require "./tinkoff_api/*"

module TinkoffApi
  VERSION = "0.1.0"
  DATE_FORMAT = "%Y-%m-%d"
  TINKOFF_SERVER = "https://business.tinkoff.ru"
  TINKOFF_PATH_PREFIX = "/openapi"
end
