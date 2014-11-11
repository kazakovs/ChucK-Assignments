<<< "assignment2_something_straight" >>>;


// sound chain
SinOsc notesOsc => Pan2 p => dac;
TriOsc bassOsc => Pan2 p1 => dac;
SqrOsc blipOsc => dac;
Noise snareNoise => dac;

0 => float blipOscGain;
0 => float snareNoiseGain;
0.25 => float notesOscGain;
0.35 => float bassOscGain;

snareNoiseGain => snareNoise.gain;
blipOscGain => blipOsc.gain;
bassOscGain => bassOsc.gain;
.0 => notesOsc.gain;

// frequensy for bliper
3000 => blipOsc.freq;

// quater duration
.25::second => dur quater;

// array of "melody" notes
[50, 52, 53, 55, 57, 59, 60, 62] @=> int notes[];

// array of bass
[50, 43, 45, 47, 45, 40, 43, 45] @=> int bass[];

// counter for "walking through bass"
0 => int i;

// begin marker
now => time begin;

// while loop for running exactly 30 seconds
while( now-begin <= 30::second ){
    
    // values for find itself in time
    now-begin => dur timing;
    timing/quater => float quaters;
    
    // starting play notes from 4'th second
    if (timing/second >= 4){
        notesOscGain => notesOsc.gain;
    }
    
    // getting random note from array
    notes[Math.random2(0,notes.cap()-1)] => int note;
    
    // converting midi note into frequency, 
    // also multiplying it randomly by 1 or 2 to use current or next octave
    Std.mtof(note)*Math.random2(1, 2) => notesOsc.freq;
    
    // this could be replaced by bass[++i%8], but we are not alowed to use %
    // bass just "walking through" again and again 
    if(++i==8){
        0=>i;
    }
    Std.mtof(bass[i]) => bassOsc.freq;
    
    // catch the moment for playing blip
    if(Math.remainder(quaters,2.0) == 0){
        1 => blipOscGain;
    } else {
        0 => blipOscGain;
    }
    
    // catch moment for playing snare 
    if((Math.remainder(quaters,4.0) == 0)  ||
       (Math.remainder(quaters,16.0) == 11)||
       (Math.remainder(quaters,16.0) == 12)||
       (Math.remainder(quaters,16.0) == 13)){
        .15 => snareNoiseGain;
    } else {
        0 => snareNoiseGain;
    }
    
    // 
    for(1=>int j; j<=1000;j++){
        
        // playing with pans for notes and bass
        Math.sin(j/1000.0*2*pi) => p.pan;
        -Math.sin(j/1000.0*2*pi) => p1.pan;
        
        // changing gain for blip and snare to make them more pulsar
        snareNoiseGain/j*100 => snareNoise.gain;
        blipOscGain/j*7 => blipOsc.gain;
        
        // various conditions for control different "instruments'" gain
        if(timing>28::second){
            0 => snareNoise.gain;
            0 => notesOsc.gain;
            0 => bassOsc.gain;
        } else {
            if(timing>26::second){
                0 => notesOsc.gain;
            }else{
                if(timing>20::second){
                    notesOscGain/((timing/second-19)) => notesOsc.gain;
                }
            }
        }
        
        // advance time
        quater/1000 => now;
    }

}
