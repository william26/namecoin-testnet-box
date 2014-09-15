# namecoin-testnet-box docker image
#
# This image uses an "easy-mining" branch of namecoind to make new blocks occur 
# more frequently while mining with `make generate-true`
# 
# Forked from Sean Lavine's bicoin-testnet-box
# https://github.com/freewil/bitcoin-testnet-box
#

FROM ubuntu:latest
MAINTAINER Antoine Jackson <a.j.william26@gmail.com>

# basic dependencies to build headless namecoind
# https://github.com/william26/namecoins/blob/easy-mining/doc/build-unix.md
RUN apt-get update
RUN apt-get install --yes build-essential libssl-dev libboost-all-dev

# install db4.8 provided via the bitcoin PPA
RUN apt-get install --yes python-software-properties
RUN add-apt-repository --yes ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install --yes db4.8
RUN apt-get install --yes libglibmm-2.4-dev


# install git to clone namecoin's source
RUN apt-get install --yes git

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# clone namecoin easy-mining branch and build it without UPnP support
RUN git clone https://github.com/william26/namecoin.git
RUN cd namecoin && git checkout easy-mining
RUN pwd
RUN cd namecoin/src; ls; make UPNP=1

# install bitcoind
RUN cp namecoin/src/namecoind /usr/local/bin/testcoind

# copy the testnet-box files into the image
ADD . /home/tester/namecoin-testnet-box

# make tester user own the bitcoin-testnet-box
RUN chown -R tester:tester /home/tester/namecoin-testnet-box

# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/namecoin-testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]