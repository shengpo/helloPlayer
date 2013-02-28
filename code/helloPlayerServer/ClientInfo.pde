public class ClientInfo {
        private int ID = -1;
        private NetAddress remoteLocation = null;

        private boolean isWaiting = false;        //if client send out /askNext request, this value will be "true" or will be "false"


        public ClientInfo(int ID, NetAddress remoteLocation) {
                this.ID = ID;
                this.remoteLocation = remoteLocation;
        }


        public boolean isWaiting(){
                return isWaiting;
        }

        public void gotoWaitingStatus(){
                isWaiting = true;
        }

        public void resetStatus(){
                isWaiting = false;
        }
        
        
        public int getID(){
                return ID;
        
        }
        
        public NetAddress getLocation(){
                return remoteLocation;
        }
}

