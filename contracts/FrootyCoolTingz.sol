// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Greenlist {
    address public admin;
    uint256 constant digits = 10**18;
    uint256 public l;
    uint256 public max;
    string public message;
    uint256 public stamp;
    uint256 public msgprice;
    FrootyCoolTingz public FCT;
    mapping(address => bool) public isListed;
    address[1234] public users;
    modifier notListed(address _adr) {
        require(isListed[_adr] == false, "already listed");
        _;
    }

    constructor(uint256 _t) {
        admin = msg.sender;

        if (_t == 0) {
            l = 0; // Testnet
            max = 1; // Testnet
            msgprice = (1 * digits) / 1000;
        } else {
            isListed[msg.sender] = true; // OFF ON TESTNET
            users[0] = msg.sender;
            l = 0; // Mainnet
            max = 1234; // Mainnet
            msgprice = (1 * digits) / 1000;
        }
        message = "GET U A #FROOT NOW !";
    }

    function setFCT(address _fct) external returns (bool) {
        FCT = FrootyCoolTingz(_fct);
        return true;
    }

    function autoStart() internal returns (bool) {
        return FCT.changeMS();
    }

    function getListed() external notListed(msg.sender) returns (bool) {
        require(l < max, "no more greenlist tickets left");
        isListed[msg.sender] = true;
        users[l] = (msg.sender);
        l++;
        if (l == max) autoStart();
        return isListed[msg.sender];
    }

    function makeListing(address _adr) external notListed(_adr) returns (bool) {
        require(admin == msg.sender, "you are not admin");
        isListed[_adr] = true;
        users[l] = (_adr);
        l++;
        if (l == max) autoStart();
        return isListed[_adr];
    }

    function showUsers() external view returns (address[1234] memory) {
        return users;
    }

    function setMsg(string memory _msg) external payable returns (bool) {
        require(msg.value >= msgprice, "insufficient balance sent");
        require(block.timestamp >= stamp + 60 * 60, "you need to wait");
        message = _msg;
        stamp = block.timestamp;
        return true;
    }

    function setMsgAdmin(string memory _msg) external returns (bool) {
        require(admin == msg.sender, "you are not admin");
        message = _msg;
        stamp = block.timestamp;
        return true;
    }

    function showMsg() external view returns (string memory) {
        return message;
    }

    function withdraw() external returns (uint256) {
        require(admin == msg.sender, "you are not admin");
        payable(admin).transfer(address(this).balance);
        return address(this).balance;
    }
}

contract ICE is ERC20 {
    uint256 public constant digits = 10**18;
    uint256 public price; // Testnet :: 10000 // Mainnet :: 10
    address public froots;
    address admin;

    modifier onlyA() {
        require(msg.sender == admin);
        _;
    }

    constructor(uint256 _t) ERC20("Incredibly Cool Essence", "ICE") {
        admin = msg.sender;
        _domint(1000 * 10**22, admin);
        if (_t == 0) {
            price = (1 * digits) / 1000;
        } else {
            if (_t == 1) {
                price = (1 * digits) / 1000;
            }
            if (_t == 2) {
                price = (1 * digits) / 1000;
            }
            if (_t == 3) {
                price = (1 * digits) / 1000;
            }
            if (_t == 4) {
                price = (1 * digits) / 1000;
            }
            if (_t == 5) {
                price = (1 * digits) / 1000;
            }
            if (_t == 6) {
                price = (1 * digits) / 1000;
            }
            if (_t == 7) {
                price = (1 * digits) / 1000;
            }
            if (_t == 8) {
                price = (1 * digits) / 1000;
            }
        }
    }

    function setFroots(address _adr) external returns (address) {
        froots = _adr;
        return froots;
    }

    function _domint(uint256 _amnt, address _adr) internal returns (uint256) {
        _mint(_adr, _amnt);
        return _amnt;
    }

    function burn(uint256 _amnt, address _adr) external returns (uint256) {
        _burn(_adr, _amnt);
        return _amnt;
    }

    function swap(uint256 _amnt, address _adr)
        external
        payable
        returns (uint256)
    {
        require(_amnt >= 10, "MINIMUM 10 ICE");
        require(msg.value >= price * _amnt, "INSUFFICIENT FUNDS PROVIDED");
        return _domint(_amnt, _adr);
    }

    function move(address _adr) external onlyA {
        _domint(1000000 * 10**18, _adr);
    }
}

contract FrootyCoolTingz is ERC721 {
    // Public Constants
    uint256 public price; // PRICE VAL Testnet
    uint256 public statusprice;
    uint256 public digits = 1 * 10**18; // PRICE VAL Mainnet
    uint256 public constant num = 1; // MAX MINTS / WALLET

    uint256 public max; // MAX TOTAL MINTS
    uint256 public sloz; // MAX FREE MINTS
    // */
    // Public Variables
    address public owner; // CONTRACT OWNER
    address iceAdr;
    uint256 public minted; // TOKENS MINTED 1-5000
    string public nam; // TOKEN NAME
    string public sym; // TOKEN SYMBOL
    uint256 public slots; // SLOZ USED 1-1234
    bool public start; // ALLOWS MINT TO START
    // Public Mappings
    mapping(uint256 => bytes) public dias; // TOKEN ID SHOWS DIAS BYTES OBJECT
    mapping(uint256 => uint256) public tid; // TOKEN ID SHOWS DIAS ID
    mapping(uint256 => string) public status; // TOKEN ID SHOWS USER STATUS
    mapping(uint256 => uint256) public icebox; // TOKEN ID SHOWS FROOT ICE BALANCE
    mapping(uint256 => uint256) public meltbox; // melted ICE of token id
    mapping(uint256 => address) public ownedBy;
    mapping(address => uint256) public minter; // Token ID by Address
    ICE public ice;
    Greenlist public GLC;

    modifier onlyO() {
        // ONLY OWNER CAN USE MOD FUNX
        require(msg.sender == owner);
        _;
    }

    constructor(
        address _ICE,
        address _Greenlist,
        uint256 _t
    ) ERC721("Cool Froots", "FROOT") {
        // INIT CONTRACT SET PUB VARS
        minted = 1;
        slots = 0;
        owner = msg.sender;
        nam = "Cool Froots";
        sym = "FROOT";
        ice = ICE(_ICE);
        GLC = Greenlist(_Greenlist);
        if (_t == 0) {
            max = 5;
            sloz = 1;
            price = (5 * digits) / 100;
            statusprice = digits / 1000;
        } else {
            max = 5555;
            sloz = 1234;
            price = 1 * digits;
            statusprice = digits / 1000;
        }
    }

    function isOwner(address _adr) external view returns (bool) {
        // SHOWS BOOL OF OWNERSTATUS OF ADDRESS
        if (_adr == owner) return true;
        else return false;
    }

    function _earn(address _adr, uint256 _o) internal returns (uint256) {
        ice.transfer(_adr, _o * digits);
        return _o;
    }

    function mint(
        uint256 _amnt,
        uint256[] memory _diasIDs,
        string[] memory _diasOBJs
    ) external payable returns (uint256) {
        // INITIATES THE MINT OF UP TO 7 TOKENS IF ALLOWED
        require(minted <= max + 1, "SOLD OUT");
        require(msg.value >= _amnt * price, "INSUFFICIET FUNDS");
        require(start == true, "MINT IS NOT YET LIVE");
        ownedBy[minted] = msg.sender;
        _doMint(_amnt, msg.sender, _diasIDs, _diasOBJs);
        uint256 o = 1 + (block.timestamp % 9);
        return _earn(msg.sender, o);
    }

    function greenMint(uint256[] memory _diasIDs, string[] memory _diasOBJs)
        external
        returns (uint256)
    {
        // INITIATES THE MINT OF UP TO 7 TOKENS IF ALLOWED
        require(minted <= max, "SOLD OUT");
        require(start == true, "MINT IS NOT YET LIVE");
        bool boo = GLC.isListed(msg.sender);
        require(boo == true, "YOU ARE NOT GREENLISTED");
        require(slots <= sloz, "ALL SLOTS HAVE BEEN MINTED");
        ownedBy[minted] = msg.sender;
        _doMint(1, msg.sender, _diasIDs, _diasOBJs);
        uint256 o = 1 + (block.timestamp % 9);
        slots++;
        return _earn(msg.sender, o);
    }

    function setStatus(uint256 _id, string memory _status)
        external
        payable
        returns (bool)
    {
        require(ownedBy[_id] == msg.sender, "YOU ARE NOT THE HOLDER");
        require(start == false, "MINT IS STILL IN PROGRESS");
        require(msg.value >= statusprice);
        status[_id] = _status;
        return true;
    }

    function iceSetStatus(uint256 _id, string memory _status)
        external
        returns (string memory)
    {
        require(ownedBy[_id] == msg.sender, "YOU ARE NOT THE HOLDER");
        require(start == false, "MINT IS STILL IN PROGRESS");
        require(ice.balanceOf(msg.sender) >= digits, "NOT ENOUGH ICE !");
        ice.burn(digits, msg.sender);
        if (block.timestamp % 9 < 3) {
            icebox[_id] += 1;
            if (meltbox[_id] == 0)
                meltbox[_id] = block.timestamp + 1 * 60 * 60 * 24;
            else meltbox[_id] += 1 * 60 * 60 * 24;
        }
        status[_id] = _status;
        return "ICE HAS BEEN ADDED TO FROOT !";
    }

    function addIce(uint256 _amount, uint256 _id)
        external
        returns (string memory)
    {
        require(ice.balanceOf(msg.sender) >= _amount * 10**18);
        ice.burn(_amount * 10**18, msg.sender);
        icebox[_id] += _amount;
        if (meltbox[_id] == 0)
            meltbox[_id] = block.timestamp + _amount * 60 * 60 * 24;
        else meltbox[_id] += _amount * 60 * 60 * 24;
        return "ICE HAS BEEN ADDED TO FROOT !";
    }

    function meltState() external view returns (int256 state) {
        int256 meltleft = int256(meltbox[minter[msg.sender]]) -
            int256(block.timestamp);
        return state = (meltleft / 3600) * 24;
    }

    function changeMintState() external onlyO returns (bool) {
        return cMS();
    }

    // ONLY TESTNET
    /* */
    function changeMS() external returns (bool) {
        require(msg.sender == address(GLC), "NOT CONTRACT !");
        return cMS();
    }

    // */
    function cMS() internal returns (bool) {
        return start = !start;
    }

    function mintOne(
        address _adr,
        uint256 _diasID,
        string memory _diasOBJ
    ) internal returns (uint256) {
        // INTERNAL // MINTS ONE TOKEN
        _mint(_adr, minted);
        tid[minted] = _diasID;
        dias[minted] = bytes(_diasOBJ);
        minter[_adr] = minted;
        minted++;
        if (minted >= max + 1) cMS();
        return minted;
    }

    function _doMint(
        uint256 _amnt,
        address _adr,
        uint256[] memory _diasIDs,
        string[] memory _diasOBJs
    ) internal returns (uint256) {
        require(
            balanceOf(_adr) + _amnt <= num,
            "EXCEEDED MAX MINTABLE TOKENS PER WALLET"
        );
        require(minted + _amnt <= max + 1, "NOT ENOUGH SUPPLY");
        // INTERNAL // MINTS UP TO 7 TOKENS IN ONE TX
        mintOne(_adr, _diasIDs[0], _diasOBJs[0]);
        return minted;
    }

    function holder(uint256 _id) external view returns (address) {
        // SHOWS OWNER OF TOKEN BY TID
        return ownedBy[_id];
    }

    function clearSloz() external returns (bool) {
        slots = 1234;
        return true;
    }

    function flush() external returns (uint256) {
        // WITHDRAW ALL ETHER FROM CONTRACT
        payable(owner).transfer(address(this).balance);
        return address(this).balance;
    }

    function flushERC20(address _erc) external returns (uint256) {
        // WITHDRAW ALL COIN FROM CONTRACT
        ERC20 coin = ERC20(_erc);
        coin.transferFrom(address(this), owner, coin.balanceOf(address(this)));
        return coin.balanceOf(address(this));
    }

    function flushERC721(address _erc, uint256 _id) external returns (uint256) {
        // WITHDRAW ALL NFT FROM CONTRACT
        ERC721 coin = ERC721(_erc);
        coin.transferFrom(address(this), owner, _id);
        return _id;
    }
}
