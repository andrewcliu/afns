class ApplicationController < ActionController::Base
  include Clearance::Controller
	skip_before_action :verify_authenticity_token
	include ApplicationHelper
	before_action :require_login
	def index 
		unless dis.nil?
			instance_variable_set("@#{dis.downcase}", this.all)
		end
	end

	def create 
		this.create(private_params)
		redirect_to send("#{dis.downcase}_path")
	end

	def edit 
		instance_variable_set("@#{dis.downcase}", this.find(params[:id]))
	end

	def new
		instance_variable_set("@#{dis.downcase}", this.new)
	end

	def show 
		instance_variable_set("@#{dis.downcase}", this.find(params[:id]))
	end

	def route_show 
	end

	def update 
		this.find(params[:id]).update(private_params)
		redirect_to send("#{dis.downcase}_path")
	end

	def destroy 
		this.find(params[:id]).destroy 
		redirect_to send("#{dis.downcase}_path")
	end

	private 


  def require_admin
    redirect_to root_path, alert: "Access denied" unless current_user&.admin?
  end
	def private_params 
		params.require(dis.singularize.to_sym).permit(this.model_column_names.map{|e|e.to_sym})
	end	
end