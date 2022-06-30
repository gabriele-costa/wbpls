set traceDisplay = long.

include(`wbpls.pvt')

const enddevice : bitstring.
const gateway : bitstring.
const ok : bitstring.

free devui : bitstring.
free intc : channel [private].
free AppKey : bitstring [private].

event EndnodeJoint(bitstring).
event EndnodeAccepted(bitstring).

query attacker(AppKey).
query x:bitstring;  event (EndnodeAccepted(x)) ==> event(EndnodeJoint(x)).  
(* End-node *)

let endnode(NE: mask, NG: mask, appkey : bitstring) =
  outjam(((wat((devui, appkey), NE), NE), gateway)).
  
(* edgenode *)
let edgenode(NE: mask, NG: mask) =
  injam(m, (dui : bitstring, aui: bitstring));
  out(intc, (dui, aui));
  in(intc, ans : bitstring);
  if ans = ok then 
    event EndnodeJoint(dui).


(* gateway *)
let gatewaynode(appKey : bitstring) = 
  in(intc, (dui : bitstring, akey : bitstring));
  if akey = appKey then 
    event EndnodeAccepted(dui);
    out(intc, ok). 

(*Main*)
process
	new NE: mask;
	new NG: mask;
	wbplsenv((!endnode(NE, NG, AppKey)) | (!edgenode(NE, NG)) | (!gatewaynode(AppKey))))
