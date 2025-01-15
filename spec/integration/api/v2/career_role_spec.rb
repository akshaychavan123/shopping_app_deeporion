require 'swagger_helper'

RSpec.describe 'Api::V2::CareerRolesController', type: :request do
  path '/api/v2/career_roles' do
    get('List Career Roles') do
      tags 'Career Roles'
      produces 'application/json'
      parameter name: :q, in: :query, schema: { type: :object }, description: 'Ransack query parameters'
      parameter name: :items, in: :query, schema: { type: :integer }, description: 'Items per page'

      response '200', 'List of career roles' do
        schema type: :object,
               properties: {
                 career_roles: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       role_name: { type: :string },
                       role_type: { type: :string },
                       location: { type: :string }
                     }
                   }
                 },
                 pagination: {
                   type: :object,
                   properties: {
                     count: { type: :integer },
                     pages: { type: :integer }
                   }
                 }
               }
        run_test!
      end
    end

    post('Create Career Role') do
      tags 'Career Roles'
      consumes 'application/json'
      parameter name: :career_role, in: :body, schema: {
        type: :object,
        properties: {
          role_name: { type: :string },
          role_type: { type: :string },
          location: { type: :string },
          career_id: { type: :integer }
        },
        required: ['role_name', 'role_type', 'location', 'career_id']
      }

      response '201', 'Career role created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 role_name: { type: :string },
                 role_type: { type: :string },
                 location: { type: :string }
               }
        run_test!
      end

      response '422', 'Invalid input' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               }
        run_test!
      end
    end
  end

  path '/api/v2/career_roles/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Career Role ID'

    get('Show Career Role') do
      tags 'Career Roles'
      produces 'application/json'

      response '200', 'Career role found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 role_name: { type: :string },
                 role_type: { type: :string },
                 location: { type: :string }
               }
        run_test!
      end

      response '404', 'Career role not found' do
        run_test!
      end
    end

    put('Update Career Role') do
      tags 'Career Roles'
      consumes 'application/json'
      parameter name: :career_role, in: :body, schema: {
        type: :object,
        properties: {
          role_name: { type: :string },
          role_type: { type: :string },
          location: { type: :string },
          career_id: { type: :integer }
        }
      }

      response '200', 'Career role updated' do
        run_test!
      end

      response '422', 'Invalid input' do
        run_test!
      end
    end

    delete('Delete Career Role') do
      tags 'Career Roles'
      response '204', 'Career role deleted' do
        run_test!
      end
    end
  end
end
