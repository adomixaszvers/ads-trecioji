unit vektorius;

interface

uses DuomenuTipas;                                          //èia keièiamas vektoriuje saugomø duomenø tipas

type vektor=^Element;
     Element=record
                Kitas:^Element;
                Duomenys:duomenu_tipas;
             end;
             
     type vect=record
                elem:vektor;
                pradzia:vektor;
                VDydis:longint;
               end;
                                                                                                                        //v- vect tipo kintamsis
     procedure VKurk(var v:vect);                                       //Sukuria tuðèia vektoriu                       VKurk(v);
     function VPtk(v:vect):boolean;                                 //Patikrina ar vektorius tuscias                VPtk(v);
     procedure VPrid(var v:vect;Duom:duomenu_tipas);                   //Prideda elementà á vektoriaus galà            VPrid(v,Elementas);
     procedure VRasyk(v:vect);                                      //Isveda visus vektoriaus elementus á ekranà    VRasyk(v);
     function VElem(v:vect; Nr:integer):duomenu_tipas;              //Gauna n-tojo elemento duomenis.               VElem(v,n);
     procedure VNaik(var v:vect);                                       //Atlaisvina atmintá                            VNaik(v);
     procedure VNaikElem(var v:vect; Nr:integer);                       //Istrina n-tàjá elementà                       VNaikElem(v,n);
     function VRask(v:vect; Duom:duomenu_tipas):integer;            //Randa elemento su dëmeniu S numerá            VRask(v,S);
     procedure VIterpk(var v:vect; Nr:integer; duom:duomenu_tipas);     //Iterpia elementà prieð n-tajá elementà        VIterpk(v,n,Elementas);
     procedure VKeisk(var v:vect; Nr:integer; duom:duomenu_tipas);      //Pakeièia n-tajá elementà, kitu elementu       VKeisk(v,n,Elementas);
     function VArSukurtas(v:vect):boolean;                         //Patikrina ar sukurtas vektorius               VArSukurtas(v);  True - sukurtas False - nesukurtas
                                                                                                                    //v.VDydis-vectoriaus dydis.
implementation

procedure VKurk(var v:vect);
begin
  new(v.elem);
  v.pradzia:=v.elem;
  v.pradzia^.kitas:=nil;
  v.VDydis:=0;
end;

function VPtk(v:vect):boolean;
begin
  VPtk:=(v.VDydis=0);
end;

procedure VPrid(var v:vect; Duom:duomenu_tipas);
begin
  If v.VDydis=0
   then begin
         v.Elem^.Duomenys:=Duom;
         v.Elem^.kitas:=nil;
         inc(v.VDydis);
        end
   else begin
         new(v.elem^.kitas);
         v.elem:=v.elem^.kitas;
         v.Elem^.Duomenys:=Duom;
         v.Elem^.kitas:=nil;
         inc(v.VDydis);
        end;
end;

procedure VRasyk(v:vect);
  var E:vektor;
begin

  E:=v.pradzia;
  while E<>nil do
   begin
    write(E^.duomenys,' ');
    e:=e^.kitas;
   end;
end;

function VElem(v:vect; Nr:integer):duomenu_tipas;
  var i:integer; E:vektor;
begin
  if Nr<1 then halt;
  E:=v.pradzia;
  for i:=1 to Nr-1 do E:=E^.kitas;
  VElem:=E^.duomenys;
end;

procedure VNaik(var v:vect);
  var tarpinis:vektor;
begin
  while v.pradzia^.kitas<>nil do
   begin
    tarpinis:=v.pradzia;
    v.pradzia:=v.pradzia^.kitas;
    dispose(tarpinis);
   end;
  dispose(v.pradzia);
  v.VDydis:=0;
end;

procedure VNaikElem(var v:vect; Nr:integer);
  var tarpinis,E:vektor; i:integer;
begin
  E:=v.pradzia;
  if Nr<1 then halt;
  if Nr=1 then  begin E:=v.Pradzia;
                      v.Pradzia:=v.Pradzia^.kitas;
                      Dispose(E);
                      dec(v.VDydis);
                end
          else  begin for i:=1 to Nr-2 do E:=E^.kitas;
                      tarpinis:=E^.kitas;
                      E^.kitas:=tarpinis^.kitas;
                      dispose(tarpinis);
                      Dec(v.VDydis);
                end;
end;

function VRask(v:vect; Duom:duomenu_tipas):integer;
  var E:vektor; i:integer; Nerastas:boolean;
begin
  E:=v.pradzia;
  Nerastas:=True;
  i:=1;
  while e<>nil do
   begin
    if VElem(v,i)=duom then begin VRask:=i;
                                Nerastas:=False;
                                Break;
                          end;
    E:=E^.kitas;
    inc(i);
   end;
  if nerastas then VRask:=0;
end;

procedure VIterpk(var v:vect; Nr:integer; duom:duomenu_tipas);
  var E,tarpinis:vektor; i:integer;
begin
  E:=v.pradzia;
  if Nr<1 then halt;
  if Nr=1 then begin if v.pradzia=nil then halt;
  
                     new(tarpinis);
                     tarpinis^.kitas:=v.pradzia;
                     tarpinis^.duomenys:=duom;
                     v.pradzia:=tarpinis;
                     inc(v.VDydis);
               end
          else begin for i:=1 to Nr-2 do E:=E^.kitas;
                     new(tarpinis);
                     tarpinis^.kitas:=E^.kitas;
                     E^.kitas:=tarpinis;
                     tarpinis^.duomenys:=duom;
                     inc(v.VDydis);
               end;
end;


procedure VKeisk(var v:vect; Nr:integer; duom:duomenu_tipas);
var E,tarpinis:vektor; i:integer;
begin
  E:=v.pradzia;
  if Nr<1 then halt;
  for i:=1 to Nr-1 do E:=E^.kitas;
  E^.duomenys:=duom;
end;

function VArSukurtas(v:vect):boolean;
begin
  if v.pradzia= nil then VArSukurtas:=False
                  else VArSukurtas:=True;
end;

end.
