"""Task Manager Implementation"""

glob AI_TIPS = [
    "Break big tasks into smaller steps.",
    "Set a timer and focus for 25 minutes.",
    "Reward yourself after completing a task.",
    "Visualize the benefits of finishing your work.",
    "Remove distractions before you start."
] ;

impl Task.mark_done {
    self.done = True ;
}

impl Task.get_hint {
    return random.choice(AI_TIPS) ;
}

impl TaskList.add_task {
    self.tasks.append(Task(description=description)) ;
    print(f"✅ Added: {description}") ;
}

impl TaskList.show_tasks {
    print("\n📋 Your Tasks:") ;
    for i in range(len(self.tasks)) {
        task = self.tasks[i] ;
        status = "✅" if task.done else "❌" ;
        print(f"{i+1}. {task.description} [{status}]") ;
    }
}

impl TaskList.complete_task {
    if index >= 0 and index < len(self.tasks) {
        task = self.tasks[index] ;
        if task.done {
            print("Already completed!") ;
        } else {
            task.mark_done() ;
            print(f"🎉 Completed: {task.description}") ;
        }
    } else {
        print("Invalid task number.") ;
    }
}

impl TaskList.get_ai_hint {
    if index >= 0 and index < len(self.tasks) {
        task = self.tasks[index] ;
        if not task.done {
            print(f"💡 Hint for '{task.description}': {task.get_hint()}") ;
        } else {
            print("Task already done!") ;
        }
    } else {
        print("Invalid task number.") ;
    }
}

