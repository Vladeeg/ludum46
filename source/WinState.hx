package;

import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class WinState extends FlxState {
    
    override public function create() {
        var bg = new FlxSprite(0, 0, AssetPaths.win__png);
        add(bg);
        var text = new FlxText(0, 0, 0, "You won!\nPress SPACE to go to main menu.", 20);
        text.screenCenter();
        text.color = FlxColor.WHITE;
        add(text);

        super.create();
    }

    override public function update(elapsed) {
        if (FlxG.keys.anyJustPressed([FlxKey.SPACE])) {
            FlxG.camera.fade(FlxColor.BLACK, 1, false, function () {FlxG.switchState(new MainState());});
        }
    }

}