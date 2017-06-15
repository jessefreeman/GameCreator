# Controller Input

There are two controllers for player one and two. The first controller ID is 0 and the second is 1. You can get the state of a given controller by calling the `Button()` method:

`bool Button( button, state, controllerID)`

The `Button()` method returns a boolean and needs to supply a Button ID, an input state, and the controller id. By default, the input state is set to `Buttons.Down`, and the controller is the first player. There is an enum for each of the controller's buttons:

<table>
  <tr>
    <td>Enum</td>
    <td>Int</td>
  </tr>
  <tr>
    <td>Buttons.Up</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Buttons.Down</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Buttons.Left</td>
    <td>2</td>
  </tr>
  <tr>
    <td>Buttons.Right</td>
    <td>3</td>
  </tr>
  <tr>
    <td>Buttons.A</td>
    <td>4</td>
  </tr>
  <tr>
    <td>Buttons.B</td>
    <td>5</td>
  </tr>
  <tr>
    <td>Buttons.Select</td>
    <td>6</td>
  </tr>
  <tr>
    <td>Buttons.Start</td>
    <td>7</td>
  </tr>
</table>


For example, if you just want to find the state of the A button on player one's controller you can use the enum, `Button.A`, or the value, `0`, when calling the `Button()` method:

`value = Button(Buttons.A)`

This returns true if the button is down during the current frame. Sometimes you want to know if the button was released. You can supply a different input state when calling the `Button()` method. Here are the two options in the `InputState `enum:

<table>
  <tr>
    <td>Enum</td>
    <td>Int</td>
  </tr>
  <tr>
    <td>InputState.Down</td>
    <td>0</td>
  </tr>
  <tr>
    <td>InputState.Released</td>
    <td>1</td>
  </tr>
</table>


When calling the `Button()` method and supplying `InputState`.Released, it returns true if the button was down in the previous frame but is not down in the current frame. Just like with the Buttons enum, you can use the `InputState `enum or supply an int for either state.

Finally, as mentioned earlier, by default calling the `Button()` method returns the input state for the first player. If you want to find out the second player's input, just pass in `1` for the last argument like so:

`value = Button( Buttons.A, InputeState.Released, 1)`

It is important to note that both controllers are always "connected." You can get their value at any time in your game's code, and you do not need to worry about them being connected or disconnected from the system. If for some reason there is no controller, it will return false.

