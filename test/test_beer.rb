# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_beer.rb


require 'helper'

class TestBeer < MiniTest::Test

  def test_version
    pp CsvRecord::VERSION
    pp CsvRecord.banner
    pp CsvRecord.root

    assert true  ## assume ok if we get here
  end


  def test_class_style1
     clazz1 = CsvRecord.define do
       field :brewery, :string   # fix: do NOT use 'Brewery' - name SHOULD be a valid variable name
       field :city,    :string
       field :name     ## default type is :string
       field :abv,     Float    ## allow type specified as class
     end
     pp clazz1
     pp clazz1.fields

     assert true  ## assume ok if we get here
  end

  Beer = CsvRecord.define do
     string :brewery   # fix: do NOT use 'Brewery' - name SHOULD be a valid variable name
     string :city
     string :name
     float  :abv
  end

  def test_class_style2
    clazz2 = CsvRecord.define do
       string :brewery   # fix: do NOT use 'Brewery' - name SHOULD be a valid variable name
       string :city
       string :name
       float  :abv
    end
    pp clazz2
    pp clazz2.class.name
    pp clazz2.fields

    txt  = File.open( "#{CsvRecord.test_data_dir}/beer.csv", 'r:utf-8' ).read
    data = CSV.parse( txt, headers: true )
    pp data
    pp data.to_a   ## note: includes header (first row with field names)

    puts "== parse( data ).to_a:"
    pp clazz2.parse( data ).to_a
    pp Beer.parse( data ).to_a

    puts "== parse( data ).each:"
    ## loop over records
    clazz2.parse( data ).each do |rec|
      pp rec
      puts "#{rec.class.name}"
      puts " name: #{rec.name}, abv: #{rec.abv}, brewery: #{rec.brewery}, city: #{rec.city}"
    end

    puts "== parse( txt ).to_a:"
    pp Beer.parse( txt ).to_a

    pp clazz2.class.name
    pp clazz2.class.name
    pp Beer.class.name

    assert true  ## assume ok if we get here
  end


  def test_read
    puts "== read( data ).to_a:"
    beers = Beer.read( "#{CsvRecord.test_data_dir}/beer.csv" ).to_a
    puts "#{beers.size} beers:"
    pp beers

    pp Beer.fields

    assert true  ## assume ok if we get here
  end

  def test_new
    beer = Beer.new
    pp beer
    beer.update( abv: 12.7 )
    beer.update( brewery: 'Andechser Klosterbrauerei',
                 city:   'Andechs',
                 name:   'Doppelbock Dunkel' )
    pp beer

    assert_equal 12.7, beer.abv
    assert_equal 'Andechser Klosterbrauerei', beer.brewery
    assert_equal 'Andechs', beer.city
    assert_equal 'Doppelbock Dunkel', beer.name


    pp beer.abv
    pp beer.abv = 12.7
    pp beer.abv
    assert_equal 12.7, beer.abv

    pp beer.parse_abv( '12.8%' )   ## (auto-)converts/typecasts string to specified type (e.g. float)
    assert_equal 12.8, beer.abv

    pp beer.name
    pp beer.name = 'Doppelbock Dunkel'
    pp beer.name
    assert_equal 'Doppelbock Dunkel', beer.name


    beer2 = Beer.new( brewery: 'Andechser Klosterbrauerei',
                      city:   'Andechs',
                      name:   'Doppelbock Dunkel' )
    pp beer2

    assert_equal nil, beer2.abv
    assert_equal 'Andechser Klosterbrauerei', beer2.brewery
    assert_equal 'Andechs', beer2.city
    assert_equal 'Doppelbock Dunkel', beer2.name
  end

end # class TestBeer
