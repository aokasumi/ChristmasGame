unit ugamedisplay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, SDL2, UEntity, UEntityDisplay;

type
  TGameDisplay = class
    strict private
      has_error: integer;
      window: PSDL_Window;
      renderer: PSDL_Renderer;
      event: PSDL_Event;
      mainViewport: TSDL_Rect;
      player: TEntity;
      playerDisplay: TEntityDisplay;
      procedure KeepInBounds();
    public
      constructor create();
      procedure show();
      destructor destroy(); override;
  end;

implementation

constructor TGameDisplay.create();
begin
  has_error := SDL_Init(SDL_INIT_VIDEO OR SDL_INIT_TIMER OR SDL_INIT_EVENTS OR SDL_INIT_AUDIO);
  has_error := SDL_CreateWindowAndRenderer(1280, 800, SDL_WINDOW_SHOWN, @window, @renderer);

  // Tue so, als waere das Fenster immer 1280x800 Pixel gross.
  has_error := SDL_RenderSetLogicalSize(renderer, 1280, 800);

  new(event);

  mainViewport.x := 0; mainViewport.y := 0;
  mainViewport.w := 980; mainViewport.h := 800;

  player := TEntity.create('Player', 100, 4);
  playerDisplay := TEntityDisplay.create(renderer, 'assets/Main.Character.prepare_to_walk1.png', 32, 64, player);
  player.setPos(100, 100);
end;

procedure TGameDisplay.show();
var
  running: boolean;
  loopStart, loopEnd, velocityStepEnd: integer;
  elapsedMilli: double;
  dt: double;
  gravity, sideForce: integer;
  d_pressed, a_pressed: boolean;
  wasOutY, wasOutX: boolean;
begin
  if has_error <> 0 then halt;

  gravity := -10000000;
  wasOutY := false; wasOutX := false;
  a_pressed := false; d_pressed := false;

  running := true;
  while running do
  begin
    loopStart := SDL_GetPerformanceCounter();
    velocityStepEnd := SDL_GetPerformanceCounter();
    dt := (velocityStepEnd - loopStart) / SDL_GetPerformanceFrequency() * 1000;
    // Main Viewport clearen
    SDL_RenderSetViewport(renderer, @mainViewport);
    SDL_SetRenderDrawColor(renderer, 0, 170, 85, 255);
    SDL_RenderFillRect(renderer, nil);

    // Event Loop
    while SDL_PollEvent(event) = 1 do
    begin
      // ^ ist uebrigens in Pascal der Pointer Dereference Operator
      if event^.type_ = SDL_KEYDOWN then
      begin
        // Welche Taste wurde gedrueckt; jeweils verschiedene Dinge tun
        case (event^.key.keysym.sym) of
        SDLK_d : d_pressed := true;
        SDLK_a : a_pressed := true;
        SDLK_SPACE:
        begin
          // Zahl etwas hoeher, weil es so intuitiver ist.
          if player.getPosY >= 726 then
          begin
            player.setVelocityY(60000);
          end;
        end;
        //SDLK_s : player.setMovementTowards(DIR_BOTTOM, 1);
        SDLK_ESCAPE : running := false;
      end;
      end
      else if event^.type_ = SDL_KEYUP then
      begin
        case (event^.key.keysym.sym) of
        SDLK_d: d_pressed := false;
        SDLK_a: a_pressed := false;
        //SDLK_w: player.setMovementTowards(DIR_TOP, 0);
        //SDLK_s: player.setMovementTowards(DIR_BOTTOM, 0);
        end;
      end;
    end;

    // Move in Y-Direction for jumping
    player.move(0, -1 * Floor(player.getVelocityY * dt));
    player.setVelocityY(player.getVelocityY + Floor(gravity * dt));

    // Herausfinden, welche Kombinationen von a und d gepresst sind, fuer Bewegung in Richtung x.
    if d_pressed then
    begin
      player.setVelocityX(1);
    end;
    if a_pressed then
    begin
      player.setVelocityX(-1);
    end;
    if (d_pressed and a_pressed) or (not(d_pressed) and not(a_pressed)) then
    begin
      player.setVelocityX(0);
    end;

    KeepInBounds();

    // Bewegung in X-Richtung
    player.move(player.getVelocityX * player.getSpeed, 0);

    // Rendering
    // Sollte spaeter wahrscheinlich durch einen Loop ersetzt werden.
    playerDisplay.draw();
    // Beschriebene Szene rendern
    SDL_RenderPresent(renderer);
    // Vergangene Zeit seit Beginn des Programms wird zu Anfang und Ende des
    // Loops bestimmt. Die Differenz ist die Zeit, die der Loop benötigt hat.
    // Die Framerate wird mit Delay() auf 60fps (16.666s) gecapped.
    loopEnd := SDL_GetPerformanceCounter();
    // GetPerformanceCounter gibt Zeit in unbekannter Einheit zurueck; daher
    // wird auf Sekunde gebracht mit Teilen durch SDL_GetPerformanceFrequency()
    // und dann auf Millisekunden zurueckkonvertiert durch * 1000
    elapsedMilli := (loopEnd - loopStart) / SDL_GetPerformanceFrequency() * 1000.0;
    SDL_Delay(Floor(16.6666 - elapsedMilli));
    writeln('Elapsed: ' + IntToStr(Floor(16.6666 - elapsedMilli)));
  end;
end;

procedure TGameDisplay.KeepInBounds();
begin
  if player.getPosX >= 968 then
  begin
    player.setPos(968, player.getPosY);
    player.setVelocityX(-1 * player.getVelocityX);
  end
  else if player.getPosX <= 0 then
  begin
    player.setPos(0, player.getPosY);
    player.setVelocityX(-1 * player.getVelocityX);
  end;
  if player.getPosY <= 0 then
  begin
    player.setPos(player.getPosX, 0);
    player.setVelocityY(-1 * player.getVelocityY);
  end
  else if player.getPosY >= 736 then
  begin
    player.setPos(player.getPosX, 736);
    player.setVelocityY(0);
  end;
end;

destructor TGameDisplay.destroy();
begin
  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();
  inherited;
end;

end.

