Shuffle
=======

Shuffles MP3 albums (folders) on USB flash drives. Allows shuffling by FAT entries, or by using random numeric prefixes to album names.

I wanted a way to shuffle the order of my classic rock albums on my car’s music flash drive and wrote a quick utility which pre-pended a 3 digit number, in random order, to each album name. This worked fine for a couple cars that I owned, till I got a Toyota Auris Hybrid. The stereo system in this car doesn’t recognize alpha-numeric sort, but rather shows the albums in the order in which they were copied to the flash drive. That forced me to find a way to randomize the order of the FAT entries. Thanks to Boris Leidner for his awesome fatsort utility. I replaced his C code “main” routine with my own routine that provides an interface to my program.

I implemented a simple UI which lists the USB flash drives found on a Mac. Once a drive is selected, the user can then shuffle the order using one (or both) of the shuffle options.

Hope this helps someone enjoy their music just a little bit more.

Abu Mami