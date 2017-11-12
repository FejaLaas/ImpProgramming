program TesteSortiereListe(input, output);

  type
  tNatZahl = 0..maxint;
  tRefListe = ^tListe;
  tListe = record
             info : tNatZahl;
             next : tRefListe;
           end;

  var
  RefListe : tRefListe;

  procedure RemoveFromFront (var ioListe, iofirstElement : tRefListe);
  { Entfernt das erste Element und korrigiert den Listenanfang.
    Das entfernte Element wird in firstElement zurückgeliefrt }
    
  begin
   iofirstElement := ioListe;
   ioListe := ioListe^.next;
   iofirstElement^.next := nil;
  end;

  procedure InsertSorted (var ioListe : tRefListe; item :tRefListe);
  { Element 'item' sortiert in Liste einfügen }
  
  var 
  iterator : tRefListe; { Iteration über die Liste }
  last : tRefListe; { "Schlepp" - Zeiger, zeigt auf das Element aus der letzen Iteration }
  
  begin
   iterator := ioListe;
   last := nil;
   while ( iterator <> nil) and ( item^.info > iterator^.info ) do
    begin
     last := iterator;
     iterator := iterator^.next;
    end;
    if iterator = ioListe    then
     begin
      item^.next := ioListe;
      ioListe := item;
     end
    else
    begin
     item^.next := iterator;
     last^.next := item;
    end;
   end;
     
  procedure SortiereListe (var ioListe: tRefListe);
  { sortiert eine lineare Liste aufsteigend }
  
  var
  sorted,
  unsorted,
  element : tRefListe;
  
  begin
   if (ioListe <> nil) and (ioListe^.next <> nil) then
    begin
     sorted := ioListe;
     unsorted := ioListe^.next;
     element := nil;
     sorted^.next := nil;
     while unsorted <> nil do
      begin
       RemoveFromFront (unsorted, element);
       InsertSorted (sorted, element);
      end;
      ioListe := sorted;
    end;
  end;
  
  
  procedure Anhaengen(var ioListe : tRefListe;
                        inZahl : tNatZahl);
{ Haengt inZahl an ioListe an }
  var Zeiger : tRefListe;
  begin
  Zeiger := ioListe;
  if Zeiger = nil then
  begin
    new(ioListe);
    ioListe^.info := inZahl;
    ioListe^.next := nil;
  end
  else
  begin
    while Zeiger^.next <> nil do
      Zeiger := Zeiger^.next;
    { Jetzt zeigt Zeiger auf das letzte Element }
    new(Zeiger^.next);
    Zeiger := Zeiger^.next;
    Zeiger^.info := inZahl;
    Zeiger^.next := nil;
  end;
end;

procedure ListeEinlesen(var outListe:tRefListe);
{ liest eine durch Leerzeile abgeschlossene Folge von Integer-
  Zahlen ein und speichert diese in der linearen Liste RefListe. }
  var
  Liste : tRefListe;
  Zeile : string;
  Zahl, Code : integer;
begin
  writeln('Bitte geben Sie die zu sortierenden Zahlen ein.');
  writeln('Beenden Sie Ihre Eingabe mit einer Leerzeile.');
  Liste := nil;
  readln(Zeile);
  val(Zeile, Zahl, Code); { val konvertiert String nach Integer }
 while Code=0 do
  begin
    Anhaengen(Liste, Zahl);
    readln(Zeile);
    val(Zeile, Zahl, Code);
  end; { while }
  outListe := Liste;
end; { ListeEinlesen }

procedure GibListeAus(inListe : tRefListe);
{ Gibt die Elemente von inListe aus }
  var Zeiger : tRefListe;
begin
  Zeiger := inListe;
  while Zeiger <> nil do
  begin
    writeln(Zeiger^.info);
    Zeiger := Zeiger^.next;
  end; { while }
end; { GibListeAus }

begin
  ListeEinlesen(RefListe);
  SortiereListe(RefListe);
  GibListeAus(RefListe)
end.
