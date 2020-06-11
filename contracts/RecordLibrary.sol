pragma solidity >=0.4.21 <0.7.0;

library RecordLibrary
{
    struct Identity
    {
        string add;
        string name;
        string pass;
        uint recordCount;
        bool isLoggedIn;
        bool isDoctor;
        mapping(uint => Record) record;
    }
    struct Record
    {
        uint id;
        uint time;
        string owner;
        string recordName;
        string desc;
        string ipfsInfo;
    }
}