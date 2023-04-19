program TryDate;

uses
  sysutils;

var
  myDate : TDateTime;

begin
  myDate := StrToDate('15/03/75');
  writeln('15/03/75   = '+DateTimeToStr(myDate));
  myDate := StrToDate('31/01/2075');
  writeln('31/01/2075 = '+DateTimeToStr(myDate));
end.
