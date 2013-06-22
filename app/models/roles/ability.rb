class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.guest?
      cannot :manage, :all

    elsif user.admin?
      can :manage, :all

    elsif user.member?
      can :create,  Company
      can :read,    Company
      
      can :create,  Person
      can :read,    Person

      can :manage,  CompanyClient, user_id: user.id

      can :manage,  PersonClient, user_id: user.id

      can :manage,  Seek

      can :manage,  UserSeek, user_id: user.id
      can :manage,  Exporter, user_id: user.id

      if user.cando
        can :read,     Cert  if user.cando.cert.read
        can :snapshot, Cert  if user.cando.cert.snapshot 

        can :read,     Crime if user.cando.crime.read
        can :snapshot, Crime if user.cando.crime.snapshot

        can :create,   ClientCompanyRelationship if user.cando.client_company_relationship.create
        can :read,     ClientCompanyRelationship if user.cando.client_company_relationship.read
        can :destroy,  ClientCompanyRelationship if user.cando.client_company_relationship.destroy

        can :create,   ClientPersonRelationship  if user.cando.client_person_relationship.create
        can :read,     ClientPersonRelationship  if user.cando.client_person_relationship.read
        can :destroy,  ClientPersonRelationship  if user.cando.client_person_relationship.destroy
      end
    end
    
    Skyeye.plugins.each do |plugin|
      instance_exec(user, &plugin.cancan_block)
    end
  end
end
