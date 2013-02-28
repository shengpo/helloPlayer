/***********************
 helloPlayerServer
 ==============
 此為helloPlayer系統的server端，主要負責同步每個client之間的frame。
 
 
 Description:
 -----------------
 - 目前helloPlayer目標平台放在Ubuntu/Linux上
         .  Mac OS跟Windows有時間再弄
 
 -  本程式為helloPlayer的server端，需搭配client使用
         . server : helloPlayerServer
         . client : helloPlayerClient
 
 
 Functions:
 ---------------
 - server端及client端可分別在任意時間開啟，等所有的client及server都開啟後，便開始做frame sync
         * 開啟順序可能如下:
         . 1) server, 2) client 0, 3) client 1
         . 1) client 0, 2) server, 3) client 1
         . 1) client 1, 2) client 0, 3) server
 
 - server端負責協調各個helloPlayer client之間的畫面同步
         . client-server彼此之間透過osc溝通做frame sync
         . server開啟後，會等待各個client的要求 (要求准許繪製下個frame)
         . 當每個client都送出要求至server後，server會發出准許的命令給每個client，然後每個client才能繪製下個frame
         . client每繪製完一個frame後，便送出准許繪製下個frame的要求給server
         . 以上步驟為循環步驟
 
 - client端可能是播放器，或是獨立執行的程式 (只要支援helloPlayer定義的OSC message即可，但皆需透過server作畫面同步)
 
 - server執行起來後，會先產生一個random seed，供每個client使用，以便每個client取random時都能取得相同的亂數
 
 - server也負責播放每個client共同的聲音檔 [needed?]
 
 
 Instruction:
 ----------------
 - 設定檔 (settings.txt) 放在data資料夾下，可設定server及client的基本設定 
         . server基本設定：osc_port, frame_rate, client_amount,  server_width, server_height, server_x, server_y, play_audio?
         . client基本設定：server_IP, server_osc_port, client_osc_port, ID, frame_rate, player_width, player_height, player_x, player_y, video_path
 
 
 Used libraries:
 ---------------------
 - Processing Video library (version: 2.0b8)
 - oscP5 (version: 0.9.8)
 
 
 Development Environment:
 --------------------------------------
 Processing 2.0b8
 
 
 Author: 
 -----------
 Shen, Sheng-Po (http://shengpo.github.com)
 
 
 License: 
 ------------
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
