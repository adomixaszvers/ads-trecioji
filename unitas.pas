
unit unitas;

interface

uses duom_type;

type
  T_Lapas = ^MedisElemType;

  MedisElemType = record
    kaire: T_Lapas;
    desine: T_Lapas;
    duom: DuomType;
  end;




  TMedis = record
    galva: T_Lapas;
    sukurtas: boolean;

  end;


procedure Kurti(var Medis: TMedis; var klaida: boolean);
// var sukurtas_medis :TT);    //sukuriamas medis

function Ar_tuscias(Medis: TMedis): boolean; //tikrinsim ar medis tuscias

procedure Iterpimas_Medis(duomenys: DuomType; var Medis: TMedis; var klaida: boolean);
//kuriam vyr. medi su reiksme ir galai nunillinami

procedure RASK_EL(Find_Who: DuomType; Medis: TMedis; var Per_kiek: integer;
  var klaida: boolean);//iesko per kiek surastu el. (kiek tevu)

procedure Naikinti_Medi(var Medis: TMedis); //sunaikinsim medi

procedure Naikinti_el(var Medis: TMedis; Del_Who: DuomType; var klaida: boolean);
//sunaikinamas ivestas elementas (sutvarkoma sasaja tarp el,o ne numetama)

procedure Balansavimas(var Medis: TMedis; var klaida: boolean);

procedure spausdintiVKD(Medis: Tmedis; klaida: boolean);

procedure spausdintiKVD(Medis: Tmedis; klaida: boolean);

procedure spausdintiKDV(Medis: Tmedis; klaida: boolean);


implementation


procedure Kurti(var Medis: TMedis; var klaida: boolean);
// var sukurtas_medis :TT); //sukuriamas medis
begin
  if Medis.sukurtas = False then
  begin
    Medis.sukurtas := True;
    klaida := False;
    Medis.galva := nil;
  end
  else
    klaida := True;
end;
//**************************************************
function Ar_tuscias(Medis: TMedis): boolean;
begin
  if Medis.galva = nil then
    Ar_tuscias := True
  else
    Ar_tuscias := False;
end;
//**************************************************
procedure iterpk(duomenys: DuomType; var Medis: T_Lapas; var klaida: boolean);
var
  temp, tarp: T_Lapas;
begin
  if Medis = nil   //jei pirma el. irasome (jei pradzia = nil)
  then
  begin
    New(Medis);
    Medis^.kaire := nil;
    Medis^.desine := nil;
    Medis^.duom := duomenys;
  end

  else
  begin     //jei nepirmas el.
    tarp := Medis;
    if Medis^.duom = duomenys then
      // jei jau buvo toks elementas ivestas, sustoti
    begin
      klaida := True;// KARTOJASI ELEMENTAS
    end
    else
    begin
      {New(temp);
      temp^.kaire := nil;
      temp^.desine := nil;
      temp^.duom := duomenys;}

      if Medis^.duom >
        duomenys   //jei naujas duomenys maziau uz pirma, tai i kaire
      then
        if Medis^.kaire =
          nil  //jei ta kaire tuscia -> priskirt reiksme, sukurti toliau
        then
        begin
          New(temp);
          temp^.kaire := nil;
          temp^.desine := nil;
          temp^.duom := duomenys;
          Medis^.kaire := temp; //duodam pag. medziui
        end

        else
        begin //jei uzimta kaire puse, pereinam i kita ir kuriam
          Medis := Medis^.kaire;
          //Dispose(temp);
          Iterpk(duomenys, Medis, klaida);
        end

      else if Medis^.duom <
        duomenys //jei ivesta reiksme didesne (same as with left)
      then
        if Medis^.desine = nil     //jei tuscia, idedam
        then
        begin
          New(temp);
          temp^.kaire := nil;
          temp^.desine := nil;
          temp^.duom := duomenys;
          Medis^.desine := temp;
        end

        else
        begin  //jei uzimta, judam toliau, kuriam
          Medis := Medis^.desine;
          //Dispose(temp);
          Iterpk(duomenys, Medis, klaida);
        end;
    end;
    Medis := tarp;
  end;
end;

procedure Iterpimas_Medis(duomenys: DuomType; var Medis: TMedis; var klaida: boolean);
//kuriam vyr. medi su reiksme ir galai nunillinami
//var temp,tarp : TMedis; //kuriant medzio isdestyma, kad nepamestu pradzios ir pabaigos
begin
  if Medis.sukurtas = True then
    iterpk(duomenys, Medis.galva, klaida)
  else
    klaida := True;

end;
//**************************************************
procedure RASK_EL1(Find_Who: DuomType; Medis: T_Lapas; var Per_kiek: integer;
  var klaida: boolean);
var
  k: integer; //aukstas pasikeite

begin
  k := 0;      //ziuresim ar judam toliau

  if Medis^.duom = Find_Who     //radom ta el.
  then
  begin
    k := 1;
    klaida := False;
  end

  else
  begin
    klaida := True;  //kolkas neradom
    k := k + 1;   //per kiek rasim

    if Medis^.duom > Find_Who then
      if Medis^.kaire <> nil then
      begin
        Medis := Medis^.kaire;
        RASK_EL1(Find_Who, Medis, Per_kiek, klaida);
      end
      else
      begin
      end

    else if Medis^.duom < Find_Who then
      if Medis^.desine <>
        nil then
      begin
        Medis := Medis^.desine;
        RASK_EL1(Find_Who, Medis, Per_kiek, klaida);
      end

      else
        k := 0;
  end;

  if k = 1 then
    Per_kiek := Per_kiek + 1;

end;

procedure RASK_EL(Find_Who: DuomType; Medis: TMedis; var Per_kiek: integer;
  var klaida: boolean);
begin
  if Medis.sukurtas = True then
    RASK_EL1(Find_Who, Medis.galva, Per_Kiek, klaida)
  else
    klaida := True;
end;
//**************************************************
procedure Naikinti_Medi1(var Medis: T_Lapas);
begin

  if Medis <> nil then
  begin

    Naikinti_Medi1(Medis^.kaire);
    Naikinti_Medi1(Medis^.desine);
    dispose(Medis); //sunaikinam ta liekanele

  end;
end;

procedure Naikinti_Medi(var Medis: TMedis);
begin
  Naikinti_Medi1(Medis.galva);
  Medis.sukurtas := False;
end;
//**************************************************
// funkcijos naudojamos TIK "Naikinti_el" proceduroje
function pirmtakas(Medis: T_Lapas): T_Lapas;
  //jei tevo desine <> nil, pirmtakas := desine, kitaip -> pirmtakas:= kaire
var
  T: T_Lapas;
begin
  T := Medis^.kaire;      //jei desine butu NILL
  while T^.desine <> nil do
    //jei desine <> NILL, priskiriam pati maziausia desiniausia nari T
    T := T^.desine;
  pirmtakas := T;         //pirmtakas = jungiamasis el
end;
// funkcijos naudojamos TIK "Naikinti_el" proceduroje

procedure Naikinti_el1(var Medis: T_Lapas; Del_Who: DuomType; var klaida: boolean);
var
  T, pirm: T_Lapas;
begin
  if Medis <> nil then
    if Medis^.duom = Del_Who      //suradome teva, kuriame yra trinamas el.
    then
      if (Medis^.kaire = nil) or (Medis^.desine = nil)
      then
      begin
        T := Medis;

        if Medis^.kaire = nil    //elementas neturi kaires ?akos
        then
          Medis := Medis^.desine    //esamam tevui priskiriam kas yra desinej

        else if Medis^.desine =
          nil    //elementas neturi de?ines ?akos, SAME AS LEFT
        then
          Medis := Medis^.kaire;  //esamam tevui priskiriam kas yra kairej

        dispose(T);
        klaida := False;
      end

      else
      begin       //elementas turi abi ?akas
        pirm := pirmtakas(Medis);
        //surandam saka, kuri pakeis istrinta saka
        Medis^.duom := pirm^.duom;
        Naikinti_el1(Medis^.kaire, Medis^.duom, klaida);
      end

    else    //neradome norimo el, judam toliau pagal < ar >
    if Del_Who > Medis^.duom then
      Naikinti_el1(Medis^.desine, Del_Who, klaida)
    else
      Naikinti_el1(Medis^.kaire, Del_Who, klaida);

end;

procedure Naikinti_el(var Medis: TMedis; Del_Who: DuomType; var klaida: boolean);
begin
  if Medis.sukurtas = True then
    Naikinti_el1(Medis.galva, Del_Who, klaida)
  else
    klaida := True;
end;
//**************************************************

function aukstis(var Medis: T_Lapas): integer;
var
  t1, t2: integer;
begin
  if (Medis <> nil) then
  begin
    t1 := aukstis(Medis^.kaire) + 1;
    t2 := aukstis(Medis^.desine) + 1;
    if (t1 >= t2) then
      aukstis := t1
    else
      aukstis := t2;
  end
  else
    aukstis := -1;
  if aukstis <= 0 then
    aukstis := 0;
end;

//********************************

procedure kopijuot_trinti(var T: T_Lapas; var Medis: T_Lapas; var klaida: boolean);

begin
  while T <> nil do
  begin
    iterpk(T^.duom, Medis, klaida);
    Naikinti_el1(T, T^.duom, klaida);

  end;

end;
//---------------------------------------
procedure Balansavimas1(var Medis: T_Lapas; var klaida: boolean);
var

  L_size, R_size: integer;
  Tmp: DuomType;

  tmpTree: T_Lapas;

begin
  if Medis <> nil then
  begin
    L_Size := aukstis(Medis^.kaire);
    R_Size := aukstis(Medis^.desine);


    while (abs(R_size - L_size) > 1) do
    begin

      if L_size < R_size then                //jei desine didesne, issiaugom esama teva
      begin                      //istrinam teva is medzio
        tmp := Medis^.duom;              //ir pridedam atgal i medi tuos duomenis
        Naikinti_el1(Medis, Medis^.duom, klaida);
        //kadangi desine pasistumi, istrintas el. eis i kaire medzio puse
        iterpk(tmp, Medis, klaida);
      end
      else
      if L_size > R_size then
      begin
        tmpTree := Medis;
        Medis := Medis^.kaire;

        tmpTree^.kaire := nil;

        kopijuot_trinti(tmptree, Medis, klaida);

      end;

      L_Size := aukstis(Medis^.kaire);
      R_Size := aukstis(Medis^.desine);
    end;

    Balansavimas1(Medis^.kaire, klaida);
    Balansavimas1(Medis^.desine, klaida);

  end;
end;

procedure Balansavimas(var Medis: TMedis; var klaida: boolean);
begin
  if Medis.sukurtas = True then
    Balansavimas1(Medis.galva, klaida)
  else
    klaida := True;
end;

procedure spausdintiVKD1(Medis: T_Lapas; klaida: boolean);
begin
  if medis = nil then
    exit;
  Write(medis^.duom, ' ');
  SpausdintiVKD1(medis^.kaire, klaida);
  SpausdintiVKD1(medis^.desine, klaida);
end;

procedure spausdintiVKD(Medis: TMedis; klaida: boolean);
begin
  if medis.sukurtas = True then
    SpausdintiVKD1(Medis.galva, klaida)
  else
    klaida := True;
end;

procedure SpausdintiKVD1(Medis: T_Lapas; klaida: boolean);
begin
  if medis = nil then
    exit;
  SpausdintiKVD1(medis^.kaire, klaida);
  Write(medis^.duom, ' ');
  SpausdintiKVD1(medis^.desine, klaida);
end;

procedure SpausdintiKVD(Medis: TMedis; klaida: boolean);
begin
  if medis.sukurtas = True then
    SpausdintiKVD1(Medis.galva, klaida)
  else
    klaida := True;
end;

procedure SpausdintiKDV1(Medis: T_Lapas; klaida: boolean);
begin
  if medis = nil then
    exit;
  SpausdintiKDV1(medis^.kaire, klaida);
  SpausdintiKDV1(medis^.desine, klaida);
  Write(medis^.duom, ' ');
end;

procedure SpausdintiKDV(Medis: TMedis; Klaida: boolean);
begin
  if medis.sukurtas = True then
    SpausdintiKDV1(Medis.galva, klaida)
  else
    klaida := True;
end;

begin
end.