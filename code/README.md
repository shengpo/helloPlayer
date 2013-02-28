Functions:
---------------

- server端及client端可分別在任意時間開啟，等所有的client及server都開啟後，便開始做frame sync
	* 開啟順序可能如下:
	- 1) server, 2) client 0, 3) client 1
	- 1) client 0, 2) server, 3) client 1
	- 1) client 1, 2) client 0, 3) server

- server端負責協調各個helloPlayer client之間的畫面同步
	- client-server彼此之間透過osc溝通做frame sync
	- server開啟後，會等待各個client的要求 (要求准許繪製下個frame)
	- 當每個client都送出要求至server後，server會發出准許的命令給每個client，然後每個client才能繪製下個frame
	- client每繪製完一個frame後，便送出准許繪製下個frame的要求給server
	- 以上步驟為循環步驟

- client端可能是播放器，或是獨立執行的程式 (只要支援helloPlayer定義的OSC message即可，但皆需透過server作畫面同步)
- server執行起來後，會先產生一個random seed，供每個client使用，以便每個client取random時都能取得相同的亂數
- server也負責播放每個client共同的聲音檔 [needed?]


Instruction:
----------------
- 設定檔 (settings.txt) 放在data資料夾下，可設定server及client的基本設定
	- server基本設定：osc_port, frame_rate, client_amount,  server_width, server_height, server_x, server_y, play_audio?
	- client基本設定：server_IP, server_osc_port, client_osc_port, ID, frame_rate, player_width, player_height, player_x, player_y, video_path


Used libraries:
---------------------
- Processing Video library (version: 2.0b8)
- oscP5 (version: 0.9.8)


Development Environment:
--------------------------------------
Processing 2.0b8



TODO list:
----------
- multicast? broadcast?
	- http://en.wikipedia.org/wiki/Multicast
- 可做local-scope multicast IP設定?
	- 參考 [oscMulticastWithPropertiesDemo](https://github.com/shengpo/processing_snips/tree/master/oscMulticastWithPropertiesDemo)
- [ ] server-clients frame sync
- [ ] server app
	- [ ] 關掉後也要關掉oscP5所佔用的port
	- [ ] 要能播聲音檔?
- [ ] client player
	- [ ] 需發出osc message給server, 要求得知共同的random seed
	- [ ] 關掉後也要關掉oscP5所佔用的port
- [ ] projection mapping for client
- 使用most-pixel-ever改寫
