import aes
import sys
text = "6bc1bee22e409f96e93d7e117393172a"
password = "2b7e151628aed2a6abf7158809cf4f3c" 
blocksize = 128   # can be 128, 192 or 256
crypted = aes.encrypt( text, password, blocksize )
sys.stdout.write(crypted)
# do something
decrypted = aes.decrypt( crypted, password, blocksize )
sys.stdout.write(decrypted)
