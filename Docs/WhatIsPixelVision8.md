# What is Pixel Vision 8

Pixel Vision 8's core philosophy is to teach retro game development with streamlined workflows. It enables designing games around limited resolutions, colors, sprites, sound and memory. It is ideal for game jams, prototyping ideas or having fun. 

PV8 is also a platform that standardizes 8-bit fantasy console limitations built on top of the open source [Pixel Vision SDK](http://pixelvisionsdk.com). Developers can customize these restrictions to match actual legacy hardware or create something new. The challenge of working within these confines forces creativity and limits the scope. Pixel Vision 8 creations are expressions of ingenuity that rise above their limitations. 

The Game Creator is built on top the Pixel Vision SDK. The underpinnings of the Pixel Vision 8 engine are exposed through an easy to use Lua API allowing you to focus on making games without needing to modify any of the core C# code directly. The Game Creator offers the following features over the core SDK:

* **The Workspace** - A standardized location and workflow for loading, saving and editing games.

* **Project Types** - Support for several project file formats such as .pv8 (games), .pvs (system templates), pvt (tools) and more.

* **Importers** - Specialized importers for sprites, tilemaps, lua code and project metadata.

* **Booting and Loading** - Allows a standardized system for loading games into memory and editing them in the workspace.

* **Tools **- Special API Bridges are exposed for loading, using and building custom tools to edit games in memory.

* **Archiving **- Games can be zipped up into archives to make them easier to run and share with others.

