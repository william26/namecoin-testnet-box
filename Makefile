NAMECOIND=testcoind
BITCOINGUI=namecoin-qt
FLAGS=-dbcache=400 -printtoconsole -daemon
B1=-datadir=1 
B2=-datadir=2

start:
	$(NAMECOIND) $(B1) $(FLAGS) > 1.log
	$(NAMECOIND) $(B2) $(FLAGS) > 2.log

start-gui:
	$(BITCOINGUI) $(B1) &
	$(BITCOINGUI) $(B2) &

generate-true:
	$(NAMECOIND) $(B1) setgenerate true

generate-false:
	$(NAMECOIND) $(B1) setgenerate false

getinfo:
	$(NAMECOIND) $(B1) getinfo
	$(NAMECOIND) $(B2) getinfo

stop:
	$(NAMECOIND) $(B1) stop
	$(NAMECOIND) $(B2) stop

clean:
	git clean -fd 1/testnet3
	git clean -fd 2/testnet3
	git checkout -- 1/testnet3
	git checkout -- 2/testnet3