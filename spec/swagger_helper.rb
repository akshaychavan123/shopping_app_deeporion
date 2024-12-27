require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          },
          bearerAuth2: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        }
      },
      # security: [
      #   {
      #     bearerAuth: []
      #   }
      # ],
      paths: {},
      servers: [
        {
          url: 'http://{localhost}',
          variables: {
            localhost: {
              default: 'localhost:3000'
            }
          }
        },
        {
          url: 'http://{herokuhost}',
          variables: {
            herokuhost: {
              default: 'https://app-like-pinklay-staging-fce0b804f3ce.herokuapp.com/'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  config.openapi_format = :yaml
end
