class OrdersController < ApplicationController
  protect_from_forgery :except => 'print'
  
  around_filter :shopify_session, :except => :snailpad_api_key

  def snailpad_api_key
    if params[:shop]
      shop.update_attributes(params[:shop])
      render :update do |page|
        page.remove "snailpad-modal-dialog"
        page.replace_html 'snailpad', :partial => "snailpad", :locals => { :has_api_key => true }
      end
    end
  end


  def index
    # this is needed for Shopify's application links, because they append the id param with 
    # a question mark (/orders?id=123) instead of rails nested style (/orders/123)
    redirect_to :action => 'show', :id => params[:id] if params[:id].present?
    
    # get latest 3 orders
    @orders = ShopifyAPI::Order.find(:all, :params => {:limit => 3, :order => "created_at DESC" })
    # get all printing templates for the current shop
    @tmpls  = shop.templates
  end
  
  
  def show
    @safe = params[:safe]
    if @safe
      flash[:notice] = "Safe mode allows you to edit templates that cause the page to break when previewed."
    end
    
    @order = ShopifyAPI::Order.find(params[:id])
    
    respond_to do |format|
      format.html do
        @tmpls = shop.templates
        
        # setup the snailpad object, only if the user has entered their API key
        if shop.snailpad_api_key
          apiauth = SnailMailer::APIAuth.new(shop.snailpad_api_key)
          @snailpad = SnailMailer::Base.new(apiauth)
        else
          # @shop = shop
        end
      end
      format.js do
        # AJAX preview, loads in modal Dialog
        @tmpl = shop.templates.find(params[:template_id])
        @rendered_template = @tmpl.render(@order.to_liquid)
        render :partial => 'preview', :locals => {:tmpl => @tmpl, :rendered_template => @rendered_template, :safe => @safe}
      end
    end
  end


  def print
    @all_templates = shop.templates
    @printed_templates = @all_templates.find(params[:print_templates])
    
    @all_templates.each { |tmpl| tmpl.update_attribute(:default, @printed_templates.include?(tmpl)) }
    head 200
  end
end
