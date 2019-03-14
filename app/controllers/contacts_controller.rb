class ContactsController < ApplicationController
  
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    @contacts = Contact.all
    render json: @contacts, include: :phones
  end

  def show
    render json: @contact, include: :phones
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      render json: @contact, include: :phones, status: :created
    else
      render json: @contact.errors
    end
  end

  def update
    if @contact.update(contact_params)
      render json: @contact, include: :phones
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize current_user
    @contact.destroy
    head :no_content
  end


  private
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(
      :name, 
      :address, 
      :document,
      :kind,
      :phones_attributes => [:number, :contact_id, :id, :_destroy]
    )
  end

end
