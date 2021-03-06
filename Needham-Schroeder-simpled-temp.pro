free c : channel.

type bitset.
type mask.


pred leq(mask, mask).
clauses forall m1:mask; leq(m1, m1);
        forall m1:mask, m2:mask, m3:mask; leq(m1, m2) && leq(m2, m3) -> leq(m1, m3).



        pred leq(mask, mask).
        clauses forall m:bitset, j:nat; leq(mk_mask(m,0), mk_mask(m,j));
                forall m:bitset, i:nat, j:nat; leq(mk_mask(m,i+1),mk_mask(m,j+1)) <-> leq(mk_mask(m,i),mk_mask(m,j)).






fun wat(bitstring, mask) : bitstring.
equation forall m:bitstring, n:mask; wat(m, n) = m.

type Bool.


fun beval(Bool) : bool.
reduc forall b : bool; mk_bool(b) = b.

fun mk_mask(bool, bool, bool, bool, bool, bool, bool, bool) : mask.

fun bleq(bool, bool) : bool
reduc forall b : bool; bleq(false, b) = true
otherwise forall b : bool; bleq(b, true) = true
otherwise forall b1 : bool, b2 : bool; bleq(b1, b2) = false.

fun mleq(mask, mask) : Bool.
equation forall b1:bool, b2:bool, b3:bool, b4:bool, b5:bool, b6:bool, b7:bool, b8:bool, b11:bool, b12:bool, b13:bool, b14:bool, b15:bool, b16:bool, b17:bool, b18:bool; mleq(mk_mask(b1, b2, b3, b4, b5, b6, b7, b8), mk_mask(b11, b12, b13, b14, b15, b16, b17, b18)) = mk_bool(true).



(* se p <= q restituisce q, altrimenti fallisce
fun leq(mask, mask, bool) : mask
reduc forall n:bitset, i:nat, j:nat; leq(mk_mask(n,i),mk_mask(n,j), ileq(i,j)) = mk_mask(n,j).
 *)


fun jam(bitstring, mask) : bitstring.
reduc forall m:bitstring, p:mask, q:mask; djam(jam(wat(m,p),q),mleq(q,p)) = m.
(* reduc forall m:bitstring, n:bitset; djam(jam(m, mk_mask(n,0))) = m. *)



fun senc(bitstring, bitstring): bitstring.
reduc forall x: bitstring, y: bitstring; sdec(senc(x, y), y)= x.

free secretANa, secretANb, secretBNa, secretBNb :bitstring [private].

query attacker(secretANa);
	  attacker(secretANb);
	  attacker(secretBNa);
	  attacker(secretBNb).

(*Alice*)
let processA(NA : mask, NB : mask)=
	new Na: bitstring;
	out(c, jam(wat(Na, NA), NA));
	in(c, m: bitstring);
	let (= Na, NX: bitstring) = djam(m, true) in
	out(c, jam(wat(NX, NA),NA));
	out(c, senc(secretANa, Na));
	out(c, senc(secretANb, NX)).

(*Bob*)
let processB(NA:mask, NB : mask)=
	in(c, m: bitstring);
	let NY: bitstring = djam(m, NA) in
	new Nb: bitstring;
	out(c, jam(wat((NY,Nb), NB),NB));
	in(c, m3: bitstring);
	if Nb= djam(m3, NA) then
	out(c, senc(secretBNa, NY));
	out(c, senc(secretBNb, Nb)).

(*Main*)
process
	new NA: mask;
	new NB: mask;
	((!processA(NA, NB)) | (!processB(NA, NB)))
