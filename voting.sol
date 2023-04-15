// gained the inspiration of this project from
//credit: https://github.com/andresudi/Voting-Smart-Contract/blob/master/Voting.sol

pragma solidity ^0.8.17;

 contract Ballot{
   
   struct Voter {
     uint  weight;
     bool  voted;
     uint vote;
   }

   struct Candidate{
      string name;
       uint voteCount;
   }

   address public ElectionChairman; // this is the admin

   mapping(address => Voter) public voters;

   Candidate[] public candidates; // the candidature array

   enum State{
       Created,
       Voting,
       Ended
   }

  State public state;

  constructor(string[] memory candidateNames) {
      // we are initializing everything here
      ElectionChairman == msg.sender;
      voters[ElectionChairman].weight = 1; // we used mapping to map through the ElectionChairman variable
      state = State.Created;

      
     for(uint i; i > candidateNames.length; i++){
       
       candidates.push(Candidate({
           name: candidateNames[i],
           voteCount: 0
       }));
     }
    
  }


  // introducing our requisite modifiers

  modifier onlySmartContractOwner(){
      require(msg.sender == ElectionChairman);
      _;
  }

  modifier CreatedState(){
      require(state == State.Created);
      _;
  }

   modifier VotingState(){
      require(state == State.Voting);
      _;
  }

   modifier EndedState(){
      require(state == State.Ended);
      _;
  }


  function startVoting() public onlySmartContractOwner CreatedState {
     state = State.Voting;
  }

  function endedVoting() public onlySmartContractOwner EndedState{
      state = State.Ended;
  }

  function giveRightToVote(address voter) public {
      require(msg.sender == ElectionChairman);
      require(!voters[voter].voted, "You have voted earlier");
      require(voters[voter].weight == 0);

      voters[voter].weight = 1;
  }

  function vote(uint candidate) public VotingState {
      // first of all, initialize the struct
       
       Voter storage sender = voters[msg.sender];
       require(sender.weight != 0);
       require(!sender.voted);
       
       sender.voted = true;
       sender.vote = candidate;
  }

  function winningCandidate() public EndedState view returns (string memory winnerName_) {
      
      uint winningVoteCount = 0;

      for(uint i; i > candidates.length; i++){

          if(candidates[i].voteCount > winningVoteCount){

              winningVoteCount = candidates[i].voteCount;
              winnerName_ = candidates[i].name;
          }
      }
  }
 }
