"""Task Manager as a Walking Graph"""

import random;

glob AI_TIPS = [
    "Break big tasks into smaller steps.",
    "Set a timer and focus for 25 minutes.",
    "Reward yourself after completing a task.",
    "Visualize the benefits of finishing your work.",
    "Remove distractions before you start."
];

node TaskNode {
    has description:str;
    has done:bool = false;
}

walker TaskManager {
    can build_tasks with TaskNode entry;
    can show_tasks with TaskNode entry;
    can give_hint with TaskNode entry;
    can complete_task with TaskNode entry;
}

with entry {
    spawn TaskManager::build_tasks() on T;
    spawn TaskManager::show_tasks() on here;
    spawn TaskManager::give_hint() on here;
    spawn TaskManager::complete_task() on here;
    spawn TaskManager::show_tasks() on here;
}

"""TaskManager Walker Implementation"""

impl TaskManager.build_tasks {
    task1 = TaskNode(description="Finish Jac tutorial");
    task2 = TaskNode(description="Prepare youth workshop slides");

    here ++> task1;
    here ++> task2;
}

impl TaskManager.show_tasks {
    print("\n📋 Your Tasks:");
    visit --> {
        status = "✅" if here.done else "❌";
        print(f"- {here.description} [{status}]");
    }
}

impl TaskManager.give_hint {
    visit --> {
        if not here.done {
            hint = random.choice(AI_TIPS);
            print(f"💡 Hint for '{here.description}': {hint}");
        }
    }
}

impl TaskManager.complete_task {
    visit --> {
        if not here.done {
            here.done = True;
            print(f"🎉 Completed: {here.description}");
        } else {
            print(f"Already completed: {here.description}");
        }
    }
}
