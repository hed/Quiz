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
import javafx.scene.Node;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;
import quiz.AllQuestions;

import javafx.animation.transition.FadeTransition;
import javafx.scene.effect.Lighting;

import javafx.scene.shape.Rectangle;

import javafx.scene.text.TextOrigin;


import javafx.scene.paint.Stop;

import javafx.scene.paint.LinearGradient;

/**
 * @author hed
 */

var backgroundImage = FXDLoader.loadContent("{__DIR__}res/stage.fxz");
var mainNode:Node =  Duplicator.duplicate(backgroundImage.getNode("hei"));
var blueWheel = mainNode.lookup("hei2");

var height:Float = 600;
var width:Float = 1000;

def questionTime = 30000;

FadeTransition {
        node: blueWheel  duration: 10s fromValue:0.2 toValue: 0.9 autoReverse:true repeatCount: Timeline.INDEFINITE
}.play();



var currentQuestion: Question = AllQuestions.questions[0];

var questionIndex = 0 ;


Timeline {
        repeatCount: sizeof(AllQuestions.questions)
        keyFrames : [
                KeyFrame {
                        time: Duration.valueOf(questionTime)
                        canSkip : false
                        action: function() {
                            questionIndex++;
                            currentQuestion = AllQuestions.questions[questionIndex];
                            duration = width;
                            durationTimeline.playFromStart();
                        }
                }
        ]
}.play();

var durationTimeline = Timeline {
        repeatCount: questionTime
        keyFrames : [
                KeyFrame {
                        time : 5ms
                        canSkip : false
                        action: function() {
                            duration = duration - step;
                        }
                }
        ]
}

durationTimeline.play();


var light= Lighting {
        diffuseConstant: 1.0
        specularConstant: 1.0
        specularExponent: 20
        surfaceScale: 1.5
}

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


var questionBackground = Rectangle {
        x: bind text.x - 5
        y: bind text.y - 5
        height: bind text.x + 200
        width: bind text.wrappingWidth
        arcHeight: 50 arcWidth: 50
        fill: Color.WHITESMOKE
        opacity: 0.7
    }

var duration = width;
def step = width/questionTime *5 ;

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


var stage = Stage {
    
  //  fullScreen: true
  height: height
  width: width

  scene: Scene {

        content: [
            mainNode,            
            questionBackground,
            text,
            timeline
        ]
    }
}