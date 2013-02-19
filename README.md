helloPlayer
===========

a simple player for video art on multi-channel, play videos simultaneously, projection mapping, and others...
(currently, target platform is focused on Ubuntu/Linux. Windows and Mac OSX will be put in the future plan)


一個簡單易用的錄像藝術(video art)播放器，主要提供多頻道播放、多錄像同步播放、投影對位校正(梯形校正及曲面校正)、以及其他功能。
(目前目標平台為Ubuntu/Linux, Windows跟Mac OSX被放進未來支援的平台)

-------------------------------------------

TODO list:
----------
- [ ] 如何獲得程式本身的IP address?
- multicast? broadcast?
	- http://en.wikipedia.org/wiki/Multicast
- [ ] server-clients frame sync
- [ ] server app
	- [ ] server要能設定client數量?
	- [ ] 能夠自動detect 每個client的IP跟OSC port 
	- [ ] 關掉後也要關掉oscP5所佔用的port
	- [ ] 一開啟時, 要廣播給client知道server的IP跟osc port
	- [ ] 要能播聲音檔
- [ ] client player
	- [ ] 需發出osc message給server, 要求得知共同的random seed
	- [ ] 關掉後也要關掉oscP5所佔用的port
	- [ ] 一開啟時, 要廣播給server知道client的IP跟osc port
- [ ] projection mapping for client