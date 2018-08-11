# encoding: utf-8


module CsvRecord

  ## note on naming:
  ##   use naming convention from awk and tabular data package/json schema for now
  ##    use - records  (use rows for "raw" untyped (string) data rows )
  ##        - fields  (NOT columns or attributes) -- might add an alias later - why? why not?

  class Field  ## ruby record class field
    attr_reader :name, :type

    def initialize( name, type )
      ## todo: always symbol-ify (to_sym) name and type - why? why not?
      @name = name.to_sym

      if type.is_a?( Class )
        @type = type    ## assign class to its own property - why? why not?
      else
        @type = type.to_sym
      end
    end
  end  # class Field



  def self.define( &block )
    builder = Builder.new
    builder.instance_eval(&block)
    builder.to_record
  end


class Base

def self.fields   ## note: use class instance variable (@fields and NOT @@fields)!!!! (derived classes get its own copy!!!)
  @fields ||= []
end


def self.add_field( name, type )

  fields << Field.new( name, type )

  define_method( name ) do
    instance_variable_get( "@#{name}" )
  end

  define_method( "#{name}=" ) do |value|
    instance_variable_set( "@#{name}", value )
  end

  define_method( "parse_#{name}") do |value|
    instance_variable_set( "@#{name}", self.class.typecast( value, type ) )
  end
end


def self.typecast( value, type )
  ## convert string value to (field) type
  if type == :string || type == 'string' || type == String
     value   ## pass through as is
  elsif type == :float || type == 'float' || type == Float
    ## note: allow/check for nil values
    float = (value.nil? || value.empty?) ? nil : value.to_f
    puts "typecast >#{value}< to float number >#{float}<"
    float
  elsif type == :number || type == 'number' || type == Integer
    number = (value.nil? || value.empty?) ? nil : value.to_i(10)   ## always use base10 for now (e.g. 010 => 10 etc.)
    puts "typecast >#{value}< to integer number >#{number}<"
    number
  else
     ## raise exception about unknow type
     puts "!!!! unknown type >#{type}< - don't know how to convert/typecast string value >#{value}<"
     value
  end
end


def self.build_hash( values )   ## find a better name - build_attrib? or something?
  ## convert to key-value (attribute) pairs
  ## puts "== build_hash:"
  ## pp values

  h = {}
  values.each_with_index do |value,i|
    field = fields[i]
    ## pp field
    h[ field.name ] = value
  end
  h
end


def parse( values )   ## use read (from array) or read_values or read_row - why? why not?
  h = self.build_hash( values )
  update( h )
end



def self.parse( txt_or_rows )  ## note: returns an (lazy) enumarator
  if txt_or_rows.is_a? String
    txt = txt_or_rows
    rows = CSV.parse( txt, headers: true )
  else
    ### todo/fix: use only self.create( array-like ) for array-like data  - why? why not?
    rows = txt_or_rows    ## assume array-like records that responds to :each
  end

  pp rows

  Enumerator.new do |yielder|
    rows.each do |row|
     ## check - check for to_h - why? why not?  supported/built-into by CSV::Row??
     ## if row.respond_to?( :to_h )
     ## else
       ## pp row.fields
       ## pp row.to_hash
       ## fix/todo: use row.to_hash
       h = build_hash( row.fields )
       ## pp h
       rec = new( h )
     ## end
     yielder.yield( rec )
    end
  end
end


def self.read( path )  ## not returns an enumarator
  txt  = File.open( path, 'r:utf-8' ).read
  parse( txt )
end



def initialize( **kwargs )
  update( kwargs )
end

def update( **kwargs )
  pp kwargs
  kwargs.each do |name,value|
    ## note: only convert/typecast string values
    if value.is_a?( String )
      send( "parse_#{name}", value )  ## note: use parse_<name> setter (for typecasting)
    else  ## use "regular" plain/classic attribute setter
      send( "#{name}=", value )
    end
  end

  ## todo: check if args.first is an array  (init/update from array)
  self   ## return self for chaining
end

end # class Base
end # module CsvRecord
