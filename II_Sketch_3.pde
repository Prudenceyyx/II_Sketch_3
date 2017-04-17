//Upload Standard Firmata to Arduino before you run the sketch.
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int[] averTilt=new int[10];
int count=0;
float aver=0;
int state=0;//0=stop,1=right,-1=left
int rightPin=3;//Motor Pin
int sensor=0;//tilt Sensor

void setup() {
  frameRate(30);
 
  arduino = new Arduino(this, "/dev/cu.usbmodem1421", 57600);
  arduino.pinMode(rightPin,Arduino.OUTPUT);
  
  //Initiate the averBrightness to an array of 0
  for(int i=0;i<averTilt.length;i++) averTilt[i]=0;
}


void draw() {
  
  //Read from a light sensor connected to pin A0 
  //The tiltier, the faster the motor is
  int tilt=arduino.analogRead(sensor);

  //A data structure to smooth the change.
  //It stores 10 mapped analog value in an array,
  //and output the average float as the brightness
  averTilt[count]=tilt;
  count=(count+1)%averTilt.length;
  println("count "+count);  
  aver=0;
  for(float f :averTilt)aver+=f;
  aver=aver/averTilt.length;

//Assign the state
  if(aver==0){//Stop
  state=0;
  }else if(aver==1023){//Run at the greatest Speed
    state=1;
  }
  else if(aver<5){//Run at lower speed
  state=-1;
  }
  
  println(aver);
  println("state "+state);
  motorOutput(state);
 
}

void motorOutput(int state){
  if(state==0){
  arduino.pinMode(rightPin,Arduino.OUTPUT);
  arduino.digitalWrite(rightPin,0);
  
  }else if(state==1){
    arduino.pinMode(rightPin,Arduino.OUTPUT);
    arduino.digitalWrite(rightPin,250);
  }else if(state==-1){
     arduino.pinMode(rightPin,Arduino.INPUT);
  arduino.analogWrite(rightPin,150);
  }
  delay(5);
  
}