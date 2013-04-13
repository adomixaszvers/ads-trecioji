Unit DvejetainisPaieskosMedis;

interface

Uses Reiksme;

type

	TPElementas = ^TElementas;

	TElementas = record
		reiksme: TReiksme;
		ka, de: TPElementas;
	end;

{prideda viena elementa}
function PridekE(var medis: TPElementas; reiksme: TReiksme): Boolean;

{rekursines spausdinimo proceduros}
procedure SpausdinkVKD(medis: TPElementas);
procedure SpausdinkKVD(medis: TPElementas);
procedure SpausdinkKDV(medis: TPElementas);

{trina visa medi}
procedure TrinkM(var medis: TPElementas);

{is pavadinimu aisku}
function RaskMin(medis: TPElementas): TPElementas;
function RaskMax(medis: TPElementas): TPElementas;
function RaskAuksti(medis: TPElementas): Longword;
function RaskVirsuniuSkaiciu(medis: TPElementas): Longword;

{trina medzio elementa}
procedure TrinkE(var medis: TPElementas; reiksme: TReiksme);

{sukimai}
function SukKairen(esamasE: TPElementas): Boolean;
function SukDesinen(esamasE: TPElementas): Boolean;

{Day–Stout–Warren algoritmas}
procedure DSWBalansavimas(medis: TPElementas);

implementation

function Max(a, b: Longword): Longword;
begin
	if a > b then
		Max := a
	else
		Max := b;
end;

function PridekE(var medis: TPElementas; reiksme: TReiksme): Boolean;
	procedure SukurkE(var rodykle: TPElementas);
	begin
		new(rodykle);
		if rodykle = nil then
			PridekE := False
		else
		begin
			rodykle^.de := nil;
			rodykle^.ka := nil;
			rodykle^.reiksme := reiksme;
			PridekE := True;
		end;
	end;
var
	esamasE: TPElementas;
begin
       	PridekE := False;	
	if medis = nil then
	begin
		SukurkE(medis);
	end

	else
	begin
		esamasE := medis;
		while True do
		begin
			if esamasE^.reiksme = reiksme then
				exit;
			if esamasE^.reiksme > reiksme then
				if esamasE^.ka = nil then
				begin
					SukurkE(esamasE^.ka);
				break;
				end
				else
					esamasE := esamasE^.ka
			else
				if esamasE^.de = nil then
				begin
					SukurkE(esamasE^.de);
					break;
				end
				else
					esamasE := esamasE^.de;
		end;
	end;
end;

procedure SpausdinkVKD(medis: TPElementas);
begin
	if medis = nil then
		exit;
	Write(medis^.reiksme, ' ');
	SpausdinkVKD(medis^.ka);
	SpausdinkVKD(medis^.de);
end;

procedure SpausdinkKVD(medis: TPElementas);
begin
	if medis = nil then
		exit;
	SpausdinkKVD(medis^.ka);
	Write(medis^.reiksme, ' ');
	SpausdinkKVD(medis^.de);
end;

procedure SpausdinkKDV(medis: TPElementas);
begin
	if medis = nil then
		exit;
	SpausdinkKDV(medis^.ka);
	SpausdinkKDV(medis^.de);
	Write(medis^.reiksme, ' ');
end;

procedure TrinkM(var medis: TPElementas);
begin
	if medis = nil then
		exit;
	TrinkM(medis^.ka);
	TrinkM(medis^.de);
	dispose(medis);
	medis := nil;
end;

function RaskMin(medis: TPElementas): TPElementas;
var
	esamasE: TPElementas;
begin
	esamasE := medis;
	while esamasE <> nil do
		if esamasE^.ka <> nil then
			esamasE := esamasE^.ka
		else
			break;
	RaskMin := esamasE;
end;

function RaskMax(medis: TPElementas): TPElementas;
var
	esamasE: TPElementas;
begin
	esamasE := medis;
	while esamasE <> nil do
		if esamasE^.de <> nil then
			esamasE := esamasE^.de
		else
			break;
	RaskMax := esamasE;
end;

function RaskAuksti(medis: TPElementas): Longword;
begin
	if medis = nil then
		RaskAuksti := 0
	else
		RaskAuksti := Max(RaskAuksti(medis^.ka), RaskAuksti(medis^.de))+1;
end;

function RaskVirsuniuSkaiciu(medis: TPElementas): Longword;
begin
	if medis = nil then
		RaskVirsuniuSkaiciu := 0
	else if (medis^.ka = nil) and (medis^.de = nil) then
		RaskVirsuniuSkaiciu := 1
	else
		RaskVirsuniuSkaiciu := 1 + RaskVirsuniuSkaiciu(medis^.ka)+RaskVirsuniuSkaiciu(medis^.de);
end;

procedure TrinkE(var medis: TPElementas; reiksme: TReiksme);
var
	esamasE, tevas: TPElementas;
	{maxReiksme: TReiksme;}
	maxE: TPElementas;
begin
	tevas := nil;
	esamasE := medis;
	while esamasE <> nil do
	begin
		if esamasE^.reiksme = reiksme then
			break;
		if esamasE^.reiksme > reiksme then
		begin
			tevas := esamasE;
			esamasE := esamasE^.ka;
		end
		else
		begin
			tevas := esamasE;
			esamasE := esamasE^.de
		end;
	end;
	if (esamasE = nil) then
		exit;
	if (esamasE^.ka = nil) and (esamasE^.de = nil) then
	begin
		if tevas <> nil then
			if tevas^.reiksme > reiksme then
				tevas^.ka := nil
			else
				tevas^.de := nil
		else
			medis := nil;
		dispose(esamasE);
	end
	else if (esamasE^.ka = nil) then
	begin
		if tevas <> nil then
		begin
			if tevas^.reiksme < esamasE^.de^.reiksme then
				tevas^.de := esamasE^.de
			else
				tevas^.ka := esamasE^.de;
		end
		else
		begin
			medis := esamasE^.de;
		end;
		dispose(esamasE);
	end
	else if (esamasE^.de = nil) then
	begin
		if tevas <> nil then
		begin
			if tevas^.reiksme < esamasE^.ka^.reiksme then
				tevas^.de := esamasE^.ka
			else
				tevas^.ka := esamasE^.ka;

		end
		else
			medis := esamasE^.ka;
		dispose(esamasE);
	end
	else
	begin
		tevas := esamasE;
		maxE := esamasE^.ka;
		while maxE <> nil do
		begin
			if maxE^.de = nil then
				break;
			tevas := maxE;
			maxE := maxE^.de;
		end;
		esamasE^.reiksme := maxE^.reiksme;
		if tevas <> nil then
			if tevas^.reiksme < maxE^.reiksme then
				tevas^.de := maxE^.ka
			else
				tevas^.ka := maxE^.ka;
		dispose(maxE);
	end;


end;

function SukDesinen(esamasE: TPElementas): Boolean;
var
	kitasE: TPElementas;
	reiksme: TReiksme;
begin
	if (esamasE = nil) then
	begin
		SukDesinen := False;
		exit;
	end;
	if (esamasE^.ka = nil) then
	begin
		SukDesinen := False;
		exit;
	end;
	kitasE := esamasE^.ka;
	esamasE^.ka := kitasE^.ka;
	kitasE^.ka := kitasE^.de;
	kitasE^.de := esamasE^.de;
	esamasE^.de := kitasE;

	reiksme := esamasE^.reiksme;
	esamasE^.reiksme := kitasE^.reiksme;
	kitasE^.reiksme := reiksme;
	SukDesinen := True;
	{WriteLn('Pasuko desinen');}
end;

function SukKairen(esamasE: TPElementas): Boolean;
var
	kitasE: TPElementas;
	reiksme: TReiksme;
begin
	if (esamasE = nil) then
	begin
		SukKairen := False;
		exit;
	end;
	if (esamasE^.de = nil) then
	begin
		SukKairen := False;
		exit;
	end;
	kitasE := esamasE^.de;
	esamasE^.de := kitasE^.de;
	kitasE^.de := kitasE^.ka;
	kitasE^.ka := esamasE^.ka;
	esamasE^.ka := kitasE;

	reiksme := esamasE^.reiksme;
	esamasE^.reiksme := kitasE^.reiksme;
	kitasE^.reiksme := reiksme;
	SukKairen := True;
	{WriteLn('Pasuko kairen');}
end;

procedure DSWBalansavimas(medis: TPElementas);
var
	esamasE: TPElementas;
	eKiekis, i, k: Longword;
begin
	esamasE := medis;
	eKiekis := 0;
	while esamasE <> nil do
	begin
		while SukDesinen(esamasE) do;
		esamasE := esamasE^.de;
		eKiekis := eKiekis+1;
	end;
	i := eKiekis div 2;
	while i>0 do
	begin
		esamasE := medis;
		k := 0;
		while k<i do
		begin
			SukKairen(esamasE);
			k := k+1;
			esamasE := esamasE^.de;
		end;
		i := i div 2;
	end;
end;

end.
