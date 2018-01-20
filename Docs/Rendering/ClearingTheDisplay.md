# Clearing The Display

When you create a new project without any code in it, the display simply shows the background color. This default color is 0 which is the first color in the Color Chip. If the color is out of range, magenta (#FF00FF) will be shown in its place.

![image alt text](images/ClearingTheDisplay_image_0.png)

You can always override the default background by calling `BackgroundColor(colorID)` in your code or by changing it in the Chip Editor.

![image alt text](images/ClearingTheDisplay_image_1.png)

Now if you refresh the game, you can see the new color. In order to see the background color, you’ll need to tell the renderer to clear the screen. The easiest way to do this is by calling `Clear()`at the beginning of your game’s `Draw()` method.

![image alt text](images/ClearingTheDisplay_image_2.png)

Not only does this method display the current background color, it also removed the previous frame's pixel data. If you were to render a sprite to the display and move it without calling clear, it would ghost.

![image alt text](images/ClearingTheDisplay_image_3.png)

You can update the background color at any time, and the next time the engine calls Clear(),  the color reflects the change. Try adding this to your `Update()` method:

`BackgroundColor(math.random(0, 3))`

Now when you refresh your game, the background will randomly change between the first 3 colors. Understanding how to correctly clear the display is critical to creating clean render logic for your game.

