set traceDisplay = long.

include(`wbpls.pvt')

const alice : bitstring.
const bob : bitstring.
const eve : bitstring.
free prop : channel.

fun succ(bitstring) : bitstring.

pred eqs(bitstring, bitstring).
clauses forall b:bitstring; eqs(b,b);
				forall b1:bitstring, b2:bitstring; eqs(succ(b1),succ(b2)) -> eqs(b1, b2).

free secretANb, secretBNb :bitstring [private].

query attacker(secretANb);
	  attacker(secretBNb).

(*Alice*)
let processA(NAB : mask)=
	outjam((wat(alice, NAB), NAB), bob);
	injam(m, Nb : bitstring);
  outjam((wat(succ(Nb), NAB),NAB), bob);
	out(prop, senc(secretANb, Nb)).

(*Bob*)
let processB(NAB : mask)=
	injam(m, A : bitstring);
	new Nb: bitstring;
	outjam((wat(Nb, NAB),NAB), alice);
	injam(m2, Nbb : bitstring);
  if eqs(succ(Nb), Nbb) then
	out(prop, senc(secretBNb, Nb)).

(*Main*)
process
	new NAB: mask;
	((!processA(NAB)) | (!processB(NAB)) | (!processJam()) | (!processDeJam()))
