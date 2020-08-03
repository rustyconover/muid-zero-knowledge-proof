CLEAN:
	-rm -f circuit.r1cs circuit.sym circuit.wasm circuit*.zkey proof.json public.json verification_key.json

pot12_0000.ptau:
	snarkjs powersoftau new bn128 16 pot12_0000.ptau -v

pot12_0001.ptau: pot12_0000.ptau
	snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v -e="some random text"

pot12_0002.ptau: pot12_0001.ptau
	snarkjs powersoftau contribute pot12_0001.ptau pot12_0002.ptau --name="Second contribution" -v -e="some random text"

#snarkjs powersoftau challenge contribute bn128 challenge_0003 response_0003 -e="some random text"
#snarkjs powersoftau import response pot12_0002.ptau response_0003 pot12_0003.ptau -n="Third contribution name"

pot12_beacon.ptau: pot12_0002.ptau
	snarkjs powersoftau beacon pot12_0002.ptau pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

pot12_final.ptau: pot12_beacon.ptau
	snarkjs powersoftau prepare phase2 pot12_beacon.ptau pot12_final.ptau -v

pot12_verify: pot12_final.ptau
	snarkjs powersoftau verify pot12_final.ptau

circuit.r1cs circuit.wasm circuit.sym: circuit.circom
	circom circuit.circom --r1cs --wasm --sym -v
	snarkjs r1cs info circuit.r1cs

circuit_0000.zkey: circuit.r1cs pot12_final.ptau
	snarkjs zkey new circuit.r1cs pot12_final.ptau circuit_0000.zkey

circuit_0001.zkey: circuit_0000.zkey
	snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v -e="some random text"

circuit_0002.zkey: circuit_0001.zkey
	snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"

zkey_verify.txt: circuit.r1cs pot12_final.ptau circuit_0002.zkey
	snarkjs zkey verify circuit.r1cs pot12_final.ptau circuit_0002.zkey | tee zkey_verify.txt

circuit_final.zkey: circuit_0002.zkey
	snarkjs zkey beacon circuit_0002.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

#snarkjs zkey verify circuit.r1cs pot12_final.ptau circuit_final.zkey

verification_key.json: circuit_final.zkey
	snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

witness.wtns: circuit.wasm input.json circuit.sym
	snarkjs wtns calculate circuit.wasm input.json witness.wtns
	snarkjs wtns debug circuit.wasm input.json witness.wtns circuit.sym --trigger --get

proof.json public.json: circuit_final.zkey witness.wtns
	snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json

verify: public.json proof.json verification_key.json
	snarkjs groth16 verify verification_key.json public.json proof.json
