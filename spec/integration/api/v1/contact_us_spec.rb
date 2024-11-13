require 'swagger_helper'

RSpec.describe 'api/v1/contact_us', type: :request do
  path '/api/v1/contact_us' do

    get 'Retrieves all Contacts' do
      tags 'ContactUs'
      consumes 'application/json'
      security [bearerAuth: []]

      response '200', 'Contacts retrieved' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        run_test!
      end

      response '401', 'unauthorized' do
        run_test!
      end
    end

    post 'Creates a Contact Us record' do
      tags 'ContactUs'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :contact_us, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string, format: :email },
          contact_number: { type: :string },
          subject: { type: :string },
          details: { type: :string },
          comment: { type: :string },
          status: { type: :string }
        },
        required: ['name', 'email', 'contact_number', 'subject', 'details']
      }

      response '201', 'contact_us created' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:contact_us) { { name: 'John Doe', email: 'john.doe@example.com', contact_number: '1234567890', subject: 'Inquiry', details: 'I would like to know more about your services.' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:contact_us) { { name: 'John Doe' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:contact_us) { { name: 'John Doe', email: 'john.doe@example.com', contact_number: '1234567890', subject: 'Inquiry', details: 'I would like to know more about your services.' } }
        run_test!
      end
    end
  end

  path '/api/v1/contact_us/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Plan ID'

    put 'Updates an Contact' do
      tags 'ContactUs'
      consumes 'application/json'
      security [bearerAuth: []]
      parameter name: :plan, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string, format: :email },
          contact_number: { type: :string },
          subject: { type: :string },
          details: { type: :string },
          comment: { type: :string },
          status: { type: :string }
        }
      }

      response '200', 'Contact updated' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { create(:plan, user: @user).id }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '404', 'Contact not found' do
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: create(:user).id)}" }
        let(:id) { 'invalid' }
        let(:plan) { { name: 'New City' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { create(:plan).id }
        let(:plan) { { plan: 'New City' } }
        run_test!
      end
    end

  end

end
