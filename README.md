# muid-zero-knowledge-proof
Zero Knowledge Proof of Memorable Unique Identifiers (Muid)

It is useful to be able to prove that you own a [Memorable Unique Identifier](https://www.microprediction.org/muids.html) without revealing the private key associated with it.

This will be useful for facilitating payments or other transactions.

This repo uses [snarkjs](https://github.com/iden3/snarkjs) and [circon](https://github.com/iden3/circom) to construct a zero-knowledge proof that verifies that the creator has a 16 byte value that produces a specified public key prefix.

More formally it shows:

`substr(Sha256(hex(private_key)), Length) === X`

Where 

* `private_key` is the private key of the Muid owner which is 16 bytes.  An example is: `3f06e5b0d027fb4e33a5207dd112892e` which is the hex encoded key for the Muid with the public name of "Homeless Flea".
* `Length` is the length or difficulty of the Muid key.  Typically this is >6.
* `X` is the public prefix of the key. This will typically be the friendly name of the Muid.  An example is `603e1e55f1ea0ded22e4b4ce7f532f44` which when converted to a Muid is "Homeless Flea".


## Usage

0. Clone this repo with submodules enabled.  
  
```
git clone --recurse-submodules git@github.com:rustyconover/muid-zero-knowledge-proof.git
```

1. First install circom and snarkjs

```
npm install -g circom snarkjs
```

2. Run `make proof`


## Caveats

1. Right now the Makefile just fakes some entropy into the Powers of Tau init steps, this is just for development purposes.  If these proofs are going to be used for real, actual entropy should be provided.

## Sizes

The sizes don't seem unreasonable for online use.  Here is an example proof for a Muid with a length of 12.

```
-rw-r--r--  1 rusty  staff       786 Aug  2 21:08 proof.json
-rw-r--r--  1 rusty  staff        95 Aug  2 21:08 public.json
-rw-r--r--  1 rusty  staff      4935 Aug  2 21:08 verification_key.json
-rw-r--r--  1 rusty  staff  12868364 Aug  2 21:07 circuit.r1cs
-rw-r--r--  1 rusty  staff  14589134 Aug  2 21:07 circuit.sym
-rw-r--r--  1 rusty  staff    466316 Aug  2 21:07 circuit.wasm
-rw-r--r--  1 rusty  staff  22713952 Aug  2 21:08 circuit_final.zkey
```
