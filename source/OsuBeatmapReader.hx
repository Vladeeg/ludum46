package;

import openfl.Assets;

enum State {
    GENERIC;
    TIMING_POINTS;
    HIT_OBJECTS;
}

class OsuBeatmapReader {

    public static function readFromFile(path: String) {
        var timePoints: Array<Int> = new Array<Int>();
        var timePointsBpm: Array<Float> = new Array<Float>();
        var hitObjectTimes: Array<Int> = new Array<Int>();
        var filename: String = "null";

        if (Assets.exists(path)) {
            var state: State = State.GENERIC;
            var data = Assets.getText(path);

            var regex: EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
            var lines: Array<String> = regex.split(data);

            function checkHeader(l: String) {
                if (l.substr(0, "audiofilename".length).toLowerCase() == "audiofilename") {
                    filename = l.split(": ")[1];
                } else if (l.toLowerCase() == "[TimingPoints]".toLowerCase()) {
                    state = State.TIMING_POINTS;
                } else if (l.toLowerCase() == "[HitObjects]".toLowerCase()) {
                    state = State.HIT_OBJECTS;
                }
            }

            for (l in lines) {
                if (state == State.TIMING_POINTS) {
                    var timePointParts = l.split(",");
                    timePoints.push(Std.parseInt(timePointParts[0]));
                    var inherited = timePointParts[6] == "0";
                    timePointsBpm.push(inherited ?
                        timePointsBpm[timePointsBpm.length - 1] :
                        Std.parseFloat(timePointParts[1]));
                } else if (state == State.HIT_OBJECTS) {
                    var hitObjectParts = l.split(",");
                    hitObjectTimes.push(Std.parseInt(hitObjectParts[2]));
                }
                checkHeader(l);
            }
        }
        

        return new OsuBeatmapInfo(
            timePoints,
            timePointsBpm,
            hitObjectTimes,
            filename
        );
    }

}