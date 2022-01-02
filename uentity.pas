unit uentity;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  { TEntity }
  TEntity = class
    strict private
      name: string;
      maxHP: integer;
      hp: integer;
      posX: integer;
      posY: integer;
      speed: integer;
      velocity: array [0..1] of integer;
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
      function getVelocityX(): integer;
      procedure setVelocityX(value: integer);
      function getVelocityY(): integer;
      procedure setVelocityY(value: integer);
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

function TEntity.getVelocityX(): integer;
begin
  Result := velocity[0];
end;

procedure TEntity.setVelocityX(value: integer);
begin
  velocity[0] := value;
end;

function TEntity.getVelocityY(): integer;
begin
  Result := velocity[1];
end;

procedure TEntity.setVelocityY(value: integer);
begin
  velocity[1] := value;
end;

end.

