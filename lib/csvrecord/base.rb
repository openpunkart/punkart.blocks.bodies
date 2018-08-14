# encoding: utf-8


module CsvRecord

  ## note on naming:
  ##   use naming convention from awk and tabular data package/json schema for now
  ##    use - records  (use rows for "raw" untyped (string) data rows )
  ##        - fields  (NOT columns or attributes) -- might add an alias later - why? why not?

  class Field  ## ruby record class field
    attr_reader :name, :type

    ## zero-based position index (0,1,2,3,...)
    ## todo: use/rename to index/idx/pos - add an alias name - why?
    attr_reader :num

    def initialize( name, num, type )
      ## note: always symbol-ify (to_sym) name and type

      ## todo: add title or titles for header field/column title as is e.g. 'Team 1' etc.
      ##   incl. numbers only or even an empty header title
      @name = name.to_sym
      @num  = num

      if type.is_a?( Class )
        @type = type    ## assign class to its own property - why? why not?
      else
        @type = Type.registry[type.to_sym]
        if @type.nil?
          puts "!!!! warn unknown type >#{type}< - no class mapping found; add missing type to CsvRecord::Type.registry[]"
          ## todo/fix:  raise exception!!!!
        end
      end
    end


    def typecast( value )  ## cast (convert) from string value to type (e.g. float, integer, etc.)
      ## todo: add typecast to class itself (monkey patch String/Float etc. - why? why not)
      ##  use __typecast or something?
      ##  or use a new "wrapper" class  Type::String or StringType - why? why not?

      ## convert string value to (field) type
      if @type == String
        value   ## pass through as is
      elsif @type == Float
        ## note: allow/check for nil values - why? why not?
        float = (value.nil? || value.empty?) ? nil : value.to_f
        puts "typecast >#{value}< to float number >#{float}<"
        float
      elsif @type == Integer
        number = (value.nil? || value.empty?) ? nil : value.to_i(10)   ## always use base10 for now (e.g. 010 => 10 etc.)
        puts "typecast >#{value}< to integer number >#{number}<"
        number
      else
        ## todo/fix: raise exception about unknow type
        pp @type
        puts "!!!! unknown type >#{@type}< - don't know how to convert/typecast string value >#{value}<"
        value
      end
    end
  end  # class Field



  class Type   ## todo: use a module - it's just a namespace/module now - why? why not?

    ##  e.g. use Type.registry[:string] = String etc.
    ##   note use @@ - there is only one registry
    def self.registry() @@registry ||={} end

    ## add built-in types:
    registry[:string]  = String
    registry[:integer] = Integer   ## todo/check: add :number alias for integer? why? why not?
    registry[:float]   = Float
    ## todo: add some more
  end  # class Type



  def self.define( &block )
    builder = Builder.new
    if block.arity == 1
      block.call( builder )
      ## e.g. allows "yield" dsl style e.g.
      ##  CsvRecord.define do |rec|
      ##     rec.string :team1
      ##     rec.string :team2
      ##  end
      ##
    else
      builder.instance_eval( &block )
      ## e.g. shorter "instance eval" dsl style e.g.
      ##  CsvRecord.define do
      ##     string :team1
      ##     string :team2
      ##  end
    end
    builder.to_record
  end


   ###########################################
   ## "magic" lazy auto-build schema from headers versions

   def self.build_class( headers )   ## check: find a better name - why? why not?
     ## (auto-)build record class from an array of headers
     ##   add fields (all types will be string for now)
     clazz = Class.new(Base)
     headers.each do |header|
       ## downcase and remove all non-ascii chars etc.
       ##  todo/fix: remove all non-ascii chars!!!
       ##  todo: check if header starts with a number too!!
       name = header.downcase.gsub( ' ', '_' )
       name = name.to_sym   ## symbol-ify
       clazz.field( name )
     end
     clazz
   end

   def self.read( path, sep: Csv.config.sep )
     headers = CsvReader.header( path, sep: sep )

     clazz = build_class( headers )
     clazz.read( path, sep: sep )
   end

   def self.foreach( path, sep: Csv.config.sep, &block )
     headers = CsvReader.header( path, sep: sep )

     clazz = build_class( headers )
     clazz.foreach( path, sep: sep, &block )
   end




class Base

def self.fields   ## note: use class instance variable (@fields and NOT @@fields)!!!! (derived classes get its own copy!!!)
  @fields ||= []
end

def self.field_names   ## rename to header - why? why not?
  ## return header row, that is, all field names in an array
  ##   todo: rename to field_names or just names - why? why not?
  ##  note: names are (always) symbols!!!
  fields.map {|field| field.name }
end

def self.field_types
  ##  note: types are (always) classes!!!
  fields.map {|field| field.type }
end



def self.field( name, type=:string )
  num = fields.size  ## auto-calc num(ber) / position index - always gets added at the end
  field = Field.new( name, num, type )
  fields << field

  define_field( field )  ## auto-add getter,setter,parse/typecast
end

def self.define_field( field )
  name = field.name   ## note: always assumes a "cleaned-up" (symbol) name
  num  = field.num

  define_method( name ) do
    instance_variable_get( "@values" )[num]
  end

  define_method( "#{name}=" ) do |value|
    instance_variable_get( "@values" )[num] = value
  end

  define_method( "parse_#{name}") do |value|
    instance_variable_get( "@values" )[num] = field.typecast( value )
  end
end

## column/columns aliases for field/fields
##   use self <<  with alias_method  - possible? works? why? why not?
def self.column( name, type=:string ) field( name, type ); end
def self.columns() fields; end
def self.column_names() field_names; end
def self.column_types() field_types; end




def self.build_hash( values )   ## find a better name - build_attrib? or something?
  ## convert to key-value (attribute) pairs
  ## puts "== build_hash:"
  ## pp values

  ## e.g. [[],[]]  return zipped pairs in array as (attribute - name/value pair) hash
  Hash[ field_names.zip(values) ]
end



def self.typecast( new_values )
  values = []

  ##
  ## todo: check that new_values.size <= fields.size
  ##
  ##   fields without values will get auto-filled with nils (or default field values?)

  ##
  ##  use fields.zip( new_values ).map |field,value| ... instead - why? why not?
  fields.each_with_index do |field,i|
     value = new_values[i]   ## note: returns nil if new_values.size < fields.size
     values << field.typecast( value )
  end
  values
end


def parse( new_values )   ## use read (from array) or read_values or read_row - why? why not?

  ## todo: check if values overshadowing values attrib is ok (without warning?) - use just new_values (not values)

  ## todo/fix:
  ##  check if values is a string
  ##  use Csv.parse_line to convert to array
  ##  otherwise assume array of (string) values
  @values = self.class.typecast( new_values )
  self  ## return self for chaining
end


def values
  ## return array of all record values (typed e.g. float, integer, date, ..., that is,
  ##   as-is and  NOT auto-converted to string
  ##  use to_csv or values for all string values)
  @values
end



def [](key)
  if key.is_a? Integer
    @values[ key ]
  elsif key.is_a? Symbol
    ## try attribute access
    send( key )
  else  ## assume string
    ## downcase and symbol-ize
    ##   remove spaces too -why? why not?
    ##  todo/fix: add a lookup mapping for (string) titles (Team 1, etc.)
    send( key.downcase.to_sym )
  end
end



def to_h    ## use to_hash - why? why not?  - add attributes alias - why? why not?
  self.class.build_hash( @values )
end


def to_csv   ## use/rename/alias to to_row too - why? why not?
  ## todo/fix: check for date and use own date to string format!!!!
  @values.map{ |value| value.to_s }
end


def self.foreach( path, sep: Csv.config.sep, headers: true )
  CsvReader.foreach( path, sep: sep, headers: headers ) do |row|
    rec = new
    values = CsvReader.unwrap( row )
    rec.parse( values )

    yield( rec )    ## check: use block.class( rec ) - why? why not?
  end
end


def self.parse( txt_or_rows, sep: Csv.config.sep, headers: true )  ## note: returns an (lazy) enumarator
  if txt_or_rows.is_a? String
    txt = txt_or_rows
    rows = CsvReader.parse( txt, sep: sep, headers: headers )
  else
    ### todo/fix: use only self.create( array-like ) for array-like data  - why? why not?
    rows = txt_or_rows    ## assume array-like records that responds to :each
  end

  pp rows

  Enumerator.new do |yielder|
    rows.each do |row|
      rec = new
      values = CsvReader.unwrap( row )
      rec.parse( values )

      yielder.yield( rec )
    end
  end
end


def self.read( path, sep: Csv.config.sep, headers: true )  ## not returns an enumarator
  txt  = File.open( path, 'r:utf-8' ).read
  parse( txt, sep: sep, headers: headers )
end



def initialize( **kwargs )
  @values = []
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
