const Greenlist = artifacts.require("Greenlist");
/**
 * net function returns the networkID and logs the id to the console
 * @returns netID the network id
 */
var n;
const net = async () => {
  const netID = await web3.eth.net.getId();
  console.log(netID);
  n = netID;
  return n;
};
net();
module.exports = function (deployer, n) {
  // var n = net();
  var t;
  console.log("netID :: ", n);
  if (n == "mantletest" || n == "mumbai" || n == "tevmos" || n == "fuji") {
    t = 0;
  } else {
    if (n == "main") t = 1;
    if (n == "polygon") t = 2;
    if (n == "fevm") t = 3;
    if (n == "avax") t = 4;
    if (n == "celo") t = 5;
  }
  console.log("mode :: ", t);
  deployer.deploy(Greenlist, t);
};
