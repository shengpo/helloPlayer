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



//for system
int serverWidth = 300;        //helloPlayer server's width
int serverHeight = 150;       //helloPlayer server's height
int serverX = 0;                    //helloPlayer server's X position on the screen   
int serverY = 0;                    //helloPlayer server's Y position on the screen
int frame_rate = 30;    //important for server-client frame sync ? (need to check)
boolean isReadyForFrameSync = false;        //if ready for server-client frame sync

//for random seed
RandomSeedGenerator randomSeedGenerator = null;

//for osc communicatoin with client
OSCHandler oscHandler = null;
int oscPort = 12000;

//for client info
ArrayList<ClientInfo> clientList = null;
int totalClientCount = 1;        //總共多少個client

//for info panel
InfoPanel infoPanel = null;

//for settings
SettingManager settingManager = null;

//for garbage collector
GarbageCollector gc = null;
float gcPeriodMinute = 5;    //設定幾分鐘做一次gc





//set frame undecorated to emulate full screen
void init() {
        loadInitialSettings();        //hack: for loading initial setting only once

        frame.dispose();  
        frame.setUndecorated(true);  
        super.init();
}


void setup() {
        //loadInitialSettings();        //if put the method here, initial settings will be loaded twice
        size(serverWidth, serverHeight, P3D);
        background(38, 41, 44);
        frameRate(frame_rate);

        //for universal random seed
        randomSeedGenerator = new RandomSeedGenerator();

        //for clients
        clientList = new ArrayList<ClientInfo>();

        //build osc for server
        oscHandler = new OSCHandler(this, oscPort);

        //for info panel
        infoPanel = new InfoPanel();

        //for garbage collector
        gc = new GarbageCollector(gcPeriodMinute);
        gc.start();

        //set frame location to emulate full screen
        frame.setLocation(serverX, serverY);
}


void draw() {
        background(38, 41, 44);

        if (isReadyForFrameSync) {
                //check if all clients waiting for next frame
                int count = 0;
                for (ClientInfo client : clientList) {
                        if (client.isWaiting())        count = count + 1;
                }

                //let all clients go to next frame
                if (count >= totalClientCount) {
                        if (oscHandler != null)        oscHandler.goNextFrame();
                }
        } else {
                if (infoPanel != null)        infoPanel.showServerInfo();
                
                if(clientList.size() >= totalClientCount){
                        isReadyForFrameSync = true;
                }
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

////release osc socket and port
//public void stop() {
//        if(oscHandler != null) oscHandler.stop();
//}

//public void exit(){
//        //...
//}
