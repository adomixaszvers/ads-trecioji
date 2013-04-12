unit ProcNFunc;

interface

Uses Tipai;

Type

TreeElementType = record //Duomen� medyje tipas
    key : KeyType;
    end;

TreePtrType = ^TreeNodeType; //Med�io rodykl�s tipas

TreeNodeType = record
    info : TreeElementType;//duomenys
    Left : TreePtrType;//rodykl� � kair� vaik�
    Right : TreePtrType;//rodykl� � de�in� vaik�
    end;

TreeType = TreePtrType;

Procedure CreateTree(var Tree : TreeType);
Procedure InsertElement (var Tree : TreeType; Element : TreeElementType);
Function Height(tree: TreeType): integer;
Function CountTop(Tree : TreeType): integer;
Procedure PrintKVD(Tree : TreeType);
Procedure PrintVKD(Tree : TreeType);
Procedure PrintKDV(Tree : TreeType);
Procedure DestroyTree(var Tree : TreeType);
Procedure DeleteElement(var Tree : TreeType; KeyValue : KeyType);
Procedure DSWBalance(tree: TreeType);
Procedure RemoveLastLevel (var Tree : TreeType; lygis : integer);

implementation

//-----------Proced�ros ir funkcijos----------
//--------------------------------
{Med�io k�rimas}
Procedure CreateTree(var Tree : TreeType);
begin
Tree := nil;  //Sukuriamas tu��ias medis
end;
//--------------------------------
Procedure FindNode( Tree : TreeType; KeyValue : KeyType; var NodePtr : TreePtrType; var ParentPtr : TreePtrType);
// Randamas vir��n� pagal duot� KeyValue;
var

Found : Boolean; //Ar rasta vir��n� su KeyValue

begin

//Pasiruo�iama paie�kai
NodePtr := Tree;
ParentPtr := nil;
Found := False;

//Ie�koma kol randama vir��n� arba kol nebera kur ie�koti
while (NodePtr <> nil) and not Found do
if NodePtr^.Info.Key = KeyValue
	then Found := True

else
	begin

	ParentPtr := NodePtr;

	if NodePtr^.Info.Key > KeyValue
		then NodePtr := NodePtr^.Left
		else NodePtr := NodePtr^.Right

	end
end;

//--------------------------------
//Elemento �terpimas [1]
Procedure InsertElement (var Tree : TreeType; Element : TreeElementType);
//�terpiamas elementas � med�. Atmetant elementus kurie pasikartoja
var
NewNode : TreePtrType;
NodePtr : TreePtrType;
ParentPtr : TreePtrType;

begin
// sukuriama naujas lapas
New (NewNode);
NewNode^.Left := nil;
NewNode^.Right := nil;
NewNode^.Info := Element;

//Ie�koma vietos kurioje iteroti
FindNode (Tree, Element.Key, NodePtr, ParentPtr);

//Jei tai pirma vir��n� sukuriama nauja vir��n�
if ParentPtr = nil
	then Tree := NewNode //Vir��n�
	else //�terpiama � jau egzistuojant� med�
		if ParentPtr^.Info.Key > Element.Key
			then ParentPtr^.Left := NewNode
			else ParentPtr^.Right := NewNode

end;
//--------------------------------
Function Max(a, b: integer): longint;
begin
	if a > b then
		Max := a
	else
		Max := b;
end;
//--------------------------------
{Med�io auk��io radimas}
Function Height(tree: TreeType): integer;
begin
	if tree = nil then Height := 0
	else Height := Max(Height(tree^.left), Height(tree^.right)) + 1;
end;
//--------------------------------
{Ie�komas vir��ni� skai�ius}
Function CountTop(Tree : TreeType): integer;
begin
	if tree = nil
        then
			CountTop := 0
        else if (tree^.left = nil) and (tree^.right = nil)
            then
				CountTop := 1
            else
				CountTop := 1 + CountTop(tree^.left) + CountTop(tree^.right);
end;
//--------------------------------
{Spausdinimas}
Procedure PrintNode(Element : TreeElementType);

begin
Writeln (Element.Key); //atspausdinamas elementas
end;

//--------------------------------

Procedure PrintKVD(Tree : TreeType);
//Atspausdinamai elementai nuo did�iausio iki ma�iausio
begin

if Tree <>nil
then

begin
	PrintKVD(Tree^.Left);
	PrintNode(Tree^.Info);
	PrintKVD(Tree^.Right)
end
end;

//--------------------------------

Procedure PrintVKD(Tree : TreeType);

begin

if Tree <> nil
then
begin
	PrintNode(Tree^.Info);
	PrintVKD(Tree^.Left);
	PrintVKD(Tree^.Right)
end
end;

//--------------------------------

Procedure PrintKDV(Tree : TreeType);

begin

if Tree <> nil
then
begin
	PrintKDV(Tree^.Left);
	PrintKDV(Tree^.Right);
	PrintNode(Tree^.Info)
end
end;
//--------------------------------
{Med�io trinimas}
Procedure DestroyTree(var Tree : TreeType);
//Pa�alina visus elementus i� med�io, palikdamas med� tu��i�
begin

if Tree <> nil //Jeigu medis yra tu��ias - nedaroma nieko
then
begin
	DestroyTree (Tree^.Left);
	DestroyTree (Tree^.Right);
	Dispose (Tree);
end
end;
//--------------------------------
Procedure FindAndRemoveMax(var Tree : TreePtrType; var MaxPtr : TreePtrType);
//randamas ir pa�alinamas did�iausias elementas
begin

if Tree^.Right = nil
then
	begin
	MaxPtr := Tree; //gra�inam rodykl� i did�iausi� lap�
	Tree := Tree^.Left;
end

else
	FindAndRemoveMax (Tree^.Right, MaxPtr);

end;
//--------------------------------
Procedure DeleteNode(var NodePtr : TreePtrType);

var
TempPtr : TreePtrType;

begin

TempPtr := NodePtr;

if NodePtr^.Right = nil
then NodePtr := NodePtr^.Left

else
if NodePtr^.Left = nil
then
	NodePtr := NodePtr^.Right

else
begin
	FindAndRemoveMax (NodePtr^.Left, TempPtr);
	NodePtr^.Info := TempPtr^.Info
end;

Dispose (TempPtr)

end;
//--------------------------------
{Elemento trinimas}
Procedure DeleteElement(var Tree : TreeType; KeyValue : KeyType);

begin

if KeyValue = Tree^.Info.Key
    then
        DeleteNode (Tree)
    else
    if KeyValue < Tree^.Info.Key
        then DeleteElement (Tree^.Left, KeyValue)
        else DeleteElement (Tree^.Right, KeyValue)

end;
//--------------------------------
Function TRight(now: TreeType): Boolean;
//Pasukimas de�in�n
var
	next: TreeType;
	reiksme: TreeElementType;
begin
	if (now = nil) then
        begin
            TRight := False;
            exit;
    	end;
	if (now^.left = nil) then
    	begin
	       	TRight := False;
	       	exit;
    	end;
//********************************
	next := now^.left;
	now^.left := next^.left;
	next^.left := next^.right;
	next^.right := now^.right;
	now^.right := next;

	reiksme := now^.info;
	now^.info := next^.info;
	next^.info := reiksme;
	TRight := True;
//********************************
end;
//--------------------------------
Function TLeft(now: TreeType): Boolean;
//Pasukimas kair�n
var
	next: TreeType;
	reiksme: TreeElementType;
	
begin
	if (now = nil) then
	   begin
		TLeft := False;
		exit;
	   end;
	if (now^.right = nil) then
	   begin
		TLeft := False;
		exit;
	   end;
 //*******************************
	next := now^.right;
	now^.right := next^.right;
	next^.right := next^.left;
	next^.left := now^.left;
	now^.left := next;

	reiksme := now^.info;
	now^.info := next^.info;
	next^.info := reiksme;
	TLeft := True;
//*******************************
end;
//--------------------------------
{Balansavimas}
Procedure DSWBalance(tree: TreeType);
var
	now: TreeType;
	amount, i, k: integer;
	
begin

    now := tree;
	amount := 0;

    while now <> nil do
	   begin
		  while TRight(now) do;
		  now := now^.right;
		  amount := amount + 1;
	   end;

    i := amount div 2;

    while i > 0 do
        begin
		  now := tree;
		  k := 0;
		  while k < i do
		      begin
                TLeft(now);
                k := k + 1;
                now := now^.right;
              end;
		  i := i div 2;
        end;
end;
//--------------------------------
{�emiausio lygio element� trinimas}
Procedure RemoveLastLevel(var Tree : TreeType; Lygis : integer);
var Kopija : TreePtrType;
begin

if Tree <> nil
then
begin

    if (tree <> nil) and (Height(Tree) = 2)
        then begin
            if Tree^.right <> nil
                then begin
                Kopija := Tree^.right;
                DeleteElement(Tree, Kopija^.info.key);
                end;
             if Tree^.left <> nil
                then begin
                Kopija := Tree^.left;
                DeleteElement(Tree, Kopija^.info.key);
                end;
            end;
	
	if lygis > 2
	then
	begin
	RemoveLastLevel(Tree^.Left, lygis+1);
	RemoveLastLevel(Tree^.Right, lygis+1)
	end;
end
end;
//--------------------------------

end.
