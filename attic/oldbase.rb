# encoding: utf-8


###
#  ye olde Base
#     does NOT use @values as its primary storage; uses instance variables


module CsvRecord


class Base

def self.define_field( field )
  name = field.name   ## note: always assumes a "cleaned-up" (symbol) name
  type = field.type   ## note: always assumes a (class) type

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

def self.build_hash( values )   ## find a better name - build_attrib? or something?
  ## convert to key-value (attribute) pairs
  ## puts "== build_hash:"
  ## pp values

  ## e.g. [[],[]]  return zipped pairs in array as (attribute - name/value pair) hash
  Hash[ field_names.zip(values) ]
end


def parse( values )   ## use read (from array) or read_values or read_row - why? why not?

  ## todo/fix:
  ##  check if values is a string
  ##  use Csv.parse_line to convert to array
  ##  otherwise assume array of (string) values

  h = self.class.build_hash( values )
  update( h )
end

def to_a
  ## return array of all record values (typed e.g. float, integer, date, ..., that is,
  ##   as-is and  NOT auto-converted to string
  ##  use to_csv or values for all string values)
  self.class.fields.map { |field| send( field.name ) }
end

def to_h    ## use to_hash - why? why not?  - add attributes alias - why? why not?
  self.class.build_hash( to_a )
end


def values   ## use/rename/alias to to_row too - why? why not?
  ## todo/fix: check for date and use own date to string format!!!!
  to_a.map{ |value| value.to_s }
end
## use values as to_csv alias
## - reverse order? e.g. make to_csv an alias of value s- why? why not?
alias_method :to_csv, :values



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
       ## fix/todo!!!!!!!!!!!!!
       ##  check for CSV::Row etc. - use row.to_hash ?
       h = build_hash( row.fields )
       ## pp h
       rec = new( h )
     ## end
     yielder.yield( rec )
    end
  end
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
