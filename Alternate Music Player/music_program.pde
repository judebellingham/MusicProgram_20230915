import java.io.*; //Pure Java Library
//
//Library: use Sketch / Import Library / Minim
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//
//Global Variables
File musicFolder; //Class for java.io.* library
Minim minim; //creates object to access all functions
int numberOfSongs = 1, currentSong = 0; //Placeholder Only, reexecute lines after fileCount Known
AudioPlayer[] playList = new AudioPlayer[numberOfSongs]; //song is now similar to song1
AudioMetaData[] playListMetaData = new AudioMetaData[numberOfSongs]; //same as above
PFont generalFont;
color red = #7C2020, blue = #69DBFC, resetColour = #FFFFFF;
//
void setup() {
  //size() or fullScreen()
  size(900, 700);
  //Display Algorithm
  String relativePathway = "Audio/songs/"; //Relative Path
  String absolutePath = sketchPath( relativePathway ); //Absolute Path
  println("Main Directory to Music Folder", absolutePath);
  musicFolder = new File(absolutePath);
  int musicFileCount = musicFolder.list().length;
  println("File Count of the Music Folder", musicFileCount);
  File[] musicFiles = musicFolder.listFiles(); //String of Full Directies
  println("List of all Directories of Each Song to Load into music playlist");
  printArray(musicFiles);
  //Demonstration Only, files know their names in Java.IO Library
  for ( int i = 0; i < musicFiles.length; i++ ) {
    println("File Name", musicFiles[i].getName() );
  }
  //NOTE: take each song's pathway and load the music into the PlayList
  String[] songFilePathway = new String[musicFileCount];
  for ( int i = 0; i < musicFiles.length; i++ ) {
    songFilePathway[i] = ( musicFiles[i].toString() );
  }
  // Re-execute Playlist Population, similar to DIV Population
  numberOfSongs = musicFileCount; //Placeholder Only, reexecute lines after fileCount Known
  playList = new AudioPlayer[numberOfSongs]; //song is now similar to song1
  playListMetaData = new AudioMetaData[numberOfSongs]; //same as above
  //
  minim = new Minim(this); //load from data directory, loadFile should also load from project folder, like loadImage
  //
  for ( int i=0; i<musicFileCount; i++ ) {
    playList[i]= minim.loadFile( songFilePathway[i] );
    playListMetaData[i] = playList[i].getMetaData();
  } //End Music Load
  playList[currentSong].play();
} //End setup
//
void draw() {
  println(currentSong, numberOfSongs);
  //NOte: Looping Function
  //Note: logical operators could be nested IFs
  if ( playList[currentSong].isLooping() && playList[currentSong].loopCount()!=-1 ) println("There are", playList[currentSong].loopCount(), "loops left.");
  if ( playList[currentSong].isLooping() && playList[currentSong].loopCount()==-1 ) println("Looping Infinitely");
  if ( playList[currentSong].isPlaying() && !playList[currentSong].isLooping() ) println("Play Once");
  //
  //Debugging Fast Forward and Fast Rewind
  //println( "Song Position", song1.position(), "Song Length", song1.length() );
  //
  // songMetaData1.title()
    generalFont = createFont ("Harrington", 55); //Must also Tools / Create Font / Find Font / Do Not Press "OK"
  rect(width*1/4, height*0, width*1/2, height*3/10); //mistake
   fill( blue );
  textAlign (CENTER, CENTER); //Align X&Y, see Processing.org / Reference
  //Values: [LEFT | CENTER | RIGHT] & [TOP | CENTER | BOTTOM | BASELINE]
  int size = 10; //Change this font size
  textFont(generalFont, size); //Change the number until it fits, largest font size
  text(playListMetaData[currentSong].title(), width*1/4, height*0, width*1/2, height*3/10);
  fill(resetColour); //Reset to white for rest of the program
} //End draw
//
void keyPressed() {
  //Broken KeyBinds
  if ( key=='P' || key=='p' ) playList[currentSong].play(); //Parameter is milli-seconds from start of audio file to start playing (illustrate with examples)
  //.play() includes .rewind()
  //
  if ( key>='1' || key<='9' ) { //Loop Button, previous (key=='1' || key=='9')
    //Note: "9" is assumed to be massive! "Simulate Infinite"
    String keystr = String.valueOf(key);
    //println(keystr);
    int loopNum = int(keystr); //Java, strongly formatted need casting
    playList[currentSong].loop(loopNum); //Parameter is number of repeats
    //
  }
  if ( key=='L' || key=='l' ) playList[currentSong].loop(); //Infinite Loop, no parameter OR -1
  //
  if ( key=='M' || key=='m' ) { //MUTE Button
    //MUTE Behaviour: stops electricty to speakers, does not stop file
    //NOTE: MUTE has NO built-in PUASE button, NO built-in rewind button
    //ERROR: if song near end of file, user will not know song is at the end
    //Known ERROR: once song plays, MUTE acts like it doesn't work
    if ( playList[currentSong].isMuted() ) {
      //ERROR: song might not be playing
      //CATCH: ask .isPlaying() or !.isPlaying()
      playList[currentSong].unmute();
    } else {
      //Possible ERROR: Might rewind the song
      playList[currentSong].mute();
    }
  } //End MUTE
  //
  //Possible ERROR: FF rewinds to parameter milliseconds from SONG Start
  //Possible ERROR: FR rewinds to parameter milliseconds from SONG Start
  //How does this get to be a true ff and fr button
  //Actual .skip() allows for varaible ff & fr using .position()+-
  //
  if (key == CODED && keyCode == RIGHT) {
    if (currentSong<numberOfSongs-1) {
      playList[currentSong].pause();
      playList[currentSong].rewind();
      currentSong=currentSong+1;
      playList[currentSong].play();
    } else if (currentSong==numberOfSongs-1) {
      playList[currentSong].pause();
      playList[currentSong].rewind();
      currentSong=0;
      playList[currentSong].play();
    }
  }
  if (key == CODED && keyCode == LEFT) {
    if (currentSong>0) {
      playList[currentSong].pause();
      playList[currentSong].rewind();
      currentSong=currentSong-1;
      playList[currentSong].play();
    } else if (currentSong==0) {
      playList[currentSong].pause();
      playList[currentSong].rewind();
      currentSong=numberOfSongs-1;
      playList[currentSong].play();
    }
  }
  //
  if ( key=='F' || key=='f' ) playList[currentSong].skip( 5000 ); //SKIP forward 1 second (1000 milliseconds)
  if ( key=='R' || key=='r' ) playList[currentSong].skip( -5000 ); //SKIP  backawrds 1 second, notice negative, (-1000 milliseconds)
  //
  //Simple STOP Behaviour: ask if .playing() & .pause() & .rewind(), or .rewind()
  if ( key=='S' | key=='s' ) {
    if ( playList[currentSong].isPlaying() ) {
      playList[currentSong].pause(); //auto .rewind()
    } else {
      playList[currentSong].rewind(); //Not Necessary
    }
  }
  //
  //Simple Pause Behaviour: .pause() & hold .position(), then PLAY
  if ( key=='Y' | key=='y' ) {
    if ( playList[currentSong].isPlaying()==true ) {
      playList[currentSong].pause(); //auto .rewind()
    } else {
      playList[currentSong].play(); //ERROR, doesn't play
    }
  }
} //End keyPressed
//
void mousePressed() {
} //End mousePressed
//
//End MAIN Program
