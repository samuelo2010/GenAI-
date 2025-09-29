## 🧠 Smart To-Do List with AI Hints (JacLang Edition)

A modular, graph-based task manager built in [JacLang](https://www.jac-lang.org/)—designed for youth workshops, community empowerment, and AI-enhanced productivity.

---

## 🚀 Features

- ✅ Add and complete tasks
- 💡 Get AI-generated motivational hints using `byLLM`
- 🧭 Visualize tasks as graph nodes
- ☁️ Deploy as a cloud API with zero code changes
- 🎓 Perfect for teaching modular thinking and agentic AI

---

## 📁 Project Structure

├── smart_todo.jac # Object and walker definitions
├── smart_todo.impl.jac # Logic implementation 
├── README.md


## 🧱 Core Concepts

| Jac Concept | Real-World Analogy |
|------------|---------------------|
| `obj Task` | A single to-do item |
| `walker`   | A helper that moves through tasks |
| `node`     | A visual room representing a task |
| `byLLM`    | AI assistant giving motivational nudges |

## 🛠️ How to Run Locally

1. **Install JacLang**
   ```bash
   pip install jaclang

2. **Run the program in lacal bash**
'''bash
jac smart_todo.jac smart_todo.impl.jac

3. **Serve API**
'''bash
jac serve smart_todo.jac --port 8000

## Cloud deployment using Dockerfile
FROM python:3.11-slim
WORKDIR /app
RUN pip install jaclang
COPY smart_todo.jac .
CMD ["jac", "serve", "smart_todo.jac", "--port", "8000"]

## Author: Samuel Ochieng