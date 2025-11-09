#prac_byllmsample; example of using ByLLM with Jac
"""ByLLM Sample in Jac"""
import from byllm.llm{Model}
glob llm = Model(model_name = "gemini/gemini-2.0-flash");

def response(text: str) -> str by llm;

with entry {
    prompt = "Define unhappiness";
    quote = response(prompt);
    print(f"Defination of unhappiness: {quote}");
}