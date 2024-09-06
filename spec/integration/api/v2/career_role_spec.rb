require 'swagger_helper'

RSpec.describe 'Api::V2::CareerRolesController', type: :request do
  path '/api/v2/career_roles' do
    get 'Retrieves all Career roles' do
      tags 'Career Roles'
      produces 'application/json'
      response '200', 'career roles found' do
        run_test!
      end
    end

    post 'Creates a Career role' do
      tags 'Career Roles'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :career, in: :body, schema: {
        type: :object,
        properties: {
          career_id: { type: :string },
          role_name: { type: :string },
          role_type: { type: :string },
          location: { type: :string },
          role_overview: { type: :string },
          key_responsibility: { type: :string },
          requirements: { type: :string },
          email_id: { type: :string }
          
        },
        required: ['career_id','role_name', 'role_type', 'location', 'role_overview', 'key_responsibility', 'requirements', 'email_id']
      }
      response '201', 'career created' do
        let(:career) { { career_id: '1',role_name: 'Software Engineer', role_type: 'Full-Time', location: 'New York', role_overview: 'Develop software', key_responsibility: 'Coding', requirements: 'Bachelor\'s Degree', email_id: 'hr@example.com' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:career) { { header: nil } }
        run_test!
      end
    end
  end

  path '/api/v2/career_roles/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Retrieves a specific Career role' do
      tags 'Career Roles'
      produces 'application/json'
      response '200', 'career found' do
        let(:id) { Career.create(header: 'Engineering Department').id }
        run_test!
      end

      response '404', 'career not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a specific Career role' do
      tags 'Career Roles'
      consumes 'application/json'
      security [bearerAuth2: []]
      parameter name: :career, in: :body,schema: {
        type: :object,
        properties: {
          career_id: { type: :string },
          role_name: { type: :string },
          role_type: { type: :string },
          location: { type: :string },
          role_overview: { type: :string },
          key_responsibility: { type: :string },
          requirements: { type: :string },
          email_id: { type: :string }
          
        },
        required: ['career_id','role_name', 'role_type', 'location', 'role_overview', 'key_responsibility', 'requirements', 'email_id']
      }
      response '200', 'career updated' do
        let(:id) { Career.create(header: 'Engineering Department').id }
        let(:career) { { career_id: 'Engineering Department Updated',  role_name: 'Software Engineer', role_type: 'Full-Time', location: 'New York', role_overview: 'Develop software', key_responsibility: 'Coding', requirements: 'Bachelor\'s Degree', email_id: 'hr@example.com'} }
        run_test!
      end

      response '404', 'career not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a specific Career role' do
      tags 'Career Roles'
      security [bearerAuth2: []]
      response '204', 'career deleted' do
        let(:id) { Career.create(header: 'Engineering Department').id }
        run_test!
      end

      response '404', 'career not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
