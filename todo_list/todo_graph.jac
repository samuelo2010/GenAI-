"""Task Manager as a Walking Graph"""
import random ;

glob AI_TIPS = [
    "Break big tasks into smaller steps.",
    "Set a timer and focus for 25 minutes.",
    "Reward yourself after completing a task.",
    "Visualize the benefits of finishing your work.",
    "Remove distractions before you start."
] ;

node TaskNode {
    has description : str ;
    has done : bool = False ;
    can mark_done ;
    can get_hint ;
    
}

node TaskListNode {
    has tasks : list[TaskNode] = [] ;
    can add_task ( description : str ) ;
    can show_tasks ;
    can complete_task ( index : int ) ;
    can get_ai_hint ( index : int ) ;
}


with entry {
    todo = spawn node::TaskListNode() ;
    # example flow (walkers / abilities will run via implementations)
    todo.add_task("Finish Jac tutorial") ;
    todo.add_task("Prepare youth workshop slides") ;
    todo.show_tasks() ;
    todo.get_ai_hint(0) ;
    todo.complete_task(0) ;
    todo.show_tasks() ;
    
}

