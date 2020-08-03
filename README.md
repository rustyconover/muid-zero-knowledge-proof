# muid-zero-knowledge-proof
Zero Knowledge Proof of Memorable Unique Identifiers (Muid)

It is useful to be able to prove that you own a Memorable Unique Identifier without revealing the private key associated with it.

This will be useful for facilitating payments or other transactions.

This repo uses snarkjs and circon to construct a zero-knowledge proof that verifies that the creator has a 16 byte value 
that produces a specified public key prefix.

More formally it shows:

`substr(Sha256(hex(Muid private key)), length) === X`

Where X is a specified public prefix which is used as an identity at [microprediction.org](https://www.microprediction.org).

