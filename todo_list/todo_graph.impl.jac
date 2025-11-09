"""Task Manager Implementation (Walking Graph Version)"""

import random ;

# -------------------------------
# 🔸 Global AI Tips
# -------------------------------
glob AI_TIPS = [
    "Break big tasks into smaller steps.",
    "Set a timer and focus for 25 minutes.",
    "Reward yourself after completing a task.",
    "Visualize the benefits of finishing your work.",
    "Remove distractions before you start."
] ;

# -------------------------------
# 🔹 TaskNode Implementations
# -------------------------------

# Mark a task as completed
impl TaskNode.mark_done {
    self.done = True ;
    print(f"🎉 Completed: {self.description}") ;
}

# Give a motivational AI hint
impl TaskNode.get_hint {
    return random.choice(AI_TIPS) ;
}

# -------------------------------
# 🔹 TaskListNode Implementations
# -------------------------------

# Add a new task and link it to the list node
impl TaskListNode.add_task {
    new_task = spawn node::TaskNode(description=description) ;
    self +edge::link-> new_task ;
    self.tasks.append(new_task) ;
    print(f"✅ Added: {description}") ;
    return new_task ;
}

# Display all tasks with completion status
impl TaskListNode.show_tasks {
    print("\n📋 Your Tasks:") ;
    if len(self.tasks) == 0 {
        print("No tasks found!") ;
        return ;

    for i in range(len(self.tasks)) {
        task = self.tasks[i] ;
        status = "✅" if task.done else "❌" ;
        print(f"{i+1}. {task.description} [{status}]") ;
    }
}

# Complete a task by index
impl TaskListNode.complete_task {
    if index < 0 or index >= len(self.tasks) {
        print("Invalid task number.") ;
        return ;

    task = self.tasks[index] ;
    if task.done {
        print("Already completed!") ;
    } else {
        task.mark_done() ;
    }
}

# Get a random AI tip for an incomplete task
impl TaskListNode.get_ai_hint {
    if index < 0 or index >= len(self.tasks) {
        print("Invalid task number.") ;
        return ;

    task = self.tasks[index] ;
    if not task.done {
        print(f"💡 Hint for '{task.description}': {task.get_hint()}") ;
    } else {
        print("Task already done!") ;
    }
}

# -------------------------------
# 🔹 ProgressWalker Implementation
# -------------------------------

impl ProgressWalker.report_progress {
    all_tasks = list(root.down("TaskNode")) ;  # find all TaskNodes in the graph
    if len(all_tasks) == 0 {
        print("No tasks found!") ;
        return ;

    done_count = 0 ;
    for t in all_tasks {
        if t.done:
            done_count += 1 ;

    percent = (done_count / len(all_tasks)) * 100 ;

    print("\n📊 Progress Report:") ;
    print(f"Completed: {done_count}/{len(all_tasks)} tasks ({percent:.1f}%)") ;

    remaining = len(all_tasks) - done_count ;
    if remaining > 0:
        print(f"Remaining: {remaining} task(s) left.") ;
    else:
        print("🎯 All tasks completed! Great job!") ;
}
