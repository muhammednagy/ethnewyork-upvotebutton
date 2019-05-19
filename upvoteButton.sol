pragma solidity ^0.5.4;


/* 
@title upvoteButton
@author Muhammed Nagy <me@muhnagy.com>
*/

contract upvoteButton {
    struct upvoter {uint256 balance ;}
    struct voter  {address user; uint256 balance ;}
    struct url {uint256 total; uint256 upvotersCount; mapping (address => upvoter) balances ; address author; address[] voters ;}
    mapping (string => url) urls ;
    uint   authorshare = 2;
    uint256  leftBalance = 0;
    function vote(string memory url) payable public  returns (bool) {
        if (msg.value > 0){
        urls[url].total += msg.value;
        urls[url].upvotersCount += 1;
        if (urls[url].upvotersCount == 1) {
            urls[url].balances[msg.sender].balance = msg.value;
            urls[url].author = msg.sender;
        } else {
            authorshare = msg.value / authorshare ;
            urls[url].balances[urls[url].author].balance += authorshare;
            leftBalance -= msg.value - authorshare;
            leftBalance = leftBalance / ( urls[url].upvotersCount - 1 );
                for (uint i=1; i<urls[url].upvotersCount; i++) {
                 urls[url].balances[urls[url].voters[i]].balance += leftBalance ;
            }
            
        }
        urls[url].voters.push(msg.sender);
        return true;
        } else {
        
            return false;
        }
        
    }
    
    function getCount(string memory url) view public returns (uint256){
        return urls[url].upvotersCount;
    }
    function getVoter(string memory url, uint256 id)view public returns (address, uint256){
        return (urls[url].voters[id], urls[url].balances[urls[url].voters[id]].balance);
    }
    
    function withdraw(string memory url) public  returns(bool){
        msg.sender.transfer(urls[url].balances[msg.sender].balance);
        urls[url].balances[msg.sender].balance = 0;
        
    }
    
}

