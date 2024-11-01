# app/helpers/application_helper.rb
module ApplicationHelper
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  def generate_barcode(member)
    barcode = Barby::Code128B.new(member.membership_number)
    base64_output = Base64.encode64(barcode.to_png(xdim: 2, height: 50, margin: 10))
    "data:image/png;base64,#{base64_output}"
  end
  def alert_class(type)
    case type.to_sym
    when :notice
      'alert-success'
    when :alert, :error
      'alert-danger'
    else
      'alert-info'
    end
  end
	def numeric?(lookAhead)
	  lookAhead.match?(/[[:digit:]]/)
	end
  def male_locker_number
    ["101", "102", "103", "104", "105"]
  end

  def female_locker_number
    ["201", "202", "203", "204", "205"]
  end
	def scrape x
		Nokogiri::HTML.parse(URI.open(x)) rescue nil
	end
  def us_states
    [
      ['Alabama', 'AL'], ['Alaska', 'AK'], ['Arizona', 'AZ'], ['Arkansas', 'AR'],
      ['California', 'CA'], ['Colorado', 'CO'], ['Connecticut', 'CT'], ['Delaware', 'DE'],
      ['District of Columbia', 'DC'], ['Florida', 'FL'], ['Georgia', 'GA'], ['Hawaii', 'HI'],
      ['Idaho', 'ID'], ['Illinois', 'IL'], ['Indiana', 'IN'], ['Iowa', 'IA'],
      ['Kansas', 'KS'], ['Kentucky', 'KY'], ['Louisiana', 'LA'], ['Maine', 'ME'],
      ['Maryland', 'MD'], ['Massachusetts', 'MA'], ['Michigan', 'MI'], ['Minnesota', 'MN'],
      ['Mississippi', 'MS'], ['Missouri', 'MO'], ['Montana', 'MT'], ['Nebraska', 'NE'],
      ['Nevada', 'NV'], ['New Hampshire', 'NH'], ['New Jersey', 'NJ'], ['New Mexico', 'NM'],
      ['New York', 'NY'], ['North Carolina', 'NC'], ['North Dakota', 'ND'], ['Ohio', 'OH'],
      ['Oklahoma', 'OK'], ['Oregon', 'OR'], ['Pennsylvania', 'PA'], ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'], ['South Dakota', 'SD'], ['Tennessee', 'TN'], ['Texas', 'TX'],
      ['Utah', 'UT'], ['Vermont', 'VT'], ['Virginia', 'VA'], ['Washington', 'WA'],
      ['West Virginia', 'WV'], ['Wisconsin', 'WI'], ['Wyoming', 'WY']
    ]
  end
	def database_tables 
		ActiveRecord::Base.connection.tables - ['schema_migrations', 'ar_internal_metadata']
	end

	def nav_table 
		ActiveRecord::Base.connection.tables - ['schema_migrations', 'ar_internal_metadata', 'menu_items']
	end

	def form_column_names 
		this = params[:controller].camelcase.singularize.constantize
		this.model_column_names - [this.reflect_on_all_associations(:has_many).map{|e|"#{e.name}_id"}.join(',')]
	end

	def page_name
		params[:controller].humanize
	end

	def action 
		params[:action]
	end

	def this 
		params[:controller].camelcase.singularize.constantize unless params[:controller]=='root' 
	end
	def title 
		if action == 'index'
			this.to_s.titleize rescue ''
		elsif action == 'new'
			return "New #{this.to_s.titleize}"
		elsif action == 'show' 
			return this.find(params[:id]).to_s
		elsif action == 'edit'
			return "Edit #{this.find(params[:id]).to_s}"
		end

	end

	def dis 
		params[:controller] unless params[:controller]=='static' 
	end

	def instant_var
		unless params[:controller] == 'static' 
			instance_variable_get("@#{params[:controller].downcase}") 
		end
	end

	def relations 
		this.reflect_on_all_associations(:has_many).map{|e|e.name}.join('')
	end

	
	def form_collection(i)
	  # Remove '_id' and convert to class name
	  t = i.gsub('_id', '').camelcase

	  # Check if it's the 'class_id' field and filter for active classes
	  if t == 'AfnsClass'
	    AfnsClass.where(is_active: true).pluck(:name, :id)  # Only active classes
	  else
	    # Default logic for other collections
	    t.constantize.all.collect { |e| [e.to_s, e.id] }
	  end
	end

	def sanitize x 
		if x.to_s.include?('_')  
			b = x.gsub('_',' ').humanize 
		elsif x.to_s == 'false'
			b = '<span>&#10005;</span>'.html_safe
		elsif x.to_s == 'true'
			b = '<span>&#10004;</span>'.html_safe
		elsif x.kind_of? Float
			b = number_to_currency x
		elsif x.to_s.include? ';'
			b = x.gsub(';','<br>').html_safe
		else
			b = x
		end
		return b
	end

end