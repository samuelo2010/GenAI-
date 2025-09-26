import random

# Sample motivational tips
class Task:
    def __init__(self, description):
        self.description = description
        self.done = False

    def mark_done(self):
        self.done = True

    def get_hint(self):
        return random.choice(AI_TIPS)

class TaskList:
    def __init__(self):
        self.tasks = []

    def add_task(self, description):
        self.tasks.append(Task(description))
        print(f"✅ Added: {description}")

    def show_tasks(self):
        print("\n📋 Your Tasks:")
        for i, task in enumerate(self.tasks, 1):
            status = "✅" if task.done else "❌"
            print(f"{i}. {task.description} [{status}]")

    def complete_task(self, index):
        if 0 <= index < len(self.tasks):
            task = self.tasks[index]
            if task.done:
                print("Already completed!")
            else:
                task.mark_done()
                print(f"🎉 Completed: {task.description}")
        else:
            print("Invalid task number.")

    def get_ai_hint(self, index):
        if 0 <= index < len(self.tasks):
            task = self.tasks[index]
            if not task.done:
                print(f"💡 Hint for '{task.description}': {task.get_hint()}")
            else:
                print("Task already done!")
        else:
            print("Invalid task number.")

# Demo interaction
todo = TaskList()
todo.add_task("Finish Jac tutorial")
todo.add_task("Prepare youth workshop slides")
todo.show_tasks()
todo.get_ai_hint(0)
todo.complete_task(0)
todo.show_tasks()
