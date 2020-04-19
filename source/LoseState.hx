package;

import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class LoseState extends FlxState {
    
    override public function create() {
        var bg = new FlxSprite(0, 0, AssetPaths.nowin__png);
        add(bg);
        // var text = new FlxText(0, 0, 0, "Game Over!\nPress SPACE to go to main menu.", 20);
        // text.screenCenter();
        // text.color = FlxColor.WHITE;
        // add(text);

        super.create();
    }

    override public function update(elapsed) {
        if (FlxG.keys.anyJustPressed([FlxKey.F])) {
            FlxG.camera.fade(FlxColor.BLACK, 1, false, function () {FlxG.switchState(new MainState());});
        }
    }

}