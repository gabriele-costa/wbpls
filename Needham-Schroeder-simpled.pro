set traceDisplay = long.

include(`wbpls.pvt')

const alice : bitstring.
const bob : bitstring.
const eve : bitstring.
free prop : channel.

free secretANa, secretANb, secretBNa, secretBNb :bitstring [private].

query attacker(secretANa);
	  attacker(secretANb);
	  attacker(secretBNa);
	  attacker(secretBNb).

(*Alice*)
let processA(NA : mask, NB : mask)=
	new Na: bitstring;
	outjam(((wat(Na, NA), NA), bob));
	injam(m, (Naa : bitstring, NX : bitstring));
  if Na = Naa then
	outjam(((wat(NX, NA),NA), bob));
	out(prop, senc(secretANa, Na));
	out(prop, senc(secretANb, NX)).

(*Bob*)
let processB(NA : mask, NB : mask)=
	injam(m, NY : bitstring);
	new Nb: bitstring;
	outjam(((wat((NY,Nb), NB),NB), alice));
	injam(m3, Nbb : bitstring);
  if Nb = Nbb then
	out(prop, senc(secretBNa, NY));
	out(prop, senc(secretBNb, Nb)).

(*Main*)
process
	new NA: mask;
	new NB: mask;
	((!processA(NA, NB)) | (!processB(NA, NB)) | (!processJam()) | (!processDeJam()))
