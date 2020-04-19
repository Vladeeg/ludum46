package;

class OsuBeatmapInfo {
    public var timePoints: Array<Int> = new Array<Int>();
    public var timePointsBpm: Array<Float> = new Array<Float>();
    public var hitObjectTimes: Array<Int> = new Array<Int>();
    public var filename: String;

    public function new(
        timePoints: Array<Int>,
        timePointsBpm: Array<Float>,
        hitObjectTimes: Array<Int>,
        filename: String
    ) {
        this.timePoints = timePoints;
        this.timePointsBpm = timePointsBpm;
        this.hitObjectTimes = hitObjectTimes;
        this.filename = filename;
    }
}