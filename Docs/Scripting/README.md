# Game Scripts

Pixel Vision 8 games can be written in C# or Lua. The Game Creator focus on standardizing game creation via Lua scripts. These scripts follow the same lifecycle as a Pixel Vision 8 game written in C#. You have hooks for `Init()`, `Update()` and `Draw()` as well as a set of APIs to draw sprites, fonts, tilemaps and more. Each script is self-contained and included inside of the Game Creator's project file.

