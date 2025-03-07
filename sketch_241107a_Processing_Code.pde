import processing.serial.*;
PFont f6,f8,f12,f10;
PFont f24;
Serial myPort; // The serial port
int xPos = 0; // horizontal position of the graph
float y1=0;
float y2=0;
float y3=0;
void setup ()
{
// set the window size: and Font size
f6 = createFont("Arial",6,true);
f8 = createFont("Arial",8,true);
f10 = createFont("Arial",10,true);
f12 = createFont("Arial",12,true);
f24 = createFont("Arial",24,true);
size(1200, 700);
 
// List all the available serial ports
println(Serial.list());
myPort = new Serial(this, "COM6", 9600);
println(myPort);
myPort.bufferUntil('\n');
background(80);
}
 
void draw ()
{
serial ();
}
 
void serial()
{
String inString = myPort.readStringUntil('$'); // reading incomming date from serial
if (inString != null)
{
// extracting all required values of all three axis:
int l1=inString.indexOf("x=")+2;
String temp1=inString.substring(l1,l1+3);
l1=inString.indexOf("y=")+2;
String temp2=inString.substring(l1,l1+3);
l1=inString.indexOf("z=")+2;
String temp3=inString.substring(l1,l1+3);
 
//mapping x, y and z value with graph dimensions
float inByte1 = float(temp1+(char)9);
inByte1 = map(inByte1, -80,80, 0, height-80);
float inByte2 = float(temp2+(char)9);
inByte2 = map(inByte2,-80,80, 0, height-80);
float inByte3 = float(temp3+(char)9);
inByte3 = map(inByte3,-80,80, 0, height-80);
float x=map(xPos,0,1120,40,width-40);
 
//ploting graph window, unit
strokeWeight(2);
stroke(175);
Line(0,0,0,100);
textFont(f24);
fill(0,00,255);
textAlign(RIGHT);
xmargin("EarthQuake Graph (SESMIOGRAPH)",200,100);
 
fill(100);
strokeWeight(100);
line(1050,80,1200,80);
 
strokeWeight(1);
textAlign(RIGHT);
fill(0,0,255);
String temp="X:"+temp1;
Text(temp,100,95);
 
fill(0,255,0);
temp="Y:"+temp2;
Text(temp,100,92);
 
fill(255,0,0);;
temp="Z:"+temp3;
Text(temp,100,89);
 
 
//ploting x y and z values over graph
strokeWeight(2);
int shift=40;
 
stroke(0,0,255);
if(y1 == 0)
y1=height-inByte1-shift;
line(x, y1, x+2, height-inByte1-shift) ;
y1=height-inByte1-shift;
 
stroke(0,255,0);
if(y2 == 0)
y2=height-inByte2-shift;
line(x, y2, x+2, height-inByte2-shift) ;
y2=height-inByte2-shift;
 
stroke(255,0,0);
if(y2 == 0)
y3=height-inByte3-shift;
line(x, y3, x+2, height-inByte3-shift) ;
y3=height-inByte3-shift;
 
xPos+=1;
 
if (x >= width-30) // go back to begining
{
xPos = 0;
background(80);
}
}
}
 
void Line(int x1, int y1, int x2, int y2)
{
float xx1=map(x1,0,100,40,width-40);
float xx2=map(x2,0,100,40,width-40);
float yy1=map(y1,0,100,height-40,40);
float yy2=map(y2,0,100,height-40,40);
 
line(xx1,yy1,xx2,yy2);
xx2=map(100,0,100,40,width-40);
yy2=map(0,0,100,height-40,40);
line(xx1,yy1,xx2,yy2);
 
strokeWeight(1);
for(int i=1;i<21;i++)
{
yy2=map(i*10,0,200,height-40,40);
yy1=yy2;
line(xx1,yy1,xx2,yy2);
}
yy2=map(100,0,100,height-40,40);
yy1=map(0,0,100,height-40,40);
for(int i=1;i<41;i++)
{
xx1=map(i*5,0,200,40,width-40);
xx2=map(i*5,0,200,40,width-40);
line(xx1,yy1,xx2,yy2);
}
 
textAlign(RIGHT); // 100 degree
// result+=yy1;
fill(255);
strokeWeight(1);
textFont(f12);
for(int i=-10;i<11;i++)
{
String result="";
result+=5*i;
ymargin(result, x1,y1);
y1+=5;
}
 
x1=0;
y1=0;
strokeWeight(1);
textFont(f10);
for(int i=0;i<41;i++)
{
String result="";
result+=28*3*i;
xmargin(result, x1,y1);
x1+=5;
}
 
textAlign(RIGHT);
 
textAlign(RIGHT);
}
 
void ymargin(String value, int x1, int y1)
{
 
float xx1=map(x1,0,100,40,width-40);
float yy1=map(y1,0,100,height-40,40);
text(value,xx1-5,yy1+5);
}
 
void xmargin(String value, int x1, int y1)
{
 
float xx1=map(x1,0,200,40,width-40);
float yy1=map(y1,0,100,height-25,25);
text(value,xx1+7,yy1);
}
 
void Text(String value, int x1, int y1)
{
 
float xx1=map(x1,0,100,40,width-40);
float yy1=map(y1,0,100,height-25,25);
text(value,xx1,yy1);
}
