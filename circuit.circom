include "circomlib/circuits/sha256/sha256.circom";
include "circomlib/circuits/bitify.circom";

// Prove the ownership of Muid of a certain lengt
// as expressed as byteLength.

template MuidProver(byteLength) {
    // The length of the Muid key in bytes.
    // this is always fixed.
    //
    // Muids are 16 random bytes but expressed
    // in hexadecimal meaning they take 32 bytes
    // to store as a string.
    //
    var keyLength = 32;

    // Store each byte of the Muid private key
    // as a unsigned 8-bit numeric value.
    //
    // So if the key was:
    //
    // 3f06e5b0d027fb4e33a5207dd112892e
    //
    // This input would be:
    //
    // 56, 57, 100, 54, 52, 99,  53,  51,
    // 97, 53, 100, 97, 50, 57,  51,  53,
    // 98, 97, 101, 54, 97, 49,  54,  55,
    // 101, 57, 101, 54, 55, 98, 101, 100
    //
    //
    signal private input key[keyLength];

    // An array of 8-bit numeric values which are
    // the expected values of the public identifier
    // of the Muid.
    //
    // So if you have a Muid with a public key of
    // "Homeless Flea" this will be a 12 element array
    // containing "603e1e55f1ea0ded22e4b4ce7f532f44"
    // The array would consist of:
    //
    // 56, 57, 100, 54, 52, 99,  53,  51,
    // 97, 53, 100, 97
    //
    // The rest of the Sha256 output is not verified.
    //
    // The length of this array changes with the length
    // of the Muid being proven.
    signal input expectedValue[byteLength];

    // An array of Num2Bits components which will convert
    // the 8 bit numbers to a bit array.
    component n2b[keyLength];

    // Number of bits in a byte.
    var size = 8;

    // In MemorableUniqueIdentifiers the public key is the output of
    // Sha256() where the input to Sha256 is the hex representation
    // of the key expressed in ASCII.  *This is very important to
    // remember.*
    //
    // So the input will be:
    //
    // 8 (bits in a byte) * keyLength
    //
    component sha256 = Sha256(keyLength * 8);

    // Loop over the entire key and convert the numbers to a bit
    // array then place it into the input of the Sha256 function.
    for(var current = 0; current < keyLength; current++) {
        n2b[current] = Num2Bits(size);
        n2b[current].in <== key[current];
        for(var i = 0; i < size; i++) {
            sha256.in[(size*current)+size-1-i] <== n2b[current].out[i];
        }
    }

    // An array of Bit2Num components that convert back to 8-bit
    // number.
    component b2n[byteLength];

    for(var current = 0; current < byteLength; current++) {
        b2n[current] = Bits2Num(size);
        for(var i = 0; i < size; i++) {
            b2n[current].in[i] <== sha256.out[(size*current)+size-1-i];
        }
    }

    // Verify that all of the values match the expected values
    // from the public key.
    for(var current = 0; current < byteLength; current++) {
        b2n[current].out === expectedValue[current];
    }

    // Viola, you now has a proof that you possess the Muid
    // without revealing the private key.
}

component main = MuidProver(12);

