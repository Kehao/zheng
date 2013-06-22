require "skyeye"
CRUD = [:create, :read, :update, :destroy]

# system map permissions
Skyeye::AccessControl.map do 
  # permission :company,                      CRUD
  # permission :person,                       CRUD
  # permission :company_client,               CRUD
  # permission :person_client,                CRUD

  # permission :role,                         CRUD

  permission :cert,                         CRUD + [:snapshot]
  permission :crime,                        CRUD + [:snapshot]

  permission :seek,                         CRUD

  permission :client_person_relationship,   CRUD
  permission :client_company_relationship,  CRUD
end


TRUE_VALUES  = ["1", 1, true, 'true', 'TRUE', 'yes', 'YES', 'on', 'ON']
FALSE_VALUES = ["0", 0, false, 'false', 'FALSE', 'no', 'NO', 'off', 'OFF']

def is_true(value)
  TRUE_VALUES.include?(value)
end

def is_false(value)
  FALSE_VALUES.include?(value)
end
