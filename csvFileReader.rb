require 'csv'
 
class Csv_File_Reader
    def initialize(attributes = {})
    @attributes = attributes
  end


   # Method Missing 
  def method_missing(method_name, *args, &block)
    string_method = method_name.to_s
    if string_method.end_with?('=')
      attr_name = string_method.chomp('=').to_sym
      value = args.first
      if numeric_attributes.include?(attr_name)
        @attributes[attr_name] = value.to_i  # Convert to integer for numeric attributes
        save
      elsif value.is_a?(String) && value.match?(/\A\D+\z/)  # Check if value is a string without numbers
        @attributes[attr_name] = value
        save
      else
        puts "Invalid input for attribute '#{attr_name}'."
      end
    elsif @attributes.key?(string_method.to_sym)
      @attributes[string_method.to_sym]
    else
      super
    end
  end
 
  # This method returns an array of attribute names that are allowed to have numeric values.
  # By defining this method, we can easily manage which attributes are considered numeric 
  # and should accept numeric values during input processing.

  def numeric_attributes
    [:population,:student_id]  # Add other numeric attributes here if needed
  end
 
  def respond_to_missing?(method_name, include_private = false)
    @attributes.key?(method_name.to_s.chomp('=').to_sym) || super
  end
 
  def self.file_path
    "#{name.downcase}s.csv"
  end
 
 
      def save
        existing_data, existing_headers = read_existing_csv_data
        updated_headers = (existing_headers | @attributes.keys.map(&:to_s)).uniq
 
        record_index = existing_data.index { |row| row['student_id'] == @attributes[:student_id].to_s }
     
        if record_index.nil?
 
          existing_data << @attributes.transform_keys(&:to_s)
        else
 
          existing_data[record_index] = existing_data[record_index].merge(@attributes.transform_keys(&:to_s)) { |key, oldval, newval| newval.nil? ? oldval : newval }
        end
 
        CSV.open(self.class.file_path, 'w', write_headers: true, headers: updated_headers) do |csv|
          existing_data.each do |row|
            csv << updated_headers.map { |header| row.fetch(header, nil) }
          end
        end
      end
 
           
      def self.find_by(attribute, value)
        CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
          if row[attribute.to_sym].to_s == value.to_s
            return new(row.to_h)
          end
        end
        nil
      end
 
 
 
    private
    def read_existing_csv_data
        file_path = self.class.file_path
        return [[], []] unless File.exist?(file_path) && !File.zero?(file_path)
       
        existing_data = CSV.read(file_path, headers: true).map(&:to_hash)
        existing_headers = existing_data.first&.keys || []
        [existing_data, existing_headers]
      end
 
  end
 
 