This project contains three small programs to be run from the command line in OS X.  They use a Swift framework, Encryptor, that gives access to functionality of the Apple CommonCrypto library.  The framework is [here](https://github.com/telliott99/Encryptor)

After building in Xcode, it should be copied into ~/Library/Frameworks or another suitable location.

The programs are invoked like this:

``keygen mypassphrase``

``keygen`` combines a user password with random bytes ("salt")
to generate a key, and writes the result to "key.txt" as binary data (encoded as a UTF8 string).

``encode input.txt key.txt``

encode reads input.txt (UTF8 String) and converts it to binary data.  It then uses key data of the kind produced by keygen, encodes it, and writes the result to "cipher.txt" as binary data (encoded as a UTF8 string).  It also writes the initialization vector to "iv.txt" to use in decoding.

``decode cipher.txt key.txt iv.txt``

decode reads cipher.txt (UTF8 String), and converts it to binary data.  It then uses key data of the kind produced by keygen and the initialization vector from "iv.txt", decodes the data, and writes the result to "decoded.txt" as binary data (encoded as a UTF8 string).

