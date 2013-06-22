#module System
#  module APIEntities
#    class Company < Grape::Entity
#      ::Company.attribute_names.each do |attr|
#        expose attr
#      end
#      #expose :credit do |model,options|
#      #  if model.credit
#      #    APIEntities::Credit.new(model.credit).serializable_hash 
#      #  end
#      #end
#    end
#    class Credit < Grape::Entity
#      ::Credit.attribute_names.each do |attr|
#        expose attr
#      end
#    end
#  end
#end
