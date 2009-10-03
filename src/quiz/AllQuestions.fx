/*
 * AllQuestions.fx
 *
 * Created on Oct 3, 2009, 10:27:38 AM
 */

package quiz;

import javafx.scene.image.Image;

/**
 * @author hed
 */



public def questions : Question[] = [
    Question{question: "Hva heter sjefen"},
    Question{question: "Hva heter serien?" sound: "{__DIR__}res/heman.wav"},
    Question{question: "Hva heter dama som omtales?" sound: "{__DIR__}res/bill.wav"},
    Question{question: "Hvem snakker her" sound: "{__DIR__}res/ihaveadream.wav"},
    Question{question: "Hvem er dette?" picture: Image { url: "{__DIR__}res/anders_nilsson.png" backgroundLoading: true}},
    Question{question: "Hvilken film?" picture: Image { url: "{__DIR__}res/wargames.png" backgroundLoading: true}},
    Question{question: "hei hei hei heter sjefen"},
    Question{question: "2134 sdflksd sdlkjsdf kljsdf"},

    ]


