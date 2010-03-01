What we know:

1) Appleworks stores text encoded as Mac Roman with CR line endings (0x0d aka octal \015)
2) Each file has an identical header which change to represent Appleworks versions. 

         vv version 6.0
0000000: 0607 9d00 424f 424f 0607 9d00 0000 0000  ....BOBO........

3) Meaningful data consistently starts at offset 0x8d8 in files under a certain length.
The character count for the file is stored in several locations

            + character count
            |         v character count
0000850: 0003 0000 0003 0000 0100 0001 0000 0003  ................

                 v character count
0000860: 0000 0003 0001 0001 0001 0000 233e 7188  ............#>q.
0000870: 233e 738c 233e 7178 0000 0000 0000 233e  #>s.#>qx......#>
0000880: 7380 0000 0000 01d4 0288 233e 34d0 0001  s.........#>4...
0000890: 000c 0000 0000 0000 0000 0000 0000 0000  ................
00008a0: 0000 0008 0000 0000 0009 0000 0000 0012  ................
00008b0: 0000 0000 0000 0000 0c01 000a 0000 0000  ................
00008c0: 0300 0000 0000 0000 000a 0000 0000 0004  ................

Doesn't seem to change for files under a certain size. What happens when character count exceeds 4 bytes?
         vvvvvvvvv
00008d0: 233e 7384 0000 0004 554e 4900 0000 005a  #>s.....UNI....Z

More examples:

                             vvvv                 File contains "UN"
00008d0: 233e 7384 0000 0003 554e 0000 0000 5a00  #>s.....UN....Z.

                           v character count +1   File contains 2 chars "UN"
00008d0: 233e 7384 0000 0003 554e 0000 0000 5a00  #>s.....UN....Z.

---

4) Our meaningful data is terminated with a constant sequence of bytes

5a00 01ff ff00 0000 4e00 0000 0100

What we don't know:

1) a lot
2) If the start of data is stored as an address in the file that we can search for. In other words, our meaningful data is surrounded by garbage that we don't fully understand however, if we can find a hint about where data begins, we can efficiently extract and convert our target data

Goals:

Be able to programmatically extract and re-encode text as UTF-8.

Misc:

tests with 2 bytes starting at 0x88a
When 0 chars in file, hex value 72b8 = dec 29368
When 1 chars in file, hex value 22bc = dec 8892
When 2 chars in file, hex value 2438 = dec 9272
When 3 chars in file, hex value 34d0 = dec 13520 
When 4 chars in file, hex value 34cc = dec 13516

Results: No pattern emerging to judge context :/

---

Verifiable format signatures:

Appleworks 6.2 calls appleworks 4 format ClarisWorks 4. 6.0 makes no distinction.

==> format_appleworks_4.xxd <==
0000000: 0481 ad00 424f 424f 0001 233e 716c 0000  ....BOBO..#>ql..

==> format_appleworks_5.xxd <==
0000000: 0581 7600 424f 424f 0607 9d00 0000 0000  ..v.BOBO........

==> format_appleworks_6.xxd <==
0000000: 0607 9d00 424f 424f 0607 9d00 0000 0000  ....BOBO........

ClarisWorks 4.0 and ClarisWorks Kids have identical headers

==> format_appleworks_kids.xxd <==
0000000: 0481 ad00 424f 424f 0001 233e 716c 0000  ....BOBO..#>ql..

