
# (Pixel) Punk Frequently Asked Questions (F.A.Q.) and Answers




## Pixel Art Programming


### **Q**: How can I generate 10 000 (basic) bored ape images in 800x800px from the all-in-one composite image in the 50x50 format?

An answer to the question in [**10 000 Basic Bored Apes Club (50x50) - Free All-In-One Image Composite Download (5000x5000px) - basicboredapeclub.png (~2MB)**](https://old.reddit.com/r/CryptoPunksDev/comments/sbpduc/10_000_basic_bored_apes_club_50x50_free_allinone/):

The bored ape (tiles) in the composite image are in 50x50px.  
To get to 800x800px use a 16x zoom (50px x 16 = 800px). Try:

``` ruby
require 'pixelart'
     
apes = ImageComposite.read( "basicboredapes50x50.png" )  ## read in ape composite

apes.each_with_index do |ape,i|
  ape.zoom(16).save( "ape-#{i}.png")
end
```


### **Q**: How can I generate 10 000 left-looking p(h)unks in any size (2x, 4x, 8x, etc.) individually, that is, one-by-one?

See [**Free Phunks Composite Download (~800k) - Get All 10 000 Left-Looking ("Mirrored") CryptoPunks In An All-In-One Image (2400x2400)**](https://old.reddit.com/r/CryptoPunksDev/comments/orv98e/free_phunks_composite_download_800k_get_all_10/) 
for a start and change the loop in the [**phunks script**](https://github.com/cryptopunksnotdead/cryptopunks/blob/master/phunks/phunks.rb) from

``` ruby
punks.each do |punk|
  phunks << punk.mirror    #¹ 
end
```

to save the phunks one-by-one in 24x24 and in 192x192 (with 8x zoom) try:

``` ruby
punks.each_with_index do |punk,i|
  phunk = punk.mirror  
  phunk.save( "phunk-#{i}.png" )
  phunk.zoom(8).save( "phunk-#{i}@8x.png" )

  phunks << phunk  ## add to composite       
end
```

(Re)run the script and voila - you will get 20 000 phunk images in two series in the 24x24 and 192x192 (with 8x zoom) format e.g.  `phunk-0.png`, `phunk-0@8x.png`, `phunk-1.png`, `phunk-1@8x.png`, and so on.

1:  The `Image#mirror` method flips the image vertically (right-facing to left-facing).

<!--
https://old.reddit.com/r/CryptoPunksDev/comments/s4hyny/q_how_can_i_generate_10_000_leftlooking_phunks_in/
-->


### Q: Is there a way to specify the tile width and height for ImageComposite (rather that the default 24 pixels)?

Yes, you can pass along the width and height (as optional) keyword arguments e.g.

``` ruby
ImageComposite.new( 3, 2,  width: 32, height: 32 )   # 3x2 grid with 32x32px tiles
```

<!--
https://old.reddit.com/r/CryptoPunksDev/comments/rzqipr/compositeimage_from_pixelart/
-->




## Legal & Financial (Con-Art) Fraud

### Q: Am I allowed to create and sell my own [Crypto] Punks?

**A:** I am not a lawyer but let's get real. Yes, in a free world you can of course create and sell your own punks.

About the originals by LarvaLabs - the first question is: Are they really original?  See the [**Blockheads (Anno 2013)**](https://github.com/pixelartexchange/pixelart-howto/tree/master/blockheads) and I am sure there are many more.

I'd say you cannot copyright a trivial 24x24 pixel image - there might be a point about the complete collection (like you can copyright a complete database but not individual facts).

Anyways, the irony is of course the name, that is, CryptoPunks.

The punk ethos is that you do-it-yourself and you don't care what others think (oh, that looks so cheap and so on).  And crypto - of course - is by definition a law-less "decentralised" fraudster paradise where anything goes. And yes, selling 24x24 pixel images by itself is a fraud and shame on the LarvaLabs fraudsters¹ for not stopping the madness but raking in the millions $$$ from greater fools.

¹: Please remember - a (blockchain) token - is nothing special - it is a database entry updated (secured) by signed transactions. Yes, the emperor has no clothes. See [**Come See My Collection**](https://www.ic.unicamp.br/~stolfi/bitcoin/2021-04-02-come-see-my-collection.html)  from a more honest computer scientist  (shame on Matt Hall and John Watkinson both have computer science university degrees - so they for sure know what they are doing and how a database works).

<!--
comments_url: https://old.reddit.com/r/CryptoPunksDev/comments/pjl8vw/am_i_allowed_to_create_and_sell_my_own_cryptopunks/
-->


### Q: Can anyone explain the "Flex-How-Stupid-AND-Rich-I-Am?!"  [Crypto] Punks?  Why pay hundred thousands of dollars for a free public domain 24×24 pixel image? 

**A:**  As a public service announcement let's restate what might get lost in the programming minutiae:

  Yes, CryptoPunks is a con-artist financial fraud. The Emperor has no clothes. Let's start with what you "own" when you buy a CryptoPunk [token].

   The only thing that you "own" is the private 256-bit integer number that you create (for free) on your own computer and that you MUST keep secret, that is, your private key.

   From the 256-bit integer number (private key) you get a "free" public key and public Ethereum account  - the account gets derived (calculated) via Elliptic Curve Cryptography from the public key.

   Anyways, if you now buy a CryptoPunks token via the CryptoPunksMarket contract / service - all you get is an entry in a database that you are now a "certified" CryptoPunks owner and you get assigned an index number (between 0 and 9999).   That's it.

  There's nothing decentralized or trustless.  You have to trust the central issuer LarvaLabs that you own a picture / image of punk.

   And the fact is that LavraLabs actually tell you that you don't. To quote:

>   My name is Mordecai Goldstein and I am the General Counsel
> of Larva Labs LLC [- a multi-million dollar crypto fraudster
> operator].
>
> [..]
>
> The original [24×24 8-bit pixel] images [that any 6-year old can
>  redraw "by hand" in minutes], to which we [claim to] own exclusive
> copyrights, can be found at: https://larvalabs.com/cryptopunks

  And so on and so forth. What's your take?  


<!--
comments_url: https://old.reddit.com/r/CryptoPunksDev/comments/ppb0fh/public_service_announcement_yes_cryptopunks_is_a/
-->



## Questions? Comments?

Post them on the [CryptoPunksDev reddit](https://old.reddit.com/r/CryptoPunksDev). Thanks.
