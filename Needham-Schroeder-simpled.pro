set traceDisplay = long.

include(`wbpls.pvt')

const alice : bitstring.
const bob : bitstring.
const eve : bitstring.

free secretANa, secretANb, secretBNa, secretBNb :bitstring [private].

query attacker(secretANa);
	  attacker(secretANb);
	  attacker(secretBNa);
	  attacker(secretBNb).

(*Alice*)
let processA(NA : mask, NB : mask)=
	new Na: bitstring;
	out(jam_chan, ((wat(Na, NA), NA), bob));
	in(c, m: bitstring);
  out(dejam_chan, m);
  in(dejam_chan, (Naa : bitstring, NX : bitstring));
  if Na = Naa then
	out(jam_chan, ((wat(NX, NA),NA), bob));
	out(c, senc(secretANa, Na));
	out(c, senc(secretANb, NX)).

(*Bob*)
let processB(NA:mask, NB : mask)=
	in(c, m: bitstring);
  out(dejam_chan, m);
  in(dejam_chan, NY : bitstring);
	new Nb: bitstring;
	out(jam_chan, ((wat((NY,Nb), NB),NB), alice));
	in(c, m3: bitstring);
  out(dejam_chan, m3);
  in(dejam_chan, Nbb : bitstring);
  if Nb = Nbb then
	out(c, senc(secretBNa, NY));
	out(c, senc(secretBNb, Nb)).

(*Main*)
process
	new NA: mask;
	new NB: mask;
	((!processA(NA, NB)) | (!processB(NA, NB)) | (!processJam()) | (!processDeJam()))
