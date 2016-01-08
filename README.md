# huffman-ruby

This is a basic implementation of Huffman Coding in Ruby.  It exposes a command line interface:

```
$ ruby main.rb -h

usage: ruby main.rb [options]
    -e, --encode                     Encoding mode
    -d, --decode                     Decoding mode
    -c, --console-output             Dump output file content to STDOUT
    -i, --input INPUT_FILE           Input file. The file to be encoded or decoded.
    -o, --output OUTPUT_FILE         Output file, where result of decoding or encoding will be written to.
```

## Getting started

You'll need Ruby 1.9 and later.  Just clone this repo and you should be good to go.  No non-standard dependencies as of yet.

There's a test file included in this repository, `sample.txt` which is a whole 29.5 KB of generated lorem ipsum. You can encode it by doing:

```
ruby main.rb -e -i sample.txt -o output.txt
```

## TODO:

Encoding works great!  But, we still need to...

1. Figure out how to serialize the huffman tree and store it at the beginning of the output file
2. Implement a decoder that will rebuild the huffman tree and decode a file

## Contributing

Feel free to fork this and suggest changes!