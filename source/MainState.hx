package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;


class MainState extends FlxState {
    
    override public function create() {
        FlxG.mouse.visible = false;
        var text = new FlxText(0, 0, 0, "Press SPACE to play.\nOn the game screen, press SPACE again to start running.", 20);
        text.screenCenter();
        text.color = FlxColor.WHITE;
        add(text);

        super.create();
    }

    override public function update(elapsed) {
        if (FlxG.keys.anyJustPressed([FlxKey.SPACE])) {
            FlxG.camera.fade(FlxColor.BLACK, 1, false, function () {FlxG.switchState(new PlayState());});
        }
    }

}