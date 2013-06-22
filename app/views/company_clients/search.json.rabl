collection @company_clients

attributes :id, :user_id

child :company do
  attributes :id, :name
end
