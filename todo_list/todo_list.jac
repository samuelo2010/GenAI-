obj Task {
    has description : str,
        done : bool = False;

    def mark_done;
    def get_hint;
}

obj TaskList {
    has tasks : list<Task> = [];

    def add_task(description : str);
    def show_tasks;
    def complete_task(index : int);
    def get_ai_hint(index : int);
}
