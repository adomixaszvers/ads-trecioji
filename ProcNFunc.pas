unit ProcNFunc;

interface

Uses Tipai;

Type

TreeElementType = record //Duomenø medyje tipas
    key : KeyType;
    end;

TreePtrType = ^TreeNodeType; //Medþio rodyklës tipas

TreeNodeType = record
    info : TreeElementType;//duomenys
    Left : TreePtrType;//rodyklë á kairá vaikà
    Right : TreePtrType;//rodyklë á deðiná vaikà
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

//-----------Procedûros ir funkcijos----------
//--------------------------------
{Medþio kûrimas}
Procedure CreateTree(var Tree : TreeType);
begin
Tree := nil;  //Sukuriamas tuðèias medis
end;
//--------------------------------
Procedure FindNode( Tree : TreeType; KeyValue : KeyType; var NodePtr : TreePtrType; var ParentPtr : TreePtrType);
// Randamas virðûnë pagal duotà KeyValue;
var

Found : Boolean; //Ar rasta virðûnë su KeyValue

begin

//Pasiruoðiama paieðkai
NodePtr := Tree;
ParentPtr := nil;
Found := False;

//Ieðkoma kol randama virðûnë arba kol nebera kur ieðkoti
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
//Elemento áterpimas [1]
Procedure InsertElement (var Tree : TreeType; Element : TreeElementType);
//Áterpiamas elementas á medá. Atmetant elementus kurie pasikartoja
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

//Ieðkoma vietos kurioje iteroti
FindNode (Tree, Element.Key, NodePtr, ParentPtr);

//Jei tai pirma virðûnë sukuriama nauja virðûnë
if ParentPtr = nil
	then Tree := NewNode //Virðûnë
	else //Áterpiama á jau egzistuojantá medá
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
{Medþio aukðèio radimas}
Function Height(tree: TreeType): integer;
begin
	if tree = nil then Height := 0
	else Height := Max(Height(tree^.left), Height(tree^.right)) + 1;
end;
//--------------------------------
{Ieðkomas virðûniø skaièius}
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
//Atspausdinamai elementai nuo didþiausio iki maþiausio
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
{Medþio trinimas}
Procedure DestroyTree(var Tree : TreeType);
//Paðalina visus elementus ið medþio, palikdamas medá tuðèià
begin

if Tree <> nil //Jeigu medis yra tuðèias - nedaroma nieko
then
begin
	DestroyTree (Tree^.Left);
	DestroyTree (Tree^.Right);
	Dispose (Tree);
end
end;
//--------------------------------
Procedure FindAndRemoveMax(var Tree : TreePtrType; var MaxPtr : TreePtrType);
//randamas ir paðalinamas didþiausias elementas
begin

if Tree^.Right = nil
then
	begin
	MaxPtr := Tree; //graþinam rodyklæ i didþiausià lapà
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
//Pasukimas deðinën
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
//Pasukimas kairën
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
{Þemiausio lygio elementø trinimas}
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
