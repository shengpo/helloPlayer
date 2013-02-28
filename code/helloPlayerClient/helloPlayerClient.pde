/***********************
 [about helloPlayer project]
 http://github.com/shengpo/helloPlayer

 [Author]
 Shen, Sheng-Po (http://shengpo.github.com)
 
 [License]
 CC BY-SA 3.0 
 ***********************/





import oscP5.*;
import netP5.*;
import processing.video.*;




//for system
int playerWidth = 400;        //helloPlayer client's width
int playerHeight = 300;       //helloPlayer client's height
int playerX = 0;                    //helloPlayer client's X position on the screen   
int playerY = 0;                    //helloPlayer client's Y position on the screen
int frame_rate = 30;    //important for server-client frame sync ? (need to check)
boolean isReadyForFrameSync = false;        //if ready for server-client frame sync

//for client
int ID = -1;
boolean isGoNextFrame = false;

//for osc communicatoin with client
OSCHandler oscHandler = null;
int clientOscPort = 12001;
String serverIP = "127.0.0.1";
int serverOscPort = 12000;

//for garbage collector
GarbageCollector gc = null;
float gcPeriodMinute = 5;    //設定幾分鐘做一次gc

//for infoPanel
InfoPanel infoPanel = null;

//for settings
SettingManager settingManager = null;

//for video player
Player player = null;
String videoPath = "";





//set frame undecorated to emulate full screen
void init() {
        loadInitialSettings();        //hack: for loading initial setting only once

        frame.dispose();  
        frame.setUndecorated(true);  
        super.init();
}


void setup() {
        //loadInitialSettings();        //if put the method here, initial settings will be loaded twice
        size(playerWidth, playerHeight, P3D);
        background(38, 41, 44);
        frameRate(frame_rate);

        //build osc for server
        oscHandler = new OSCHandler(this, clientOscPort, serverIP, serverOscPort);

        //for info panel
        infoPanel = new InfoPanel();
        
        //for video player
        player = new Player(this, videoPath);

        //for garbage collector
        gc = new GarbageCollector(gcPeriodMinute);
        gc.start();

        //set frame location to emulate full screen
        frame.setLocation(playerX, playerY);
}


void draw() {
        if(isReadyForFrameSync){
                //play frame after setting random seed!
                if(isGoNextFrame){
                        if(player != null)        player.play();
                }else{
                        if(oscHandler != null)        oscHandler.askNext();
                }
        }else{
                background(38, 41, 44);

                //show basic client info
                if(infoPanel != null)        infoPanel.showClientInfo();
                
                //request to add in server's client list
                if(oscHandler != null)        oscHandler.addToServerList();
        }
}


//load initial settings
void loadInitialSettings() {
        settingManager = new SettingManager();
        println("[ server INFO ] loading settings.txt");
        settingManager.load(sketchPath("settings.ini"));
        println("[ server INFO ] loading SUCESS!!");
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
        if(oscHandler != null)        oscHandler.processOscMessage(theOscMessage);
}


void movieEvent(Movie m) {
        m.read();
}


////release osc socket and port
//public void stop() {
//        if(oscHandler != null) oscHandler.stop();
//}

//public void exit(){
//        //...
//}
