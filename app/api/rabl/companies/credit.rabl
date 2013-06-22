attributes *Credit.attribute_names

child :operators do
  attributes *Operator.attribute_names
end

child :equips do
  attributes *Equip.attribute_names
end

child :loans do
  attributes *Loan.attribute_names
end

child :morts do
  attributes *Mort.attribute_names
end

child :mass_changes do
  attributes *MassChange.attribute_names
end

child :holder_changes do
  attributes *HoldChange.attribute_names
end

