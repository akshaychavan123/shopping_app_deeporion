class AddressSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :phone_number, :email, :country, :pincode, :area, :state, :address, :city, :address_type, :default
end
