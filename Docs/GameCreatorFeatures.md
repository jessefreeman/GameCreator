# Game Creator Features

Pixel Vision 8’s Game Creator is built on top of the open source [Pixel Vision SDK](http://pixelvisionsdk.com), which is a completely modular C# engine. The underpinning of the engine is exposed through an easy to use Lua API allowing you to focus on making games without needing to modify any of the core C# code directly. The Game Creator offers the following features over the core SDK:

* **The Workspace** - A standardized location and workflow for loading, saving and editing games.

* **Project Types** - Support for several project file formats such as .pv8 (games), .pvs (system templates), pvt (tools) and more.

* **Importers** - Specialized importers for sprites, tilemaps, lua code and project metadata.

* **Booting and Loading** - Allows a standardized system for loading games into memory and editing them in the workspace.

* **Tools **- Special API Bridges are exposed for loading, using and building custom tools to edit games in memory.

* **Archiving **- Games can be zipped up into archives to make them easier to run and share with others.

