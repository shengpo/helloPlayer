public class OSCHandler {
        private PApplet papplet = null;

        private OscP5 oscP5 = null;
        private NetAddress remoteLocation = null;



        public OSCHandler(PApplet papplet, int clientOscPort, String serverIP, int serverOscPort) {
                this.papplet = papplet;

                //build osc communication
                oscP5 = new OscP5(papplet,  clientOscPort);
                remoteLocation = new NetAddress(serverIP, serverOscPort);
        }


        /*following methods are for sending OSC message to outside (server)*/
        //request server to add this client into it's client list
        public void addToServerList(){
                OscMessage myMessage = new OscMessage("/addClient");
                myMessage.add(ID);
                myMessage.add(clientOscPort);
                oscP5.send(myMessage, remoteLocation);

                println("[client INFO] helloPlayer ( cleint " + ID + " ) request to add in helloPlayer server's client list");
        }
                
        //ask server for rendering next frame
        public void askNext(){
                OscMessage myMessage = new OscMessage("/askNext");
                myMessage.add(ID);
                oscP5.send(myMessage, remoteLocation);

                println("[client INFO] helloPlayer ( cleint " + ID + " ) wait for playing next frame");
        }


        /*following methods are for responding to coming OSC from outside (server)*/
        public void processOscMessage(OscMessage theOscMessage){
                String addrPattern = theOscMessage.addrPattern();
                String typeTag = theOscMessage.typetag();
                
                //server-client connection is build
                if(oscMessageFormatCheck(addrPattern, typeTag, "/connected", "ii")){
                        int clientID = theOscMessage.get(0).intValue();
                        int universalRandomSeed = theOscMessage.get(1).intValue();                        

                        if(ID == clientID){
                                randomSeed(universalRandomSeed);
                                isReadyForFrameSync = true;
                                println("[client INFO] helloPlayer ( client " + ID + " ) is connected with helloPlayer server");
                                println("[client INFO] helloPlayer ( client " + ID + " ) set random seed " + universalRandomSeed);
                        }
                }
                
                //permitted to play next frame
                else if(oscMessageFormatCheck(addrPattern, typeTag, "/nextFrame", "")){
                        isGoNextFrame = true;
                        println("[client INFO] helloPlayer ( client " + ID + " ) go next frame");
                }
                
                //receive non-defined osc message
                else{
                        println("[client INFO] received a non-defined osc message : with address pattern "+ addrPattern+" typetag "+ typeTag);
                }
        }


        private boolean oscMessageFormatCheck( String addrPattern, String typeTag, String checkAddrPattern, String checkTypeTag){
                return addrPattern.equals(checkAddrPattern) && typeTag.equals(checkTypeTag);
        }


        //stop oscP5 and close open Sockets.    (避免重啟oscP5時佔用相同的local port)
        public void stop() {
                if (oscP5 != null)    oscP5.stop();
        }
}
