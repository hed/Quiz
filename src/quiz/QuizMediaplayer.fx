/*
 * QuizMediaplayer.fx
 *
 * Created on Oct 4, 2009, 1:22:30 PM
 */

package quiz;

import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;

/**
 * @author tlm
 */

public class QuizMediaplayer {
    public var source : String;
    public var delay : Duration = 1s;

    public def playSound = Timeline {
        repeatCount: 1
        interpolate: false
        keyFrames : [
            KeyFrame {
                time : delay
                canSkip : true
                action: runPlayer
            }
        ]
    }

    function runPlayer() : Void {
        if (source.length() != 0) {
            println("should start player now");
            player.play();
        }
    }

    var player = MediaPlayer {
        media : Media {
            source : bind source
        }
    }
}
