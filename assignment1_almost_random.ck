<<< "Assignment_1_Almost_Random." >>>;

// silence "const";
0 => float silence;
// all Oscillators
TriOsc oscillator1 => dac;
SinOsc oscillator2 => dac;
SawOsc oscillator3 => dac;
// initial gains for ocsillators
.04 => float oscillator3Gain;
.2 => float oscillator1Gain;
.1 => float oscillator2Gain;
oscillator1Gain => oscillator1.gain;
oscillator2Gain => oscillator2.gain;
silence => oscillator3.gain;
// initialization of numbers needed for random emulation
// as was said on forum that random2 is not alowed in assignment 1
// as well as modulo
// You can change these numbers to get different sound pattern.
65535 => int mod;
1667 => int mul;
1019 => int inc;
8376 => int seed;

// switcher for "bass"
1 => int isPlaying;

// initial time markers
now => time begin;
now => time start;

// while loop running for 25 seconds
while(begin+25::second > now){
   
    // if body runs once in 0.8+ secs
    if(now-start > 0.8::second){
        // renew marker
        now => start;
        // using  pseudo random number
        50+20*seed/mod => oscillator3.freq;
        // check if note is playing now
        if(isPlaying == 1){
            silence => oscillator3.gain;
        }else{
            oscillator3Gain => oscillator3.gain;
        }
        // switches play flag
        1 - isPlaying => isPlaying;
    }
    
    // calculating next pseudo-random number
    seed*mul + inc => int temprand;
    (temprand - (temprand/mod)*mod) => seed;
    
    // setting random gain for Osc. just for fun
    seed*oscillator1Gain/mod => oscillator1.gain;
    
    // loop for the funny sounds
    for(0=>int i;i<200;i++){
        if(i<100){
            600.0*seed/mod+100+i => oscillator1.freq;
        }else{
            600.0*seed/mod+200-i => oscillator1.freq;            
        }
        200+i => oscillator2.freq;
        // move time for small piece of time wich depends a little from
        // time track already plays. so it slows to the end.
        0.001*(1 + (now-begin)/second/25)::second => now;
    }
}
silence => oscillator3.gain;

// coda :)
// emulating fade out.
for(1=>int i; i<=8; i++){
    oscillator1Gain/i => oscillator1.gain;
    oscillator2Gain/i => oscillator2.gain;
    .5::second => now;
    silence => oscillator1.gain;
    silence => oscillator2.gain;
    .1::second => now;
 }
