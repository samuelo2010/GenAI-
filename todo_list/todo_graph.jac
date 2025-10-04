"""Task Manager as a Walk Graph"""

import random ;

# --- Node Definitions ---
node TaskNode {
    has description : str ,
        done : bool = False ;

    can mark_done ;
    can get_hint ;
}

# --- Root/Controller Node ---
node TaskManager {
    has tasks : list[TaskNode] = [] ;

    can add_task ;
    can show_tasks ;
    can complete_task ;
    can get_ai_hint ;
}

# --- Entry Point ---
with entry {
    root = spawn here ++> TaskManager() ;
    root.add_task("Finish Jac tutorial") ;
    root.add_task("Prepare youth workshop slides") ;
    root.show_tasks() ;
    root.get_ai_hint(0) ;
    root.complete_task(0) ;
    root.show_tasks() ;
}
