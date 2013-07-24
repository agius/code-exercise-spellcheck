Coding Problem for an Interview
================================

Spellchecker
------------

Write a program that reads a large list of English words (e.g. from /usr/share/dict/words on a unix system) into memory, and then reads words from stdin, and prints either the best spelling suggestion, or "NO SUGGESTION" if no suggestion can be found. The program should print ">" as a prompt before reading each word, and should loop until killed.

Your solution should be faster than O(n) per word checked, where n is the length of the dictionary. That is to say, you can't scan the dictionary every time you want to spellcheck a word.

For example:

    > sheeeeep
    sheep
    > peepple
    people
    > sheeple
    NO SUGGESTION

The class of spelling mistakes to be corrected is as follows:

    Case (upper/lower) errors: "inSIDE" => "inside"
    Repeated letters: "jjoobbb" => "job"
    Incorrect vowels: "weke" => "wake"
    Any combination of the above types of error in a single word should be corrected (e.g. "CUNsperrICY" => "conspiracy").

If there are many possible corrections of an input word, your program can choose one in any way you like. It just has to be an English word that is a spelling correction of the input by the above rules.

Final step: Write a second program that *generates* words with spelling mistakes of the above form, starting with correctly spelled English words. Pipe its output into the first program and verify that there are no occurrences of "NO SUGGESTION" in the output.

Notes
------
This solution could probably use some refactoring. My first thought was to use a trie-walk to figure out the shortest edit distance, but that proved to have lots of nasty edge cases. It might actually be faster to just hack at it with regular expressions until you find a match or hit the word length. But that doesn't show off my knowledge of CS :)

There is also a nasty problem with long strings of vowels - theoretically, you'd have to run through every permutation to avoid missing cases. I capped the length of vowel permutations at two, because it's pretty unlikely you'll have something like QUEUEING misspelled as QUUUUUNG or something similar. Realistically, you're not likely to have more than two different vowels in a row before you can check other combinations.

Last thing: while you _can_ pipe to the command line, reading in the dictionary every time is quite slow. Test.rb includes two environment variables: RUNS and STDIN. RUNS controls the total number of misspelled words generated and checked. STDIN will force the program to pipe to stdin instead of running it all in Ruby (ie, the _really slow way_). 

Examples:

    ruby spellcheck.rb                # run in manual mode
    DEBUG=true ruby spellcheck.rb     # view entire walk through letters
    ruby test.rb                      # full auto!
    RUNS=200 ruby test.rb
    RUNS=25 STDIN=true ruby test.rb
    
Cheat Codes
-----------
Two options for cheating on this:

1. Set up Solr / Sunspot with a dictionary and use their spellcheck algorithm. I set up a way to do that [here](http://atevans.com/spellchecking-with-sunspot-and-solr)

2. Google the word and scrape the spellcheck suggestion. Easy with [HTTParty](https://github.com/jnunemaker/httparty)

Cheers,