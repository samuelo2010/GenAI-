"""Task Manager Model"""

import random ;

obj Task {
    has description : str ,
        done : bool = False ;

    def mark_done ;
    def get_hint ;
}

obj TaskList {
    has tasks : list[Task] = [] ;

    def add_task ( description : str ) ;
    def show_tasks ;
    def complete_task ( index : int ) ;
    def get_ai_hint ( index : int ) ;
}

# Entry point
with entry {
    todo = TaskList() ;
    todo.add_task("Finish Jac tutorial") ;
    todo.add_task("Prepare youth workshop slides") ;
    todo.show_tasks() ;
    todo.get_ai_hint(0) ;
    todo.complete_task(0) ;
    todo.show_tasks() ;
}
