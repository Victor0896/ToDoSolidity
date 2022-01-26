// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

contract scrum {

    uint public nSprintTasks;
    
    struct taskStruct {
        address owner;
        string name;
        uint conclusionTime;
        uint effort;
        taskProgress phase;
        uint priority;
    }

    enum taskProgress {
        backlog,
        toDo,
        inProgress,
        review,
        done
    } 

    taskStruct[] private sprint;

    mapping (address => uint[]) private myTasks;

    event TaskAdded(address owner, string name, uint conclusionTime, uint effort, taskProgress phase, uint priority);

    modifier onlyOwner (uint _taskIndex) {
        if(sprint[_taskIndex].owner == msg.sender) {
            _;
        }
    }

    constructor() {
        nSprintTasks = 0;      
        addTask ("INIT BACKLOG", 20, 1, taskProgress.backlog, 1);
        addTask ("INIT TODO", 40, 3, taskProgress.toDo, 2);
        addTask ("INIT INPROGRESS", 60, 5, taskProgress.inProgress, 3);
        addTask ("INIT REVIEW", 80, 7, taskProgress.review, 4);
        addTask ("INIT DONE", 100, 13, taskProgress.done, 5);
    } 

    function getSprintTask(uint _taskIndex) public view
        returns (address owner, string memory name, uint conclusionTime, uint effort, taskProgress phase, uint priority) {
        owner = sprint[_taskIndex].owner;        
        name = sprint[_taskIndex].name;
        conclusionTime = sprint[_taskIndex].conclusionTime;
        effort = sprint[_taskIndex].effort;
        phase = sprint[_taskIndex].phase;
        priority = sprint[_taskIndex].priority;
    }

    function sprintTaskList() public view returns (uint[] memory) {
        return myTasks[msg.sender];
    }

    function addTask(string memory _name, uint _conclusionTime, uint _effort, taskProgress _phase, uint _priority) public returns (uint index) {
        require ((_priority >= 1 && _priority <=5), "priority must be between 1 and 5");

        taskStruct memory taskAux = taskStruct ({
            owner: msg.sender,
            name: _name,
            conclusionTime: _conclusionTime,
            effort: _effort,
            phase: _phase, 
            priority: _priority
        });
        
        sprint.push(taskAux);
        index = sprint.length - 1;
        nSprintTasks ++;
        myTasks[msg.sender].push(index);

        emit TaskAdded(msg.sender, _name, _conclusionTime, _effort, _phase, _priority);
    }

    function updateTaskPhase(uint _taskIndex, taskProgress _phase) public onlyOwner(_taskIndex) {
        sprint[_taskIndex].phase = _phase;
    }

    function getTaskWithPriority(uint _priority) public view returns(uint[] memory) {

    }

    //Tarefas para grupos
    //Ao invés da tarefa ser exclusiva do owner, poderíamos definir grupos para visualizar ou alterar a tarefa.

}