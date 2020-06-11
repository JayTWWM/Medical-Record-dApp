pragma solidity >=0.4.21 <0.7.0;
import "./RecordLibrary.sol";

contract RecordTracker {

    mapping(uint => RecordLibrary.Identity) public IdentityStore;
    uint256 public identityCount= 0;

    function createIdentity(string memory _add, string memory _name, string memory _pass, bool _isDoctor) public returns (uint256)
    {
        require(canAddExist(_add), "Address Already Exists!");
        require(canNameExist(_name), "User Name Already Taken!");
        identityCount++;
        IdentityStore[identityCount] = RecordLibrary.Identity(_add,_name,_pass,0,true,_isDoctor);
        emit IdentityCreate(identityCount,_add,_name,_pass,_isDoctor);
    }

    function logInIdentity(string memory _add, string memory _name, string memory _pass) public returns (uint256)
    {
        require(!canAddExist(_add), "Address Does Not Exist!");
        require(!canNameExist(_name), "Name Does Not Exist!");
        require(doesAccExist(_add,_name,_pass), "Provided Name And Email Do Not Belong To Current Address!");
        uint ind = getAddIndex(_add);
        IdentityStore[ind].isLoggedIn = true;
        emit LogIn(_add,_name,_pass);
    }

    function createRecord(string memory _adder, string memory _ipfsInfo, string memory _recordName, string memory _desc) public returns(uint256)
    {
        require(!canAddExist(_adder), "Address Does Not Exist!");
        uint index = getAddIndex(_adder);
        require(IdentityStore[index].isLoggedIn == true, "Please Log In First!");
        IdentityStore[index].recordCount++;
        uint recordIndex = IdentityStore[index].recordCount;
        string memory _owner = getUsername(_adder);
        IdentityStore[index].record[recordIndex] = RecordLibrary.Record(recordIndex,block.number,_owner,_recordName,_desc,_ipfsInfo);
        emit RecordCreate(_adder,recordIndex,block.number,_owner,_recordName,_desc,_ipfsInfo);
    }

    function doesAccExist(string memory _adder, string memory _namer, string memory _passer) private view returns (bool)
    {
        for(uint i = 1;i<=identityCount;i++)
        {
            string memory acc = IdentityStore[i].add;
            if(keccak256(abi.encodePacked((acc))) == keccak256(abi.encodePacked((_adder))))
            {
                string memory name1 = IdentityStore[i].name;
                string memory email1 = IdentityStore[i].pass;
                if((keccak256(abi.encodePacked((name1))) == keccak256(abi.encodePacked((_namer))))&&(keccak256(abi.encodePacked((email1))) == keccak256(abi.encodePacked((_passer)))))
                {
                    return true;
                }
                break;
            }
        }
        return false;
    }

    function getAddFromName(string memory _userNamer) private view returns (string memory)
    {
        for(uint i = 1;i<=identityCount;i++)
        {
            string memory acc = IdentityStore[i].name;
            if(keccak256(abi.encodePacked((acc))) == keccak256(abi.encodePacked((_userNamer))))
            {
                return IdentityStore[i].add;
            }
        }
    }

    function getAddIndex(string memory _adder) private view returns (uint)
    {
        for(uint i = 1;i<=identityCount;i++)
        {
            string memory acc = IdentityStore[i].add;
            if(keccak256(abi.encodePacked((acc))) == keccak256(abi.encodePacked((_adder))))
            {
                return i;
            }
        }
    }

    function canAddExist(string memory _adder) private view returns (bool)
    {
        for(uint i = 1;i<=identityCount;i++)
        {
            string memory acc = IdentityStore[i].add;
            if(keccak256(abi.encodePacked((acc))) == keccak256(abi.encodePacked((_adder))))
            {
                return false;
            }
        }
        return true;
    }

    function canNameExist(string memory _namer) private view returns (bool)
    {
        for(uint i = 1;i<=identityCount;i++)
        {
            string memory acc1 = IdentityStore[i].name;
            if(keccak256(abi.encodePacked((acc1))) == keccak256(abi.encodePacked((_namer))))
            {
                return false;
            }
        }
        return true;
    }

    function logOut(string memory _addressed) public returns (uint256)
    {
        uint index = getAddIndex(_addressed);
        require(IdentityStore[index].isLoggedIn == true, "Please Log In First!");
        IdentityStore[index].isLoggedIn = false;
        emit LogOut(_addressed);
    }

    function getUsername(string memory _ad) public view returns (string memory)
    {
        require(!canAddExist(_ad), "Address Does Not Exist!");
        uint indexer = getAddIndex(_ad);
        require(IdentityStore[indexer].isLoggedIn == true, "Please Log In First!");
        return IdentityStore[indexer].name;
    }

    function getRecordCount(string memory _ader) public view returns (uint)
    {
        require(!canAddExist(_ader), "Address Does Not Exist!");
        uint indexer = getAddIndex(_ader);
        require(IdentityStore[indexer].isLoggedIn == true, "Please Log In First!");
        return IdentityStore[indexer].recordCount;
    }

    function getRecord(string memory _adder, uint _ider) public view returns (string memory, string memory, string memory, string memory)
    {
        require(!canAddExist(_adder), "Address Does Not Exist!");
        uint indexer = getAddIndex(_adder);
        require(IdentityStore[indexer].isLoggedIn == true, "Please Log In First!");
        return(IdentityStore[indexer].record[_ider].owner,
            IdentityStore[indexer].record[_ider].recordName,
            IdentityStore[indexer].record[_ider].desc,
            IdentityStore[indexer].record[_ider].ipfsInfo);
    }

    function shareRecord(string memory _adder, uint _ider, string memory _sendUserName) public returns (uint256)
    {
        require(!canAddExist(_adder), "Address Does Not Exist!");
        string memory _own = getUsername(_adder);
        uint indexer = getAddIndex(_adder);
        require(keccak256(abi.encodePacked((_own))) == keccak256(abi.encodePacked((IdentityStore[indexer].record[_ider].owner))),"You are not the owner.");
        require(IdentityStore[indexer].isLoggedIn == true, "Please Log In First!");
        string memory addSend = getAddFromName(_sendUserName);
        require(!canAddExist(addSend), "Address Does Not Exist!");
        uint indexee = getAddIndex(addSend);
        require(keccak256(abi.encodePacked((_adder))) != keccak256(abi.encodePacked((_sendUserName))), "Cannot Send Record To Yourself!");
        IdentityStore[indexee].recordCount++;
        uint recordIndexee = IdentityStore[indexee].recordCount;
        IdentityStore[indexee].record[recordIndexee] = RecordLibrary.Record(recordIndexee,block.number,
        IdentityStore[indexer].record[_ider].owner,
        IdentityStore[indexer].record[_ider].recordName,
        IdentityStore[indexer].record[_ider].desc,
        IdentityStore[indexer].record[_ider].ipfsInfo);
        emit RecordShare(_adder,_ider,_sendUserName);
    }

    event RecordShare(string adder,uint ider,string sendUserName);
    event LogOut(string addressed);
    event IdentityCreate(uint id, string add, string name, string pass, bool isDoctor);
    event LogIn(string add, string name, string pass);
    event RecordCreate(string add,uint id, uint time, string owner, string recordName, string desc, string ipfsInfo);
}