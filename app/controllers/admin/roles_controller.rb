class Admin::RolesController < Admin::ApplicationController
  respond_to :json,:html,:xml
  expose(:role)

  def index
    @roles = Role.all
    respond_with(@roles)
  end

  def show
    respond_with(role)
  end

  def new
    role.capability = Capability.new(can: Role.default_permissions_access)
    respond_with(role)
  end

  def edit
    respond_with(role)
  end

  def create
    respond_with(role) do |format|
      if role.save
        format.html { redirect_to admin_role_url(role), notice: 'Role was successfully created.' }
        format.json { render json: role, status: :created, location: role }
      else
        format.html { render action: "new" }
        format.json { render json: role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_with(role) do |format|
      if role.update_attributes(params[:role])
        format.html { redirect_to admin_role_url(role), notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    role.destroy
    redirect_to admin_roles_url
  end
end
