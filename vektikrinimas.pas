Program Tikrinimas;

Uses vektorius;

var
	v: vect;
	i: integer;

begin
	VKurk(v);
	for i := 1 to 10 do
		VPrid(v, i);
	for i := 1 to 10 do
		VNaikElem(v, 1);
	for i := 1 to 10 do
	begin
		VPrid(v, i);
		WriteLn(VElem(v, i));
	end;
	VRasyk(v); WriteLn;
	VNaik(v);
end.
