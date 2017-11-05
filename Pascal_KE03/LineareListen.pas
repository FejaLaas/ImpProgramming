program LineareListe (input, output);

type
tRefListe = ^tListe;
  tNatZahl = 0..maxint;
tListe = record
			info : integer;
			next : tRefListe
	     end;

var
RefAnfang : tRefListe;
SuchZahl : integer;
ElementGefunden : tRefListe;
  
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

 procedure ListeDurchlaufen (inRefAnfang : tRefListe);
 { gibt die Werte der Listenelemente aus }
  var
  Zeiger : tRefListe;

 begin
   Zeiger := inRefAnfang;
   while Zeiger <> nil do
   begin
     writeln (Zeiger^.info);
     Zeiger := Zeiger^.next
   end
 end; { ListeDurchlaufen }
 
 function ListenElemSuchen1 (
               inRefAnfang : tRefListe;
               inZahl : integer): tRefListe;
 { bestimmt das erste Element in einer Liste, bei dem
   die info-Komponente gleich inZahl ist }
  var
  Zeiger : tRefListe;

 begin
  Zeiger := inRefAnfang;
  if Zeiger <> nil then
    { Liste nicht leer }
  begin
    while (Zeiger <> nil) and
          (Zeiger^.info <> inZahl) do
     Zeiger := Zeiger^.next;
    if Zeiger^.info <> inZahl then
      { dann muss Zeiger^.next = nil gewesen sein,
        d.h. Zeiger zeigt auf das letzte Element.
        Da dessen info-Komponente <> inZahl ist,
        kommt inZahl nicht in der Liste vor. }
      Zeiger := nil
  end;
  { Liste nicht leer } 
  ListenElemSuchen1 := Zeiger
 end; { ListenElemSuchen1 }
 
 procedure SortiertEinfuegen (
                    inZahl : integer;
                    var ioRefAnfang : tRefListe);
 { fuegt ein neues Element fuer inZahl in eine
   sortierte Liste ein }

   var
   Zeiger,
   RefNeu : tRefListe;
   gefunden : boolean;

 begin
  { neues Element erzeugen }
   new (RefNeu);
   RefNeu^.info := inZahl;
   if ioRefAnfang = nil then
   { Sonderfall: Liste ist leer }
   begin
     RefNeu^.next := ioRefAnfang; {die Liste hat ein Element (die eingegebene Zahl), deshalb next = nil}
     ioRefAnfang := RefNeu {Anfang wird auf die neu erzeugte Liste gesetzt}
   end
   else
     if ioRefAnfang^.info > inZahl then {wenn die erste Zahl in der vorhandenen Lise > der eingegeben Zahl ist}
     { Sonderfall: Einfuegen am Listenanfang }
     begin
     RefNeu^.next := ioRefAnfang; {next zeigt deshalb auf das bis jetzt erste Element in der Liste}
     ioRefAnfang := RefNeu {der neue Anfang ist der neu eingeschobene Element in der Liste}
     end
     else
     { Einfuegeposition suchen }
     begin
       gefunden := false;
       Zeiger := ioRefAnfang; {der Zeiger steht am Anfang der Liste}
       while (Zeiger^.next <> nil) and {so lange die Liste nicht leer ist}
             (not gefunden) do { und gefunden = true ist }
         if Zeiger^.next^.info > inZahl then {da, die erste Zahl in der Liste bereits oben behandelt wurde, wird die nächste Zahl verglichen}
           gefunden := true { wenn die nächste Zahl größer ist, dann ist gefunden = true }
         else
           Zeiger := Zeiger^.next; {sonst wird der Zeiger auf die nächste Stelle geschoben}
       if gefunden then {wenn die Einfügestelle gefunden wurde}
       { Normalfall: Einfuegen in die Liste }
       begin
         RefNeu^.next := Zeiger^.next;
         Zeiger^.next := RefNeu
       end
       else
      { Sonderfall: Anhaengen an das Listenende }
       begin
         Zeiger^.next := RefNeu;
         RefNeu^.next := nil
       end
     end
 end; { SortiertEinfuegen }

procedure Eingabesortieren(var ioRefAnfang : tRefListe);
var
  Unsortiert: tRefListe;
  Sortiert: tRefListe;
begin
  Unsortiert := ioRefAnfang;
  Sortiert := nil;
  while Unsortiert <> nil do
  begin
     SortiertEinfuegen(Unsortiert^.info, Sortiert);
     Unsortiert := Unsortiert^.next;
  end;
  
  ioRefAnfang := Sortiert;
end;
 
begin
 ListeEinlesen (RefAnfang);
 Eingabesortieren(RefAnfang);
 writeln('Ergebnis: ');
 ListeDurchlaufen (RefAnfang);
end.
