/*
 * Main.fx
 *
 * Created on Sep 26, 2009, 7:21:27 PM
 */

package quiz;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.scene.paint.Color;
import javafx.fxd.FXDLoader;
import javafx.fxd.Duplicator;
import javafx.scene.text.Text;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import quiz.AllQuestions;
import javafx.animation.transition.FadeTransition;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.TextOrigin;
import javafx.scene.paint.Stop;
import javafx.scene.paint.LinearGradient;
import javafx.scene.media.MediaPlayer;
import javafx.scene.media.Media;
import javafx.scene.image.ImageView;
import javafx.scene.image.Image;
import javafx.scene.Group;
import javafx.scene.transform.Scale;
import javafx.scene.input.MouseEvent;
import javafx.animation.transition.RotateTransition;

import java.lang.System;

/**
 * @author hed
 */

// The duration of one question in milliseconds
def questionTime = 30000;

// The heigh and width of the screen
var height = javafx.stage.Screen.primary.bounds.height;
var width = javafx.stage.Screen.primary.bounds.width;

// The background sound
var backgoundSoundPlayer = MediaPlayer {
    media: Media {
        source: "{__DIR__}res/proclamation.mp3"
    }
}

backgoundSoundPlayer.repeatCount = MediaPlayer.REPEAT_FOREVER;
backgoundSoundPlayer.volume = 0.5;

// The background image
var blueLight = FXDLoader.loadContent("{__DIR__}res/BlueLight.fxz");
var blueWheel = Duplicator.duplicate(blueLight.getNode("blue"));
FadeTransition {
    node: blueWheel duration: 8s fromValue:0.2 toValue: 0.8 autoReverse:true repeatCount: Timeline.INDEFINITE
}.play();
var yellowLight = FXDLoader.loadContent("{__DIR__}res/YellowLight.fxz");
var yellowWheel = Duplicator.duplicate(yellowLight.getNode("yellow"));
FadeTransition {
    node: yellowWheel  duration: 10s fromValue:0.8 toValue: 0.2 autoReverse:true repeatCount: Timeline.INDEFINITE time: 5ms
}.play();

var redLight = FXDLoader.loadContent("{__DIR__}res/RedLight.fxz");
var redWheel = Duplicator.duplicate(redLight.getNode("red"));


var redWheelGroup = Group {
    content: [redWheel]
}

FadeTransition {
    node: redWheelGroup  duration: 12s fromValue:0.2 toValue: 0.8 autoReverse:true repeatCount: Timeline.INDEFINITE
}.play();

RotateTransition {
    node: redWheelGroup byAngle: 360 duration: 120s repeatCount: Timeline.INDEFINITE
}.play();

var backgroundImage = ImageView {
    image: Image
        { url: "{__DIR__}res/stageBackground.png" }
    x: 0
    y: 0
}
var backgroundFrontImage = ImageView {
    image: Image
        { url: "{__DIR__}res/stageFront.png" }
    x: 0
    y: 0
}
var scaledBackground = Group {
    content: [
        backgroundImage,
        redWheelGroup,
        blueWheel,
        yellowWheel,
        backgroundFrontImage
    ]
    transforms: [
        Scale {
            pivotX:0
            pivotY:0
            x:width / backgroundImage.boundsInLocal.width
            y:height / backgroundImage.boundsInLocal.height
        }
    ]
    onMouseClicked: function( e: MouseEvent ):Void {
        startQuiz();
    }
}

// The question currently displayed
var questionIndex = 0 ;
var currentQuestion: Question; 

// The timeline that gets the next question and displays it
var questionTimeline = Timeline {
    repeatCount: sizeof(AllQuestions.questions)
    var myCounter = 0;
    var isSoundPlayed = false;
    keyFrames : [
        KeyFrame {
            time: Duration.valueOf(questionTime)
            canSkip : false
            action: function() {
                questionIndex++;
                currentQuestion = AllQuestions.questions[questionIndex];
                duration = width;
                durationTimeline.playFromStart();

                isSoundPlayed = false;
                if (currentQuestion.picture != null) {
                    currentImage = currentQuestion.picture;
                    image.x = (width / 2) - (currentImage.width / 2);
                } else{
                    currentImage = null;
                }
            }
        }
        // extra keyframe for playing sounds with a delay
        KeyFrame {
            time: Duration.valueOf(questionTime) / 10
            canSkip : false
            action: function() {
                if (currentQuestion.sound.length() != 0) {                    
                    if (isSoundPlayed == false) {
                        if (myCounter mod 1 == 0) {
                            playSound();
                            isSoundPlayed = true;
                        }
                    }
                }
            }

        }
    ]
}

// Plays the sound of the current question if any
function playSound() {
    backgoundSoundPlayer.volume=0;
    var player = MediaPlayer {
        media: Media {
            source: currentQuestion.sound
        }

        onEndOfMedia: function () {
            backgoundSoundPlayer.volume = 0.5;
        }
    }.play();
}

// Starts the quiz
function startQuiz() {
    questionTimeline.play();
    durationTimeline.play();
    backgoundSoundPlayer.play();
    currentQuestion = AllQuestions.questions[questionIndex];
}

// The timeline that animates the time left on the current question
var durationTimeline = Timeline {
    repeatCount: questionTime
    keyFrames : [
        KeyFrame {
            time : 5ms
            action: function() {
                duration = duration - step;
            }
        }
    ]
}

// The question text
var text = Text {
    font : Font {
        size : 56
    }
    fill: Color.BLACK
    x: 80
    y: 100
    textOrigin: TextOrigin.TOP
    wrappingWidth: width - 160
    content: bind currentQuestion.question
}

// The background for the question text
var questionBackground = Rectangle {
    x: bind text.x - 5
    y: bind text.y - 5
    height: bind text.x + 200
    width: bind text.wrappingWidth
    arcHeight: 50 arcWidth: 50
    fill: Color.WHITESMOKE
    opacity: 0.7
}

// The image if any for the question
var currentImage: Image;
var image = ImageView {
    image: bind currentImage;
    y: questionBackground.y + questionBackground.height + 3;
}

// Helpers to calculate the duration timeline
var duration = width;
def step = width/questionTime *5 ;

// The timeline that shows how much time is left for the current question
var timeline = Rectangle {
    x: 0
    y: 0
    height:10
    width: bind duration
    fill: LinearGradient {
       startX: 0
       startY: 0
       endX: 0
       endY: 1
       proportional: true
       stops: [
           Stop {
               color: Color.DARKRED
               offset: 0.6
           },
           Stop {
               color: Color.ORANGE
               offset: 0.9
           },
           Stop {
               color: Color.DARKRED
               offset: 1.0
           },
       ]
   }
}

// The stage an scene with the content
var stage:Stage = Stage {
    fullScreen: true

    scene: Scene {
        content: [
            scaledBackground,
            questionBackground,
            image,
            text,
            timeline
        ]
    }
}

