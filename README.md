# muid-zero-knowledge-proof
Zero Knowledge Proof of Memorable Unique Identifiers (Muid)

It is useful to be able to prove that you own a (Memorable Unique Identifier)[https://www.microprediction.org/muids.html] without revealing the private key associated with it.

This will be useful for facilitating payments or other transactions.

This repo uses snarkjs and circon to construct a zero-knowledge proof that verifies that the creator has a 16 byte value 
that produces a specified public key prefix.

More formally it shows:

`substr(Sha256(hex(private_key)), Length) === X`

Where 

* `private_key` is the private key of the Muid owner which is 16 bytes.  An example is: `3f06e5b0d027fb4e33a5207dd112892e` which is the hex encoded key for the Muid with the public name of "Homeless Flea".
* `Length` is the length or difficulty of the Muid key.  Typically this is >6.
* `X` is the public prefix of the key. This will typically be the friendly name of the Muid.  An example is `603e1e55f1ea0ded22e4b4ce7f532f44` which when converted to a Muid is "Homeless Flea".
