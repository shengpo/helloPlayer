public class OSCHandler {
        private PApplet papplet = null;

        private OscP5 oscP5 = null;



        public OSCHandler(PApplet papplet, int oscPort) {
                this.papplet = papplet;

                //build osc communication
                oscP5 = new OscP5(papplet, oscPort);
        }


        /*following methods are for sending OSC message to outside (clients)*/
        //tell all clients to play next frame
        public void goNextFrame(){
                //reset all clients' status
                for(ClientInfo client : clientList){
                        client.resetStatus();
                }

                delay(5000);

                //send /nextFrame osc message to every client
                for(ClientInfo client : clientList){
                        OscMessage myMessage = new OscMessage("/nextFrame");
                        oscP5.send(myMessage, client.getLocation());
                }

                println("[server INFO] halloPlayer server tell every client to play next frame");
        }



        /*following methods are for responding to coming OSC from outside (client)*/
        public void processOscMessage(OscMessage theOscMessage){
                String addrPattern = theOscMessage.addrPattern();
                String typeTag = theOscMessage.typetag();

                //helloPlayer client request to add in client list                
                if(oscMessageFormatCheck(addrPattern, typeTag, "/addClient", "ii")){
                        int clientID = theOscMessage.get(0).intValue();
                        int clientOscPort = theOscMessage.get(1).intValue();

                        //check client是否已存在
                        for (ClientInfo client : clientList) {
                                if (client.getID() == clientID)        return;        //已存在的話就不再加入client list中
                        }
                        
                        //client尚未存在於list中的話便將其加入
                        NetAddress  remoteLocation = new NetAddress(theOscMessage.address().substring(1), clientOscPort);        //theOscMessage.address()的output第一個字元為/
                        clientList.add(new ClientInfo(clientID, remoteLocation));
                        
                        //do hand-shake with clientID (讓client知道server收到加入client list的要求)
                        OscMessage myMessage = new OscMessage("/connected");
                        myMessage.add(clientID);
                        myMessage.add(randomSeedGenerator.getRandomSeed());
                        oscP5.send(myMessage, remoteLocation);
                        println("[server INFO] helloPlayer ( cleint " + clientID + " ) request to add in client list");
                }
                
                //helloPlayer client ask for play next frame (client will be paused by server until all clients ask for next their next frames)
                else if(oscMessageFormatCheck(addrPattern, typeTag, "/askNext", "i")){
                        int clientID = theOscMessage.get(0).intValue();

                        for (ClientInfo client : clientList) {
                                if (client.getID() == clientID) {
                                        client.gotoWaitingStatus();
                                        println("[server INFO] helloPlayer ( cleint " + clientID + " ) is waiting for next frame");
                                        break;
                                }
                        }
                }
                
                //receive non-defined osc message
                else{
                        println("[server INFO] received a non-defined osc message : with address pattern "+ addrPattern+" typetag "+ typeTag);
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

