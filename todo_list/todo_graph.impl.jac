"""Task Manager Implementation"""

glob AI_TIPS = [
    "Break big tasks into smaller steps.",
    "Set a timer and focus for 25 minutes.",
    "Reward yourself after completing a task.",
    "Visualize the benefits of finishing your work.",
    "Remove distractions before you start."
] ;

# --- TaskNode Behaviors ---
impl TaskNode.mark_done {
    self.done = True ;
}

impl TaskNode.get_hint {
    return random.choice(AI_TIPS) ;
}

# --- TaskManager Behaviors ---
impl TaskManager.add_task {
    let t = spawn here ++> TaskNode(description=description) ;
    self.tasks.append(t) ;
    print(f"✅ Added: {description}") ;
}

impl TaskManager.show_tasks {
    print("\n📋 Your Tasks:") ;
    for i = 0 to len(self.tasks) - 1 {
        let task = self.tasks[i] ;
        let status = "✅" if task.done else "❌" ;
        print(f"{i+1}. {task.description} [{status}]") ;
    }
}

impl TaskManager.complete_task {
    if index >= 0 and index < len(self.tasks) {
        let task = self.tasks[index] ;
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

impl TaskManager.get_ai_hint {
    if index >= 0 and index < len(self.tasks) {
        let task = self.tasks[index] ;
        if not task.done {
            print(f"💡 Hint for '{task.description}': {task.get_hint()}") ;
        } else {
            print("Task already done!") ;
        }
    } else {
        print("Invalid task number.") ;
    }
}
