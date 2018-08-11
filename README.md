# csvrecord - read in comma-separated values (csv) records with typed structs / schemas


* home  :: [github.com/csv11/csvrecord](https://github.com/csv11/csvrecord)
* bugs  :: [github.com/csv11/csvrecord/issues](https://github.com/csv11/csvrecord/issues)
* gem   :: [rubygems.org/gems/csvrecord](https://rubygems.org/gems/csvrecord)
* rdoc  :: [rubydoc.info/gems/csvrecord](http://rubydoc.info/gems/csvrecord)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)



## Usage

[`beer.csv`](test/data/beer.csv):

```
Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%
Bayerische Staatsbrauerei Weihenstephan,Freising,Hefe Weissbier,5.4%
Brauerei Spezial,Bamberg,Rauchbier Märzen,5.1%
Hacker-Pschorr Bräu,München,Münchner Dunkel,5.0%
Staatliches Hofbräuhaus München,München,Hofbräu Oktoberfestbier,6.3%
```

Step 1: Define a (typed) struct for the comma-separated values (csv) records. Example:

```ruby
require 'csvrecord'

Beer = CsvRecord.define do
  field :brewery        ## note: default type is :string
  field :city
  field :name
  field :abv, Float     ## allows type specified as class (or use :float)
end
```

Step 2: Read in the comma-separated values (csv) datafile. Example:

```ruby
beers = Beer.read( 'beer.csv' ).to_a

puts "#{beers.size} beers:"
pp beers
```

pretty prints (pp):

```
6 beers:
[#<Beer:0x302c760
    @abv     = 7.0,
    @brewery = "Andechser Klosterbrauerei",
    @city    = "Andechs",
    @name    = "Doppelbock Dunkel">,
 #<Beer:0x3026fe8
    @abv     = 5.6,
    @brewery = "Augustiner Br\u00E4u M\u00FCnchen",
    @city    = "M\u00FCnchen",
    @name    = "Edelstoff">,
 #<Beer:0x30257a0
    @abv     = 5.4,
    @brewery = "Bayerische Staatsbrauerei Weihenstephan",
    @city    = "Freising",
    @name    = "Hefe Weissbier">,
 ...
]
```

Or loop over the records. Example:

``` ruby
Beer.read( data ).each do |rec|
  puts "#{rec.name} (#{rec.abv}%) by #{rec.brewery}, #{rec.city}"
end
```

printing:

```
Doppelbock Dunkel (7.0%) by Andechser Klosterbrauerei, Andechs
Edelstoff (5.6%) by Augustiner Bräu München, München
Hefe Weissbier (5.4%) by Bayerische Staatsbrauerei Weihenstephan, Freising
Rauchbier Märzen (5.1%) by Brauerei Spezial, Bamberg
Münchner Dunkel (5.0%) by Hacker-Pschorr Bräu, München
Hofbräu Oktoberfestbier (6.3%) by Staatliches Hofbräuhaus München, München
```


Or create new records from scratch. Example:

``` ruby
beer = Beer.new( brewery: 'Andechser Klosterbrauerei',
                 city:    'Andechs',
                 name:    'Doppelbock Dunkel' )
pp beer

# -or-

beer = Beer.new
beer.update( abv: 12.7 )
beer.update( brewery: 'Andechser Klosterbrauerei',
             city:    'Andechs',
             name:    'Doppelbock Dunkel' )

# -or-

beer.abv     = 12.7
beer.name    = 'Doppelbock Dunkel'
beer.brewery = 'Andechser Klosterbrauerei'
```


And so on. That's it.



## Alternatives

See the Libraries & Tools section in the [Awesome CSV](https://github.com/csv11/awesome-csv#libraries--tools) page.


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `csvrecord` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
