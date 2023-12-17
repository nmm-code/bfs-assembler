{$L ueb.o}
function rinstr(s:shortstring;c:char):byte;
external name 'rinstr';

function rinstrpos(p:byte;s:shortstring;c:char):byte;
external name 'rinstrpos';

var
	s:string;
	p:byte;
	c:char;

begin
	s:='Hallo Welt';
	c:='l';
	Writeln('Suche "',c,'" in "',s,'"');	
		
	p:=rinstr(s,c);
	while p>0 do
	begin	
		writeln('Gefunden an Position ',p);
		p:=rinstrpos(p-1,s,c);
	end;
end.

