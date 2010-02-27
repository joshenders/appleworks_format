What we know:

1) Appleworks works stores text encoded as Mac Roman with CR line endings (0x0d aka octal \015)
2) Each file has an identical header, some bytes change with different Appleworks versions

0000000: 0607 9d00 424f 424f 0607 9d00 0000 0000  ....BOBO........

3) Our meaningful data is terminated with a predictable sequence of bytes

5a00 01ff ff00 0000 4e00 0000 0100

What we don't know:

1) a lot, perhaps we don't care to know it all
2) If the start of data is stored as an address in the file that we can search for. In other words, our meaningful data is surrounded by garbage that we don't fully understand however, if we can find a hint about where data begins we can efficiently extract and convert our target data

Goals:

Be able to programmatically extract and re-encode text as UTF-8.
