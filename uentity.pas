unit uentity;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  direction = (DIR_TOP=0, DIR_RIGHT, DIR_BOTTOM, DIR_LEFT);

  { TEntity }
  TEntity = class
    strict private
      name: string;
      maxHP: integer;
      hp: integer;
      posX: integer;
      posY: integer;
      speed: integer;
      movement: array [0..3] of integer;  // top, right, left, bottom; Werte sollten immer entweder 0 oder 1 sein
    public
      constructor create(nm: string; maxHealth: integer; spd: integer);
      procedure changeHP(value: integer);
      procedure move(x: integer; y: integer);
      procedure setPos(x: integer; y: integer);
      function getHP(): integer;
      function getPosX(): integer;
      function getPosY(): integer;
      function getSpeed(): integer;
      procedure setSpeed(value: integer);
      function getMovementTowards(dir: direction): integer;
      procedure setMovementTowards(dir: direction; value: integer);
  end;

implementation

constructor TEntity.create(nm: string; maxHealth: integer; spd: integer);
begin
  name := nm;
  maxHP := maxHealth;
  hp := maxHealth;
  speed := spd;
end;

// Diese Funktion fuegt Lebenspunkte hinzu oder zieht welche ab.
procedure TEntity.changeHP(value: integer);
begin
  hp := hp + value;
  if hp < 0 then
  begin
    hp := 0;
    // some sort of dying procedure
  end;
end;

// Entity in eine bestimmte Richtung bewegen (relativ zur momentanen Position)
procedure TEntity.move(x: integer; y: integer);
begin
  posX := posX + x;
  posY := posY + y;
end;

// Absolute Position der Entity setzen
procedure TEntity.setPos(x: integer; y: integer);
begin
  posX := x;
  posY := y;
end;

function TEntity.getHP(): integer;
begin
  Result := hp;
end;

function TEntity.getPosX(): integer;
begin
  Result := posX;
end;

function TEntity.getPosY(): integer;
begin
  Result := posY;
end;

function TEntity.getSpeed(): integer;
begin
  Result := speed;
end;

procedure TEntity.setSpeed(value: integer);
begin
  speed := value;
end;

function TEntity.getMovementTowards(dir: direction): integer;
begin
  Result := movement[integer(dir)];
end;

procedure TEntity.setMovementTowards(dir: direction; value: integer);
begin
  movement[integer(dir)] := value;
end;

end.

