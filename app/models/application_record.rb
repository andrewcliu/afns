class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  dis = self.reflect_on_all_associations(:has_many).map{|e|e.name}.join('')

  unless dis.blank?
    accepts_nested_attributes_for dis.to_sym, reject_if: :all_blank, allow_destroy: true
  end

  def self.model_column_names 
    self.column_names - ['id', 'created_at', 'updated_at'] 
  end

  def self.db_column_names 
    self.column_names + ['id'] 
  end

  def self.view_columns 
    self.column_names - ['id', 'created_at', 'updated_at'] 
  end

  def self.relations
    self.reflect_on_all_associations(:has_many).map{|e|e.name}.join('')
  end
  def to_s 
    try :name
  end
  def to_url 
    name.include?('/') ? name.gsub('/','-').downcase : name.include?('&') ? name.strip.gsub('&','').squeeze(" ").gsub(' ','-').downcase : name.include?(' ') ? name.gsub(' ','-').downcase : name.downcase
  end

  def self.notes 
    ''
  end

  def self.custom_links 
    %w''
  end

  def self.editable? 
    false
  end
  def even?
    self%1==0 && self.to_i.even?
  end
end