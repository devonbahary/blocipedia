class ChargesController < ApplicationController
  def create
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
 
    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the user_id in your app
      amount: Amount.default,
      description: "Blocipedia Premium Membership",
      currency: 'usd'
    )
 
    # promote to premium
    current_user.premium!
    flash[:notice] = "You've been upgraded to a Premium membership."
    redirect_to edit_user_registration_path # or wherever
 
    # Stripe will send back CardErrors, with friendly messages when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      current_user.standard!
      redirect_to edit_user_registration_path
  end
  
  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Blocipedia Premium Membership - #{current_user.email}",
      amount: Amount.default
    }
  end

end
