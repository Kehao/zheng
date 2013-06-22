object @company
attributes *Company.attribute_names

child :credit do
  extends "companies/credit" 
end

child :cert do
  attributes *Cert.attribute_names
end

child :business do
  attributes *Business.attribute_names
end



